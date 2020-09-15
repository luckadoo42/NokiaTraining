<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xlink="http://www.w3.org/1999/xlink" 
    exclude-result-prefixes="#all"
    version="2.0">


  <xsl:template match="/" >
    <xsl:result-document doctype-public="-//OASIS//DTD DITA Map//EN"
			 doctype-system="map.dtd">
      <map id="keydefs">
	<title>Variable key definitions</title>
	<xsl:apply-templates/>
      </map>
    </xsl:result-document>
  </xsl:template>

  <xsl:template match="echo"/>
	
  <xsl:template match="property" >
    <xsl:variable name="name" select="@name"></xsl:variable>

    <!-- Prefix the key name with "var_" to give the writer a hint that the key is a variable. -->
    <keydef keys="var_{$name}">
      <topicmeta>
	<keywords>
	  <keyword><xsl:value-of select="@value"/></keyword>
	</keywords>
      </topicmeta>
    </keydef>
  
  </xsl:template>


</xsl:stylesheet>
