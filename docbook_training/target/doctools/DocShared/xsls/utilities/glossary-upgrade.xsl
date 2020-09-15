<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:db="http://docbook.org/ns/docbook"
    xmlns="http://docbook.org/ns/docbook"
    version="2.0">
        
    <xsl:template match="db:glossentry">
        <xsl:result-document href="{ancestor::db:glossary/@xml:id}/{@xml:id}.xml">
            <xsl:copy>
                <xsl:attribute name="version">5.0-extension BroadBook-2.0</xsl:attribute>
                <xsl:apply-templates select="@*|node()"/>
            </xsl:copy>
        </xsl:result-document>
        <xi:include href="{ancestor::db:glossary/@xml:id}/{@xml:id}.xml"/>
    </xsl:template>
    
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@security[. = 'bjinternal']">
        <xsl:attribute name="security">internal</xsl:attribute>
    </xsl:template>
    
    <xsl:template match="@moreinfo"/>
    
    <xsl:template match="db:interface">
        <phrase remap="interface"><xsl:apply-templates select="@*|node()"/></phrase>
    </xsl:template>
    
    <xsl:template match="db:glossdiv/db:info"/>
    
    <xsl:template match="db:glossdiv">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="systemitem[@class = 'constant']">
        <systemitem><xsl:apply-templates select="node()"/></systemitem>
    </xsl:template>
        
</xsl:stylesheet>