<?xml version='1.0'?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version='1.0' xmlns="http://www.w3.org/1999/xhtml">

  <xsl:import href="../hhp/docbook.xsl"/>
  <xsl:import href="eclipse.xsl"/>
  <xsl:include href="../xhtml/changebars.xsl"/>

  <xsl:output 
	method="xml" 
	omit-xml-declaration="no"/>

  <xsl:include href="related-topics.xsl"/>

<!-- Alcatel stuff. -->
<!-- Also need to remove the line
<xsl:import href="titlepage.xsl"/>
from ../xhtml/main.xsl
 -->
<xsl:param name="section.autolabel" select="1"/>
<xsl:param name="section.label.includes.component.label" select="1"/>
<xsl:param name="section.autolabel.max.depth">1</xsl:param>
<xsl:param name="formal.procedures" select="1"/>
<xsl:param name="eclipse.autolabel" select="1"/>
<xsl:param name="appendix.autolabel" select="'A'"/>
<xsl:param name="part.autolabel" select="'I'"/>
<xsl:param name="chapter.autolabel" select="1"/>
<xsl:param name="procedures.in.toc">0</xsl:param>

<xsl:template name="section.level">
  <xsl:param name="node" select="."/>
  <xsl:choose>
    <xsl:when test="local-name($node)='sect1'">1</xsl:when>
    <xsl:when test="local-name($node)='sect2'">2</xsl:when>
    <xsl:when test="local-name($node)='sect3'">3</xsl:when>
    <xsl:when test="local-name($node)='sect4'">4</xsl:when>
    <xsl:when test="local-name($node)='sect5'">5</xsl:when>
    <xsl:when test="local-name($node)='section'">
      <xsl:choose>
        <xsl:when test="$node/../../../../../../section">6</xsl:when>
        <xsl:when test="$node/../../../../../section">5</xsl:when>
        <xsl:when test="$node/../../../../section">4</xsl:when>
        <xsl:when test="$node/../../../section">3</xsl:when>
        <xsl:when test="$node/../../section">2</xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="local-name($node)='refsect1' or
                    local-name($node)='refsect2' or
                    local-name($node)='refsect3' or
                    local-name($node)='refsection' or
                    local-name($node)='refsynopsisdiv'">
      <xsl:call-template name="refentry.section.level">
        <xsl:with-param name="node" select="$node"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="local-name($node)='simplesect'">
      <xsl:choose>
        <xsl:when test="$node/../../sect1">2</xsl:when>
        <xsl:when test="$node/../../sect2">3</xsl:when>
        <xsl:when test="$node/../../sect3">4</xsl:when>
        <xsl:when test="$node/../../sect4">5</xsl:when>
        <xsl:when test="$node/../../sect5">5</xsl:when>
        <xsl:when test="$node/../../section">
          <xsl:choose>
            <xsl:when test="$node/../../../../../section">5</xsl:when>
            <xsl:when test="$node/../../../../section">4</xsl:when>
            <xsl:when test="$node/../../../section">3</xsl:when>
            <xsl:otherwise>2</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>1</xsl:otherwise>
  </xsl:choose>
</xsl:template><!-- section.level -->


<xsl:template match="figure|table|example" mode="label.markup">
  <xsl:variable name="pchap"
                select="ancestor::chapter
                        |ancestor::appendix
                        |ancestor::article[ancestor::book]"/>

  <xsl:variable name="prefix">
    <xsl:if test="count($pchap) &gt; 0">
      <xsl:apply-templates select="$pchap" mode="label.markup"/>
    </xsl:if>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="@label">
      <xsl:value-of select="@label"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="$prefix != ''">
            <xsl:apply-templates select="$pchap" mode="label.markup"/>
	    <xsl:text>-</xsl:text>
          <xsl:number format="1" from="chapter|appendix" level="any"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:number format="1" from="book|article" level="any"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="procedure" mode="label.markup">
  <xsl:variable name="pchap"
                select="ancestor::chapter
                        |ancestor::appendix
                        |ancestor::article[ancestor::book]"/>

  <xsl:variable name="prefix">
    <xsl:if test="count($pchap) &gt; 0">
      <xsl:apply-templates select="$pchap" mode="label.markup"/>
    </xsl:if>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="@label">
      <xsl:value-of select="@label"/>
    </xsl:when>
    <xsl:when test="$formal.procedures = 0">
      <!-- No label -->
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="count($pchap)>0">
          <xsl:if test="$prefix != ''">
            <xsl:apply-templates select="$pchap" mode="label.markup"/>
	    <xsl:text>-</xsl:text>
          </xsl:if>
          <xsl:number count="procedure[title]" format="1" 
                      from="chapter|appendix" level="any"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:number count="procedure[title]" format="1" 
                      from="book|article" level="any"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="label.this.section">
  <xsl:param name="section" select="."/>

  <xsl:variable name="level">
    <xsl:call-template name="section.level"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$section/ancestor::preface">0</xsl:when>
    <xsl:when test="$level &lt;= $section.autolabel.max.depth">      
      <xsl:value-of select="$section.autolabel"/>
    </xsl:when>
    <xsl:otherwise>0</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- end alcatel stuff -->

  <xsl:param name="htmlhelp.use.hhk" select="0"/>  
  <xsl:param name="suppress.navigation">0</xsl:param>

<xsl:param name="eclipse.plugin.name"><xsl:value-of select="normalize-space(//title[1])"/></xsl:param>
  <xsl:param name="eclipse.plugin.id"><xsl:call-template name="escape-quotes">
      <xsl:with-param name="value" select="translate(normalize-space(//title[1]),' :,.', '_')"/>
    </xsl:call-template></xsl:param>
<xsl:param name="eclipse.plugin.provider">Alcatel-Lucent</xsl:param>
<xsl:param name="generate.index" select="1"/>
<xsl:param name="inherit.keywords" select="'0'"/>
  <xsl:param name="PLANID"/>
  <xsl:param name="BUILDNUMBER"/>

<xsl:param name="tooltip.glossterms">1</xsl:param>

<xsl:template name="write.indexterm"/>

<xsl:template name="header.navigation">
  <xsl:param name="prev" select="/foo"/>
  <xsl:param name="next" select="/foo"/>
  <xsl:variable name="home" select="/*[1]"/>
  <xsl:variable name="up" select="parent::*"/>
	<xsl:variable name="quote.char">"</xsl:variable>	

  <xsl:if test="$suppress.navigation = '0'">
    <div xmlns="http://www.w3.org/1999/xhtml" class="navheader">
      <table width="100%" summary="Navigation header">
	<xsl:if test="$navig.showtitles != 0">
	  <tr>
	    <th colspan="3" align="center">
              <xsl:apply-templates select="." mode="object.title.markup"/>
            </th>
          </tr>
        </xsl:if>
        <tr>
          <td width="20%" align="left">
            <xsl:if test="count($prev)&gt;0  and not(local-name($prev) = local-name(/*[1]))">
              <a accesskey="p">
                <xsl:attribute name="href">
                  <xsl:call-template name="href.target">
                    <xsl:with-param name="object" select="$prev"/>
                  </xsl:call-template>
                </xsl:attribute>
<script language="Javascript" type="text/javascript"><xsl:comment><xsl:text>
document.write('</xsl:text>
                <xsl:call-template name="navig.content">
		    <xsl:with-param name="direction" select="'prev'"/>
		</xsl:call-template>
<xsl:text>')
</xsl:text>//</xsl:comment></script>
              </a>
            </xsl:if>
            <xsl:text>&#160;</xsl:text>
          </td>
          <th width="60%" align="center">
			  <xsl:if test="not(self::book)">
				<b><script language="Javascript" type="text/javascript"><xsl:comment><xsl:text>
document.write("</xsl:text>
<xsl:value-of select="normalize-space(translate(/*[1]//title[1],$quote.char,''))"/>
<xsl:text>")</xsl:text>//</xsl:comment></script></b>
			  </xsl:if>
            <xsl:choose>
              <xsl:when test="count($up) &gt; 0 and $up != $home and $navig.showtitles != 0">
                <xsl:apply-templates select="$up" mode="object.title.markup"/>
              </xsl:when>
              <xsl:otherwise>&#160;</xsl:otherwise>
            </xsl:choose>
          </th>
          <td width="20%" align="right">
            <xsl:text>&#160;</xsl:text>
            <xsl:if test="count($next)&gt;0">
              <a accesskey="n">
                <xsl:attribute name="href">
                  <xsl:call-template name="href.target">
                    <xsl:with-param name="object" select="$next"/>
                  </xsl:call-template>
                </xsl:attribute>
<script language="Javascript" type="text/javascript"><xsl:comment><xsl:text>
document.write('</xsl:text>
                <xsl:call-template name="navig.content">
		    <xsl:with-param name="direction" select="'next'"/>
		</xsl:call-template>
<xsl:text>')
</xsl:text>//</xsl:comment></script>
              </a>
            </xsl:if>
			  <xsl:call-template name="feedback"/>
          </td>
        </tr>
      </table>
<!--       <hr/> -->
    </div>
  </xsl:if>
  </xsl:template>


  <xsl:template name="user.head.content">
<xsl:text>
</xsl:text>
 	  <script type="text/javascript" src="common/motive.js"><xsl:comment> </xsl:comment></script>
<xsl:text>
</xsl:text>
	  <link rel="stylesheet" type="text/css" href="common/classic.css" />
<xsl:text>
</xsl:text>
	<meta name="date" >  
	  <xsl:attribute name="content">  
		<xsl:call-template name="datetime.format">  
		  <xsl:with-param name="date" select="date:date-time()" xmlns:date="http://exslt.org/dates-and-times"/>  
		  <xsl:with-param name="format" select="'m/d/Y H:M:S'"/>  
		</xsl:call-template>
	  </xsl:attribute>
	</meta>
<xsl:text>
</xsl:text>
	<meta name="copyright">
	  <xsl:attribute name="content">Copyright (c) <xsl:value-of select="//year[1]"/><xsl:text> </xsl:text>Alcatel-Lucent. All rights reserved. </xsl:attribute>
	</meta>
<xsl:text>
</xsl:text>
	<xsl:if test="$hostname">
	  <meta name="build-info-maker" content="DocShared\docbook\eclipse\alcatel.xsl"/> 
	  <meta name="buildinfo" content="{$hostname}"/> 
	</xsl:if>
   	<xsl:if test="$docfilename">
	  <meta name="docfilename" content="{$docfilename}"/> 
	</xsl:if>
   	<xsl:if test="$buildtag">
	  <meta name="buildtag" content="{$buildtag}"/> 
	</xsl:if>
        <xsl:if test="$PLANID">
	  <meta name="Build" content="{$PLANID}-{$BUILDNUMBER}"/> 
	</xsl:if>
<xsl:text>
</xsl:text>
	<xsl:call-template name="keywordset"/>
<xsl:text>
</xsl:text>
  </xsl:template>

<!--   <xsl:template name="body.attributes"> -->
<!-- 	<xsl:attribute name="onload">initjsDOMenu();</xsl:attribute> -->
<!--   </xsl:template> -->
  

<!-- ==================================================================== -->
<!-- Template for escaping <, & and " in attribute values. 
     We aren't using HTML output method, so we must do this job ourselves -->

<xsl:template name="escape-quotes">
	<xsl:param name="value"/>
	<xsl:variable name="quote.char">'</xsl:variable>
  <xsl:variable name="amp.escaped">
    <xsl:call-template name="string.subst">
      <xsl:with-param name="string" select="$value"/>
      <xsl:with-param name="target" select="'&amp;'"/>
      <xsl:with-param name="replacement" select="'_'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="quot.escaped">
    <xsl:call-template name="string.subst">
      <xsl:with-param name="string" select="$amp.escaped"/>
      <xsl:with-param name="target" select="'&quot;'"/>
      <xsl:with-param name="replacement" select="'_'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="angle.escaped">
    <xsl:call-template name="string.subst">
      <xsl:with-param name="string" select="$quot.escaped"/>
      <xsl:with-param name="target" select="'&lt;'"/>
      <xsl:with-param name="replacement" select="'_'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="ndash.escaped">
    <xsl:call-template name="string.subst">
      <xsl:with-param name="string" select="$angle.escaped"/>
      <xsl:with-param name="target" select="'&#8211;'"/>
      <xsl:with-param name="replacement" select="'-'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="mdash.escaped">
    <xsl:call-template name="string.subst">
      <xsl:with-param name="string" select="$ndash.escaped"/>
      <xsl:with-param name="target" select="'&#8212;'"/>
      <xsl:with-param name="replacement" select="'-'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="lsquo.escaped">
    <xsl:call-template name="string.subst">
      <xsl:with-param name="string" select="$mdash.escaped"/>
      <xsl:with-param name="target" select="'&#8216;'"/>
      <xsl:with-param name="replacement" select="'_'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="rsquo.escaped">
    <xsl:call-template name="string.subst">
      <xsl:with-param name="string" select="$lsquo.escaped"/>
      <xsl:with-param name="target" select="'&#8217;'"/>
      <xsl:with-param name="replacement" select="'_'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="ldquo.escaped">
    <xsl:call-template name="string.subst">
      <xsl:with-param name="string" select="$rsquo.escaped"/>
      <xsl:with-param name="target" select="'&#8220;'"/>
      <xsl:with-param name="replacement" select="'_'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="rdquo.escaped">
    <xsl:call-template name="string.subst">
      <xsl:with-param name="string" select="$ldquo.escaped"/>
      <xsl:with-param name="target" select="'&#8221;'"/>
      <xsl:with-param name="replacement" select="'_'"/>
    </xsl:call-template>
  </xsl:variable>

<!-- 
	These last two are real ugly to do, but I haven't
	been able to get Saxon to work with ISO 8859-15-->
  <xsl:variable name="oe.escaped">
    <xsl:call-template name="string.subst">
      <xsl:with-param name="string" select="$rdquo.escaped"/>
      <xsl:with-param name="target" select="'&#339;'"/>
      <xsl:with-param name="replacement" select="'oe'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="OE.escaped">
    <xsl:call-template name="string.subst">
      <xsl:with-param name="string" select="$oe.escaped"/>
      <xsl:with-param name="target" select="'&#338;'"/>
      <xsl:with-param name="replacement" select="'OE'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="apos.escaped">
    <xsl:call-template name="string.subst">
      <xsl:with-param name="string" select="$OE.escaped"/>
      <xsl:with-param name="target" select="$quote.char"/>
      <xsl:with-param name="replacement" select="'_'"/>
    </xsl:call-template>
  </xsl:variable>


  <xsl:value-of select="$apos.escaped"/>

</xsl:template>
  
<!-- Alcatel stuff -->
<!-- Numbers of formal objects use x-y format -->

<!-- end alcatel stuff -->

  <xsl:param name="local.l10n.xml" select="document('')"/>
  <i18n xmlns="http://docbook.sourceforge.net/xmlns/l10n/1.0">

	<l10n language="en">
	  
	  <gentext key="TableofContents" text="Contents"/> 
	  
	  <context name="title">
		<template name="procedure.formal" text="Procedure&#160;%n&#160;&#160;%t"/>     
		<template name="section" text="%n&#160;%t"/> 
	  </context>
	  
	  <context name="title-numbered">
		<template name="chapter" text="%n&#160;&#8212;&#160;&#160;%t"/> 
		<template name="appendix" text="%n&#160;&#8212;&#160;&#160;%t"/> 
		<template name="part" text="Part&#160;%n&#160;&#8212;&#160;&#160;%t"/> 
		<template name="section" text="%n&#160;%t"/> 
		<template name="sect1" text="%n&#160;%t"/> 
	  </context>
	  
	  <context name="xref">
		<template name="section" text="&#8220;%t&#8221;"/> 
		<template name="procedure.formal" text="Procedure&#160;%n&#160;&#160;%t"/>     
		<template name="procedure" text="Procedure&#160;%n&#160;&#160;%t"/>     
	  </context>
	  
   <context name="glossary">
	<template name="see" text="See %t."/>
	<template name="seealso" text="See also %t."/>
	<template name="seealso-separator" text=", "/>
   </context>

	</l10n>
  </i18n>

<!-- Adding this modification to fix a bug where section autolabel isn't working -->
<xsl:template match="section/title | section/sectioninfo/title" mode="titlepage.mode">
  <!-- JCBG-1366: added 'section/sectioninfo/title' to the match to catch cases where the title is done as <section><info><title/></info></section> in the original db5 xml source; the symptom is that such a section doesn't display its section number (autolabel). -->

  <xsl:variable name="id">
    <xsl:choose>
      <!-- if title is in an *info wrapper, get the grandparent -->
      <xsl:when test="contains(local-name(..), 'info')">
        <xsl:call-template name="object.id">
          <xsl:with-param name="object" select="../.."/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="object.id">
          <xsl:with-param name="object" select=".."/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <h1>
    <xsl:apply-templates select="." mode="class.attribute"/>
    <a id="{$id}"/>
    <xsl:choose>
      <xsl:when test="$show.revisionflag != 0 and @revisionflag">
	<span class="{@revisionflag}">
			<!-- modification: --><xsl:call-template name="section.title"/>
	</span>
      </xsl:when>
      <xsl:otherwise>
		  <!-- modification: --><xsl:call-template name="section.title"/>
      </xsl:otherwise>
    </xsl:choose>
  </h1>
</xsl:template>

<!-- Adding this modification to fix a bug where chapter autolabel isn't working -->
<xsl:template match="chapter/title | chapter/chapterinfo/title" mode="titlepage.mode">
  <!-- JCBG-1366: added 'chapter/chapterinfo/title' to the match to catch cases where the title is done as <chapter><info><title/></info></chapter> in the original db5 xml source; the symptom is that such a section doesn't display its chapter number (autolabel). -->

  <xsl:variable name="id">
    <xsl:choose>
      <!-- if title is in an *info wrapper, get the grandparent -->
      <xsl:when test="contains(local-name(..), 'info')">
        <xsl:call-template name="object.id">
          <xsl:with-param name="object" select="../.."/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="object.id">
          <xsl:with-param name="object" select=".."/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <h1>
    <xsl:apply-templates select="." mode="class.attribute"/>
    <a id="{$id}"/>
    <xsl:choose>
      <xsl:when test="$show.revisionflag != 0 and @revisionflag">
	<span class="{@revisionflag}">
			<!-- modification: -->
			<!-- 	  <xsl:apply-templates mode="titlepage.mode"/> -->
			<xsl:call-template name="component.title">
			  <xsl:with-param name="node" select="ancestor::chapter[1]"/>
			</xsl:call-template>
	</span>
      </xsl:when>
      <xsl:otherwise>
		  <!-- modification: -->
		  <!-- 	  <xsl:apply-templates mode="titlepage.mode"/> -->
			<xsl:call-template name="component.title">
			  <xsl:with-param name="node" select="ancestor::chapter[1]"/>
			</xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </h1>
</xsl:template>

</xsl:stylesheet>



