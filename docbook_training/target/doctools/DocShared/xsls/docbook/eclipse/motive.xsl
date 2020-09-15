<?xml version='1.0'?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version='1.0' xmlns="http://www.w3.org/1999/xhtml">

  <xsl:import href="../hhp/driver.xsl"/>
  <xsl:import href="eclipse.xsl"/>
  <xsl:import href="../xhtml/titlepage.xsl"/>
  <xsl:include href="../xhtml/changebars.xsl"/>

  <xsl:output 
	method="xml" 
	omit-xml-declaration="no"/>

  <xsl:include href="related-topics.xsl"/>
  <xsl:param name="section.autolabel" select="0"/>
  <xsl:param name="appendix.autolabel" select="0"/>
  <xsl:param name="part.autolabel" select="0"/>
  <xsl:param name="chapter.autolabel" select="0"/>
  <xsl:param name="section.autolabel.max.depth">0</xsl:param>

  <xsl:param name="htmlhelp.use.hhk" select="0"/>  
  <xsl:param name="suppress.navigation">0</xsl:param>
<xsl:param name="eclipse.autolabel" select="0"/>
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
	  <meta name="build-info-maker" content="DocShared\docbook\eclipse\motive.xsl"/> 
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
  
</xsl:stylesheet>



