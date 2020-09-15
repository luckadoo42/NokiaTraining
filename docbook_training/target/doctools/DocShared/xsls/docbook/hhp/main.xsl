<?xml version='1.0'?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  version='1.0'>

<xsl:import href="../../../../docbook-xsl/1.72.0/xhtml/chunkfast.xsl"/>
<xsl:import href="../xhtml/l10n.xsl"/>
<xsl:import href="../xhtml/main.xsl"/>
<xsl:import href="related-topics.xsl"/>

<xsl:output 
	method="xml" 
	omit-xml-declaration="yes"/>

<xsl:include href="htmlhelp-common.xsl"/>

  <xsl:param name="branding"/>

  <xsl:param name="tooltip.glossterms">
	<xsl:choose>
	  <xsl:when test="$chm.type = 'book'">1</xsl:when>
	  <xsl:when test="$chm.type = 'help'">1</xsl:when>
	  <xsl:otherwise>1</xsl:otherwise>
	</xsl:choose>
  </xsl:param>


<!-- chm.type: possible values are help and book -->
<xsl:param name="chm.type">help</xsl:param>


  <!-- create section toc only for first section in chunk -->
  <xsl:param name="generate.section.toc.level">
	<xsl:choose>
	  <xsl:when test="$chm.type = 'help'">100</xsl:when>
	  <xsl:otherwise>100</xsl:otherwise>
	</xsl:choose>
  </xsl:param>

  
  <xsl:template name="empty.hhk">
	<xsl:call-template name="write.text.chunk">
	  <xsl:with-param name="filename" select="'Index.hhk'"/>
	  <xsl:with-param name="method" select="'text'"/>
	  <xsl:with-param name="content"></xsl:with-param>
	</xsl:call-template>
  </xsl:template>

  <xsl:template 
	match="processing-instruction('bjhhp')"
    mode="bjhhp">
	<xsl:value-of
    select="substring-before(substring-after(normalize-space(.),' '),'.chm ')"/>.chm
  </xsl:template>



<xsl:template name="section.level">
  <xsl:param name="node" select="."/>
  <xsl:choose>
    <xsl:when test="name($node)='sect1'">2</xsl:when>
    <xsl:when test="name($node)='sect2'">3</xsl:when>
    <xsl:when test="name($node)='sect3'">4</xsl:when>
    <xsl:when test="name($node)='sect4'">5</xsl:when>
    <xsl:when test="name($node)='sect5'">6</xsl:when>
    <xsl:when test="name($node)='section'">
      <xsl:choose>
        <xsl:when test="$node/../../../../../section">2</xsl:when>
        <xsl:when test="$node/../../../../section">2</xsl:when>
        <xsl:when test="$node/../../../section">2</xsl:when>
        <xsl:when test="$node/../../section">2</xsl:when>
        <xsl:otherwise>2</xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="name($node)='refsect1'">2</xsl:when>
    <xsl:when test="name($node)='refsect2'">3</xsl:when>
    <xsl:when test="name($node)='refsect3'">4</xsl:when>
    <xsl:when test="name($node)='simplesect'">
      <xsl:choose>
        <xsl:when test="$node/../../sect1">3</xsl:when>
        <xsl:when test="$node/../../sect2">4</xsl:when>
        <xsl:when test="$node/../../sect3">5</xsl:when>
        <xsl:when test="$node/../../sect4">6</xsl:when>
        <xsl:when test="$node/../../sect5">6</xsl:when>
        <xsl:when test="$node/../../section">
          <xsl:choose>
            <xsl:when test="$node/../../../../../section">6</xsl:when>
            <xsl:when test="$node/../../../../section">5</xsl:when>
            <xsl:when test="$node/../../../section">4</xsl:when>
            <xsl:otherwise>3</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>2</xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>2</xsl:otherwise>
  </xsl:choose>
</xsl:template><!-- section.level -->

<xsl:template match="copyright" mode="titlepage.footer.mode">
	<xsl:if test="$security = 'internal' or $security = 'reviewer' or $security = 'writeronly'">
	  <p xmlns="http://www.w3.org/1999/xhtml" class="{name(.)}">
		<a class="headerlink" href="javascript:void(0);" onmouseover="return overlib('{$motive.footer.popup.text}',DELAY,250,BGCLASS, 'bgClass',FGCLASS,'fgClass',CENTER);" onmouseout="return nd();">
      <xsl:choose>
        <xsl:when test="substring($branding,1,5) = 'nokia'">
          Nokia &#x2014; Confidential<br/>Solely for authorized persons having a need to know<br/>Proprietary &#x2014; Use pursuant to Company instructions
        </xsl:when>
        <xsl:otherwise>Alcatel-Lucent &#x2014; Internal<br/>Proprietary &#x2014; Use pursuant to Company instruction</xsl:otherwise>
      </xsl:choose>
		  
		</a></p>
	</xsl:if>
  <p xmlns="http://www.w3.org/1999/xhtml" class="{name(.)}">
	  <a>
		<xsl:attribute name="href"><xsl:value-of select="$root.filename"/></xsl:attribute>
    <xsl:call-template name="gentext">
      <xsl:with-param name="key" select="'Copyright'"/>
    </xsl:call-template>
	  </a>
    <xsl:call-template name="gentext.space"/>
    <xsl:call-template name="dingbat">
      <xsl:with-param name="dingbat">copyright</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="gentext.space"/>
    <xsl:call-template name="copyright.years">
      <xsl:with-param name="years" select="year"/>
      <xsl:with-param name="print.ranges" select="$make.year.ranges"/>
      <xsl:with-param name="single.year.ranges" select="$make.single.year.ranges"/>
    </xsl:call-template>
    <xsl:call-template name="gentext.space"/>
    <xsl:apply-templates select="holder" mode="titlepage.mode"/>
	</p>
</xsl:template>

<!-- section.toc -->
<xsl:template name="foobar">
  <xsl:variable name="toc.title">
    <p xmlns="http://www.w3.org/1999/xhtml">
      <b>
        <xsl:call-template name="gentext">
          <xsl:with-param name="key">TableofContents</xsl:with-param>
        </xsl:call-template>
      </b>
    </p>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$manual.toc != ''">
      <xsl:variable name="id">
        <xsl:call-template name="object.id"/>
      </xsl:variable>
      <xsl:variable name="toc" select="document($manual.toc, .)"/>
      <xsl:variable name="tocentry" select="$toc//tocentry[@linkend=$id]"/>
      <xsl:if test="$tocentry and $tocentry/*">
        <div xmlns="http://www.w3.org/1999/xhtml" class="toc">
          <xsl:copy-of select="$toc.title"/>
          <xsl:element name="{$toc.list.type}" namespace="http://www.w3.org/1999/xhtml">
            <xsl:call-template name="manual-toc">
              <xsl:with-param name="tocentry" select="$tocentry/*[1]"/>
            </xsl:call-template>
          </xsl:element>
        </div>
      </xsl:if>
    </xsl:when>
	  <xsl:otherwise>
<!-- 	<xsl:when test="./*[(self::title|self::chapterinfo|self::sectioninfo|self::indexterm[preceding-sibling::title|preceding-sibling::sectioninfo|preceding-sibling::chapterinfo])[following-sibling::*[1][self::section]]]"> -->
      <xsl:variable name="nodes" select="section|sect1|sect2|sect3|sect4|sect5|refentry                             |bridgehead"/>
      <xsl:if test="$nodes">
        <div xmlns="http://www.w3.org/1999/xhtml" class="toc">
          <xsl:copy-of select="$toc.title"/>
          <xsl:element name="{$toc.list.type}" namespace="http://www.w3.org/1999/xhtml">
            <xsl:apply-templates select="$nodes" mode="toc"/>
          </xsl:element>
        </div>
      </xsl:if>
<!-- 	  </xsl:when> -->
	  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

  <xsl:template
	match="processing-instruction('ftilde')"><xsl:text disable-output-escaping="yes">&#12316;</xsl:text></xsl:template>


  </xsl:stylesheet>
