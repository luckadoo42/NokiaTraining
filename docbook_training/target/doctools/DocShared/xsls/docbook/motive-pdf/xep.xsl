<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:rx="http://www.renderx.com/XSL/Extensions"
                version='1.0'>

<!-- ********************************************************************
     $Id: xep.xsl,v 1.9 2009/11/19 22:22:34 dcramer Exp $
     ********************************************************************
     (c) Stephane Bline Peregrine Systems 2001
     Implementation of xep extensions:
       * Pdf bookmarks (based on the XEP 2.5 implementation)
       * Document information (XEP 2.5 meta information extensions)
     ******************************************************************** -->

<!-- FIXME: Norm, I changed things so that the top-level element (book or set)
     does not appear in the TOC. Is this the right thing? -->

<xsl:param name="procedures.in.toc">1</xsl:param>

<xsl:template name="xep-document-information">
  <rx:meta-info>
    <xsl:variable name="authors" select="(//author|//editor|//corpauthor|//authorgroup)[1]"/>
<!--  Test not needed. It's always by Alcatel -->
<!--     <xsl:if test="$authors"> -->
      <xsl:variable name="author">
        <xsl:choose>
          <xsl:when test="$authors[self::authorgroup]">
            <xsl:call-template name="person.name.list">
              <xsl:with-param name="person.list" 
                        select="$authors/*[self::author|self::corpauthor|
                               self::othercredit|self::editor]"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$authors[self::corpauthor]">
            <xsl:value-of select="$authors"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="person.name">
              <xsl:with-param name="node" select="$authors"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:element name="rx:meta-field">
        <xsl:attribute name="name">author</xsl:attribute>
        <xsl:attribute name="value">Alcatel-Lucent
<!--           <xsl:value-of select="normalize-space($author)"/> -->
        </xsl:attribute>
      </xsl:element>
<!--     </xsl:if> -->

    <xsl:variable name="title">
      <xsl:apply-templates select="/*[1]" mode="label.markup"/>
      <xsl:apply-templates select="/*[1]" mode="title.markup"/>
    </xsl:variable>

    <xsl:element name="rx:meta-field">
      <xsl:attribute name="name">creator</xsl:attribute>
      <xsl:attribute name="value">
        <xsl:text>DocBook </xsl:text>
        <xsl:value-of select="$DistroTitle"/>
        <xsl:text> V</xsl:text>
        <xsl:value-of select="$VERSION"/>
      </xsl:attribute>
    </xsl:element>

    <xsl:element name="rx:meta-field">
      <xsl:attribute name="name">title</xsl:attribute>
      <xsl:attribute name="value">
        <xsl:value-of select="normalize-space($title)"/>
      </xsl:attribute>
    </xsl:element>

   <!-- Per JCBG-223, populate keywords with Vol info, using part number as 1st bibloid, and date as 1st pubdate -->
      <xsl:element name="rx:meta-field">
        <xsl:attribute name="name">keywords</xsl:attribute>
        <xsl:attribute name="value">
Vol 1 of 1 <xsl:value-of select="//biblioid[1]"/>
Issue 1 Date <xsl:value-of select="//pubdate[1]"/>.

<!-- Also, include any keywords that are in the document ... -->
          <xsl:for-each select="//keyword">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="position() != last()">
              <xsl:text>, </xsl:text>
            </xsl:if>
          </xsl:for-each>
        </xsl:attribute>
      </xsl:element>


    <xsl:if test="//subjectterm">
      <xsl:element name="rx:meta-field">
        <xsl:attribute name="name">subject</xsl:attribute>
        <xsl:attribute name="value">
          <xsl:for-each select="//subjectterm">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="position() != last()">
              <xsl:text>, </xsl:text>
            </xsl:if>
          </xsl:for-each>
        </xsl:attribute>
      </xsl:element>
    </xsl:if>
  </rx:meta-info>
</xsl:template>

<!-- ********************************************************************
     Pdf bookmarks for FOP
     ******************************************************************** -->

<!-- adding test stuff for fo bookmarks, JCBG-76 -->




<!-- 
<xsl:template match="*" mode="outline">
     <xsl:apply-templates select="*" mode="outline"/>    
 </xsl:template> -->

<!-- test code to generate a single hardcoded bookmark per book, validating fop bookmarks for jcbg-76 -->
  <!-- note that the id of the BOOK links you to the title pg, id+ _2 -> Contents. -->
  
  <!-- commented out for now
<xsl:template match="book" mode="outline">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>
  <xsl:message>FOP bookmark: creating one for book, with destination= <xsl:value-of select="@id"/></xsl:message>
  <fo:bookmark-tree>
    <fo:bookmark internal-destination="{@id}_2">
      
      <fo:bookmark-title font-weight="bold">Test Fo Bookmark</fo:bookmark-title>
    </fo:bookmark>
  </fo:bookmark-tree>
  <xsl:apply-templates select="*" mode="outline"/>
</xsl:template> -->

<!--
  <xsl:template match="set|book|part|reference|preface|chapter|appendix|article
    |glossary|bibliography|index|setindex
    |refentry|refsynopsisdiv
    |refsect1|refsect2|refsect3|refsection
    |sect1|sect2|sect3|sect4|sect5|section|simplesect|procedure"
    mode="outline">
    <xsl:variable name="id">
      <xsl:call-template name="object.id"/>
    </xsl:variable>
    <xsl:variable name="bookmark-label">
      <xsl:choose>
        <xsl:when test="name() = 'chapter'">
          <xsl:choose>
            <xsl:when test="$label.from.part != 0 and ancestor::part">
              <xsl:number from="part" count="chapter" format="1" level="any"/><xsl:text>. </xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:number from="book" count="chapter" format="1" level="any"/><xsl:text>. </xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="name() = 'appendix'">
          <xsl:choose>
            <xsl:when test="$label.from.part != 0 and ancestor::part">
              <xsl:number from="part" count="appendix" format="A" level="any"/><xsl:text>. </xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:number from="book|article" count="appendix" format="A" level="any"/><xsl:text>. </xsl:text>
            </xsl:otherwise>
          </xsl:choose>		  
        </xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="." mode="object.title.markup"/>
    </xsl:variable>
-->    
    <!-- Put the root element bookmark at the same level as its children -->
    <!-- If the object is a set or book, generate a bookmark for the toc, and wrap in bookmark-tree -->
  
<!--   
    <xsl:choose>
      <xsl:when test="self::index and $generate.index = 0"/>
      <xsl:when test="parent::* and (not(self::procedure) or $procedures.in.toc != '0')">
          <fo:bookmark internal-destination="{$id}">
            <fo:bookmark-title>
              <xsl:value-of select="normalize-space($bookmark-label)"/>
            </fo:bookmark-title>
            <xsl:apply-templates select="*" mode="outline"/>
          </fo:bookmark> 
      </xsl:when>
      <xsl:otherwise> 
        <fo:bookmark-tree>
        <xsl:if test="$bookmark-label != ''">
          <fo:bookmark internal-destination="{$id}">
            <fo:bookmark-title>
              <xsl:value-of select="normalize-space($bookmark-label)"/>
            </fo:bookmark-title>
          </fo:bookmark>
        </xsl:if> 
        
        <xsl:variable name="toc.params">
          <xsl:call-template name="find.path.params">
            <xsl:with-param name="table" select="normalize-space($generate.toc)"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:if test="contains($toc.params, 'toc')
          and set|book|part|reference|section|simplesect|procedure|sect1|refentry
          |article|bibliography|glossary|chapter
          |appendix">
          <fo:bookmark internal-destination="toc...{$id}">
            <fo:bookmark-title>
              <xsl:call-template name="gentext">
                <xsl:with-param name="key" select="'TableofContents'"/>
              </xsl:call-template>
            </fo:bookmark-title>
          </fo:bookmark>
        </xsl:if>
        <xsl:apply-templates select="*" mode="outline"/>
        </fo:bookmark-tree>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template> -->

  <!-- ********************************************************************
    Pdf bookmarks for XEP, using xep extensions
    ******************************************************************** -->
<xsl:template match="*" mode="xep.outline">
  <xsl:apply-templates select="*" mode="xep.outline"/>
</xsl:template>

<xsl:template match="set|book|part|reference|preface|chapter|appendix|article
                     |glossary|bibliography|index|setindex
                     |refentry|refsynopsisdiv
                     |refsect1|refsect2|refsect3|refsection
                     |sect1|sect2|sect3|sect4|sect5|section|simplesect|procedure"
              mode="xep.outline">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>
  <xsl:variable name="bookmark-label">
	  <xsl:choose>
		<xsl:when test="name() = 'chapter'">
		  <xsl:choose>
			<xsl:when test="$label.from.part != 0 and ancestor::part">
			  <xsl:number from="part" count="chapter" format="1" level="any"/><xsl:text>. </xsl:text>
			</xsl:when>
			<xsl:otherwise>
			  <xsl:number from="book" count="chapter" format="1" level="any"/><xsl:text>. </xsl:text>
			</xsl:otherwise>
		  </xsl:choose>
		</xsl:when>
		<xsl:when test="name() = 'appendix'">
		  <xsl:choose>
			<xsl:when test="$label.from.part != 0 and ancestor::part">
			  <xsl:number from="part" count="appendix" format="A" level="any"/><xsl:text>. </xsl:text>
			</xsl:when>
			<xsl:otherwise>
			  <xsl:number from="book|article" count="appendix" format="A" level="any"/><xsl:text>. </xsl:text>
			</xsl:otherwise>
		  </xsl:choose>		  
		</xsl:when>
		<xsl:otherwise></xsl:otherwise>
	  </xsl:choose>
    <xsl:apply-templates select="." mode="object.title.markup"/>
  </xsl:variable>

  <!-- Put the root element bookmark at the same level as its children -->
  <!-- If the object is a set or book, generate a bookmark for the toc -->

  <xsl:choose>
	<xsl:when test="self::index and $generate.index = 0"/>
    <xsl:when test="parent::* and (not(self::procedure) or $procedures.in.toc != '0')">
      <rx:bookmark internal-destination="{$id}">
        <rx:bookmark-label>
          <xsl:value-of select="normalize-space($bookmark-label)"/>
        </rx:bookmark-label>
        <xsl:apply-templates select="*" mode="xep.outline"/>
      </rx:bookmark>
    </xsl:when>
    <xsl:otherwise>
      <xsl:if test="$bookmark-label != ''">
        <rx:bookmark internal-destination="{$id}">
          <rx:bookmark-label>
            <xsl:value-of select="normalize-space($bookmark-label)"/>
          </rx:bookmark-label>
        </rx:bookmark>
      </xsl:if>

      <xsl:variable name="toc.params">
        <xsl:call-template name="find.path.params">
          <xsl:with-param name="table" select="normalize-space($generate.toc)"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="contains($toc.params, 'toc')
                    and set|book|part|reference|section|simplesect|procedure|sect1|refentry
                        |article|bibliography|glossary|chapter
                        |appendix">
        <rx:bookmark internal-destination="toc...{$id}">
          <rx:bookmark-label>
            <xsl:call-template name="gentext">
              <xsl:with-param name="key" select="'TableofContents'"/>
            </xsl:call-template>
          </rx:bookmark-label>
        </rx:bookmark>
      </xsl:if>
      <xsl:apply-templates select="*" mode="xep.outline"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="xep-pis">
  <xsl:if test="$crop.marks != 0">
    <xsl:processing-instruction name="xep-pdf-crop-mark-width"><xsl:value-of select="$crop.mark.width"/></xsl:processing-instruction>
    <xsl:processing-instruction name="xep-pdf-crop-offset"><xsl:value-of select="$crop.mark.offset"/></xsl:processing-instruction>
    <xsl:processing-instruction name="xep-pdf-bleed"><xsl:value-of select="$crop.mark.bleed"/></xsl:processing-instruction>
  </xsl:if>

  <xsl:call-template name="user-xep-pis"/>
</xsl:template>

<!-- Placeholder for user defined PIs -->
<xsl:template name="user-xep-pis"/>

</xsl:stylesheet>
