<?xml version="1.0" encoding="US-ASCII"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:exslt="http://exslt.org/common" extension-element-prefixes="exslt" exclude-result-prefixes="exslt" version="1.0">

  <!-- This customization of keywords.xsl causes any
  indexterms to be added to the <meta name="keywords".../> tag
  in the chunked html output. The main reason for doing this
  is to improve support for Asian languages and help
  compensate for the lack of stemming in the indexer. 

  As implmented, this customization only supports situations
  where all sections or sect* elements are chunked. For
  example, if you have chunk.first.sections set to 0, any
  indexterms in the first sections will not be appended to the
  keywords list.  -->

  <xsl:param name="security"/>

  <xsl:template match="keywordset"/>
  <xsl:template match="subjectset"/>

  <!-- ==================================================================== -->
  <xsl:template name="keywordset">
	<!-- what is the current section level depth? -->
	<xsl:variable name="section_level">
	  <xsl:number value="count(ancestor-or-self::section)"/>
	</xsl:variable>

	<!-- get the terms appropriate for this chunk -->
	<xsl:variable name="indexterms-and-keywords">
		<xsl:choose>
		  <xsl:when test="$section_level = $chunk.section.depth or ancestor-or-self::*/processing-instruction('dbhtml')[normalize-space(.) ='stop-chunking']">
			<xsl:copy-of select=".//indexterm/*"/>
			<xsl:copy-of select=".//keywordset/keyword"/>
			<xsl:if test=".//*[@revisionflag and not(@revisionflag = 'off')] and $security = 'reviewer'"><keyword>revisionflag</keyword></xsl:if>
		  </xsl:when>
		  <xsl:when test="$chunk.first.sections = '0'">
			<xsl:copy-of select="./*[not(self::section)]//indexterm/*|./section[1]//indexterm/*|./indexterm/*"/>
			<xsl:copy-of select="./*[not(self::section)]//keywordset/keyword|./section[1]//keywordset/keyword|./keywordset/keyword"/>
			<xsl:if test="$security = 'reviewer' and (@revisionflag or ./*[not(self::section) and @revisionflag] or ./*[not(self::section)]//*[@revisionflag] or ./section[1][@revisionflag] or ./section[1]//*[@revisionflag and not(@revisionflag = 'off')])"><keyword>revisionflag</keyword></xsl:if>
		  </xsl:when>
		  <xsl:otherwise>
			<xsl:copy-of select="./*[not(self::section)]//indexterm/*|./indexterm/*"/>
			<xsl:copy-of select="./*[not(self::section)]//keywordset/keyword|./keywordset/keyword"/>
			<xsl:if test="$security = 'reviewer' and ((@revisionflag and not(@revisionflag = 'off')) or ./*[not(self::section) and (@revisionflag and not(@revisionflag = 'off'))] or ./*[not(self::section)]//*[@revisionflag and not(@revisionflag = 'off')])"><keyword>revisionflag</keyword></xsl:if>
		  </xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- get unique set of index terms -->
	<xsl:variable name="indexterms-and-keywords-unique">
	  <xsl:for-each select="exslt:node-set($indexterms-and-keywords)/*[not(. = preceding-sibling::*)]">
		<xsl:value-of select="normalize-space(.)"/><xsl:if test="not(position() =  last())">, </xsl:if>
	  </xsl:for-each>
	</xsl:variable>

	<!-- if index terms are present, put them in the meta keywords tag -->
	<xsl:if test="not($indexterms-and-keywords-unique = '') and not(self::part)">
	  <meta name="keywords">
		<xsl:attribute name="content">
		  <xsl:value-of select="$indexterms-and-keywords-unique" />
		</xsl:attribute>
	  </meta>
	</xsl:if>

	<!--xsl:message>
	  ==================================================
	  local-name: <xsl:value-of select="local-name(.)"/>
	  title: <xsl:value-of select="./title"/>
	  keywords: <xsl:if test="not($indexterms-and-keywords-unique = '')">
		<meta name="keywords">
		  <xsl:attribute name="content">
			<xsl:value-of select="$indexterms-and-keywords-unique" />
		  </xsl:attribute>
		</meta>
	  </xsl:if>
	  ==================================================
	</xsl:message-->
	
  </xsl:template>
  <!-- ==================================================================== -->


</xsl:stylesheet>
