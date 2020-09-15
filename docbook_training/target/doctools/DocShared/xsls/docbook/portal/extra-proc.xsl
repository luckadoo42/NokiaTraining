<?xml version ="1.0"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="2.0" xmlns:db="http://docbook.org/ns/docbook"
  xmlns="http://docbook.org/ns/docbook" xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  >

  <xsl:output method="xml" indent="yes"/>

  <!-- copy everything, unless it matches lower down... -->
  <xsl:template match="node() | * |@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

  <!-- JCBG-2126: Discard copyright elements for portal format. -->
  <xsl:template match="copyright" />

</xsl:stylesheet>
