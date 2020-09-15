<?xml version ="1.0"?>

  <xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!-- 
IMPORTANT: This xslt must contain NO xsl:message elements!!!
           I'm using it via the <java> task with the output attr,
           so xsl:messages end up in the result document!
-->
	<xsl:output
	  method="xml"
	  indent="no"/>

    <xsl:template match="@*|node()">
      <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
    </xsl:template>
    
    
    <xsl:template match="@targetptr">
      <xsl:attribute name="targetptr"><xsl:value-of select="normalize-space(.)"/></xsl:attribute>
    </xsl:template>
    <xsl:template match="@targetdoc">
      <xsl:attribute name="targetdoc"><xsl:value-of select="normalize-space(.)"/></xsl:attribute>
    </xsl:template>
    
  </xsl:stylesheet>