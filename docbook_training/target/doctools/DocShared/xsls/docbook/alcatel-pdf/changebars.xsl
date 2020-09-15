<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format" 
  xmlns:rx="http://www.renderx.com/XSL/Extensions"
  version="1.0">

  <xsl:output indent="no"/>
  
  <xsl:param name="security"/>
  <xsl:param name="show.changebars"><xsl:if test="not($security = 'external') and not($security = 'internal')">1</xsl:if></xsl:param>

  <xsl:template match="
	*[@revisionflag and not(self::part) and not(self::preface) and not(self::chapter) and not(self::appendix)]|
	*[parent::preface/@revisionflag or parent::appendix/@revisionflag or parent::chapter/@revisionflag or parent::*[parent::part/@revisionflag]]
	">

	<xsl:variable name="class" select="generate-id()"/>
	<xsl:variable name="revisionflag">
	  <xsl:choose>
		<xsl:when test="not(@revisionflag) or @revisionflag=''"><xsl:value-of select="ancestor::*[@revisionflag and not(@revisionflag='')]/@revisionflag[1]"/></xsl:when>
		<xsl:otherwise><xsl:value-of select="@revisionflag"/></xsl:otherwise>
	  </xsl:choose>
	</xsl:variable>
	<xsl:if test="$show.changebars != 0">
	  <rx:change-bar-begin change-bar-class="{$class}">
		<xsl:attribute name="change-bar-style">
		  <xsl:choose>
			<xsl:when test="$revisionflag='added'">solid</xsl:when>
			<xsl:when test="$revisionflag='changed'">dashed</xsl:when>
			<xsl:when test="$revisionflag='deleted'">dotted</xsl:when>
			<xsl:otherwise>none</xsl:otherwise>
		  </xsl:choose>
		</xsl:attribute>
		<xsl:attribute name="change-bar-color">
		  <xsl:choose>
			<xsl:when test="$revisionflag='added'">black</xsl:when>
			<xsl:when test="$revisionflag='changed'">green</xsl:when>
			<xsl:when test="$revisionflag='deleted'">red</xsl:when>
			<xsl:otherwise>none</xsl:otherwise>
		  </xsl:choose>
		</xsl:attribute>
	  </rx:change-bar-begin>
	</xsl:if>
	<xsl:apply-imports/>
	<xsl:if test="$show.changebars != 0">
	  <rx:change-bar-end change-bar-class="{$class}"/>
	</xsl:if>
  </xsl:template>

  <xsl:template match="text()[ancestor::*[@revisionflag = 'deleted']] | xref[ancestor-or-self::*[@revisionflag = 'deleted']]">
	<xsl:choose>
	  <xsl:when test="$show.changebars != 0">
		<fo:wrapper xmlns:fo="http://www.w3.org/1999/XSL/Format" color="red" text-decoration="line-through"><xsl:apply-imports/></fo:wrapper>
	  </xsl:when>
	  <xsl:otherwise>
		<xsl:apply-imports/>
	  </xsl:otherwise>
	</xsl:choose>
  </xsl:template>

</xsl:stylesheet>
