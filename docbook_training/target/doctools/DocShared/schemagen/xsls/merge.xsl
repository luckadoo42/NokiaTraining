<?xml version ="1.0"?>
<!DOCTYPE xsl:stylesheet>

<!-- This xsl merges a newly generated datamodel xml file -->
<!-- with an older one that already has descriptions and -->
<!-- examples. It works by walking the tree of the new file, -->
<!-- and copying over descriptions and examples from tables -->
<!-- and columns in the old doc. This means that if a table -->
<!-- or column's name has CHANGED, its descriptions must be -->
<!-- manually copied over in some way. -->

<!-- To use this, run the xsl and pass the path to the old -->
<!-- doc in as the parameter old-doc -->

<!--code notes
	
	When testing this, change the hardcoded local value for old-doc to something useful for your testing. 
	
	
	Had to use db: prefix on docbook elements referenced in this stylesheet,
	in order to catch those with the templates in here -->


  <xsl:stylesheet version="1.1"
	xmlns:bj="http://motive.com/techpubs/datamodel" 
	xmlns:db="http://docbook.org/ns/docbook"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns="http://docbook.org/ns/docbook"
    xmlns:lookup="http://www.broadjump.com/lookup"
	exclude-result-prefixes='db lookup' >


  <xsl:output
	method="xml"
	indent="yes"
	/>
  	

  <xsl:param name="new-version">xxx</xsl:param>
  	
  	<!-- old-doc now requires a URI-style path. for an abs path, skip the drive name, use like the below, which 
  		is same as for file in my c:\worksvn... -->
  	
  	<xsl:param name="old-doc">/worksvn/pubs/smp/branches/5.2.0/en_US/smp_datadictionary/schema/datamodel.xml</xsl:param>
  <xsl:param name="old-doc-tree">
	<xsl:copy-of select="document($old-doc)/*"/>
  </xsl:param>
  <xsl:param name="new-doc-tree">
	<xsl:copy-of select="/*"/>
  </xsl:param>
  	
  <xsl:param name="verbose">N</xsl:param> <!-- set to Y to display extra debug info -->
  	

  <xsl:template match="/">
  	<!-- generate header stuff -->
  	<xsl:text>
  		
  	</xsl:text>
  	<xsl:processing-instruction name="xml-model">
  	<xsl:value-of select="processing-instruction()"/>
  	
  	</xsl:processing-instruction>

	<xsl:if test="$new-version = ''">
<xsl:message>
Tip: Use the new-version param to specify the version number of the
     new schema. This number will automatically be placed in the added
     attribute on all new tables and columns.

	  </xsl:message>
	</xsl:if>
	<xsl:apply-templates/>


</xsl:template>
  	
  	<!-- this is the master template that drives the check for deleted process -->
<xsl:template name="check-deleted">
  	<xsl:message>

==================================
Any tables, views, or columns that exist 
in the old schema but are missing
in the new one will be listed
below.

Missing tables, views, and columns are 
omitted from the merged file.
==================================
	</xsl:message>
	<xsl:apply-templates select="$old-doc-tree//bj:table" mode="check-for-deleted"/>
	<xsl:message>
==================================
	</xsl:message>
  	
  	
  </xsl:template>
  

<!-- named template that inserts text Table or View by checking the @view attribute of the current node -->
  <xsl:template name="tableorview">
  	<xsl:choose>
  		<xsl:when test="@view='yes'">View</xsl:when>
  		<xsl:otherwise>Table</xsl:otherwise>
  	</xsl:choose>
  </xsl:template>
  
    
  <xsl:template match="bj:table" mode="check-for-deleted">
  	<xsl:choose>
  		<!-- first: when the table is NOT found... -->
  		<xsl:when test="not(@name = $new-doc-tree//bj:table/@name)">
  			<xsl:message>
Missing <xsl:call-template name="tableorview"/>:  <xsl:value-of select="@name"/> <xsl:if test="@view"> (has @view= <xsl:value-of select="@view"/>)</xsl:if>
  			</xsl:message>
  			<bj:deleted-table name="{@name}" removed="{$new-version}">
  				<xsl:attribute name="cat"><xsl:value-of select="document('categories.xsl')//lookup:subject-area[contains(.,current()/@name)]/@name"/></xsl:attribute>
  			</bj:deleted-table>
  		</xsl:when>
  		<!-- otherwise, it IS present, so we check whether its columns were deleted -->
  		<xsl:otherwise>
  			<xsl:for-each select="bj:column">
  				<xsl:apply-templates select="." mode="check-for-deleted"/>
  			</xsl:for-each>
  		</xsl:otherwise>
  	</xsl:choose>
  </xsl:template>

  <xsl:template match="bj:column" mode="check-for-deleted">
	<xsl:variable name="table-name" select="parent::bj:table/@name"/>
	<xsl:variable name="column-name" select="@name"/>
  	<xsl:variable name="cat" select="document('categories.xsl')//lookup:subject-area[contains(.,$table-name)]/@name"/>
	<xsl:if test="not($new-doc-tree//bj:table[@name = $table-name and ./bj:column/@name = $column-name])">
	  <xsl:message>Missing Column: <xsl:value-of select="$table-name"/>.<xsl:value-of select="$column-name"/></xsl:message>
		<bj:deleted-column cat="{$cat}" table="{$table-name}" name="{$column-name}" removed="{$new-version}"/>
	</xsl:if>
  </xsl:template>

  <xsl:template match="bj:subsystem">
    <!-- output all the needed namespaces with the main tag ... -->
    <bj:subsystem xmlns:bj="http://motive.com/techpubs/datamodel"
              xmlns:xi="http://www.w3.org/2001/XInclude"
			  xmlns:xlink="http://www.w3.org/1999/xlink"
              xmlns:db="http://docbook.org/ns/docbook"
              xmlns="http://docbook.org/ns/docbook"
              name="Foo">


	  <!-- output the schema title from the NEW doc tree; ignore the old title;
		   because the new title came from most recent value of schema.ref.title property -->
	  <xsl:copy-of select="$new-doc-tree/bj:subsystem[1]/bj:title[1]"/>
	  <!-- But take the schema description from the old doc tree, because the only place
		   where you'd ever edit that is in datamodel.xml. -->
	  <xsl:copy-of select="$old-doc-tree/bj:subsystem[1]/bj:description[1]"/>

	  <!-- Same for any bj:subsystem/db:section elements -->
      <!-- we had this before	  <xsl:copy-of select="$old-doc-tree//bj:subsystem[1]/db:section|$old-doc-tree//bj:subsystem[1]/comment()"/> -->
      <!-- does this version drop the extra comments top of file? --> 
	  <xsl:copy-of select="$old-doc-tree//bj:subsystem[1]/db:section"/>

	  <xsl:apply-templates select="bj:table"/>
      <xsl:call-template name="check-deleted"/>
	</bj:subsystem>
  </xsl:template>

  <xsl:template match="bj:table[not(substring(1,4,@name) = 'STG_')]">
  	<!-- declare a variable for the old table reference, so that we can reuse this complex expression
  	over and over, with a much simpler syntax -->
  	
   	<xsl:variable name="table-name" select="@name"/>
  	<xsl:variable name="oldtable" select="$old-doc-tree//bj:table[@name = $table-name]"/>
  	<!--
  		<xsl:variable name="oldtable" select="$old-doc-tree//bj:table[@name = current()/@name]"/> -->
  	
  	<xsl:if test="$verbose = 'Y'">
  	<xsl:message>=====
  		Processing table <xsl:value-of select="@name"/>. 
  		$table-name = <xsl:value-of select="$table-name"/>.
  		Current/@name = <xsl:value-of select="current()/@name"/>. 
  		and oldtable/@name = <xsl:value-of select="$oldtable/@name"/>
 	    old doc tree expression hardcoded gives an old table with @name of... <xsl:value-of select="$old-doc-tree/bj:subsystem[1]/bj:table[@name = current()/@name]/@name"/>
  		====
  	</xsl:message></xsl:if>
  	
  	<xsl:choose>
  		<xsl:when test="@name = $oldtable/@name"> 		
  			<!--  		<xsl:when test="@name = $old-doc-tree//bj:table[@name = current()/@name]/@name"> -->
  				<!-- when it's an existing table...-->		
		<bj:table>
		  <!-- first copy over all the attributes from the old table -->	
		  <xsl:copy-of select="$oldtable/@*"/>

		  <!-- then, if it happens to have @view in new, insert that... -->
		   <xsl:copy-of select="@view"/>

            <!-- then decide which table description to use -->
			<xsl:choose>  <!-- choosing which description to use -->
				<!-- bj:description below = the descr of NEW table 
				
				   We want to use the new one IF the new one is NOT empty or FIXME, and the old one IS empty or FIXME.
				
				-->			  
				<xsl:when test="normalize-space(bj:description) != 'FIXME' and normalize-space(bj:description) !='' and 
					(normalize-space($oldtable/bj:description) ='FIXME' or 
					normalize-space($oldtable/bj:description)='')">
					<!-- use the new description -->
					<xsl:message>Using NEW (database) description for table <xsl:value-of select="@name"/> because it has the following content:
						====
						<xsl:value-of select="normalize-space(bj:description)"/>
						====
						while the original (datamodel file) description was: 
						===
						<xsl:value-of select="normalize-space($oldtable/bj:description)"/>
						===
					</xsl:message>
					<xsl:copy-of select="bj:description"/>
				</xsl:when>
				<xsl:otherwise> <!-- copy over description from old doc -->
					<xsl:copy-of select="$oldtable/bj:description"/>
				</xsl:otherwise>
			</xsl:choose>
		  <xsl:apply-templates/>
		</bj:table>
	  </xsl:when>
	  <xsl:otherwise>
		<bj:table added="{$new-version}">
		  <xsl:copy-of select="./*|@*"/>
		</bj:table>
	  	<xsl:message>New <xsl:call-template name="tableorview"/>:  <xsl:value-of select="@name"/></xsl:message>
	  </xsl:otherwise>
	</xsl:choose>
  </xsl:template>

  <xsl:template match="bj:column">
  	<!-- declare a variable for the old column reference, so that we can reuse this complex expression
  		over and over, with a much simpler syntax -->
  	<xsl:variable name="oldcolumn" select="$old-doc-tree/bj:subsystem[1]/bj:table[@name = current()/../@name]/bj:column[@name = current()/@name]"/>	  	
  	
  	<xsl:if test="$verbose = 'Y'">
  		<xsl:message>
  		Processing column <xsl:value-of select="../@name"/>.<xsl:value-of select="@name"/> 
  	Current/@name = <xsl:value-of select="current()/@name"/>. 
  	and oldcolumn/@name = <xsl:value-of select="$oldcolumn/@name"/>
  		while value of old doc tree expression hardcoded gives an old col with @name of... <xsl:value-of select="$old-doc-tree/bj:subsystem[1]/bj:table[@name = current()/../@name]/bj:column[@name = current()/@name]/@name"/>
  	</xsl:message></xsl:if>
  	
	<xsl:choose>
    <!-- when the current col name matches the one in old tree, copy over stuff from old tree
         but do it piecemeal, so we can make comparisons along the way
    -->
	  <xsl:when test="@name = $oldcolumn/@name">

		<bj:column>
			
		  <!-- We're going to copy over the pieces of the column, one at a time -->
			
		  <!-- first, copy over the attributes -->	
		  <xsl:copy-of select="$oldcolumn/@*"/>


		  <!-- Next, copy over the description. 
		  	  Exception: if new tree has a description, while old tree has '' or FIXME, then use the description from the new tree 

			 Cases for the choose struture
			     old descr   new descr     use 
				 FIXME       FIXME         old
				 FIXME       ''            old
				 ''          FIXME         old
				 ''          ''            old
				 FIXME       not '' or FIXME new
				 ''          not '' or FIXME new
			So, the only cases where we vary from using old are when the new description is NOT '' or FIXME, so test that first.

-->
		  <xsl:choose>  <!-- choosing which description to use -->
			  <!-- bj:description = the descr of new col. -->			  
 		      <xsl:when test="normalize-space(bj:description) != 'FIXME' and normalize-space(bj:description) !='' and 
 		      	(normalize-space($oldcolumn/bj:description) ='FIXME' or 
 		      	normalize-space($oldcolumn/bj:description)='')">
				<!-- use the new description -->
				<xsl:message>Using NEW description for column <xsl:value-of select="../@name"/>.<xsl:value-of select="@name"/> because it has the following content:
====
<xsl:value-of select="normalize-space(bj:description)"/>
====
while the original description was: 
===
<xsl:value-of select="normalize-space($oldcolumn/bj:description)"/>
===
</xsl:message>
				<xsl:copy-of select="bj:description"/>
              </xsl:when>
			  <xsl:otherwise> <!-- copy over description from old doc -->
				  <xsl:copy-of select="$oldcolumn/bj:description"/>
			  </xsl:otherwise>
          </xsl:choose>

			<xsl:choose> <!-- choosing which example to use --> 
				<!-- bj:example = the example of new col. -->			  
				<xsl:when test="normalize-space(bj:example) != 'FIXME' and normalize-space(bj:example) !='' and 
					(normalize-space($oldcolumn/bj:example) ='FIXME' or 
					normalize-space($oldcolumn/bj:example)='')">
					<!-- use the new example -->
					<xsl:message>Using NEW example for column <xsl:value-of select="../@name"/>.<xsl:value-of select="@name"/> because it has the following content:
						====
						<xsl:value-of select="normalize-space(bj:example)"/>
						
						====
						while the original example was: 
						===
						<xsl:value-of select="$oldcolumn/bj:example/*"/>
						===
					</xsl:message>
					<xsl:copy-of select="bj:example"/>
				</xsl:when>
				<xsl:otherwise> <!-- copy over example from old doc -->
					<xsl:copy-of select="$oldcolumn/bj:example"/>
				</xsl:otherwise>
			</xsl:choose>
			
			<!-- JCBG-1130: test for chgs in format, spit out comments if there were any -->
			<!-- using NEW format with new @last added, jcbg-2054 -->
			<xsl:choose> 	  
				<xsl:when test="./bj:format/@type != $oldcolumn/bj:format/@type">
					<!-- when not same, use the new format -->
					<xsl:message>New Format: Column <xsl:value-of select="../@name"/>.<xsl:value-of select="@name"/> had format <xsl:value-of select="$oldcolumn/bj:format/@type"/> but now it is <xsl:value-of select="./bj:format/@type"/>. </xsl:message>
					<!-- create the new format, and  add an @last with the old format in it -->
					<bj:format added="{$new-version}">
						<!-- xxx need code here to apply templates to all @ in new format -->
						<xsl:attribute name="last"><xsl:value-of select="$oldcolumn/bj:format/@type"/></xsl:attribute>
						
						<xsl:apply-templates select="./bj:format/@*"/>
						
					</bj:format> 
				</xsl:when>
				<xsl:otherwise> <!-- use new format in case of other changes; we ONLY check for type changes but 
				if there were others we want to capture them-->
					<xsl:copy-of select="./bj:format"/>
				</xsl:otherwise>
			</xsl:choose>
			
	



			
		  <xsl:copy-of select="$old-doc-tree/bj:subsystem[1]/bj:table[@name = current()/../@name]/bj:column[@name = current()/@name]/bj:source"/>
		</bj:column>
	  </xsl:when>
	  <xsl:otherwise>
		<!-- otherwise, take the whole bj:column from the new tree, but add an 'added' attrib-->
		<bj:column>
		  <xsl:if 
			test="not($old-doc-tree/bj:subsystem[1]/bj:table[@name = current()/../@name and normalize-space(@added) = normalize-space($new-version)])">
			<xsl:attribute name="added"><xsl:value-of select="$new-version"/></xsl:attribute>
		  </xsl:if>
		  <xsl:copy-of select="./*|@*"/>
		</bj:column>
<xsl:message>New Column: <xsl:value-of select="parent::bj:table/@name"/>.<xsl:value-of select="@name"/></xsl:message>
	  </xsl:otherwise>
	</xsl:choose>
  </xsl:template>


<xsl:template match="@*"> <!-- copy over @ when processed-->
	<xsl:copy-of select="."/>	
</xsl:template>

<xsl:template match="text()"></xsl:template>
  </xsl:stylesheet>

