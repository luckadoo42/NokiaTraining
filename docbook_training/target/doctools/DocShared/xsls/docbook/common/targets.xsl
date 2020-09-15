<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                exclude-result-prefixes="doc"
                version='1.0'>

<!-- ********************************************************************
     $Id: targets.xsl 6413 2006-11-15 09:00:26Z bobstayton $
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://nwalsh.com/docbook/xsl/ for copyright
     and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->

<!-- cross reference target collection  -->

<doc:mode mode="collect.targets" xmlns="">
<refpurpose>Collects information for potential cross reference targets</refpurpose>
<refdescription>
<para>Processing the root element in the
<literal role="mode">collect.targets</literal> mode produces 
a set of target database elements that can be used by
the olink mechanism to resolve external cross references.
The collection process is controlled by the <literal>
collect.xref.targets</literal> parameter, which can be
<literal>yes</literal> to collect targets and process
the document for output, <literal>only</literal> to
only collect the targets, and <literal>no</literal>
(default) to not collect the targets and only process the document.
</para>
<para>
A <literal>targets.filename</literal> parameter must be
specified to receive the output if 
<literal>collect.xref.targets</literal> is
set to <literal>yes</literal> so as to
redirect the target data to a file separate from the
document output.
</para>
</refdescription>
</doc:mode>

<!-- ============================================================ -->

<xsl:param name="eclipse.plugin.id"/>
<xsl:param name="security"/>
<xsl:template match="*" mode="collect.targets">
  <xsl:choose>
    <xsl:when test="$collect.xref.targets = 'yes' and $targets.filename = ''">
      <xsl:message>
        Must specify a $targets.filename parameter when
        $collect.xref.targets is set to 'yes'.
        The xref targets were not collected.
      </xsl:message>
    </xsl:when> 
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="$targets.filename">
          <xsl:call-template name="write.chunk">
            <xsl:with-param name="filename" select="$targets.filename"/>
            <xsl:with-param name="method" select="'xml'"/>
            <xsl:with-param name="encoding" select="'utf-8'"/>
            <xsl:with-param name="omit-xml-declaration" select="'yes'"/>
            <xsl:with-param name="doctype-public" select="''"/>
            <xsl:with-param name="doctype-system" select="''"/>
            <xsl:with-param name="indent" select="'no'"/>
            <xsl:with-param name="quiet" select="0"/>
            <xsl:with-param name="content">
              <xsl:apply-templates select="." mode="olink.mode"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <!-- Else write to standard output -->
          <xsl:apply-templates select="." mode="olink.mode"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="olink.href.target">
  <xsl:param name="nd" select="."/>

  <xsl:value-of select="$olink.base.uri"/>
  <xsl:call-template name="href.target">
    <xsl:with-param name="object" select="$nd"/>
    <xsl:with-param name="context" select="NOTANODE"/>
  </xsl:call-template>
</xsl:template>

<!-- Templates for extracting cross reference information
     from a document for use in an xref database.
-->

<xsl:template name="attrs">
  <xsl:param name="nd" select="."/>

  <xsl:attribute name="element">
    <xsl:value-of select="local-name(.)"/>
  </xsl:attribute>

  <xsl:attribute name="href">
    <xsl:call-template name="olink.href.target">
      <xsl:with-param name="nd" select="$nd"/>
    </xsl:call-template>
  </xsl:attribute>

  <xsl:variable name="num">
    <xsl:apply-templates select="$nd" mode="label.markup">
      <xsl:with-param name="verbose" select="0"/>
    </xsl:apply-templates>
  </xsl:variable>

  <xsl:if test="$num">
    <xsl:attribute name="number">
      <xsl:value-of select="$num"/>
    </xsl:attribute>
  </xsl:if>

  <xsl:choose>
    <xsl:when test="$nd/@id">
      <xsl:attribute name="targetptr">
        <xsl:value-of select="$nd/@id"/>
      </xsl:attribute>
    </xsl:when>
    <xsl:when test="$nd/@xml:id">
      <xsl:attribute name="targetptr">
        <xsl:value-of select="$nd/@xml:id"/>
      </xsl:attribute>
    </xsl:when>
  </xsl:choose>

  <xsl:if test="$nd/@lang">
    <xsl:attribute name="lang">
      <xsl:value-of select="$nd/@lang"/>
    </xsl:attribute>
  </xsl:if>
  
  <!-- for JCBG-1587, adding security info as data-security attrib -->
     <!-- adding 4/25/16: test whether a security attrib exists before adding this, 
     so we don't get empty data-security elements
     note that we're always adding a security element if the current element OR ANY ANCESTOR has one, so that our other code doesn't have to look backward
     -->
  <xsl:if test="not(ancestor-or-self::*[@security][1]/@security) = ''">
   <xsl:attribute name="data-security">
      <xsl:value-of select="ancestor-or-self::*[@security][1]/@security"/>
    </xsl:attribute>
  </xsl:if>
  
  <!-- for JCBG-1681, need to add stop-chunking PIs to the olink db: 
    shows up as @data-stopchunk=true, on elements that have the dbhtml stop-chunking PI as a child. -->
  <xsl:if test="./processing-instruction('dbhtml')= 'stop-chunking'"> <!-- if the current element has a child pi dbhtml stop-chunking... -->
    <xsl:attribute name="data-stopchunk">true</xsl:attribute>
  </xsl:if>
  

</xsl:template>

<xsl:template name="div">
  <xsl:param name="nd" select="."/>
  <xsl:variable name="ttl-var"> <!-- JCBG-103: Handle trailing spaces -->
    <xsl:apply-templates select="$nd" mode="title.markup">
      <xsl:with-param name="verbose" select="0"/>
    </xsl:apply-templates>
  </xsl:variable>
  <div>
    <xsl:call-template name="attrs">
      <xsl:with-param name="nd" select="$nd"/>
    </xsl:call-template>
    <xsl:if test="local-name(.)='book' or local-name(.)='article'">  <!-- adding eclipse id for JCBG-672 -->
      <xsl:attribute name="data-eclipseid"><xsl:value-of select="$eclipse.plugin.id"/></xsl:attribute>
    </xsl:if>
    <ttl> <!-- JCBG-103: Handle trailing spaces -->
      <xsl:value-of select="normalize-space(string($ttl-var))"/>
    </ttl>
    <xreftext>
      <xsl:choose>
        <xsl:when test="$nd/@xreflabel">
          <xsl:call-template name="xref.xreflabel">
            <xsl:with-param name="target" select="$nd"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="$nd" mode="xref-to">
            <xsl:with-param name="verbose" select="0"/>
          </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
    </xreftext>
    <xsl:apply-templates mode="olink.mode"/>
  </div>
</xsl:template>

<xsl:template name="obj">
  <xsl:param name="nd" select="."/>
  <xsl:variable name="ttl-var2"> <!-- JCBG-103: Handle trailing spaces -->
    <xsl:apply-templates select="$nd" mode="title.markup">
      <xsl:with-param name="verbose" select="0"/>
    </xsl:apply-templates>
  </xsl:variable>

  <obj>
    <xsl:call-template name="attrs">
      <xsl:with-param name="nd" select="$nd"/>
    </xsl:call-template>
    <ttl> <!-- JCBG-103: Handle trailing spaces -->
      <xsl:value-of select="normalize-space(string($ttl-var2))"/>
    </ttl>
    <xreftext>
      <xsl:choose>
        <xsl:when test="$nd/@xreflabel">
          <xsl:call-template name="xref.xreflabel">
            <xsl:with-param name="target" select="$nd"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="$nd" mode="xref-to">
            <xsl:with-param name="verbose" select="0"/>
          </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
    </xreftext>
  </obj>
</xsl:template>

<xsl:template match="text()|processing-instruction()|comment()"
              mode="olink.mode">
  <!-- nop -->
</xsl:template>

<!--
<xsl:template match="*" mode="olink.mode">
</xsl:template>
-->
  
  <xsl:template match="info" mode="olink.mode">
    <xsl:apply-templates mode="olink.mode"/> <!-- no-op, but process contents -->
  </xsl:template>
<!-- write keywords out to the olink.db file, per JCBG-672 -->
  <xsl:template match="keywordset" mode="olink.mode">
    <keywordset><xsl:apply-templates mode="olink.mode"/></keywordset>
  </xsl:template>
<!-- only write out keywords if they have role='rh' -->
  <xsl:template match="keyword[@role='rh']" mode="olink.mode"> 
    <keyword><xsl:value-of select="."/></keyword>
  </xsl:template>
  

  

<xsl:template match="set" mode="olink.mode">
  <xsl:call-template name="div"/>
</xsl:template>

<xsl:template match="book" mode="olink.mode">
  <xsl:call-template name="div"/>
</xsl:template>

<xsl:template match="preface|chapter|appendix" mode="olink.mode">
  <xsl:call-template name="div"/>
</xsl:template>

<xsl:template match="part|reference" mode="olink.mode">
  <xsl:call-template name="div"/>
</xsl:template>

<xsl:template match="article" mode="olink.mode">
  <xsl:call-template name="div"/>
</xsl:template>

<xsl:template match="bibliography|bibliodiv" mode="olink.mode">
  <xsl:call-template name="div"/>
</xsl:template>

<xsl:template match="biblioentry|bibliomixed" mode="olink.mode">
  <xsl:call-template name="obj"/>
</xsl:template>

<xsl:template match="refentry" mode="olink.mode">
  <xsl:call-template name="div"/>
</xsl:template>

<xsl:template match="section|sect1|sect2|sect3|sect4|sect5" mode="olink.mode">
  <xsl:call-template name="div"/>
</xsl:template>

<xsl:template match="refsection|refsect1|refsect2|refsect3" mode="olink.mode">
  <xsl:call-template name="div"/>
</xsl:template>

<xsl:template match="figure|example|table" mode="olink.mode">
  <xsl:call-template name="obj"/>
  <xsl:apply-templates mode="olink.mode"/>
</xsl:template>

<xsl:template match="equation[title or info/title]" mode="olink.mode">
  <xsl:call-template name="obj"/>
</xsl:template>

<xsl:template match="qandaset|qandaentry" mode="olink.mode">
  <xsl:call-template name="div"/>
</xsl:template>

<xsl:template match="*" mode="olink.mode">
  <xsl:if test="@id or @xml:id">
    <xsl:call-template name="obj"/>
  </xsl:if> 
  <xsl:apply-templates mode="olink.mode"/>
</xsl:template>

</xsl:stylesheet>
