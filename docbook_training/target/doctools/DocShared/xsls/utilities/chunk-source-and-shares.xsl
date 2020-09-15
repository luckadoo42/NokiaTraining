<?xml version ="1.0"?>

<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  
  xmlns:xi="http://www.w3.org/2001/XInclude" 
  xmlns:db="http://docbook.org/ns/docbook" 
  xmlns="http://docbook.org/ns/docbook">
  
  <xsl:key match="*" name="ids" use="@xml:id"/>
  <xsl:key match="*" name="linkends" use="@linkend"/>
  <xsl:key match="*" name="sharer_ids" use="@sharer_id"/>
  <xsl:key match="*" name="targetptrs" use="@targetptr"/>
  
  <xsl:param name="broadbook-version">5.0-extension BroadBook-2.0</xsl:param>
  <xsl:param name="subdir"></xsl:param>
  
  <!-- Use this to convert xrefs to olinks -->
  <xsl:param name="current.docid"/>
  <xsl:param name="filerefdir"/>
  <xsl:param name="this">this</xsl:param>
  
  <xsl:output method="xml" indent="no"/>
  
  <xsl:preserve-space elements="*"/>
  
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
        <xsl:element name="xi:include" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xi="http://www.w3.org/2001/XInclude">
          <xsl:attribute name="href"><xsl:value-of select="concat(normalize-space($dirname),'fragments','/',@sharer_id,'.xml')"/></xsl:attribute>
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
  
  <xsl:template match="*" mode="compute-name">
    <xsl:variable name="filename">
      <xsl:apply-templates select="ancestor-or-self::db:part" mode="count"/><xsl:apply-templates select="ancestor-or-self::db:chapter|ancestor-or-self::db:appendix|ancestor-or-self::db:preface|ancestor-or-self::db:glossary|ancestor-or-self::db:reference" mode="count"/>_<xsl:value-of select="@xml:id"/>.xml
    </xsl:variable>
    <xsl:value-of select="normalize-space($filename)"/>
  </xsl:template>
  
  <xsl:template match="db:part" mode="count"><xsl:variable name="number"><xsl:number count="db:part" format="01"/></xsl:variable>part_<xsl:value-of select="format-number($number * 10, '000')"/>_</xsl:template>
  <xsl:template match="db:chapter|db:appendix|db:preface|db:glossary|db:reference" mode="count">
    <xsl:variable name="number"><xsl:number count="db:chapter|db:appendix|db:preface|db:glossary|db:reference" format="01"/></xsl:variable>
    <xsl:value-of select="local-name(.)"/>_<xsl:value-of select="format-number($number * 10, '000')"/>
  </xsl:template>
  
  <!-- Convert xrefs to olinks -->
  <xsl:template match="db:xref">
    <xsl:element name="olink">
      <xsl:attribute name="targetdoc" select="$current.docid"/>
      <xsl:attribute name="targetptr" select="@linkend"/>
      <xsl:copy-of select="@xrefstyle"/>
      <xsl:variable name="linktext">
        <xsl:apply-templates select="key('ids',@linkend)/db:title|key('ids',@linkend)/db:info/db:title" mode="strip-remarks"/>
      </xsl:variable>
      <xsl:value-of select="normalize-space($linktext)"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="db:link" xmlns:xlink="http://www.w3.org/1999/xlink">
    <xsl:choose>
      <xsl:when test="starts-with(@xlink:href,'http')">
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="olink">
          <xsl:attribute name="targetdoc" select="$current.docid"/>
          <xsl:attribute name="targetptr" select="@linkend"/>
          <xsl:attribute name="xrefstyle">select: linktext</xsl:attribute>
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>
  
  <xsl:template match="db:remark" mode="strip-remarks"/>
  
  <xsl:template match="/">
    <xsl:message terminate="no">
      Warning: This stylesheet requires an xslt 2.0 processor such as Saxon 8.
      Version:  <xsl:value-of select = "system-property('xsl:version')" />
      Vendor: <xsl:value-of select = "system-property('xsl:vendor')" />
      URL: <xsl:value-of select = "system-property('xsl:vendor-url')" />
    </xsl:message>
    <xsl:if test="$current.docid = ''">
      <xsl:message terminate="yes">ERROR: current.docid must be set.</xsl:message>
    </xsl:if>
    <!-- <xsl:text disable-output-escaping="yes"><![CDATA[<!DOCTYPE ]]></xsl:text><xsl:value-of select="local-name(/*[1])"/><xsl:text disable-output-escaping="yes"><![CDATA[ [ -->
    <!--     <!ENTITY % DOCTYPE.ent SYSTEM "DOCTYPE.ent"> -->
    <!--     %DOCTYPE.ent; ]> -->
    <!--     ]]></xsl:text>  -->
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="db:book|db:part">
    <xsl:variable name="part-number">
      <xsl:number count="db:part" format="01"/>
    </xsl:variable>
    <xsl:variable name="part">
      <xsl:choose>
        <xsl:when test="not($part-number = '')">part_<xsl:value-of select="format-number($part-number * 10,'000')"/>_</xsl:when>
        <xsl:otherwise/>
      </xsl:choose>
    </xsl:variable>
    <xsl:element name="{local-name(.)}">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates>
        <xsl:with-param name="part" select="$part"/>
      </xsl:apply-templates>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="db:chapter|db:appendix|db:preface|db:glossary|db:reference">
    <xsl:param name="part"/>
    <xsl:param name="elementname" select="local-name()"/>
    <xsl:variable name="number">
      <xsl:number count="*[local-name() = $elementname]" format="01"/>
    </xsl:variable>
    <xsl:variable name="name" select="concat($part,local-name(),'_',format-number($number * 10, '000'),'_',@xml:id,'.xml')"/>
    <xsl:message>name="<xsl:value-of select="$name"/>"</xsl:message>
    <xsl:result-document href="{$subdir}{$name}">
      <!-- <xsl:text disable-output-escaping="yes"><![CDATA[<!DOCTYPE ]]></xsl:text><xsl:value-of select="local-name(.)"/><xsl:text disable-output-escaping="yes"><![CDATA[ [ -->
      <!--   <!ENTITY % DOCTYPE.ent SYSTEM "DOCTYPE.ent"> -->
      <!--   %DOCTYPE.ent; ]> -->
      <!--   ]]></xsl:text>  -->
      <xsl:element name="{local-name(.)}">
        <xsl:copy-of select="@*"/>
        <xsl:attribute name="version"><xsl:value-of select="$broadbook-version"/></xsl:attribute>
        <xsl:apply-templates/>
      </xsl:element>
    </xsl:result-document>
    <xsl:comment>
      <xsl:apply-templates select="./db:title|./db:info/db:title" mode="strip-remarks"/>
      <xsl:if test="self::db:glossary">Glossary</xsl:if>
    </xsl:comment>
    <xsl:element name="xi:include">
      <xsl:attribute name="href" select="concat($subdir,$name)"/>   
    </xsl:element>
  </xsl:template>
  
  <!-- and not(key('linkends',@xml:id)) and not(key('targetptrs',@xml:id))   -->
  <xsl:template match="*[@xml:id][not(starts-with(local-name(.),'share_')) and not(self::db:part) and not(self::db:chapter) and not(self::db:glossary) and not(self::db:preface) and not(self::db:appendix) and not(self::db:reference)]">
    <xsl:choose>
      <xsl:when test="key('sharer_ids',@xml:id) and not(key('linkends',@xml:id)) and not(key('targetptrs',@xml:id)) and not(.//*[key('linkends',@xml:id) or key('targetptrs',@xml:id)])">
        <xsl:result-document href="fragments/{@xml:id}.xml">
          <xsl:element name="{local-name(.)}" xmlns="http://docbook.org/ns/docbook">
            <xsl:for-each select="@*">
              <xsl:choose>
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
          <xsl:attribute name="href"><xsl:value-of select="concat('fragments','/',@xml:id,'.xml')"/></xsl:attribute>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:template>
  
  <!-- <xsl:template match="@fileref"> -->
  <!--   <xsl:attribute name="fileref">images/<xsl:choose> -->
  <!--       <xsl:when test="starts-with(.,$filerefdir)"><xsl:value-of select="substring-after(.,$filerefdir)"/></xsl:when> -->
  <!--       <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise> -->
  <!--     </xsl:choose> -->
  <!--   </xsl:attribute> -->
  <!-- </xsl:template>   -->
  
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>
