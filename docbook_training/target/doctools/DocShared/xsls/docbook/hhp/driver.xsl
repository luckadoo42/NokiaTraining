<?xml version='1.0'?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  version='1.0'>
  
  <xsl:import href="../xhtml/param.xsl"/>
<xsl:import href="../xhtml/html.xsl"/>
  <xsl:param name="security"/>
  <xsl:param name="PLANID"/>
  <xsl:param name="BUILDNUMBER"/>
  <xsl:param name="hostname"/>
  <xsl:param name="docfilename"/>
  <xsl:param name="buildtag"/>
<xsl:output 
	method="xml" 
	omit-xml-declaration="yes"/>

<xsl:param name="common.files" select="'common'"/>
<xsl:param name="part.autolabel" select="0"/>



  <!-- This lets us choose an alternative set of l10n
  settings if chm.type is book. For book chms we want to say
  Figure 5. The foo figure, etc. In the help chms we just
  have the title, with no numbering. -->
  <xsl:param name="l10n.path">../xhtml/l10n.xsl</xsl:param>
  <xsl:param name="local.l10n.xml" select="document($l10n.path)"/>

	<xsl:param name="timestamp">
	  <xsl:call-template name="datetime.format">  
		<xsl:with-param name="date" select="date:date-time()" xmlns:date="http://exslt.org/dates-and-times"/>  
		<xsl:with-param name="format" select="'m/d/Y H:M:S'"/>  
	  </xsl:call-template>
	</xsl:param>



<xsl:include href="../xhtml/titlepage.templates.xsl"/>
<xsl:include href="main.xsl"/>

<xsl:include href="index_hhk2.xsl"/>

<xsl:param name="generate.toc">
<xsl:choose>
	  <xsl:when test="$chm.type = 'book'">
appendix  toc
article   noop
book      noop
chapter   toc
part      toc
preface   toc
qandadiv  toc
qandaset  toc
reference toc,title
section   toc
set       noop
	  </xsl:when>
		<xsl:when test="$chm.type = 'help'">
appendix  toc
article   noop
book      noop
chapter   toc
part      toc
preface   toc
qandadiv  toc
qandaset  toc
reference toc,title
section   toc
set       noop
	  </xsl:when>
	  <xsl:otherwise>
appendix  toc,title
article/appendix  nop
article   toc,title
book      toc,title,figure,table,example,equation
chapter   toc,title
part      toc,title
preface   toc,title
qandadiv  toc
qandaset  toc
reference toc,title
sect1     toc
sect2     toc
sect3     toc
sect4     toc
sect5     toc
section   toc
set       toc,title
	  </xsl:otherwise>
	</xsl:choose>
  </xsl:param>
  <xsl:param name="protected"/>

<xsl:include href="chunk-code.xsl"/>
<xsl:include href="chunk-common.xsl"/>


  <xsl:param name="motive.include.infocenter.footer"/>
  <xsl:param name="motive.footer.text">
	<xsl:choose>
	  <xsl:when test="$security = 'external'"/>
	  <xsl:when test="$protected = 'yes'">Internal Only (Protected)</xsl:when>
	  <xsl:when test="$security = 'internal'">Internal Version</xsl:when>
	  <xsl:when test="$security = 'reviewer'">Draft/Review Version - Internal Only</xsl:when>
	  <xsl:when test="$security = 'writeronly'">Draft/Writeronly Version - Internal Only</xsl:when>
	  <xsl:otherwise/>
	</xsl:choose>
  </xsl:param>

  <xsl:param name="motive.footer.popup.text">
	<xsl:choose>
	  <xsl:when test="$security = 'external'"/>
	  <xsl:when test="$protected = 'yes'">You are viewing the \'Protected\' version of this document. This version may contain content that is only intended for Motive/ALU-internal audiences. The internal/protected content is &lt;span class=\'internal\'>blue&lt;/span> in color. You may distribute the internal version to customers with the caveat that it may contain content that does not apply to them.</xsl:when>
	  <xsl:when test="$security = 'internal'">You are viewing the internal version of this document. The internal version may contain content that is only intended for Motive/ALU-internal audiences. The internal content is &lt;span class=\'internal\'>blue&lt;/span> in color. Please only distribute the &lt;b>external&lt;/b> version of this document to customers.</xsl:when>
	  <xsl:when test="$security = 'reviewer'">You are viewing the draft or review version of this document. This version contains remarks for reviewers (highlighted in yellow) as well as internal-only content (in &lt;span class=\'internal\'>blue&lt;/span> text). &lt;b>Do not&lt;/b> distribute this version of the document to customers.</xsl:when>
	  <xsl:when test="$security = 'writeronly'">Draft/Writeronly Copy - Internal Only</xsl:when>
	  <xsl:otherwise/>
	</xsl:choose>
  </xsl:param>

  <xsl:template name="user.header.content">
	<xsl:if test="normalize-space($motive.footer.text) != '' and ($security = 'internal' or $security = 'writeronly' or $security = 'reviewer' or $protected = 'yes')">
	  <p class="internal" style="text-align: center">
		<a class="headerlink" href="javascript:void(0);" onmouseover="return overlib('{$motive.footer.popup.text}',DELAY,250,BGCLASS, 'bgClass',FGCLASS,'fgClass',CENTER);" onmouseout="return nd();"><b><script language="Javascript" type="text/javascript"><xsl:comment><xsl:text>
				document.write('</xsl:text><xsl:copy-of select="$motive.footer.text"/><xsl:text>')
				</xsl:text>//</xsl:comment></script>
		  <xsl:if test="$security = 'reviewer'">
		  	<!-- JCBG-1861, shortening the reviewer header info, putting it on one line -->
				<script language="Javascript" type="text/javascript"><xsl:comment><xsl:text>
				  document.write('</xsl:text>  (<xsl:value-of select="$timestamp"/>, build <xsl:value-of select="$PLANID"/>-<xsl:value-of select="$BUILDNUMBER"/>)<xsl:text>')
				</xsl:text>//</xsl:comment></script>
		  </xsl:if>
		</b></a>
	  </p>
	</xsl:if>
  </xsl:template>




</xsl:stylesheet>



