<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:db="http://docbook.org/ns/docbook"
    xmlns="http://docbook.org/ns/docbook"
    version="2.0">
    
    <xsl:param name="format">pdf</xsl:param>
 <!--   <xsl:param name="strip.xrefstyle.formats">monolithic-html;eclipse-infocenter;eclipse-help;chunk;webhelp</xsl:param>
    <xsl:param name="strip.stop-chunking.formats"/>-->
    <xsl:param name="security"/>
    
    <xsl:template match="@*|*|text()|comment()|processing-instruction()">
        <xsl:choose>
            <xsl:when test="$format = 'pdf' and @condition = 'online'"/>   
            <xsl:when test="self::db:imageobject and not(@condition = 'online') and not($format = 'pdf')">
                <imageobject>
                    <xsl:copy-of select="@*"/>
                    <imagedata>
                        <xsl:for-each select="./db:imagedata/@*">
                            <xsl:choose>
                                <xsl:when test="$format = 'l10nkit'">
                                    <xsl:copy-of select="."/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:if test="not(local-name(.) = 'contentwidth') 
                                        and not(local-name(.) = 'condition')">
                                        <xsl:copy-of select="."/>
                                    </xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </imagedata>
                </imageobject>
            </xsl:when>
            <xsl:when test="not($format = 'pdf') and @condition = 'print' and not($format = 'docbook') and not($format = 'l10nkit')"/>    
            <xsl:when test="$security = 'external' and (@security and @security != 'external')"/>
            <xsl:when test="$security = 'internal' and (@security and (@security = 'writeronly' or @security = 'unconscious'))"/>   
            <xsl:when test="$security = 'writeronly' and (@security and @security = 'unconscious')"/>       
            <xsl:when test="($security = 'external' or $security = 'internal') and self::db:remark"/>  
            <xsl:when test="self::db:remark[@role='l10n' or @role='i18n']">
                <remark><xsl:copy-of select="@*"/>L10N/I18N: 
                    <!-- notice that i omitted @* in the below apply templates, to fix a bug -->
                    <xsl:apply-templates
                        select="*|text()|comment()|processing-instruction()"/></remark>
            </xsl:when>            
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*|*|text()|comment()|processing-instruction()"/>
                </xsl:copy>               
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template> 
    
    <xsl:template match="@xrefstyle">
        <xsl:choose>	
            <xsl:when test="$format = 'pdf' and not(parent::db:olink)">
                <xsl:copy-of select="."/>
            </xsl:when>
            <xsl:when test="parent::db:olink"/>
            <xsl:when test="contains (.,'nopage')">
                <xsl:attribute name="xrefstyle"><xsl:value-of select="replace(.,' nopage','')"/></xsl:attribute>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <!--
    <xsl:template match="processing-instruction('dbhtml')[normalize-space(.) = 'stop-chunking']">
        <xsl:if test="not(contains(concat(';',$strip.stop-chunking.formats,';'),concat(';',$format,';')))">
            <xsl:copy-of select="."/>
        </xsl:if>
        </xsl:template>	-->
   
    
    <!-- Match an image object if it's online and does not
        have a print sibling. In that case, we're going to make a
        print sibling version. -->
    <xsl:template
        match="
        db:imageobject[
        @condition = 'online' and 
        not(preceding-sibling::db:imageobject[@condition='print']) and 
        not(following-sibling::db:imageobject[@condition='print'])
        ]" priority="100">
        <xsl:variable name="motive-fileref"><xsl:value-of select="normalize-space(./db:imagedata/@fileref)"/></xsl:variable>
        <xsl:variable name="motive-fileref-print"><xsl:value-of select="concat(substring($motive-fileref,1,string-length($motive-fileref) - 3),'pdf')"/></xsl:variable>
        <!--xsl:message>Motive fileref: <xsl:value-of
            select="$motive-fileref"/> Motive fileref print: <xsl:value-of select="$motive-fileref-print"/></xsl:message-->
        <!-- Copy through the online version, but leave off the
        content with attribute. -->

        <xsl:if test="not($format = 'pdf')">
            <imageobject condition="online">
                <xsl:copy-of select="@*"/>
                <imagedata>
                    <xsl:for-each select="./db:imagedata/@*">
                        <xsl:choose>
                            <xsl:when test="$format = 'l10nkit'">
                                <xsl:copy-of select="."/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:if test="not(local-name(.) = 'contentwidth') 
                                    and not(local-name(.) = 'condition')">
                                    <xsl:copy-of select="."/>
                                </xsl:if>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </imagedata>
            </imageobject>
        </xsl:if>
        <xsl:if test="$format = 'pdf' or $format = 'docbook' or $format = 'l10nkit'">
            <xsl:message>
                INFO: Handling imageobject with @condition="online" and no sibling imageobject
                <imageobject condition="print">
                    <imagedata> 
                        <xsl:for-each select="./db:imagedata/@*">
                            <xsl:if test="not(local-name(.) = 'fileref') and not(local-name(.) = 'condition')">
                                <xsl:copy-of select="."/>
                            </xsl:if>
                        </xsl:for-each>
                        <xsl:attribute name="fileref">
                            <xsl:value-of select="$motive-fileref-print"/>
                        </xsl:attribute>
                    </imagedata>
                </imageobject>
            </xsl:message>
            <imageobject condition="print">
                <imagedata> 
                    <xsl:for-each select="./db:imagedata/@*">
                        <xsl:if test="not(local-name(.) = 'fileref') and not(local-name(.) = 'condition')">
                            <xsl:copy-of select="."/>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:attribute name="fileref">
                        <xsl:value-of select="$motive-fileref-print"/>
                    </xsl:attribute>
                </imagedata>
            </imageobject>
        </xsl:if>
    </xsl:template>
    
<!--
     
    <xsl:template name="chunked-third-party-software">
        <xsl:if test="$format = 'chunk'">
            <note>
                <para><phrase id="chunked-third-party-software">This help system may use software from the following sources:</phrase><itemizedlist>
                    <listitem>
                        <para><ulink url="http://www.bosrup.com/web/overlib/">overLib 4.21</ulink>. Copyright (c) Erik Bosrup 1998-2004.  </para>
                    </listitem>
                    <listitem><para><ulink url="http://tech.groups.yahoo.com/group/dita-users/files/Demos/" target="_top">htmlsearch 1.04</ulink>. (Requires a Yahoo ID and membership in the dita-users Yahoo group.) Copyright (c) 2007-2008 NexWave Solutions. </para></listitem>
                    <listitem><para><ulink url="http://www.silverstripe.org">Silverstripe tree-control</ulink>. Copyright (c) 2005 SilverStripe Limited. </para></listitem>
                </itemizedlist>
                </para>
            </note>
        </xsl:if>
    </xsl:template>
    -->
</xsl:stylesheet>