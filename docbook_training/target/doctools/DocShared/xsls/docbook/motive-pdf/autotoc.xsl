<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
                version='1.0'>

<!-- ********************************************************************
     $Id: autotoc.xsl,v 1.17 2007/02/21 22:39:09 dcramer Exp $
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://nwalsh.com/docbook/xsl/ for copyright
     and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->

<xsl:template name="set.toc">
  <xsl:param name="toc-context" select="."/>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="cid">
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="$toc-context"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="nodes" select="book|setindex"/>

  <xsl:if test="$nodes">
    <fo:block id="toc...{$id}"
              xsl:use-attribute-sets="toc.margin.properties">
      <xsl:if test="$axf.extensions != 0">
        <xsl:attribute name="axf:outline-level">1</xsl:attribute>
        <xsl:attribute name="axf:outline-expand">false</xsl:attribute>
        <xsl:attribute name="axf:outline-title">
          <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="'TableofContents'"/>
          </xsl:call-template>
        </xsl:attribute>
      </xsl:if>
      <xsl:call-template name="table.of.contents.titlepage"/>
      <xsl:apply-templates select="$nodes" mode="toc">
        <xsl:with-param name="toc-context" select="$toc-context"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template name="division.toc">
  <xsl:param name="toc-context" select="."/>
  <xsl:param name="toc.title.p" select="true()"/>

  <xsl:variable name="cid">
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="$toc-context"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="nodes"
                select="$toc-context/part
                        |$toc-context/reference
                        |$toc-context/preface
                        |$toc-context/chapter
                        |$toc-context/appendix
                        |$toc-context/article
                        |$toc-context/bibliography
                        |$toc-context/glossary
                        |$toc-context/index"/>

  <xsl:if test="$nodes">
    <fo:block id="toc...{$cid}"
              margin-top="-.33in"
              xsl:use-attribute-sets="toc.margin.properties">
      <xsl:if test="$axf.extensions != 0">
        <xsl:attribute name="axf:outline-level">1</xsl:attribute>
        <xsl:attribute name="axf:outline-expand">false</xsl:attribute>
        <xsl:attribute name="axf:outline-title">
          <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="'TableofContents'"/>
          </xsl:call-template>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="$toc.title.p">
        <xsl:call-template name="table.of.contents.titlepage"/>
      </xsl:if>
      <xsl:apply-templates select="$nodes" mode="toc">
        <xsl:with-param name="toc-context" select="$toc-context"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template name="component.toc">
  <xsl:param name="toc-context" select="."/>
  <xsl:param name="toc.title.p" select="true()"/>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="cid">
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="$toc-context"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="nodes" select="section|sect1|refentry
                                     |article|bibliography|glossary
                                     |appendix|index"/>
  <xsl:if test="$nodes">
    <fo:block id="toc...{$id}"
              xsl:use-attribute-sets="toc.margin.properties">
      <xsl:if test="$toc.title.p">
        <xsl:call-template name="table.of.contents.titlepage"/>
      </xsl:if>
      <xsl:apply-templates select="$nodes" mode="toc">
        <xsl:with-param name="toc-context" select="$toc-context"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template name="component.toc.separator">
  <!-- Customize to output something between
       component.toc and first output -->
</xsl:template>

<xsl:template name="section.toc">
  <xsl:param name="toc-context" select="."/>
  <xsl:param name="toc.title.p" select="true()"/>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="cid">
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="$toc-context"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="nodes"
                select="section|sect1|sect2|sect3|sect4|sect5|refentry
                        |bridgehead[$bridgehead.in.toc != 0]"/>

  <xsl:variable name="level">
    <xsl:call-template name="section.level"/>
  </xsl:variable>

  <xsl:if test="$nodes">
    <fo:block id="toc...{$id}"
              xsl:use-attribute-sets="toc.margin.properties">

      <xsl:if test="$toc.title.p">
        <xsl:call-template name="section.heading">
          <xsl:with-param name="level" select="$level + 1"/>
          <xsl:with-param name="title">
            <fo:block space-after="0.5em">
              <xsl:call-template name="gentext">
                <xsl:with-param name="key" select="'TableofContents'"/>
              </xsl:call-template>
            </fo:block>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>

      <xsl:apply-templates select="$nodes" mode="toc">
        <xsl:with-param name="toc-context" select="$toc-context"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template name="section.toc.separator">
  <!-- Customize to output something between
       section.toc and first output -->
</xsl:template>
<!-- ==================================================================== -->

<xsl:template name="toc.line">
  <xsl:param name="toc-context" select="NOTANODE"/>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="label">
    <xsl:apply-templates select="." mode="label.markup"/>
  </xsl:variable>

  <fo:block xsl:use-attribute-sets="toc.line.properties"
            end-indent="{$toc.indent.width}pt"
            last-line-end-indent="-{$toc.indent.width}pt">
     <!-- JCBG-393: set indent for qandadiv titles specially  -->
     <xsl:if test="local-name(.)='qandadiv'">
        <xsl:attribute name="margin-left">0em</xsl:attribute>
     </xsl:if>
 
    <fo:inline keep-with-next.within-line="always">
      <fo:basic-link internal-destination="{$id}">
<!--         <xsl:if test="$label != ''"> -->
<!--           <xsl:copy-of select="$label"/> -->
<!--           <xsl:value-of select="$autotoc.label.separator"/> -->
<!--         </xsl:if> -->
        <xsl:apply-templates select="." mode="titleabbrev.markup"/>
      </fo:basic-link>
    </fo:inline>
    <fo:inline keep-together.within-line="always">
      <xsl:text> </xsl:text>
      <fo:leader leader-pattern="dots"
                 leader-pattern-width="3pt"
                 leader-alignment="reference-area"
                 keep-with-next.within-line="always"/>
      <xsl:text> </xsl:text> 
      <fo:basic-link internal-destination="{$id}">
        <fo:page-number-citation ref-id="{$id}"/>
      </fo:basic-link>
    </fo:inline>
  </fo:block>
</xsl:template>

<!-- ==================================================================== -->
<xsl:template name="qandaset.toc">
  <xsl:param name="toc-context" select="."/>
  <xsl:param name="toc.title.p" select="true()"/>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="cid">
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="$toc-context"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="nodes" select="qandadiv|qandaentry"/>

  <xsl:if test="$nodes">
    <fo:block id="toc...{$id}"
              xsl:use-attribute-sets="toc.margin.properties">
      <xsl:if test="$toc.title.p">
        <xsl:call-template name="table.of.contents.titlepage"/>
      </xsl:if>
      <xsl:apply-templates select="$nodes" mode="toc">
        <xsl:with-param name="toc-context" select="$toc-context"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template name="qandaset.toc.separator">
  <!-- Customize to output something between
       qandaset.toc and first output -->
</xsl:template>

<xsl:template match="qandadiv" mode="toc">
  <xsl:param name="toc-context" select="."/>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="cid">
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="$toc-context"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:call-template name="toc.line">
    <xsl:with-param name="toc-context" select="$toc-context"/>
  </xsl:call-template>

  <xsl:variable name="nodes" select="qandadiv|qandaentry"/>

  <xsl:if test="$nodes">
    <fo:block id="toc.{$cid}.{$id}">
      <xsl:attribute name="margin-left">
        <xsl:call-template name="set.toc.indent"/>
      </xsl:attribute>

      <xsl:apply-templates select="$nodes" mode="toc">
        <xsl:with-param name="toc-context" select="$toc-context"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template match="qandaentry" mode="toc">
  <xsl:apply-templates select="question" mode="toc"/>
</xsl:template>

<xsl:template match="question" mode="toc">
  <xsl:variable name="firstchunk">
    <xsl:apply-templates select="(*[local-name(.)!='label'])[1]/node()"/>
  </xsl:variable>

  <xsl:variable name="deflabel">
    <xsl:choose>
      <xsl:when test="ancestor-or-self::*[@defaultlabel]">
        <xsl:value-of select="(ancestor-or-self::*[@defaultlabel])[last()]
                              /@defaultlabel"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$qanda.defaultlabel"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="label">
    <xsl:apply-templates select="." mode="label.markup"/>
  </xsl:variable>

  <fo:block xsl:use-attribute-sets="toc.line.properties"
	    margin-left="3em"
	    text-indent="-3em"
            end-indent="{$toc.indent.width}pt"
            last-line-end-indent="-{$toc.indent.width}pt">
    <fo:inline keep-with-next.within-line="always">
      <fo:basic-link internal-destination="{$id}">
        <xsl:if test="$label != ''">
          <xsl:copy-of select="$label"/>
          <xsl:if test="$deflabel = 'number' and not(label)">
            <xsl:value-of select="$autotoc.label.separator"/>
          </xsl:if>
	  <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:value-of select="$firstchunk"/><!-- orig <xsl:copy-of select="$firstchunk"/> 
        chgd this to value-of in order to prevent it including dupe ids for indexterms when those are in the chunk, for JCBG-76
        
        -->
      </fo:basic-link>
    </fo:inline>
    <fo:inline keep-together.within-line="always">
      <xsl:text> </xsl:text>
      <fo:leader leader-pattern="dots"
                 leader-pattern-width="3pt"
                 leader-alignment="reference-area"
                 keep-with-next.within-line="always"/>
      <xsl:text> </xsl:text> 
      <fo:basic-link internal-destination="{$id}">
        <fo:page-number-citation ref-id="{$id}"/>
      </fo:basic-link>
    </fo:inline>
  </fo:block>

</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="book|setindex" mode="toc">
  <xsl:param name="toc-context" select="."/>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="cid">
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="$toc-context"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:call-template name="toc.line">
    <xsl:with-param name="toc-context" select="$toc-context"/>
  </xsl:call-template>

  <xsl:variable name="nodes" select="glossary|bibliography|preface|chapter
                                     |reference|part|article|appendix|index"/>

  <xsl:variable name="depth.from.context" select="count(ancestor::*)-count($toc-context/ancestor::*)"/>

  <xsl:if test="$toc.section.depth > 0 
                and $toc.max.depth > $depth.from.context
                and $nodes">
    <fo:block id="toc.{$cid}.{$id}">
      <xsl:attribute name="margin-left">
        <xsl:call-template name="set.toc.indent"/>
      </xsl:attribute>

      <xsl:apply-templates select="$nodes" mode="toc">
        <xsl:with-param name="toc-context" select="$toc-context"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template match="part" mode="toc">
  <xsl:param name="toc-context" select="."/>

	<xsl:variable name="motive.part.label">
	  <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'Part'"/>
      </xsl:call-template><xsl:text> </xsl:text>
      <xsl:number from="book" count="part" format="I"/>
	</xsl:variable>

	<xsl:variable name="motive.part.title">
	  <xsl:apply-templates select="." mode="title.markup"/>
	</xsl:variable>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="cid">
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="$toc-context"/>
    </xsl:call-template>
  </xsl:variable>

<fo:block  margin-left="-.3in" space-before="2em">
	<fo:list-block>
	  <fo:list-item>
		<fo:list-item-label end-indent="1in" >
		  <fo:block font-weight="normal">
			<fo:inline><xsl:value-of select="translate($motive.part.label,'abcdefghijklmnopqrstuvwxyz&#223;&#224;&#225;&#226;&#227;&#228;&#229;&#230;&#231;&#232;&#233;&#234;&#235;&#236;&#237;&#238;&#239;&#240;&#241;&#242;&#243;&#244;&#245;&#246;&#247;&#248;&#249;&#250;&#251;&#252;&#253;','ABCDEFGHIJKLMNOPQRSTUVWXYZ&#223;&#192;&#193;&#194;&#195;&#196;&#197;&#198;&#199;&#200;&#201;&#202;&#203;&#204;&#205;&#206;&#207;&#208;&#209;&#210;&#211;&#212;&#213;&#214;&#215;&#216;&#217;&#218;&#219;&#220;&#221;')"/></fo:inline>
		  </fo:block>
		</fo:list-item-label>
		<fo:list-item-body start-indent="body-start()">
<fo:block>
			  <fo:block 
				keep-with-next.within-column="always"
				keep-together.within-column="always" 
				font-weight="normal"
				padding-bottom="-.1em"
				text-align="start"
				text-align-last="start"
				xsl:use-attribute-sets="toc.line.properties"
				end-indent="{$toc.indent.width}pt"
				last-line-end-indent="-{$toc.indent.width}pt">
				<xsl:value-of select="translate($motive.part.title,'abcdefghijklmnopqrstuvwxyz&#223;&#224;&#225;&#226;&#227;&#228;&#229;&#230;&#231;&#232;&#233;&#234;&#235;&#236;&#237;&#238;&#239;&#240;&#241;&#242;&#243;&#244;&#245;&#246;&#247;&#248;&#249;&#250;&#251;&#252;&#253;','ABCDEFGHIJKLMNOPQRSTUVWXYZ&#223;&#192;&#193;&#194;&#195;&#196;&#197;&#198;&#199;&#200;&#201;&#202;&#203;&#204;&#205;&#206;&#207;&#208;&#209;&#210;&#211;&#212;&#213;&#214;&#215;&#216;&#217;&#218;&#219;&#220;&#221;')"/>
			  </fo:block>

  <xsl:variable name="nodes" select="chapter|appendix|preface|reference|
                                     refentry|article|index|glossary|
                                     bibliography"/>

  <xsl:variable name="depth.from.context" select="count(ancestor::*)-count($toc-context/ancestor::*)"/>

  <xsl:if test="$toc.section.depth > 0 
                and $toc.max.depth > $depth.from.context
                and $nodes">
    <fo:block id="toc.{$cid}.{$id}">
      <xsl:attribute name="margin-left">
        <xsl:call-template name="set.toc.indent"/>
      </xsl:attribute>
      
      <xsl:apply-templates select="$nodes" mode="toc">
        <xsl:with-param name="toc-context" select="$toc-context"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:if>
			</fo:block>
		  </fo:list-item-body>
		</fo:list-item>
	  </fo:list-block>
	</fo:block>
</xsl:template>

<xsl:template match="reference" mode="toc">
  <xsl:param name="toc-context" select="."/>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="cid">
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="$toc-context"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="depth.from.context" select="count(ancestor::*)-count($toc-context/ancestor::*)"/>

  <xsl:call-template name="toc.line">
    <xsl:with-param name="toc-context" select="$toc-context"/>
  </xsl:call-template>

  <xsl:if test="$toc.section.depth > 0
                and $toc.max.depth > $depth.from.context
                and refentry">
    <fo:block id="toc.{$cid}.{$id}">
      <xsl:attribute name="margin-left">
        <xsl:call-template name="set.toc.indent"/>
      </xsl:attribute>
              
      <xsl:apply-templates select="refentry" mode="toc">
        <xsl:with-param name="toc-context" select="$toc-context"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template match="refentry" mode="toc">
  <xsl:param name="toc-context" select="."/>

  <xsl:call-template name="toc.line">
    <xsl:with-param name="toc-context" select="$toc-context"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="preface|chapter|appendix|article"
              mode="toc">
  <xsl:param name="toc-context" select="."/>

	<xsl:variable name="motive.chapter.label">
	  <xsl:choose>
		<xsl:when test="local-name(.) = 'chapter'">
		  <xsl:number from="book" count="chapter" format="1" level="any"/>
		</xsl:when>
		<xsl:when test="local-name(.) = 'appendix'">
		  <xsl:number from="book" count="appendix" format="A" level="any"/>
		</xsl:when>
		<xsl:otherwise></xsl:otherwise>
	  </xsl:choose>
	</xsl:variable>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="cid">
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="$toc-context"/>
    </xsl:call-template>
  </xsl:variable>

  <fo:block text-align-last="justify"
	             space-before.optimum=".3em"
	             space-after.optimum=".25em"
	  keep-with-next.within-column="always"
	  keep-together.within-column="always"
	  xsl:use-attribute-sets="toc.line.properties"
            last-line-end-indent="-{$toc.indent.width}pt">
    <fo:inline>
      <fo:leader leader-pattern="rule"
                 rule-thickness="1pt"
	             leader-length.maximum="102.5%"
                 leader-alignment="reference-area"
                 keep-with-next.within-line="always"
		  margin-left="-.255em" 
		  />
	  </fo:inline>
	</fo:block>
<fo:block 	  margin-left="-.35in">
	<fo:list-block>
	  <fo:list-item>
		<fo:list-item-label end-indent="1in" >
		  <fo:block 				margin-top="-1.1em">
			<fo:inline
			  font-size="42pt"
			  color="silver"><xsl:value-of select="$motive.chapter.label"/></fo:inline>
		  </fo:block>
		</fo:list-item-label>
		<fo:list-item-body start-indent="body-start()">
<fo:block>
	  <fo:inline font-weight="bold">
  <xsl:call-template name="toc.line">
    <xsl:with-param name="toc-context" select="$toc-context"/>
  </xsl:call-template>
	  </fo:inline>

  <xsl:variable name="nodes" select="section|sect1
                                     |simplesect[$simplesect.in.toc != 0]
                                     |refentry|appendix"/>

  <xsl:variable name="depth.from.context" select="count(ancestor::*)-count($toc-context/ancestor::*)"/>

  <xsl:if test="$toc.section.depth > 0 
                and $toc.max.depth > $depth.from.context
                and $nodes">
    <fo:block id="toc.{$cid}.{$id}">
      <xsl:attribute name="margin-left">
        <xsl:call-template name="set.toc.indent"/>
      </xsl:attribute>
              
      <xsl:apply-templates select="$nodes" mode="toc">
        <xsl:with-param name="toc-context" select="$toc-context"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:if>
		  </fo:block>
		</fo:list-item-body>
	  </fo:list-item>
	</fo:list-block>
	</fo:block>
</xsl:template>

<xsl:template match="sect1" mode="toc">
  <xsl:param name="toc-context" select="."/>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="cid">
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="$toc-context"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:call-template name="toc.line">
    <xsl:with-param name="toc-context" select="$toc-context"/>
  </xsl:call-template>

  <xsl:variable name="depth.from.context" select="count(ancestor::*)-count($toc-context/ancestor::*)"/>

  <xsl:if test="$toc.section.depth > 1 
                and $toc.max.depth > $depth.from.context
                and sect2">
    <fo:block id="toc.{$cid}.{$id}">
      <xsl:attribute name="margin-left">
        <xsl:call-template name="set.toc.indent"/>
      </xsl:attribute>
              
      <xsl:apply-templates select="sect2" mode="toc">
        <xsl:with-param name="toc-context" select="$toc-context"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template match="sect2" mode="toc">
  <xsl:param name="toc-context" select="."/>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="cid">
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="$toc-context"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:call-template name="toc.line">
    <xsl:with-param name="toc-context" select="$toc-context"/>
  </xsl:call-template>

  <xsl:variable name="reldepth"
                select="count(ancestor::*)-count($toc-context/ancestor::*)"/>

  <xsl:variable name="depth.from.context" select="count(ancestor::*)-count($toc-context/ancestor::*)"/>

  <xsl:if test="$toc.section.depth > 2 
                and $toc.max.depth > $depth.from.context
                and sect3">
    <fo:block id="toc.{$cid}.{$id}">
      <xsl:attribute name="margin-left">
        <xsl:call-template name="set.toc.indent">
          <xsl:with-param name="reldepth" select="$reldepth"/>
        </xsl:call-template>
      </xsl:attribute>
              
      <xsl:apply-templates select="sect3" mode="toc">
        <xsl:with-param name="toc-context" select="$toc-context"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template match="sect3" mode="toc">
  <xsl:param name="toc-context" select="."/>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="cid">
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="$toc-context"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:call-template name="toc.line">
    <xsl:with-param name="toc-context" select="$toc-context"/>
  </xsl:call-template>

  <xsl:variable name="reldepth"
                select="count(ancestor::*)-count($toc-context/ancestor::*)"/>

  <xsl:variable name="depth.from.context" select="count(ancestor::*)-count($toc-context/ancestor::*)"/>

  <xsl:if test="$toc.section.depth > 3 
                and $toc.max.depth > $depth.from.context
                and sect4">
    <fo:block id="toc.{$cid}.{$id}">
      <xsl:attribute name="margin-left">
        <xsl:call-template name="set.toc.indent">
          <xsl:with-param name="reldepth" select="$reldepth"/>
        </xsl:call-template>
      </xsl:attribute>
              
      <xsl:apply-templates select="sect4" mode="toc">
        <xsl:with-param name="toc-context" select="$toc-context"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template match="sect4" mode="toc">
  <xsl:param name="toc-context" select="."/>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="cid">
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="$toc-context"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:call-template name="toc.line">
    <xsl:with-param name="toc-context" select="$toc-context"/>
  </xsl:call-template>

  <xsl:variable name="reldepth"
                select="count(ancestor::*)-count($toc-context/ancestor::*)"/>

  <xsl:variable name="depth.from.context" select="count(ancestor::*)-count($toc-context/ancestor::*)"/>

  <xsl:if test="$toc.section.depth > 4 
                and $toc.max.depth > $depth.from.context
                and sect5">
    <fo:block id="toc.{$cid}.{$id}">
      <xsl:attribute name="margin-left">
        <xsl:call-template name="set.toc.indent">
          <xsl:with-param name="reldepth" select="$reldepth"/>
        </xsl:call-template>
      </xsl:attribute>
              
      <xsl:apply-templates select="sect5" mode="toc">
        <xsl:with-param name="toc-context" select="$toc-context"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template match="sect5|simplesect" mode="toc">
  <xsl:param name="toc-context" select="."/>

  <xsl:call-template name="toc.line">
    <xsl:with-param name="toc-context" select="$toc-context"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="set.toc.indent">
  <xsl:param name="reldepth"/>

  <xsl:variable name="depth">
    <xsl:choose>
      <xsl:when test="$reldepth != ''">
        <xsl:value-of select="$reldepth"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="count(ancestor::*)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$fop.extensions != 0 or $passivetex.extensions != 0">
       <xsl:value-of select="concat($depth*$toc.indent.width, 'pt')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat($toc.indent.width, 'pt')"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="section" mode="toc">
  <xsl:param name="toc-context" select="."/>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="cid">
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="$toc-context"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="depth" select="count(ancestor::section) + 1"/>
  <xsl:variable name="reldepth"
                select="count(ancestor::*)-count($toc-context/ancestor::*)"/>

  <xsl:variable name="depth.from.context" select="count(ancestor::*)-count($toc-context/ancestor::*)"/>

  <xsl:if test="$toc.section.depth &gt;= $depth">
    <xsl:call-template name="toc.line">
      <xsl:with-param name="toc-context" select="$toc-context"/>
    </xsl:call-template>

    <xsl:if test="$toc.section.depth > $depth 
                  and $toc.max.depth > $depth.from.context
                  and section">
      <fo:block id="toc.{$cid}.{$id}">
        <xsl:attribute name="margin-left">
          <xsl:call-template name="set.toc.indent">
            <xsl:with-param name="reldepth" select="$reldepth"/>
          </xsl:call-template>
        </xsl:attribute>
                
        <xsl:apply-templates select="section" mode="toc">
          <xsl:with-param name="toc-context" select="$toc-context"/>
        </xsl:apply-templates>
      </fo:block>
    </xsl:if>
  </xsl:if>
</xsl:template>

<xsl:template match="bibliography"
              mode="toc">
  <xsl:param name="toc-context" select="."/>

  <xsl:call-template name="toc.line">
    <xsl:with-param name="toc-context" select="$toc-context"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="index|glossary" mode="toc">
  <xsl:param name="toc-context" select="."/>

  <xsl:if test="* or $generate.index != 0 or self::glossary">
	  <fo:block space-before="1em" keep-with-previous.within-column="always" keep-together.within-column="always">
		<fo:inline font-weight="bold">
    <xsl:call-template name="toc.line">
    <xsl:with-param name="toc-context" select="$toc-context"/>
  </xsl:call-template>
		</fo:inline>
	  </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template match="title" mode="toc">
  <xsl:apply-templates/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="list.of.titles">
  <xsl:param name="titles" select="'table'"/>
  <xsl:param name="nodes" select=".//table"/>
  <xsl:param name="toc-context" select="."/>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:if test="$nodes">
    <fo:block id="lot...{$titles}...{$id}">
      <xsl:choose>
        <xsl:when test="$titles='table'">
          <xsl:call-template name="list.of.tables.titlepage"/>
        </xsl:when>
        <xsl:when test="$titles='figure'">
          <xsl:call-template name="list.of.figures.titlepage"/>
        </xsl:when>
        <xsl:when test="$titles='equation'">
          <xsl:call-template name="list.of.equations.titlepage"/>
        </xsl:when>
        <xsl:when test="$titles='example'">
          <xsl:call-template name="list.of.examples.titlepage"/>
        </xsl:when>
        <xsl:when test="$titles='procedure'">
          <xsl:call-template name="list.of.procedures.titlepage"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="list.of.unknowns.titlepage"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="$nodes" mode="toc">
        <xsl:with-param name="toc-context" select="$toc-context"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template match="figure|table|example|equation|procedure" mode="toc">
  <xsl:param name="toc-context" select="."/>
  <xsl:call-template name="toc.line">
    <xsl:with-param name="toc-context" select="$toc-context"/>
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->

</xsl:stylesheet>

