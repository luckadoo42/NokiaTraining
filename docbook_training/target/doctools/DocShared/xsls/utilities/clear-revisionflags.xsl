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
	  encoding="utf-8"
	  omit-xml-declaration="no"
	  indent="no"/>

    <xsl:template match="@*|node()">
      <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
    </xsl:template>
    
    <xsl:template match="*[@revisionflag = 'deleted']"/>
    
    <xsl:template match="@revisionflag"/>

  </xsl:stylesheet>