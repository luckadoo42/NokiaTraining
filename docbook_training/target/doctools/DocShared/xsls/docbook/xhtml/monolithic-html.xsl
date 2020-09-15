<?xml version="1.0" encoding="US-ASCII"?>


<xsl:stylesheet
  xmlns="http://www.w3.org/1999/xhtml" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
  exclude-result-prefixes="doc" version="1.0">



<xsl:import href="docbook.xsl"/>
<xsl:import href="titlepage.templates-monolithic.xsl"/>
<xsl:import href="../common/targets.xsl"/> <!-- added for jcbg-672, to add keywords to the targetdb output -->
	<!-- Removed to prevent title page content from showing up at top of EVERY topic (part of JCBG-133)
    You won't really notice this unless you are using a branding like alcatel2 that has cover art and text
  <xsl:import href="../xhtml/titlepage.xsl"/> -->
	
  <xsl:include href="changebars.xsl"/>

<xsl:output 
	omit-xml-declaration="yes"
	method="xml" 
	encoding="UTF-8" 
	indent="no" 
	doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" 
	doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>


<xsl:param name="toc.max.depth">100</xsl:param>
<xsl:param name="toc.section.depth">100</xsl:param>
<xsl:param name="tooltip.glossterms" select="0"/>
<xsl:param name="chapter.autolabel" select="0"/>
<xsl:param name="section.autolabel" select="0"/>
<xsl:param name="part.autolabel" select="0"/>
<xsl:param name="appendix.autolabel" select="0"/>
<xsl:param name="section.label.includes.component.label" select="0"/>
  <xsl:param name="chunker.output.encoding" select="'utf-8'"/>
<xsl:param name="hostname"/>
<xsl:param name="docfilename"/>
<xsl:param name="buildtag"/>
<xsl:param name="motive.include.infocenter.footer"/>
<xsl:param name="timestamp"/>
<xsl:param name="PLANID"/>
<xsl:param name="BUILDNUMBER"/>

<!-- kludgey fix for jcbg-195 converts quote element to quote chars
ignoring the gentext complexities of the main templates 

...tried using &#8220; and &#8221; for curly quotes but causes same
error as not having this template.

-->
<xsl:template match="quote">
  &quot;<xsl:apply-templates />&quot;
</xsl:template>

<!-- for JCBG-933, ignore remarks if this is an olink build;
detecting that via value of collect.xref.targets -->
<xsl:param name="collect.xref.targets">no</xsl:param>

<xsl:template match="remark">
  <!-- if this is not an olink build, then process remarks normally: I added a name to the remarks template in main.xsl after testing 
  that that is what gets used by this guy -->
  <xsl:if test="not($collect.xref.targets='only')">
    <xsl:call-template name='main.comment.remark.xhmtl'/>
  </xsl:if>
</xsl:template>





<xsl:template name="system.head.content">
	<xsl:param name="node" select="."/>
	<meta http-equiv='Content-Type' content='text/html; charset={$chunker.output.encoding}'/>
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />

  <!-- system.head.content is like user.head.content, except that
       it is called before head.content. This is important because it
       means, for example, that <style> elements output by system.head.content
       have a lower CSS precedence than the users stylesheet. -->
</xsl:template>

  <xsl:template name="user.footer.content">
	<xsl:call-template name="book.titlepage.recto"/>
  </xsl:template>

  <xsl:template name="user.head.content" xmlns="http://www.w3.org/1999/xhtml">
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
	  <meta name="build-info-maker" content="DocShared\docbook\xhtml\monolithic-html.xsl"/> 
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

	<style type="text/css">
	  <xsl:comment>
	    <![CDATA[
/* Copyright (c) 2000-2009 Alcatel-Lucent. All rights reserved. */

a.glossterm {
	border-bottom: .05em dashed gray;
	color: black;
	background: white;
	text-decoration: none;
	line-height: 125%;
    cursor: help;
	}
a:link.glossterm{
	color: black;
	}

a:link    { 
	color: #00589E;
	} 
th a:link{
    color: white;
	}
th a:visited{
    color: gray;
	}

.copyright a:visited {
	color : gray;
	background: white;
	}	
.copyright a:link {
	color : gray;
	background: white;
	}			
			
body{
font-size: small;
}
	
body, table
	{
	font-family: Verdana, Arial, Helvetica, sans-serif;
	color: black;
	background: white;
	}

pre.programlisting, tt, code, pre.screen { font-size: small;}

div.simplesect h1.title{
font-size: 1.5em;
}

H1.title, H2.title, H3.title, H4.title, H5.title, H6.title, H7.title
	{
	color: #00589E;
	background: white;
	font-weight: bold;
}

p.title{
	margin-top: 1em;
	margin-bottom: .5em;
}

.note, .itemizedlist, .orderedlist, .procedure
{
    margin-left: .5em;
	margin-top: 1em;
	margin-bottom: 1em;
}

.admonitiontitle
{
 margin-bottom: -10px;
}

.admonitionbody
{
 margin-top: -10px;
}

.biblioid 
	{font-weight: bold;}

.legalnotice, .bookinfo-productname, .pubdate, .biblioid, .releaseinfo
	{font-size: smaller;}

.copyright
	{
	color : gray;
	background: white;
	}

p.copyright
	{
	text-align:center;
	font-size: x-small;
	}

td,th
	{
	padding-top: 5px;
	padding-bottom: 5px;
	padding-right : 10px;
	padding-left : 5px;
	}

td, th {	
	vertical-align: top;
	}
td>p, th>p{
	margin-top: 0;
	}

table.admonition
{
  margin-top: .5em;
  margin-bottom: .5em;
  border-top: thin solid;
  border-bottom: thin solid;
  background: white;
  color: black;
}

.navheader tr th{
	background: white;
	color: black;
    text-align: center;
}

th[align="center"]{ 
 text-align: center; 
 }
 

tr th, tr th .internal, tr th .added, tr th .changed
	{
	background: #00589E;
	color: white;
	font-weight: bold;
	text-align: left;
	}

		
li
  	{ 
	margin-left: -1em;
	}

*[valign="middle"]{
vertical-align: middle;
}

*[valign="top"]{
vertical-align: top;
}

*[valign="bottom"]{
vertical-align: bottom;
}

dt{
margin-bottom: .5em;
}

.internal
	{
	color : #0000CC;
	}

.writeronly
	{
	color : red;
	}

.remark, .remark .added, .remark .changed, .remark .deleted{
	background: yellow;
	} 

ul.compact li{
  margin-top: -.75em;
  margin-bottom: -.75em;
}

.sidebar{
background-color: LightGray;
border: thin black solid;
padding-left: 5px;
padding-right: 5px;
margin-left: 10px;
margin-right: 10px;
}

.example-break {display:none;}

OBJECT{
display: none;
}

/* The following rules are used to style the related topics button */

      ul.rt-inner, ul.rt-outer { 
      list-style-type: none;
      }

      ul.rt-inner a, ul.rt-outer a {
        text-decoration: none;
        color: black;
        background-color: #CCCCCC;
      }

	  ul.rt-inner>li{
	  margin: 3px;

	  }

      ul.rt-inner a:hover {
      background-color: #000099;
      color: white;
      }

      ul.rt-inner {
      margin-top: 0em; // IE 1em
	  width: 250px;
      background-color: #CCCCCC;
      background-position: left;
      background-repeat: no-repeat;
      border: 2px outset;
      border-bottom-color: #000000;
      border-left-color: #FFFFFF;
      border-right-color: #000000;
      border-top-color: #FFFFFF;
      cursor: default;
      padding-bottom: 1px;
      padding-left: 12px;
      padding-right: 12px;
      padding-top: 1px;
      font-family: Tahoma, Helvetica, sans, Arial, sans-serif;
	  position:relative;
      }

      span.button{
      color: black;
      background-color: #CCCCCC;
      background-position: left;
      background-repeat: no-repeat;
      border: 2px outset;
      border-bottom-color: #000000;
      border-left-color: #FFFFFF;
      border-right-color: #000000;
      border-top-color: #FFFFFF;
      text-decoration: none;
      cursor: default;
      padding-bottom: 5px;
      padding-left: 12px;
      padding-right: 12px;
      padding-top: 1px;
      //position: absolute; /* Strange. Commenting out v. removing has different effects in IE v. Firefox */
      font-family: Tahoma, Helvetica, sans, Arial, sans-serif;
	  }


tr th .added { color: #E6E6FA; } 
tr th .changed {color: #99ff99; }
div.added tr, div.added    { background-color: #E6E6FA; }
div.deleted tr, div.deleted  { text-decoration: line-through;
               background-color: #FF7F7F; }
div.changed tr, div.changed  { background-color: #99ff99; }
div.off      {  }

span.added   { background-color: #E6E6FA; }
span.deleted { text-decoration: line-through;
               background-color: #FF7F7F; }
span.changed { background-color: #99ff99; }
span.off     {  }


a.headerlink, a:visited.headerlink, a:active.headerlink,a:hover.headerlink{
color: inherit;
text-decoration: none;
}

.bgClass,.fgClass{
background-color: #FFFF66;
}

div.chapter>div.section h1 {font-size: 1.65em;}
div.chapter>div.section>div.section h1 {font-size: 1.45em;}
div.chapter>div.section>div.section>div.section h1 {font-size: 1.35em;}
div.chapter>div.section>div.section>div.section>div.section h1 {font-size: 1.25em;}
div.chapter>div.section>div.section>div.section>div.section>div.section h1 {font-size: 1.15em;}

	    ]]>
	  </xsl:comment>
	</style>

  </xsl:template>

</xsl:stylesheet>
