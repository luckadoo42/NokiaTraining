<?xml version='1.0'?>

<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
  xmlns:rx="http://www.renderx.com/XSL/Extensions"
  exclude-result-prefixes="doc"
  version='1.1'>

  <xsl:import href="main.xsl"/>
  <xsl:import href="../common/olink.xsl"/>
  <xsl:include href="../alcatel-pdf/changebars.xsl"/>
<xsl:attribute-set name="monospace.properties">
  <xsl:attribute name="font-size"><xsl:value-of select="$motive.monospace.font.size"/></xsl:attribute>
</xsl:attribute-set>



</xsl:stylesheet>
