<?xml version='1.0'?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version='1.0' xmlns="http://www.w3.org/1999/xhtml">

<xsl:import href="driver.xsl"/>

<!-- Alcatel stuff. -->
<!-- Also need to remove the line
<xsl:import href="titlepage.xsl"/>
from ../xhtml/main.xsl
-->
<xsl:param name="motive.include.infocenter.footer" select="''"/>
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
    <xsl:otherwise>1</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- end alcatel stuff -->

<!-- Alcatel stuff -->
<!-- Numbers of formal objects use x-y format -->

<!-- end alcatel stuff -->

  <xsl:param name="local.l10n.xml" select="document('')"/>
  <i18n xmlns="http://docbook.sourceforge.net/xmlns/l10n/1.0">

	<l10n language="en">
	  <!-- These are for the search stuff in chunked/plainhelp output -->
	  <gentext key="Search" text="Search"/>
	  <gentext key="Enter_a_term_and_click" text="Enter a term and click "/>
	  <gentext key="Go" text="Go"/>
	  <gentext key="to_perform_a_search" text=" to perform a search."/>
	  <gentext key="txt_filesfound" text="Results"/>
	  <gentext key="txt_enter_at_least_1_char" text="You must enter at least one character."/>
	  <gentext key="txt_browser_not_supported" text="Your browser is not supported. Use Internet Explorer or Mozilla/Firefox."/>
	  <gentext key="txt_please_wait" text="Please wait. Search in progress..."/>
	  <gentext key="txt_results_for" text="Results for: "/>

	  <gentext key="TableofContents" text="Contents"/> 
	  
	  <context name="title">
		<template name="procedure.formal" text="Procedure&#160;%n&#160;&#160;%t"/>     
		<template name="section" text="%n&#160;%t"/> 
	  </context>
	  
	  <context name="section-title-numbered">
		<template name="section" text="%n&#160;%t"/> 
	  </context>
	  

	  <context name="xref-number-and-title">
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
