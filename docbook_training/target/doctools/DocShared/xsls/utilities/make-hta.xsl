<?xml version ="1.0"?>
<!DOCTYPE xsl:stylesheet>

  <xsl:stylesheet version="1.1"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:param name="output_file_name">index</xsl:param>
  <xsl:param name="chunk.frameset.start.filename">index.html</xsl:param>

  <xsl:param name="default.topic">
	<xsl:choose>
	  <xsl:when test="$htmlhelp.default.topic != ''">
		<xsl:value-of select="$htmlhelp.default.topic"/>
	  </xsl:when>
	  <xsl:when test="$manifest.in.base.dir != 0">
		<xsl:call-template name="href.target">
		  <xsl:with-param name="object" select="key('id',$rootid)"/>
		</xsl:call-template>
	  </xsl:when>
	  <xsl:otherwise>
		<xsl:call-template name="href.target.with.base.dir">
		  <xsl:with-param name="object" select="key('id',$rootid)"/>
		</xsl:call-template>
	  </xsl:otherwise>
	</xsl:choose>
  </xsl:param>
  
  <xsl:template name="make-frameset">

	<xsl:call-template name="write.chunk">
	  <xsl:with-param name="filename">frameset/toc.html</xsl:with-param>
	  <xsl:with-param name="quiet">1</xsl:with-param>
	  <xsl:with-param name="content"><xsl:call-template name="toc"/></xsl:with-param>
	</xsl:call-template>
	<xsl:call-template name="write.chunk">
	  <xsl:with-param name="filename">frameset/<xsl:value-of select="$output_file_name"/>.hta</xsl:with-param>
	  <xsl:with-param name="quiet">1</xsl:with-param>
	  <xsl:with-param name="content">
		<xsl:call-template name="hta"/>
	  </xsl:with-param>
	</xsl:call-template>
<!-- 	<xsl:call-template name="write.chunk"> -->
<!-- 	  <xsl:with-param name="filename">frameset/<xsl:value-of select="$chunk.frameset.start.filename"/></xsl:with-param> -->
<!-- 	  <xsl:with-param name="quiet">1</xsl:with-param> -->
<!-- 	  <xsl:with-param name="content"> -->
<!-- 		<xsl:call-template name="html"/> -->
<!-- 	  </xsl:with-param> -->
<!-- 	</xsl:call-template> -->
  </xsl:template>

  <xsl:template name="hta">
	<html>
	  <head>
		<title><xsl:value-of select="//title[1]"/></title>
		<HTA:APPLICATION
		  xmlns:HTA="http://www.microsoft.com/HTA" 
		  ID="oHTA"
		  APPLICATIONNAME="{//title[1]}"
		  BORDER="thick"
		  BORDERSTYLE="normal"
		  CAPTION="yes"
		  ICON="common/images/motive.ico"
		  MAXIMIZEBUTTON="yes"
		  MINIMIZEBUTTON="yes"
		  SHOWINTASKBAR="yes"
		  SINGLEINSTANCE="yes"
		  SYSMENU="yes"
		  VERSION="1.0"
		  WINDOWSTATE="normal"/>
		<script language="JavaScript" type="text/javascript" src="common/js/cookies.js"><xsl:comment>Comment to prevent and empty script element which confuses IE.</xsl:comment></script>
	  </head>
	  <frameset cols="30%, *" id="masterFrameset" onload="setFrameVis()">
		<frame name="toc" id="toc" src="toc.html" application="yes"/>
		<frame name="contentFrame" id="contentFrame" src="content/{$default.topic}" application="yes"/>
	  </frameset>
	</html>
  </xsl:template>

  <xsl:template name="html">
	<html>
	  <head>
		<title><xsl:value-of select="//title[1]"/></title>

		<script language="JavaScript" type="text/javascript" src="common/js/cookies.js"><xsl:comment>Comment to prevent empty script element which confuses IE.</xsl:comment></script>
	  </head>
	  <frameset cols="30%, *" id="masterFrameset" onload="setFrameVis()">
		<frame name="toc" id="toc" src="toc.html" />
		<frame name="contentFrame" id="contentFrame" src="content/{$default.topic}" />
	  </frameset>
	</html>
  </xsl:template>

  <xsl:template name="toc">
	<html>
	  <head>
		<title><xsl:call-template name="gentext">
            <xsl:with-param name="key" select="'TableofContents'"/>
          </xsl:call-template></title>
		<link rel="stylesheet" href="content/common/html.css" type="text/css"/>
		<style type="text/css">
		  .OLRow {vertical-align:middle; }
		  .OLBlock {display:none}
		  img.widgetArt {vertical-align:text-top}
		  body { white-space: nowrap;}
		  a, a:link, a:visited{	
		  color: black;
		  background: white;
		  text-decoration: none;
		  }
		</style>
		<script language="JavaScript" type="text/javascript" src="common/js/XMLoutline-eclipse.js"><xsl:comment>Preventing this from being empty script element, which confuses IE </xsl:comment></script>
	  </head>
	  <body onload="initXMLOutline('content/toc.xml')">
		<h1 style="font-size:1.2em; font-weight:bold"><xsl:call-template name="gentext">
            <xsl:with-param name="key" select="'TableofContents'"/>
          </xsl:call-template></h1>
		<hr />
		<div id="content"></div>
		<!-- Try to load Msxml.DOMDocument ActiveX to assist support verification -->
		<object id="msxml" WIDTH="1" HEIGHT="1" classid="CLSID:2933BF90-7B36-11d2-B20E-00C04F983E60" ></object>
	  </body>
	</html>
	
  </xsl:template>


  </xsl:stylesheet>
