<?xml version='1.0'?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:exslt="http://exslt.org/common" 
xmlns:xhtml="http://www.w3.org/1999/xhtml"
  exslt:dummy="dummy" 
  xmlns="http://www.w3.org/1999/xhtml"
  extension-element-prefixes="exslt" 
  exclude-result-prefixes="exslt xhtml"
  version='1.0'>

  <xsl:param name="related.topics.type">list</xsl:param><!-- list, activex, otherwise -->



  <xsl:template name="user.footer.content">

	<xsl:variable name="language"><xsl:call-template name="l10n.language"/></xsl:variable>
	<xsl:variable name="title"><xsl:copy-of select="./title"/></xsl:variable>
<xsl:choose>
	<xsl:when test="$related.topics.type = 'activex'">

<!-- Known Limitations: For best results, set -->
<!-- chunk.first.sections=1 and chunk.section.depth=100 -->

	<xsl:variable name="params">
		<!-- TODO: Think about sorting these? Document order? -->
	  <xsl:for-each select="./*/keywordset/keyword">
		<xsl:apply-templates select="/*//keywordset/keyword[ 
		  normalize-space(.) = normalize-space(current()) and 
		  generate-id(.) != generate-id(current())]" mode="relatedtopics"/>
	  </xsl:for-each>
	</xsl:variable>

	<xsl:variable name="unique-params">
	  <xsl:for-each select="exslt:node-set($params)/xhtml:PARAM[not(preceding-sibling::xhtml:PARAM/@value = ./@value)]">
		<PARAM>
		  <xsl:attribute name="value"><xsl:value-of select="@value"/></xsl:attribute>
		</PARAM>
	  </xsl:for-each>
	</xsl:variable>

	<xsl:if test="exslt:node-set($unique-params)/PARAM">
<!-- See: http://msdn.microsoft.com/library/default.asp?url=/library/en-us/htmlhelp/html/vsconocxrelatedtopics.asp -->
<div class="RelatedTopics">
	  <OBJECT
		type="application/x-oleobject"
		classid="clsid:adb880a6-d8ff-11cf-9377-00aa003b7a11"
		codebase="Hhctrl.ocx#Version=4,72,8252,0"
		width="100"
		height="100">
		<PARAM name="Command" value="Related Topics, MENU"/>
		<PARAM name="Button">
		  <xsl:attribute name="value"><xsl:text>Text:</xsl:text><xsl:call-template name="gentext">
			  <xsl:with-param name="key">RelatedTopics</xsl:with-param>
			</xsl:call-template></xsl:attribute>
		</PARAM>
		<xsl:for-each select="exslt:node-set($unique-params)/PARAM">
		  <PARAM>
			<xsl:attribute name="name">Item<xsl:number/></xsl:attribute>
			<xsl:attribute name="value"><xsl:value-of select="@value"/></xsl:attribute>
		  </PARAM>
		</xsl:for-each>
	  </OBJECT>
</div>
	</xsl:if>
	  </xsl:when>
	  <xsl:when test="$related.topics.type = 'list'">

	<xsl:variable name="params">
		<!-- TODO: Think about sorting these? Document order? -->


	  <xsl:for-each select="./*/keywordset/keyword">
		<xsl:apply-templates select="/*//keywordset/keyword[ 
		  normalize-space(.) = normalize-space(current()) and 
			  not(./@role = 'notarget') and 
		  generate-id(.) != generate-id(current())]" mode="relatedtopics"/>
	  </xsl:for-each>

	</xsl:variable>

	<xsl:variable name="unique-params">
	  <xsl:for-each select="exslt:node-set($params)/xhtml:p[not(preceding-sibling::xhtml:p/xhtml:a/@href = ./xhtml:a/@href)  and not(normalize-space(preceding-sibling::xhtml:p/xhtml:a) = normalize-space(./xhtml:a)) and not(normalize-space(./xhtml:a) = normalize-space($title))]">
			<xsl:copy-of select="."/>
	  </xsl:for-each>
	</xsl:variable>

		<xsl:if test="exslt:node-set($unique-params)/xhtml:p and
		  not(./*[(self::title|self::chapterinfo|self::sectioninfo)[following-sibling::*[1][self::section]]])">

<!-- 
Figure out if the first following sibling of the title is a -->
<!-- section. This doesn't work:
		  ./title[local-name(following-sibling::*[1] = 'section')]) 
 -->
		  <h3 class="title"><xsl:call-template name="gentext">
			  <xsl:with-param name="key">RelatedTopics</xsl:with-param>
		  </xsl:call-template></h3>
		  <xsl:for-each select="exslt:node-set($unique-params)/xhtml:p">
			<xsl:sort lang="{$language}"/>
			<xsl:copy-of select="."/>
		  </xsl:for-each>

		</xsl:if>
	  </xsl:when>
	  <xsl:otherwise>
		<!-- noop -->
	  </xsl:otherwise>
	</xsl:choose>

  </xsl:template>
  
  <xsl:template match="keyword" mode="relatedtopics">
<xsl:choose>
	<xsl:when test="$related.topics.type = 'activex'">

	<PARAM>
	  <!-- TODO: Get the title with the label? e.g. Chapter
	  1. Blah de blah. Or not? -->
	  <xsl:attribute name="value"><xsl:value-of select="../../../title"/>;<xsl:apply-templates mode="chunk-filename" select="../../.."/></xsl:attribute>
	</PARAM>
	  </xsl:when>
	  <xsl:when test="$related.topics.type = 'list'">
		<p>
		  <!-- TODO: Get the title with the label? e.g. Chapter
		  1. Blah de blah. Or not? -->
		  <a>
			<xsl:attribute name="href">
			  <xsl:apply-templates
				mode="chunk-filename"
				select="../../.."/>
			</xsl:attribute>
			<xsl:value-of select="../../../title"/>
		  </a>
		</p>

	  </xsl:when>
	  <xsl:otherwise>
		<!-- noop -->
	  </xsl:otherwise>
	</xsl:choose>
													   
  </xsl:template>

  <xsl:template name="user.footer.navigation">
	<xsl:apply-templates mode="titlepage.footer.mode" select="/book/bookinfo/copyright"/>
  </xsl:template>
  
</xsl:stylesheet>