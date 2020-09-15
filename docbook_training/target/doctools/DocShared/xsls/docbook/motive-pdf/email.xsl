<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet >
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:rx="http://www.renderx.com/XSL/Extensions"
                xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
                version="1.0">


<!-- <email> handler, added for JCBG-305
I chose to make a new file for this, so it could be shared by both motive-pdf and alcatel-pdf.
-Aaron DaMommio, 2/21/12
 -->
<xsl:param name="email.delimiters.enabled">0</xsl:param>

<xsl:template match="email">
  <xsl:call-template name="inline.boldseq">
    <xsl:with-param name="content">
      <!-- Added xref.properties below to make the links look like other links, per JCBG-305.-->
      <fo:inline xsl:use-attribute-sets="xref.properties" keep-together.within-line="always" hyphenate="false">
        <xsl:if test="not($email.delimiters.enabled = 0)">
          <xsl:text>&lt;</xsl:text>
        </xsl:if>
        <xsl:apply-templates/>
        <xsl:if test="not($email.delimiters.enabled = 0)">
          <xsl:text>&gt;</xsl:text>
        </xsl:if>
      </fo:inline>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

</xsl:stylesheet>
