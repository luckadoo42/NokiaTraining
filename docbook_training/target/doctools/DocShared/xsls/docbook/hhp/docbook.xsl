<?xml version='1.0'?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  version='1.1'>


  <xsl:import href="driver.xsl"/>
  <xsl:import href="../xhtml/titlepage.xsl"/>
 
  <!-- No idea why I have to put these here for it to work -->
  <xsl:param name="chapter.autolabel" select="0"/>
  <xsl:param name="appendix.autolabel" select="0"/>
  <xsl:param name="section.autolabel" select="0"/>
  <xsl:param name="suppress.navigation">0</xsl:param>
  <xsl:param name="generate.index" select="0"/>

  <xsl:output 
	method="xml" 
	omit-xml-declaration="yes"/>

</xsl:stylesheet>



