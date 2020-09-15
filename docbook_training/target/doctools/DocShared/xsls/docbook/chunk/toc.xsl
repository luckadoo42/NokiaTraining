<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0">
  
  <!-- ********************************************************************
  $Id: toc.xsl,v 1.19 2009/05/28 15:47:55 dcramer Exp $
  ********************************************************************

  This file is part of the XSL DocBook Stylesheet distribution.
  See ../README or http://nwalsh.com/docbook/xsl/ for copyright
  and other information.

  ******************************************************************** -->
  <xsl:include href="../../utilities/make-hta.xsl"/>

  <xsl:output 
	method="xml" 
	omit-xml-declaration="no"/>

  <xsl:param name="manifest.in.base.dir">0</xsl:param>
  <xsl:param name="chunked.toc.all.open">0</xsl:param>
  <xsl:param name="exclude.search.from.chunked.html">false</xsl:param>
  <xsl:param name="chunk_output_file_name"><xsl:value-of select="$output_file_name"/></xsl:param>
  <xsl:param name="chunk.default.topic"><xsl:value-of select="$htmlhelp.default.topic"/></xsl:param>

  <xsl:param name="PLANID"/>
  <xsl:param name="BUILDNUMBER"/>

  <xsl:template match="/">
	<xsl:choose>
	  <xsl:when test="$rootid != ''">
		<xsl:choose>
		  <xsl:when test="count(key('id',$rootid)) = 0">
			<xsl:message terminate="yes">
			  <xsl:text>ID '</xsl:text>
			  <xsl:value-of select="$rootid"/>
			  <xsl:text>' not found in document.</xsl:text>
			</xsl:message>
		  </xsl:when>
		  <xsl:otherwise>
			<xsl:message>Formatting from <xsl:value-of select="$rootid"/></xsl:message>
			<xsl:apply-templates select="key('id',$rootid)" mode="process.root"/>
		  </xsl:otherwise>
		</xsl:choose>
	  </xsl:when>
	  <xsl:otherwise>
		<xsl:apply-templates select="/" mode="process.root"/>
	  </xsl:otherwise>
	</xsl:choose>

	<xsl:call-template name="etoc"/>
	<xsl:call-template name="index.html"/>
	<xsl:call-template name="web.xml"/>
	<xsl:if test="$exclude.search.from.chunked.html != 'true'">
	  <xsl:call-template name="search"/>
	</xsl:if>

  </xsl:template>

  <xsl:template name="etoc">
	<xsl:call-template name="write.chunk">
	  <xsl:with-param name="filename"><xsl:value-of select="'toc.html'"/></xsl:with-param>
	  <xsl:with-param name="method" select="'xml'"/>
	  <xsl:with-param name="encoding" select="'utf-8'"/>
	  <xsl:with-param name="indent" select="'no'"/>
	  <xsl:with-param name="content">
		<xsl:choose>

		  <xsl:when test="$rootid != ''">
			<xsl:variable name="title">
			  <xsl:if test="$eclipse.autolabel=1">
				<xsl:variable name="label.markup">
				  <xsl:apply-templates select="key('id',$rootid)" mode="label.markup"/>
				</xsl:variable>
				<xsl:if test="normalize-space($label.markup)">
				  <xsl:value-of select="concat($label.markup,$autotoc.label.separator)"/>
				</xsl:if>
			  </xsl:if>
			  <xsl:apply-templates select="key('id',$rootid)" mode="title.markup"/>
			</xsl:variable>
			<xsl:variable name="href">
			  <xsl:choose>
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
			</xsl:variable>
			
			<!--           <toc label="{$title}" topic="{concat($base.dir,$href)}"> -->
			<!--             <xsl:apply-templates select="key('id',$rootid)/*" mode="etoc"/> -->
			<!--           </toc> -->
		  </xsl:when>

		  <xsl:otherwise>
			<xsl:variable name="title">
			  <xsl:if test="$eclipse.autolabel=1">
				<xsl:variable name="label.markup">
				  <xsl:apply-templates select="/*" mode="label.markup"/>
				</xsl:variable>
				<xsl:if test="normalize-space($label.markup)">
				  <xsl:value-of select="concat($label.markup,$autotoc.label.separator)"/>
				</xsl:if>
			  </xsl:if>
			  <xsl:apply-templates select="/*" mode="title.markup"/>
			</xsl:variable>
			<xsl:variable name="href">
			  <xsl:choose>
				<xsl:when test="$manifest.in.base.dir != 0">
				  <xsl:call-template name="href.target">
					<xsl:with-param name="object" select="/"/>
				  </xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
				  <xsl:call-template name="href.target.with.base.dir">
					<xsl:with-param name="object" select="/"/>
				  </xsl:call-template>
				</xsl:otherwise>
			  </xsl:choose>
			</xsl:variable>
			<html>
			  <head>
				<meta http-equiv="X-UA-Compatible" content="IE=7" />
				<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
				<title><xsl:call-template name="gentext">
					<xsl:with-param name="key" select="'TableofContents'"/>
				  </xsl:call-template></title>
				<link rel="stylesheet" type="text/css" media="all" href="common/tree/tree.css" />
				<script type="text/javascript" src="common/tree/tree.js"><xsl:comment> </xsl:comment></script>
				<style type="text/css">
				  body{
				  font-family: Verdana, Arial, Helvetica, sans-serif;
				  font-size: small;
				  color: black;
				  background: white;
				  }
				  a, a:link, a:visited{	
				  text-decoration: none;
				  }
				  img {vertical-align:text-top}
				  ul.tree { width: 10in; }
				</style>
				<!-- Call template "metatags" to add copyright and date meta tags:  -->
				<xsl:call-template name="metatags"/>
				<link rel="stylesheet" type="text/css" media="screen" href="common/css/tabs.css"/>
			  </head>
			  <body>
				<div>
				  <ul id="tabnav">
					<li><a href="#" class="active"><xsl:call-template name="gentext">
					<xsl:with-param name="key" select="'TableofContents'"/>
				  </xsl:call-template></a></li>
					<xsl:if test="$exclude.search.from.chunked.html != 'true'">
					  <li><a href="search.html"><xsl:call-template name="gentext">
							<xsl:with-param name="key" select="'Search'"/>
						  </xsl:call-template></a></li>
					</xsl:if>
				  </ul>
				</div>
				<div>
				  <ul class="tree">
					<xsl:apply-templates select="/*/*" mode="etoc"/>
					<!--           <toc label="{$title}" topic="{$href}"> -->
					<!--             <xsl:apply-templates select="/*/*" mode="etoc"/> -->
					<!--           </toc> -->
				  </ul>
				</div>
			  </body>
			</html>

		  </xsl:otherwise>

		</xsl:choose>
	  </xsl:with-param>
	</xsl:call-template>
  </xsl:template>

  <xsl:template match="book|part|reference|preface|chapter|bibliography|appendix|article|glossary|section|simplesect|sect1|sect2|sect3|sect4|sect5|refentry|colophon|bibliodiv|index" mode="etoc">
	<xsl:variable name="title">
	  <xsl:if test="$eclipse.autolabel=1">
		<xsl:variable name="label.markup">
		  <xsl:apply-templates select="." mode="label.markup"/>
		</xsl:variable>
		<xsl:if test="normalize-space($label.markup)">
		  <xsl:value-of select="concat($label.markup,$autotoc.label.separator)"/>
		</xsl:if>
	  </xsl:if>
	  <xsl:apply-templates select="." mode="title.markup"/>
	</xsl:variable>

	<xsl:variable name="href">
	  <xsl:choose>
		<xsl:when test="$manifest.in.base.dir != 0">
		  <xsl:call-template name="href.target"/>
		</xsl:when>
		<xsl:otherwise>
		  <xsl:call-template name="href.target.with.base.dir"/>
		</xsl:otherwise>
	  </xsl:choose>
	</xsl:variable>
	<xsl:if test="not(self::index) or (self::index and not($generate.index = 0))">
	<li style="white-space: pre; line-height: 0em;"><xsl:attribute name="class"><xsl:choose><xsl:when test="part|reference|preface|chapter|bibliography|appendix|article|glossary|section|simplesect|sect1|sect2|sect3|sect4|sect5|refentry|colophon|bibliodiv and $chunked.toc.all.open = 0">closed</xsl:when><xsl:otherwise>open</xsl:otherwise></xsl:choose></xsl:attribute><a target="contentFrame" href="{concat($base.dir,$href)}"><xsl:value-of select="$title"/></a><xsl:if test="part|reference|preface|chapter|bibliography|appendix|article|glossary|section|simplesect|sect1|sect2|sect3|sect4|sect5|refentry|colophon|bibliodiv"><ul><xsl:apply-templates select="part|reference|preface|chapter|bibliography|appendix|article|glossary|section|simplesect|sect1|sect2|sect3|sect4|sect5|refentry|colophon|bibliodiv" mode="etoc"/></ul></xsl:if>
	</li>
	</xsl:if>
  </xsl:template>

  <xsl:template match="text()" mode="etoc"/>

  <xsl:template name="index.html">
<xsl:variable name="default.topic">
  <xsl:choose>
    <xsl:when test="$chunk.default.topic != ''">
      <xsl:value-of select="$chunk.default.topic"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="make-relative-filename">
        <xsl:with-param name="base.dir">
          <xsl:if test="$manifest.in.base.dir = 0">
            <xsl:value-of select="$base.dir"/>
          </xsl:if>
        </xsl:with-param>
        <xsl:with-param name="base.name">
          <xsl:choose>
            <xsl:when test="$rootid != ''">
              <xsl:apply-templates select="key('id',$rootid)" mode="chunk-filename"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="preface|chapter|appendix|section|simplesect" mode="chunk-filename"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>
	<xsl:call-template name="write.chunk">
	  <xsl:with-param name="filename">
		<!--       <xsl:if test="$manifest.in.base.dir != 0"> -->
		<!--         <xsl:value-of select="$base.dir"/> -->
		<!--       </xsl:if> -->
		<xsl:choose>
		  <xsl:when test="$chunk.frameset.start.filename"><xsl:value-of select="$chunk.frameset.start.filename"/></xsl:when>
		  <xsl:otherwise><xsl:value-of select="'index.html'"/></xsl:otherwise>
		</xsl:choose>
	  </xsl:with-param>
	  <xsl:with-param name="method" select="'xml'"/>
	  <xsl:with-param name="encoding" select="'utf-8'"/>
	  <xsl:with-param name="indent" select="'yes'"/>
	  <xsl:with-param name="content">
		<html>
		  <head>
			<meta http-equiv="X-UA-Compatible" content="IE=7" />
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
			<title><xsl:value-of select="//title[1]"/>&#160;</title>
			<script language="JavaScript" type="text/javascript" src="common/js/cookies.js"><xsl:comment> </xsl:comment></script>
			<!-- Call template "metatags" to add copyright and date meta tags:  -->
			<xsl:call-template name="metatags"/>
		  </head>
		  <frameset cols="250px, *" id="masterFrameset" onload="setFrameVis();">
			<frame noresize="1" name="toc" id="toc" src="toc.html" />
			<frame name="contentFrame" id="contentFrame" src="{concat('content/',$default.topic)}" scrolling="yes" />
		  </frameset>
		</html>
	  </xsl:with-param>
	</xsl:call-template>
  </xsl:template>

  <xsl:template name="web.xml">
	<xsl:call-template name="write.chunk">
	  <xsl:with-param name="filename">
		<xsl:value-of select="'web.xml'"/>
	  </xsl:with-param>
	  <xsl:with-param name="method" select="'xml'"/>
	  <xsl:with-param name="encoding" select="'utf-8'"/>
	  <xsl:with-param name="indent" select="'yes'"/>
	  <xsl:with-param name="content">
		<web-app id="{$chunk_output_file_name}">

		  <display-name><xsl:value-of select="$chunk_output_file_name"/></display-name>

		  <welcome-file-list>
			<welcome-file><xsl:choose>
		  <xsl:when test="$chunk.frameset.start.filename"><xsl:value-of select="$chunk.frameset.start.filename"/></xsl:when>
		  <xsl:otherwise><xsl:value-of select="'index.html'"/></xsl:otherwise>
		</xsl:choose></welcome-file>
		  </welcome-file-list>

<!-- 		  <security-constraint> -->

<!-- 			<web-resource-collection> -->
<!-- 			  <web-resource-name>All Pages</web-resource-name> -->
<!-- 			  <url-pattern>*.*</url-pattern> -->
<!-- 			  <http-method>POST</http-method> -->
<!-- 			  <http-method>GET</http-method> -->
<!-- 			</web-resource-collection> -->
			
<!-- 			<auth-constraint> -->
<!-- 			  <role-name>ReadTelemetry</role-name> -->
<!-- 			</auth-constraint> -->
			
<!-- 			<user-data-constraint> -->
<!-- 			  <transport-guarantee>NONE</transport-guarantee> -->
<!-- 			</user-data-constraint>	 -->

<!-- 		  </security-constraint> -->

<!-- 		  <login-config> -->
<!-- 			<auth-method>BASIC</auth-method> -->
<!-- 			<realm-name>Motive CSR Console</realm-name> -->
<!-- 		  </login-config> -->
		  
<!-- 		  <security-role> -->
<!-- 			<role-name>ReadTelemetry</role-name> -->
<!-- 		  </security-role> -->
		 
		</web-app>
	  </xsl:with-param>
	</xsl:call-template>
  </xsl:template>

  <xsl:template name="search">
	<xsl:call-template name="write.chunk">
	  <xsl:with-param name="filename">search.html</xsl:with-param>
	  <xsl:with-param name="method" select="'xml'"/>
	  <xsl:with-param name="encoding" select="'utf-8'"/>
	  <xsl:with-param name="indent" select="'yes'"/>
	  <xsl:with-param name="content">
		<html>
		  <head>
			<meta http-equiv="X-UA-Compatible" content="IE=7"/>
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
			<title><xsl:call-template name="gentext">
					<xsl:with-param name="key" select="'Search'"/>
				  </xsl:call-template></title>
			<link href="common/css/tabs.css" type="text/css" rel="stylesheet"/>
			<!-- Call template "metatags" to add copyright and date meta tags:  -->
			<xsl:call-template name="metatags"/>
		  </head>
		  <frameset frameborder="no" border="0" framespacing="0" rows="100px, *" id="searchFrameset">
			<frame  noresize="1"  marginwidth="10" marginheight="10" scrolling="no" name="searchwin" id="searchwin" src="searchbox.html"/>
			<frame noresize="1"  marginwidth="10" marginheight="10" name="searchresults" id="searchresults" src="searchresults.html" scrolling="yes"/>
		  </frameset>
		</html>
	  </xsl:with-param>
	</xsl:call-template>
	<xsl:call-template name="write.chunk">
	  <xsl:with-param name="filename">searchbox.html</xsl:with-param>
	  <xsl:with-param name="method" select="'xml'"/>
	  <xsl:with-param name="encoding" select="'utf-8'"/>
	  <xsl:with-param name="indent" select="'yes'"/>
	  <xsl:with-param name="content">
		<html>
		  <head>
			<meta http-equiv="X-UA-Compatible" content="IE=7"/>
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
			<title><xsl:call-template name="gentext">
					<xsl:with-param name="key" select="'Search'"/>
				  </xsl:call-template></title>
			<script type="text/javascript" src="content/search/addition.js"><xsl:comment> </xsl:comment></script>
			<script type="text/javascript" src="content/search/indexLoader.js"><xsl:comment> </xsl:comment></script>
			<script language="JavaScript">
			  txt_filesfound = "<xsl:call-template name="gentext">
					<xsl:with-param name="key" select="'txt_filesfound'"/>
				  </xsl:call-template>";
			  txt_enter_at_least_1_char = "<xsl:call-template name="gentext">
					<xsl:with-param name="key" select="'txt_enter_at_least_1_char'"/>
				  </xsl:call-template>";
			  txt_browser_not_supported = "<xsl:call-template name="gentext">
					<xsl:with-param name="key" select="'txt_browser_not_supported'"/>
				  </xsl:call-template>";
			  txt_please_wait = "<xsl:call-template name="gentext">
					<xsl:with-param name="key" select="'txt_please_wait'"/>
				  </xsl:call-template>";
			  txt_results_for = "<xsl:call-template name="gentext">
					<xsl:with-param name="key" select="'txt_results_for'"/>
				  </xsl:call-template>";
			</script>
			<script type="text/javascript" src="content/search/nwSearchFnt.js"><xsl:comment> </xsl:comment></script>
			<link rel="stylesheet" type="text/css" media="screen" href="common/css/tabs.css"/>
			<xsl:text disable-output-escaping="yes">
&lt;!--[if IE]></xsl:text>
			<style>
			input{
			margin-bottom: 5px;
			margin-top: 2px;}
		    </style>		
<xsl:text disable-output-escaping="yes">&lt;![endif]-->
</xsl:text>
			<!-- Call template "metatags" to add copyright and date meta tags:  -->
			<xsl:call-template name="metatags"/>
		  </head>
		  <body>
			<ul id="tabnav">
			  <li><a target="toc" href="toc.html"><xsl:call-template name="gentext">
					<xsl:with-param name="key" select="'TableofContents'"/>
				  </xsl:call-template></a></li>
			  <li><a class="active" href="#"><xsl:call-template name="gentext">
					<xsl:with-param name="key" select="'Search'"/>
				  </xsl:call-template></a></li>
			</ul>
			<br/>
			<div align ="center">
			  <form onsubmit="Verifie(ditaSearch_Form);return false" name="ditaSearch_Form" class="searchForm">
				<fieldset class="searchFieldSet">
				  <legend><xsl:call-template name="gentext">
					<xsl:with-param name="key" select="'Search'"/>
				  </xsl:call-template></legend>
				  <center><input name="textToSearch" type="text" class="searchText"/>
					<input onclick="Verifie(ditaSearch_Form)" type="button" class="searchButton">
					  <xsl:attribute name="value"><xsl:call-template name="gentext">
						  <xsl:with-param name="key" select="'Go'"/>
						</xsl:call-template></xsl:attribute>
					</input>
				  </center>
				</fieldset>
			  </form>
			</div>
		  </body>
		</html>
	  </xsl:with-param>
	</xsl:call-template>
	<xsl:call-template name="write.chunk">
	  <xsl:with-param name="filename">searchresults.html</xsl:with-param>
	  <xsl:with-param name="method" select="'xml'"/>
	  <xsl:with-param name="encoding" select="'utf-8'"/>
	  <xsl:with-param name="indent" select="'yes'"/>
	  <xsl:with-param name="content">
		<html>
		  <head>
			<meta http-equiv="X-UA-Compatible" content="IE=7"/>
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
			<link rel="stylesheet" type="text/css" media="screen" href="common/css/tabs.css"/>
			<!-- Call template "metatags" to add copyright and date meta tags:  -->
			<xsl:call-template name="metatags"/>
		  </head>
		  <body>
			<p><xsl:call-template name="gentext">
					<xsl:with-param name="key" select="'Enter_a_term_and_click'"/>
				  </xsl:call-template><b><xsl:call-template name="gentext">
						  <xsl:with-param name="key" select="'Go'"/>
						</xsl:call-template></b><xsl:call-template name="gentext">
					<xsl:with-param name="key" select="'to_perform_a_search'"/>
				  </xsl:call-template></p>
		  </body>
		</html>
	  </xsl:with-param>
	</xsl:call-template>
  </xsl:template>

  <xsl:template name="metatags">
	<meta name="date">  
	  <xsl:attribute name="content">  
		<xsl:call-template name="datetime.format">  
		  <xsl:with-param name="date" select="date:date-time()" xmlns:date="http://exslt.org/dates-and-times"/>  
		  <xsl:with-param name="format" select="'m/d/Y H:M:S'"/>  
		</xsl:call-template>
	  </xsl:attribute>
	</meta>
	<meta name="copyright">
	  <xsl:attribute name="content">Copyright (c) <xsl:value-of select="//year[1]"/><xsl:text> </xsl:text>Alcatel-Lucent. All rights reserved. </xsl:attribute>
	</meta>
	<xsl:if test="$hostname">
<xsl:text>
</xsl:text>
	  <meta name="build-info-maker" content="DocShared\docbook\chunk\toc.xsl"/> 
	  <meta name="buildinfo" content="{$hostname}"/> 
	</xsl:if>
   	<xsl:if test="$docfilename">
<xsl:text>
</xsl:text>
	  <meta name="docfilename" content="{$docfilename}"/> 
	</xsl:if>
   	<xsl:if test="$buildtag">
<xsl:text>
</xsl:text>
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
  
</xsl:stylesheet>
