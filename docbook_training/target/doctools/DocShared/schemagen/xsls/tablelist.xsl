<?xml version ="1.0"?>
<!DOCTYPE xsl:stylesheet>

  <xsl:stylesheet version="1.1"
	xmlns:bj="http://motive.com/techpubs/datamodel"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output
	method="text"
	indent="no"/>

  <xsl:template match="/">
=== TABLES ===
<xsl:apply-templates select="//bj:table[not(@view='yes')]"/>
    
=== VIEWS ===   
<xsl:apply-templates select="//bj:table[@view='yes']"/>
</xsl:template>

  <xsl:template match="//bj:table">
<xsl:value-of select="@name"/><xsl:text>
</xsl:text>
</xsl:template>

  <xsl:template match="node()"/>

  </xsl:stylesheet>
