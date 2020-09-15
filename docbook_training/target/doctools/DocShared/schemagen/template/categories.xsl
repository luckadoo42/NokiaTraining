<?xml version="1.0" ?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="1.1" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:lookup="http://www.broadjump.com/lookup">

	
<!-- 
This stylesheet is for specifying categories for database tables and for listing all the tables you wish to include in your schema reference. Tables that are not listed in this file will not appear in the generated reference. 
-->

<!-- You can have as many categories as you like. Each should follow this format:

<lookup:subject-area  name="Category One">TABLE1,
TABLE2
</lookup:subject-area>

Notice that the list of tables in each category is comma-delimited. 

IF, after you rebuild, YOU SEE ONLY ONE TABLE IN A SUBJECT AREA, you might have done a line-delimited list, in which case you only get the last table listed in the subject area.

Each category must have a unique name, and the set of tables listed in each category will be stored inside a section with a title equal to the name attribute given here.

-->

<lookup:subject-area  name="Category One">TABLE1,
TABLE2
</lookup:subject-area>

<lookup:subject-area name="Category Two">TABLE3,
TABLE4</lookup:subject-area>

</xsl:stylesheet>

