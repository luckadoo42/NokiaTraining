<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xi="http://www.w3.org/2001/XInclude" 
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:db="http://docbook.org/ns/docbook" 
    exclude-result-prefixes="db" 
    version="2.0">

    <xsl:param name="broadbook-version">5.0-extension BroadBook-2.0</xsl:param>

    <xsl:key match="*" name="ids" use="@xml:id"/>
    <xsl:key match="*" name="linkends" use="@linkend"/>
    <xsl:key match="*" name="sharer_ids" use="@sharer_id"/>
    <xsl:key match="*" name="targetptrs" use="@targetptr"/> 
<!--
    <xsl:template match="db:*[@xml:id]">
        <xsl:result-document href="{concat('/home/dcramer//Documents/workhead/docmodules-BCM/6x/enus/csm_install_admin/shared/shared_procedures/',@xml:id,'.xml')}">
            <xsl:element name="{local-name(.)}" namespace="http://docbook.org/ns/docbook">
                <xsl:attribute name="version">5.0-extension BroadBook-2.0</xsl:attribute>
                <xsl:apply-templates select="node()"/>
            </xsl:element>
        </xsl:result-document>
        <xsl:element name="include" namespace="http://www.w3.org/2001/XInclude">
            <xsl:attribute name="href"><xsl:value-of select="concat(@xml:id,'.xml')"/></xsl:attribute>
        </xsl:element>
    </xsl:template>-->

    <xsl:template match="node() | @*">

                <xsl:copy>
                    <xsl:apply-templates select="node() | @*"/>
                </xsl:copy>
            
    </xsl:template>
    
    <xsl:template match="
        db:share_appendix|
        db:share_caution|
        db:share_chapter|
        db:share_computeroutput|
        db:share_formalpara|
        db:share_important|
        db:share_informaltable|
        db:share_itemizedlist|
        db:share_listitem|
        db:share_member|
        db:share_note|
        db:share_orderedlist|
        db:share_para|
        db:share_phrase|
        db:share_preface|
        db:share_procedure|
        db:share_qandaentry|
        db:share_row|
        db:share_section|
        db:share_segmentedlist|
        db:share_simplelist|
        db:share_step|
        db:share_substeps|
        db:share_table|
        db:share_tip|
        db:share_variablelist|
        db:share_varlistentry|
        db:share_warning">
        <!-- 
            Replace with xinclude,
            if nothing xrefs to it AND
            if its target doesn't contain any xml:id attrs that are linked to within this doc, 
            <xi:include xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xi="http://www.w3.org/2001/XInclude" href="fragments/{@sharer_doc}"/>
            
            If an element has @xml:id AND 
            there's a */@sharer_doc that matches AND
            there's no xref's to it, AND
            it doesn't contain any xml:id attrs,
            then split it out into a fragments dir with the file name of the xml:id.
            
            not(key('linkends',@xml:id)) and
            not(key('targetptrs',@xml:id)) and
            not(key('linkends',@sharer_id)) and             
        -->
        <xsl:choose>
            <xsl:when test="
                (not(key('linkends',@xml:id)) and not(key('targetptrs',@xml:id)) and 
                not(key('ids',@sharer_id)//*[key('linkends',@xml:id) or key('targetptrs',@xml:id)])) "> 
                <xsl:variable name="dirname">
                    <xsl:if test="starts-with(@sharer_doc,'..')">
                        <xsl:value-of select="replace(@sharer_doc,'(../.*/).*\.xml$','$1')"/>      
                    </xsl:if>
                </xsl:variable>
                <xsl:element name="xi:include"  xmlns:xi="http://www.w3.org/2001/XInclude">
                    <xsl:attribute name="href"><xsl:value-of select="concat(normalize-space($dirname),@sharer_id,'.xml')"/></xsl:attribute>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:copy>
                <xsl:comment>FIXME</xsl:comment>
                <xsl:message>INFO: Not splitting out <xsl:copy-of select="."/>. You must fix it manually.</xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- and not(key('linkends',@xml:id)) and not(key('targetptrs',@xml:id))   -->
    <xsl:template match="*[@xml:id]">
        <xsl:choose>
            <xsl:when test="self::db:procedure or self::db:section or ( not(key('linkends',@xml:id)) and not(key('targetptrs',@xml:id)) and not(.//*[key('linkends',@xml:id) or key('targetptrs',@xml:id)]))">
                <xsl:result-document href="/home/dcramer/Documents/workhead/docmodules-BCM/6x/enus/csm_install_admin/shared/shared_procedures/{@xml:id}.xml">
                    <xsl:element name="{local-name(.)}" xmlns="http://docbook.org/ns/docbook">
                        <xsl:for-each select="@*">
                            <xsl:choose>
                                <xsl:when test="parent::db:procedure or parent::db:section">
                                    <xsl:copy-of select="."/>
                                </xsl:when>
                                <xsl:when test="not(local-name(.) = 'xml:id') and not(local-name(.) = 'id')">
                                    <xsl:copy-of select="."/>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:for-each>
                        <xsl:attribute name="version"><xsl:value-of select="$broadbook-version"/></xsl:attribute>
                        <xsl:apply-templates select="node()"/>
                    </xsl:element>
                </xsl:result-document>
                <xsl:element name="xi:include" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xi="http://www.w3.org/2001/XInclude">
                    <xsl:attribute name="href"><xsl:value-of select="concat(@xml:id,'.xml')"/></xsl:attribute>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>    
    </xsl:template>
    

    
    
    <xsl:template match="db:link" xmlns:xlink="http://www.w3.org/1999/xlink">
        <xsl:choose>
            <xsl:when test="starts-with(@xlink:href,'http')">
                <xsl:copy>
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="node() | @*"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    

</xsl:stylesheet>
