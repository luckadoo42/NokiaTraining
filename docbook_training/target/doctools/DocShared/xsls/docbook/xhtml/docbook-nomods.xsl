<?xml version='1.0'?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  version='1.0'>
  <xsl:import href="../../../../DocBookXSL/1.70.0/xhtml/docbook.xsl"/>


  <xsl:param name="suppress.footer.navigation">0</xsl:param>
  <xsl:param name="suppress.header.navigation">0</xsl:param>
  <xsl:param name="suppress.navigation">0</xsl:param>

  <xsl:param name="admon.graphics.path">./common/</xsl:param>
  <xsl:param name="callout.graphics.extension" select="'.gif'"/>
  <xsl:param name="callout.graphics.path" select="'./common/'"/>
  <xsl:param name="chunk.quietly" select="0"/>
</xsl:stylesheet>



