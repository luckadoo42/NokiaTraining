<?xml version ="1.0"?>
<!DOCTYPE xsl:stylesheet>

  <xsl:stylesheet version="1.1"
	xmlns:bj="http://motive.com/techpubs/datamodel"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:output
	method="xml"
	indent="yes"
	/>

  <xsl:param name="new-version">XXXX</xsl:param>
  
  <xsl:template match="/">
=======

Table descriptions with FIXMEs: <xsl:value-of select="count(//bj:table[contains(./bj:description,'FIXME')])"/> out of <xsl:value-of select="count(//bj:table[@added='{$new-version}'])"/> new tables.
Columns with FIXMEs: <xsl:value-of select="count(//bj:column[contains(./bj:description,'FIXME')])"/> out of <xsl:value-of select="count(//bj:column[@added='{$new-version}']) + count(//bj:table[@added='{$new-version}']/bj:column)"/> new columns.
Examples with FIXMEs: <xsl:value-of select="count(//bj:column[contains(./bj:example,'FIXME')])"/> out of <xsl:value-of select="count(//bj:column[@added='{$new-version}']) + count(//bj:table[@added='{$new-version}']/bj:column)"/> new columns.
==========	
Using a new version string of <xsl:value-of select="$new-version"/> to check for new items.
==========


  </xsl:template>

  </xsl:stylesheet>
