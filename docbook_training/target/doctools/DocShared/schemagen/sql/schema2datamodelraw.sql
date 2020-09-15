/* schema2datamodelraw.sql:
pl/sql script to grab data about tables in an oracle database,
and output that data as xml.

Basic algorithm here is to loop over all the tables and columns using user_tab_columns.
Outer loop to cover all the tables, inner loop to cover the columns of each table.

This script expects to be passed 1 command-line parameters: 
filename-to-spool-to

*/

-- Setup

-- This will allow unlimited output to standard out; otherwise it's capped at 1000000 bytes. Note that this command is only available in Oracle 10.2.0.1 and later, so it forces us to use that version of oracle.
set serveroutput on size unlimited

-- This avoids the "PL/SQL procedure successfully completed." message at the end
set feedback off

-- necessary to avoid some data being dropped
set linesize 100   

-- write output to a file, using the first parameter supplied to the script

spool &1


DECLARE 
	  -- vars used in constructing bj:format
      c_type CHAR(30);  -- used to store value for 'type' attribute
	  c_null CHAR(5); -- str true or false; value of nullable
      c_pk CHAR(5); -- str true or false; value of primaryKey
      c_fk CHAR(64); -- str table.col; value of foreignKey
	  verbose CHAR(1); -- str Y or N to indicate whether to print out extra debug info


-- We'll define two cursors, one for each loop. They'll be c1 and c2. First one now...

cursor c1 is   -- outer loop cursor
  select distinct col.table_name, com.comments
    from user_tab_columns col,
         user_tab_comments com
    where col.table_name = com.table_name(+)
	-- use the below line instead of above to limit to 1 table for fast tests; requires that you know 1 table name from the source database (the example RESULT is from SMP).
    --where col.table_name = com.table_name(+) and col.table_name = 'REPORT'
	-- smp tables for testing: RESULT has 3 foreign keys; POEM_SUBJECT has table and column comments
	order by col.table_name;


BEGIN

verbose := 'Y'; -- set verbose mode

-- initial xml declarations to go at the top of the file

  dbms_output.put_line ('<?xml version="1.0" encoding="utf-8"?>');
  dbms_output.put_line ('<?xml-model href="../../../target/doctools/DocShared/schemas/broadbook/datamodel.rng"');
  dbms_output.put_line ('type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"?>');

  -- subsystem open tag
  dbms_output.put_line ('<bj:subsystem xmlns:bj="http://motive.com/techpubs/datamodel"');
  dbms_output.put_line ('              xmlns:xi="http://www.w3.org/2001/XInclude"');
  dbms_output.put_line ('              xmlns:xlink="http://www.w3.org/1999/xlink"');
  dbms_output.put_line ('              xmlns:db="http://docbook.org/ns/docbook"');
  dbms_output.put_line ('              xmlns="http://docbook.org/ns/docbook"');
  dbms_output.put_line ('              name="Foo">');

  -- subsystem title and description: we don't know those yet, but need them to make 
  -- the datamodel valid
  dbms_output.put_line ('<bj:title>@@schema.ref.title@@</bj:title>');
  dbms_output.put_line ('<bj:description><para>FIXME</para></bj:description>');


FOR t in c1     -- now t.something refers to a field in the current row of the cursor
LOOP   -- This is our outer loop, looping over all tables
    dbms_output.put_line ('<!-- --> '); --blank line
    dbms_output.put_line ('<!-- rows for table '||t.table_name ||'  -->');
    dbms_output.put_line ('<!-- --> '); --blank line

   
    -- table opener    

    -- open the table tag, put name in it
    dbms_output.put_line ('<bj:table name="'||t.table_name||'"');

      -- Figure out if this table is really a view, and signify that with attrib view='yes'

        -- I wanted to do something like IF  ((select count(view_name) from user_views where view_name = t.table_name) > 0) THEN , but couldn't get any variant of that to work, so instead I found I had to set up a variable, select into that, and then do my IF against that, because queries/selects don't seem to be allowed in an IF
   
    DECLARE is_view INT; -- var = 0 if not a view, 1 if the current item IS a view

    BEGIN
     SELECT COUNT(*) INTO is_view FROM user_views WHERE view_name = t.table_name; 
     -- Now that is_view is either 0 or 1, we can test it to determine what to output
	 -- basically we skip the view attrib if it's a table, but if it's a view, then...           
     IF is_view > 0 THEN
        dbms_output.put_line ('view="yes" ');
	 END IF;
    END;

    -- then close the table tag either way
    dbms_output.put_line ('>');
    
    -- table description from table comments
    dbms_output.put_line ('<bj:description><para>'||t.comments|| '</para></bj:description>');

    DECLARE 
      t_col CHAR(1024);

    CURSOR c2 is   -- here is our second cursor
	     select distinct col.column_name, col.data_type, col.char_length, col.data_precision, col.nullable, col.column_id, com.comments
    from user_tab_columns col,
         user_col_comments com
    where col.table_name = t.table_name 
    and col.column_name = com.column_name
	and col.table_name = com.table_name
    order by col.column_id;
    
    BEGIN

    FOR c in c2   -- now c.something refers to a field in the current row of the column cursor

    LOOP  -- this is inner loop, looping over all columns of current table

	-- at this point, t.table_name is the table we are looking at, and c.column_name is the column


	  /* Before we write out column info, we need to gather some more values. */


	  /* Now we're going to set up <bj:format>, which has several attributes that take work to get.

	  	 So, we'll gather all the values into variables, then write out bj:format as one line. 

		   c_type = value of 'type' attribute
           c_null = value of 'nullable' attribute.
           c_pk = value of 'primaryKey' attribute
           c_fk = value of 'foreignKey' attribute
	  */

	  /* Populating c_type */

	  	
		IF c.data_type IN ('VARCHAR2','NVARCHAR2')  THEN   -- per JCBG-1542, added NVARCHAR2
		   -- now using char length instead of data_length, per JCBG-834
	      c_type := c.data_type || '(' ||c.char_length || ')';
		   
		ELSIF c.data_type = 'NUMBER' THEN
   		  c_type := c.data_type || '(' ||c.data_precision || ')';

		-- otherwise, just use the data_type as-is
		ELSE 
		   c_type := c.data_type;  
		
		END IF;
	  

		   

	  /*
	  Populating c_null ... taking that from user_tab_columns.nullable
	  			 That can be N or Y, I'm converting that to false and true
	  			    need to verify that that is accurate  
      */

      IF c.nullable = 'N' THEN 
         c_null:='false';
	  END IF; 

      IF c.nullable = 'Y' THEN
        c_null:='true';
	  END IF; 


	  /* populating c_pk  ... true if current column is a primary key, false if not

	 some inspiration from http://www.techonthenet.com/oracle/questions/find_pkeys.php

     */

DECLARE
 test_pk INTEGER; -- used for count test for primary key

BEGIN
  SELECT COUNT(*) INTO test_pk  -- using count so that we always get some value
  from user_cons_columns where constraint_name in (select constraint_name from user_constraints where table_name = t.table_name and column_name = c.column_name and constraint_type = 'P');

  IF test_pk > 0 THEN  -- if 1 or more primary key constraints found, return true; there should be only one, but in testing with SMP db there was at least 1 case where there were two, because of a system constraint
    c_pk := 'true';
  ELSE
    c_pk := 'false';
  END IF;
END; 



/* Foreign key query: given any table and column name, returns either
   .   (if no foreign key for this column)
   referenced table (in form 'tablename.columname')

Original foreign key query taken from http://blog.mclaughlinsoftware.com/2009/03/05/validating-foreign-keys/ 
That was a query to produce a list of all foreign keys, giving source table.column and referenced ones. I hacked it down to just return the referenced table and column name for a given table.column ( I added 'and' for table and column; otherwise it would return all of them)

This is using 2 copies of user_cons_columns. Do we need that? Yes, looks like we do. Effectively we're relating two pointers within user_cons_columns. I didn't know you could do that.

I added min() around the selections to force it to return null instead of throwing the 'no rows found' error. 

*/

SELECT   
min(ucc2.TABLE_NAME)||'.'||min(ucc2.column_name)
-- min forces return of null if nothing found ... so you get '.' if no foreign key for this column
into c_fk   -- stow the result in c_fk for later use
FROM     user_constraints uc
,        user_cons_columns ucc1
,        user_cons_columns ucc2
WHERE    uc.constraint_name = ucc1.constraint_name
AND      uc.r_constraint_name = ucc2.constraint_name
AND      ucc1.POSITION = ucc2.POSITION -- Correction for multiple column primary keys.
AND      uc.constraint_type = 'R'
and ucc1.table_name = t.table_name  -- limit to current table
and ucc1.column_name = c.column_name; -- limit to current column

/* end of code to gather column details (primaryKey, foreignKey) */

      IF verbose = 'Y' THEN 
		 dbms_output.put_line('<!-- '|| t.table_name||'.'||c.column_name||'-->');
	  END IF;


   	  -- write out the col start
      dbms_output.put_line ('<bj:column name="'||c.column_name|| '">');

      -- write out the description: several cases below

	  	-- open tags
		         dbms_output.put_line ('<bj:description><para>');

        -- PRIMARY KEY: output an xml comment + any content from the column comment 
     	  IF c_pk = 'true' THEN
		      IF verbose = 'Y' THEN 
			    dbms_output.put_line('<!-- Primary Key descripton  -->');
			  END IF;
			  dbms_output.put_line ('<!--boilerplate text will be generated. Text put here will replace that-->'||c.comments);

		-- SPECIFIC COLUMN NAMES: output boilerplate for these
		  ELSIF c.column_name = 'NULLINDICATOR' THEN
		      IF verbose = 'Y' THEN 
			    dbms_output.put_line('<!-- output by nullindicator boiler -->');
			  END IF;
		      dbms_output.put_line('Indicates that there is an allowable exception to a constraint');
			  dbms_output.put_line('set in this table. For example, a non-unique serial number is allowed');
			  dbms_output.put_line('if it only appears in a deleted record from the table.');

		  ELSIF c.column_name = 'GUID' THEN
		      IF verbose = 'Y' THEN 
			    dbms_output.put_line('<!-- output by GUID boiler -->');
			  END IF;
			  dbms_output.put_line('The globally unique ID for the object.');

		  ELSIF c.column_name = 'INSERTED' THEN
		      IF verbose = 'Y' THEN 
			    dbms_output.put_line('<!-- output by INSERTED boiler -->');
			  END IF;
			  dbms_output.put_line('Time stamp indicating when the record was created.');

		  ELSIF c.column_name = 'UPDATED' THEN
		      IF verbose = 'Y' THEN 
			    dbms_output.put_line('<!-- output by UPDATED boiler -->');
			  END IF;
			  dbms_output.put_line('Time stamp indicating when the record was last updated.');

		  ELSIF c.column_name = 'DELETED' THEN
		      IF verbose = 'Y' THEN 
			    dbms_output.put_line('<!-- output by DELETED boiler -->');
			  END IF;
			  dbms_output.put_line('Indicates whether an object has been logically deleted.');
			  dbms_output.put_line('The data store maintains a history of all objects ever created and uses this flag to indicate which ones have been logically deleted.');

		-- FOREIGN KEY:  put a comment; text will be generated by later xsl.
		   -- the test here is, if c_fk NOT EQUAL '.', that's a test of whether it is null, the '.' = null
		  ELSIF c_fk <> '.' THEN 
			  dbms_output.put_line('<!-- boilerplate text will be generated. Put any additions to that here-->'); 

		-- COMMENTS: If comments not null, and no other more specific cases match, then output the comments 
   		   -- the test here is, if c.comments NOT EQUAL '.', that's a test of whether it is null, the '.' = null
		  ELSIF c.comments <> '.' THEN
		      IF verbose = 'Y' THEN 
			    dbms_output.put_line('<!-- Outputting the comments for this col as its description -->');
			  END IF;
			  dbms_output.put_line (c.comments);

		-- NO COMMENTS: output a FIXME (does not match any other cases)
		  ELSE
                      IF verbose = 'Y' THEN 
			    dbms_output.put_line('<!-- Choosing FIXME because no comments found and no other special cases match -->');
			  END IF;
		  	  dbms_output.put_line ('FIXME');

		  END IF;

		-- closing tags for description
				 dbms_output.put_line ('</para></bj:description>');


-- write out the example

   -- open tag
      dbms_output.put_line ('<bj:example>');
	  
   -- INSERTED or UPDATED columns
      IF c.column_name = 'INSERTED' OR c.column_name = 'UPDATED' THEN
		  IF verbose = 'Y' THEN 
		     dbms_output.put_line('<!-- INSERTED/UPDATED example -->');
		  END IF;
		  dbms_output.put_line('@@schema.example.year@@-09-29 17:39:05.052531');

   -- STARTDATE, ENDDATE, FIRSTACTIVATED, LASTACTIVATED
      ELSIF c.column_name = 'STARTDATE' or c.column_name = 'ENDDATE' or c.column_name = 'FIRSTACTIVATED' or c.column_name = 'LASTACTIVATED' THEN
		  dbms_output.put_line('@@schema.example.year@@-09-29');

   -- TYPE = TIMESTAMP(6)
      ELSIF c_type = 'TIMESTAMP(6)' THEN 
		  dbms_output.put_line('@@schema.example.year@@-09-29 17:39:05.052531');

   -- TYPE = DATE
      ELSIF c_type = 'DATE' THEN
		  dbms_output.put_line('@@schema.example.year@@-09-29');

   -- OTHERWISE, output a fixme
	  ELSE 
  		  dbms_output.put_line('FIXME');

   END IF;

   -- close tag
      dbms_output.put_line ('</bj:example>');




/* Output the bj:format

 Needs to look like this example:
<bj:format type="" nullable="false" primaryKey="true" foreignKey="ATTRIBUTE.ATTRIBUTE_KEY"/>

 Note use of rtrim() on variable values below to trim trailing spaces from display. I found it didn't work to put that earlier -- to trim the variable value; I had to put it in the output line.

*/
      dbms_output.put_line ('<bj:format type="'|| rtrim(c_type) || '" nullable="'|| rtrim(c_null) || '"');
 
	  -- output primaryKey only if its value is true
      IF c_pk = 'true' then
        dbms_output.put_line ('primaryKey="' || rtrim(c_pk)||'"');
	  END IF;

   	  -- output foreignKey only if its value is not '.', which is the return if no foreign key
      IF c_fk <> '.' then 
        dbms_output.put_line ('foreignKey="' || rtrim(c_fk) ||'"');
	  END IF;

	  -- close the bj:format element and the column

      dbms_output.put_line ('/> </bj:column>');

    END LOOP;

    END;
	
	-- table closing tag
    dbms_output.put_line ('</bj:table>');

END LOOP;

-- ending tag for everything
dbms_output.put_line ('</bj:subsystem>');

END;
/

exit;
