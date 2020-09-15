<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:db="http://docbook.org/ns/docbook"
    xmlns="http://docbook.org/ns/docbook"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs db xlink"
    version="2.0">
    
    <xsl:variable 
        name="links" 
        select="document('/home/dcramer/Documents/workhead/docmodules/6x/enus/smp_data_dic/smp_data_dic.xml')//db:link"/>
    
    <xsl:template match="/">
<!--        <xsl:message>
            <xsl:for-each select="$links">
                ;<xsl:value-of select="normalize-space(.)"/>;
            </xsl:for-each>
        </xsl:message>-->
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="db:olink[@targetptr='']" priority="100">
        <xsl:variable name="content" select="normalize-space(.)"/>
        <xsl:choose>
            <xsl:when test="$links//node()[normalize-space(.) = $content]">
                <xsl:message>Fixing bad olink.</xsl:message>
                <link xlink:href="{$links[normalize-space(.) = $content][1]/@xlink:href}"><xsl:apply-templates select="node()"/></link>            
                <xsl:if test="count($links[normalize-space(.) = $content]) &gt; 1">
                    <xsl:message>Warning: more than one possible fix found for <xsl:copy-of select="."/></xsl:message>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>No fix found: "<xsl:value-of select="normalize-space(.)"/>"</xsl:message>
                <xsl:copy>
                    <xsl:apply-templates select="node() | @*"/>
                </xsl:copy>                
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>