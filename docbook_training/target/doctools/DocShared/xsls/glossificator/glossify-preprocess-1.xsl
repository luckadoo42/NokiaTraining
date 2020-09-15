<?xml version ="1.0"?>
<!DOCTYPE stylesheet>

<!--
  This stylesheet pulls in all <glossentry>s which are referenced, directly or
  indirectly, from <glossterm>s outside of their ancestor <glossary>.
  (Indirectly referenced <glossentry>s are those which are referenced by a chain
  of other <glossentry>s (via their <glossterm>, <glosssee>, or <glossseealso>
  children), the head of which is directly referenced.)  Those <glossentry>s
  which are not referenced from without the <glossary> are not written to the
  output.
  
  This transformation was previously accomplished with three separate
  transformations, called "weed," "sort" and "unique."  This one reduces the
  aggregate time needed to run those three by about 36%.
  
  Notice that any output to STDOUT may be interpreted by Powderkeg Perl scripts
  as a failure of the transformation; hence the 'DEBUG' <xsl:message>s below
  have been commented out.
  
  Informal Change History
  =======================
  
  Wed Jan  9 11:29:16  2002
  
  Added non-fatal whining  (subject to ``quiet'' global parameter setting) when
  a glossentry with a ``role="deprecated"'' attribute is written.
  
-->

<xsl:stylesheet exclude-result-prefixes="db"
  version="2.0"
  xmlns:db="http://docbook.org/ns/docbook"
  xmlns="http://docbook.org/ns/docbook"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:key
    name="outsideGlossaryGlossterms"
    match="//db:glossterm[not(ancestor::db:glossary)]"
    use="@linkend"/>
  
  <!-- "quiet" != 0 => Quell non-fatal <xsl:message>s. -->
  <xsl:param name="quiet" select="0"/>
  
  <xsl:param name="debug" select="'1'"/>
  
  <!-- If recurse.on.glossary != 0 => put glossterms that
    occur in glossdefs in glossary -->
  <xsl:param name="recurse.on.glossary" select="'0'"/>
  
  <xsl:output
    method="xml"/>
  
  
  <!-- ========== Start preprocess templates ===================== -->
  <!-- This pass is, among other things, combining a document's
    internally defined glossentries with those from the master glossary into oneb
    big glossary element. -->
  
  <xsl:variable name="glossary-pass-1">
    <xsl:apply-templates mode="preprocess"/>
  </xsl:variable>
  
  <!-- 
    Replace the existing <glossary role="main"> or <?glossary?> with the glossary pulled in via xslt
    This will allow us to break the glossary file up into smaller files to make it easier to manage. 
  -->
  <xsl:param name="language">en_US</xsl:param>
  <xsl:param name="glossary-path">_masterglossary-db5-chunked-xincluded.xml</xsl:param>
  
  <xsl:template match="db:index" mode="preprocess">
    <xsl:choose>
      <xsl:when	test="//db:indexterm and //processing-instruction('glossary') or //db:glossary[@role='main']">
        <index>
          <xsl:if test="not(@role)">
            <xsl:attribute name="role">default</xsl:attribute>
          </xsl:if>
          <xsl:apply-templates select="@*|node()" mode="preprocess"/>
        </index>
      </xsl:when>
      <xsl:when	test="//db:indexterm and not(//db:glossterm[not(ancestor::db:glossentry)]) or preceding::db:index">
        <index>
          <xsl:if test="not(@role)">
            <xsl:attribute name="role">default</xsl:attribute>
          </xsl:if>
          <xsl:apply-templates select="@*|node()" mode="preprocess"/>
        </index>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="insert-glossary"/>
        <index>
          <xsl:if test="not(@role)">
            <xsl:attribute name="role">default</xsl:attribute>
          </xsl:if>
          <xsl:apply-templates select="@*|node()" mode="preprocess"/>
        </index>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- added for JDBG-209 and JCBG-335: insert a glossary when there is no index to trigger it
  
  Match on book that has 
    no index(es) and 
    no <?glossary?> and 
    no <glossary role="main"> and 
    DOES have some glossterms (not in a glossary tag, ie glossterms with linkends)
    
-->
  <xsl:template match="db:book[not(//db:index) and not(//processing-instruction('glossary')) and not(//db:glossary[@role='main']) and //db:glossterm[not(ancestor::db:glossentry)]]" mode="preprocess">
    <xsl:copy>
     <!-- first copy out the book and all its contents (notice the mode!) -->
      <xsl:apply-templates select="@*|node()" mode="preprocess" />
      <!-- then insert glossary at end --> 
      <xsl:call-template name="insert-glossary"/>
    </xsl:copy>
  </xsl:template>
  


  <xsl:template
    match="db:glossary[@role='main']|processing-instruction('glossary')" name="insert-glossary"
    mode="preprocess">
    <xsl:variable name="local-glossterms" select="//db:glossentry[parent::db:glossary[not(@role='main')]]"/>
    
    <xsl:message>Inserting main glossary.</xsl:message>
    
    <xsl:choose>
      <xsl:when test="$language = 'en_US' or $language='' or substring($language,1,2) = 'en'">
        <xsl:if test="count(document($glossary-path, .)//db:glossentry) = 0">
          <xsl:message terminate="yes">
            Error: Failed to open <xsl:value-of select="$glossary-path"/>
          </xsl:message>
        </xsl:if>
        <glossary role="main">
          <xsl:apply-templates select="document($glossary-path, .)//db:glossentry[not(@xml:id = $local-glossterms/@xml:id )]" mode="preprocess"/>
          <!-- Merge any local, doc-specific glossaries into the main one -->
          <xsl:apply-templates select="//db:glossentry[parent::db:glossary[not(@role='main')]]" mode="preprocess"/>
        </glossary>
      </xsl:when>
      <xsl:otherwise>
        <glossary>
          <xsl:apply-templates select="@*|node()" mode="preprocess"/>
        </glossary>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- Nuke any doc-specific glossaries...these have been merged into the main one. -->
  <xsl:template match="db:glossary[not(@role='main')]" mode="preprocess"/>
  
  <!-- Removing markup from inside glossterms in the glossary -->
  <!-- to prevent sorting problems. Also normalizing -->
  <!-- space. -->
  <xsl:template match="db:glossentry/db:glossterm" mode="preprocess">  
    <glossterm><xsl:copy-of select="@*"/><xsl:apply-templates select="node()" mode="remarks"/></glossterm>
  </xsl:template>
  
  <xsl:template match="db:remark|*[@security and not(@security='external')]" mode="remarks">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="remarks"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- Instead let's just validate after glossification -->
  <!--xsl:template match="db:glossterm[not(parent::db:glossentry) and
    (not(@linkend) or normalize-space(@linkend) = '')]" mode="preprocess">
    <xsl:message terminate="yes">
    =======================================================================
    ERROR: Glossterm that lacks a linkend found: <xsl:copy-of select="."/>
    in <xsl:for-each select="ancestor-or-self::*"><xsl:value-of select="local-name(.)"/><xsl:if test="@id">[@id="<xsl:value-of select="@id"/>"]</xsl:if><xsl:if test="not(position() = last())">/</xsl:if></xsl:for-each>
    =======================================================================
    </xsl:message>
    </xsl:template-->
  
  <xsl:template match="@*|node()" mode="preprocess">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"  mode="preprocess"/>
    </xsl:copy>
  </xsl:template>
  <!-- ========== End preprocess templates ===================== -->
  
  <!-- ========== Start preprocess-2 templates ================ -->
  <xsl:param name="glossary.exclusions"/>
  <xsl:param name="exclude.deprecated.glossterms">0</xsl:param>
  <xsl:param name="terminate">yes</xsl:param>
  
  <xsl:variable name="glossary-pass-2">
    <xsl:apply-templates select="$glossary-pass-1" mode="preprocess-2"/>
  </xsl:variable>
  
  <xsl:template match="db:glossterm[ancestor::db:glossary and not(parent::db:glossentry)]|db:glossseealso|db:glossentry[db:glosssee]" mode="preprocess-2">
    <xsl:choose>
      <xsl:when 
        test="
        self::db:glossterm and 
        contains(concat(';',translate($glossary.exclusions,' ',';'),';'),concat(';',@linkend,';'))"><xsl:apply-templates  mode="preprocess-2"/></xsl:when>
      <xsl:when 
        test="
        self::db:glossseealso and 
        contains(concat(';',translate($glossary.exclusions,' ',';'),';'),concat(';',@otherterm,';')) and 
        not(key('outsideGlossaryGlossterms', @otherterm))">
        <!-- Drop it -->
      </xsl:when>
      <xsl:when 
        test="self::db:glossentry and 
        contains(concat(';',translate($glossary.exclusions,' ',';'),';'),concat(';',./db:glosssee/@otherterm,';')) and 
        not(key('outsideGlossaryGlossterms', @otherterm))"></xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="@*|node()" mode="preprocess-2"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="db:glossterm[not(ancestor::db:glossary) and not(//db:glossary/db:glossentry/@xml:id = @linkend)]" mode="preprocess-2">
    <xsl:message terminate="{$terminate}">
      ===================================
      Uh oh! 
      -----------------------------------
      I found a glossterm whose linkend
      doesn't have a matching glossentry. 
      Here's the problematic glossterm:
      
      <xsl:copy-of select="."/>
      
      in
      
      <xsl:copy-of select="parent::*"/>
      
      ===================================
    </xsl:message>
    <xsl:copy-of select="."/>
  </xsl:template>
  
  <xsl:template match="@*|node()" mode="preprocess-2">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="preprocess-2"/>
    </xsl:copy>
  </xsl:template>
  <!-- ========== End preprocess-2 templates =============== -->
  
  <xsl:template match="/">
    <xsl:message>
      glossary-path=<xsl:value-of select="$glossary-path"/>
    </xsl:message>
    
    <xsl:result-document href="_05.1.glossified_pass_1.xml">
      <xsl:copy-of select="$glossary-pass-1"/>
    </xsl:result-document>
    
    <xsl:copy-of select="$glossary-pass-2"/>
    
  </xsl:template>
 
</xsl:stylesheet>

