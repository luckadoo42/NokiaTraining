<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:rx="http://www.renderx.com/XSL/Extensions"
  xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
  version="1.0">



 
  <xsl:import href="../common/olink.xsl"/>
  <xsl:import href="fo.xsl"/>
  <xsl:import href="../motive-pdf/email.xsl"/>
  <xsl:include href="changebars.xsl"/>

<!-- declare fop and xep params -->
<xsl:param name="fop.extensions"/>
<xsl:param name="fop1.extensions"/>
<xsl:param name="xep.extensions"/>
 
<xsl:variable name="fop-xep-values-message">
		<xsl:message>FOP/XEP values: fop.extensions=<xsl:value-of select="$fop.extensions"/>; fop1.extensions=<xsl:value-of select="$fop1.extensions"/>; xep.extensions=<xsl:value-of select="$xep.extensions"/>;</xsl:message>
</xsl:variable>


</xsl:stylesheet>
