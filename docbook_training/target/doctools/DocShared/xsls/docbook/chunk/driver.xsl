<?xml version='1.0'?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version='1.0' xmlns="http://www.w3.org/1999/xhtml">

  <xsl:import href="../hhp/docbook.xsl"/>
  <xsl:import href="toc.xsl"/>
  <xsl:import href="../xhtml/titlepage.xsl"/>

  <xsl:output 
	method="xml" 
	omit-xml-declaration="no"/>

  <xsl:include href="../eclipse/related-topics.xsl"/>

  <xsl:param name="common.files" select="'../common'"/>
  <!-- for JCBG-1585 and JCBG-672, new param css.filename -->
  <xsl:param name="css.filename" select="'html.css'"/>
  <xsl:param name="html.stylesheet" select="concat('../common/css/', $css.filename)"/>
  <xsl:param name="common.graphics.path"/>
  <xsl:param name="callout.graphics.path" select="'images/_common/'"/>  
  <xsl:param name="manifest.in.base.dir" select="0"/>
  <xsl:param name="base.dir" select="'content/'"/>
  <xsl:param name="htmlhelp.use.hhk" select="1"/>  
  <xsl:param name="suppress.navigation">0</xsl:param>
  <xsl:param name="eclipse.autolabel" select="0"/>
  <xsl:param name="eclipse.plugin.name"><xsl:value-of select="normalize-space(//title[1])"/></xsl:param>
  <xsl:param name="eclipse.plugin.id"><xsl:value-of select="translate(normalize-space(//title[1]),' :,.', '_')"/></xsl:param>
  <xsl:param name="eclipse.plugin.provider">Motive Tech Pubs</xsl:param>
  <xsl:param name="generate.index" select="1"/>
  <xsl:param name="inherit.keywords" select="'0'"/>
  <xsl:param name="PLANID"/>
  <xsl:param name="BUILDNUMBER"/>

  <xsl:param name="tooltip.glossterms">1</xsl:param>

<xsl:template name="header.navigation">
  <xsl:param name="prev" select="/foo"/>
  <xsl:param name="next" select="/foo"/>
  <xsl:variable name="home" select="/*[1]"/>
  <xsl:variable name="up" select="parent::*"/>

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
            <xsl:if test="count($prev)&gt;0 and not(local-name($prev) = local-name(/*[1]))">
              <a accesskey="p">
                <xsl:attribute name="href">
                  <xsl:call-template name="href.target">
                    <xsl:with-param name="object" select="$prev"/>
                  </xsl:call-template>
                </xsl:attribute>
                <xsl:call-template name="navig.content">
		    <xsl:with-param name="direction" select="'prev'"/>
		</xsl:call-template>
              </a>
            </xsl:if>
            <xsl:text>&#160;</xsl:text>
          </td>
          <th width="60%" align="center">
			  <xsl:if test="not(self::book)">
				<b><xsl:value-of select="/*[1]//title[1]"/></b>
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
                <xsl:call-template name="navig.content">
		    <xsl:with-param name="direction" select="'next'"/>
		</xsl:call-template>
              </a>
            </xsl:if>
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
	<script type="text/javascript" src="../common/js/cookies.js"><xsl:comment>IE needs this comment because &lt;script/> confuses it</xsl:comment></script>
<xsl:text>
</xsl:text>
<!-- 	  <link rel="stylesheet" type="text/css" href="common/js/classic.css" /> -->
<!-- <xsl:text> -->
<!-- </xsl:text> -->
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
	  <meta name="build-info-maker" content="DocShared\docbook\chunk\driver.xsl"/> 
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

  <xsl:template name="body.attributes">
	<xsl:attribute name="onload">setToggleUI();</xsl:attribute>
  </xsl:template>
  
<!-- for JCBG-689, adding [last()] to this template so that it only triggers on the last legalnotice element in the document -->
<xsl:template match="legalnotice[last()]" mode="book.titlepage.recto.auto.mode">
  <div xsl:use-attribute-sets="book.titlepage.recto.style">
    <xsl:apply-templates select="." mode="book.titlepage.recto.mode"/>
  </div>
  <p>
    <b>Note:</b> <span id="chunked-third-party-software"> This help system may use software from the following sources:</span>
  <ul>
    <li><p><a href="http://www.bosrup.com/web/overlib/">overLib 4.21</a>. Copyright (c) Erik Bosrup 1998-2004. <!-- (<a href="common/js/overlib.js">src</a>) --></p></li>
    <li><p><a href="http://tech.groups.yahoo.com/group/dita-users/files/Demos/" target="_top">htmlsearch 1.04</a>. (Requires a Yahoo ID and membership in the dita-users Yahoo group.) Copyright (c) 2007-2008 NexWave Solutions. </p></li>
    <li><p><a href="http://www.silverstripe.org">Silverstripe tree-control</a>. Copyright (c) 2005 SilverStripe Limited. <!-- (<a href="common/tree/tree.js">src</a>) --></p></li>
  </ul>
  </p>
</xsl:template>

  
</xsl:stylesheet>



