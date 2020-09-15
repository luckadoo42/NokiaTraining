<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version='1.0'>

<!-- ********************************************************************
     $Id: admon.xsl,v 1.9 2007/02/21 22:39:09 dcramer Exp $
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://nwalsh.com/docbook/xsl/ for copyright
     and other information.

     ******************************************************************** -->
<xsl:param name="motive.always.use.original.nongraphical.admonition" select="0"/> 

<xsl:template match="note|important|warning|caution|tip">
  <xsl:choose>
    <xsl:when test="$admon.graphics != 0">
      <xsl:call-template name="graphical.admonition"/>
    </xsl:when>
	  <xsl:when test="self::tip or self::note or
		$motive.always.use.original.nongraphical.admonition
		!= 0">
		<xsl:call-template name="original.nongraphical.admonition"/>
	  </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="nongraphical.admonition"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="*" mode="admon.graphic.width">
  <xsl:param name="node" select="."/>
  <xsl:text>36pt</xsl:text>
</xsl:template>

<xsl:template name="admon.graphic">
  <xsl:param name="node" select="."/>

  <xsl:variable name="filename">
    <xsl:value-of select="$admon.graphics.path"/>
    <xsl:choose>
      <xsl:when test="local-name($node)='note'">note</xsl:when>
      <xsl:when test="local-name($node)='warning'">warning</xsl:when>
      <xsl:when test="local-name($node)='caution'">caution</xsl:when>
      <xsl:when test="local-name($node)='tip'">tip</xsl:when>
      <xsl:when test="local-name($node)='important'">important</xsl:when>
      <xsl:otherwise>note</xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="$admon.graphics.extension"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$passivetex.extensions != 0
                    or $fop.extensions != 0
                    or $arbortext.extensions != 0">
      <xsl:value-of select="$filename"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>url(</xsl:text>
      <xsl:value-of select="$filename"/>
      <xsl:text>)</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="graphical.admonition">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>
  <xsl:variable name="graphic.width">
     <xsl:apply-templates select="." mode="admon.graphic.width"/>
  </xsl:variable>

  <fo:block id="{$id}"
            xsl:use-attribute-sets="graphical.admonition.properties">
    <fo:list-block provisional-distance-between-starts="{$graphic.width} + 18pt"
                    provisional-label-separation="18pt">
      <fo:list-item>
          <fo:list-item-label end-indent="label-end()">
            <fo:block>
              <fo:external-graphic width="auto" height="auto"
                                         content-width="{$graphic.width}" >
                <xsl:attribute name="src">
                  <xsl:call-template name="admon.graphic"/>
                </xsl:attribute>
              </fo:external-graphic>
            </fo:block>
          </fo:list-item-label>
          <fo:list-item-body start-indent="body-start()">
            <xsl:if test="$admon.textlabel != 0 or title or info/title">
              <fo:block xsl:use-attribute-sets="admonition.title.properties">
                <xsl:apply-templates select="." mode="object.title.markup"/>
              </fo:block>
            </xsl:if>
            <fo:block xsl:use-attribute-sets="admonition.properties">
              <xsl:apply-templates/>
            </fo:block>
          </fo:list-item-body>
      </fo:list-item>
    </fo:list-block>
  </fo:block>
</xsl:template>

<!-- dwc: Modifying to make our admons look like motives -->
<xsl:template name="nongraphical.admonition">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

	<xsl:variable name="motive.admon.title">
	  <xsl:apply-templates select="." mode="object.title.markup"/>
	</xsl:variable>

	<xsl:variable
	  name="motive.admon.title.width">
	  <xsl:choose>
		<xsl:when test="string-length($motive.admon.title) &lt; 5">
		  <xsl:value-of	select="string-length($motive.admon.title) * .66"/>
		</xsl:when>
		<xsl:otherwise>
		  <xsl:value-of	select="string-length($motive.admon.title) * .55"/>
		</xsl:otherwise>
	  </xsl:choose>em</xsl:variable>

  <fo:block space-before.minimum="0.8em"
            space-before.optimum="1em"
            space-before.maximum="1.2em"
            id="{$id}">
	  <!-- dwc: Putting admon in a single item list to have the label float to the left of the admon body.  -->
	  <fo:list-block provisional-distance-between-starts="{$motive.admon.title.width}">
		<fo:list-item>
		  <xsl:attribute name="border-top-width">0.5pt</xsl:attribute>
		  <xsl:attribute name="border-top-style">solid</xsl:attribute>
		  <xsl:attribute name="border-top-color">black</xsl:attribute>
		  <xsl:attribute name="border-bottom-width">0.5pt</xsl:attribute>
		  <xsl:attribute name="border-bottom-style">solid</xsl:attribute>
		  <xsl:attribute name="border-bottom-color">black</xsl:attribute>
		  <fo:list-item-label 
			end-indent="label-end()">
			<fo:block
              xsl:use-attribute-sets="admonition.title.properties">
			  <fo:block>
				<xsl:apply-templates select="." mode="object.title.markup"/>
				</fo:block>
			</fo:block>
		  </fo:list-item-label>
		  <fo:list-item-body  
			start-indent="body-start()">
			<fo:block xsl:use-attribute-sets="admonition.properties">
			  <xsl:apply-templates/>
			</fo:block>
		  </fo:list-item-body>
		</fo:list-item>
	  </fo:list-block>
  </fo:block>
</xsl:template>

<xsl:template match="note/*[1][local-name()='para' or 
                                   local-name()='simpara' or 
                                   local-name()='formalpara']
                     |important/*[1][local-name()='para' or 
                                   local-name()='simpara' or 
                                   local-name()='formalpara']
                     |caution/*[1][local-name()='para' or 
                                   local-name()='simpara' or 
                                   local-name()='formalpara']
                     |tip/*[1][local-name()='para' or 
                                   local-name()='simpara' or 
                                   local-name()='formalpara']
                     |warning/*[1][local-name()='para' or 
                                   local-name()='simpara' or 
                                   local-name()='formalpara']"
              priority="2">
  <fo:block>
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<xsl:template match="note/title"></xsl:template>
<xsl:template match="important/title"></xsl:template>
<xsl:template match="warning/title"></xsl:template>
<xsl:template match="caution/title"></xsl:template>
<xsl:template match="tip/title"></xsl:template>

</xsl:stylesheet>
