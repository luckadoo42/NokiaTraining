<?xml version='1.0'?>

<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
  xmlns:rx="http://www.renderx.com/XSL/Extensions" exclude-result-prefixes="doc" version="1.1">

  <xsl:import href="../../../../docbook-xsl/1.72.0/fo/docbook.xsl"/>
  <xsl:import href="../common/common.xsl"/>
  <!-- added to fix jcbg-718-->
  <xsl:import href="param.xsl"/>
  <xsl:import href="l10n.xsl"/>
  <xsl:import href="pagesetup.xsl"/>
  <xsl:import href="autotoc.xsl"/>
  <xsl:import href="admon.xsl"/>

  <!--   <xsl:import href="autoidx.xsl"/> -->
  <xsl:import href="xep.xsl"/>
  <!-- fop.xsl provides bookmarks using fop extensions, nothing else 
      <xsl:import href="../../../../docbook-xsl/1.72.0/fo/fop.xsl"/>-->
  <!--   <xsl:import href="table.xsl"/> -->
  <xsl:import href="titlepage.templates.xsl"/>
  <!-- Remove italics from xrefs to chapters. -->
  <xsl:import href="xref.xsl"/>
  <xsl:import href="block.xsl"/>
  <xsl:import href="cover.xsl"/>
  <xsl:import href="division.xsl"/>
  <xsl:import href="component.xsl"/>
  <xsl:import href="lists.xsl"/>
  <xsl:import href="formal.xsl"/>
  <xsl:import href="inline.xsl"/>
  <xsl:import href="index.xsl"/>
  <xsl:import href="synop.xsl"/>
  <!--   <xsl:import href="ulink.xsl"/> -->
  <!--   <xsl:import href="common.xsl"/> -->
  <!-- This copy of qandaset.xsl fixes bugs and has been committed to svn. Omit when you upgrade -->
  <xsl:import href="qandaset.xsl"/>
  <!--   <xsl:import href="verbatim.xsl"/> -->
  <!-- Processing Instructions  -->
  <xsl:include href="../common/inline.xsl"/>

  <xsl:param name="motive.monospace.font.size">0.8em</xsl:param>
  <xsl:param name="security">external</xsl:param>
  <!-- ??? -->

  <!-- This is more of a param, so I'm overriding it here. -->
  <xsl:template name="next.itemsymbol">
    <xsl:param name="itemsymbol" select="'default'"/>
    <xsl:choose>
      <!-- Change this list if you want to change the order of symbols -->
      <xsl:when test="$itemsymbol = 'square'">box</xsl:when>
      <xsl:when test="$itemsymbol = 'box'">disc</xsl:when>
      <xsl:when test="$itemsymbol = 'disc'">circle</xsl:when>
      <xsl:when test="$itemsymbol = 'circle'">bullet</xsl:when>
      <xsl:when test="$itemsymbol = 'bullet'">round</xsl:when>
      <xsl:when test="$itemsymbol = 'round'">square</xsl:when>
      <xsl:otherwise>square</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Make glossterms in glossary bold -->
  <xsl:template match="glossentry/glossterm" mode="glossary.as.blocks">
    <fo:inline font-weight="bold">
      <xsl:apply-imports/>
    </fo:inline>
  </xsl:template>

  <!-- <xsl:template match="mediaobject"> -->
  <!-- 	<fo:block margin-left="-.5in" margin-right="-.5in" text-align="center"> -->
  <!-- 	  <xsl:apply-imports/> -->
  <!-- 	</fo:block> -->
  <!--   </xsl:template> -->

  <xsl:template
    match="processing-instruction('bjfo')[. = 'soft-break'] | processing-instruction('sbr')">
    <xsl:text>&#x200B;</xsl:text>
  </xsl:template>

  <xsl:template match="processing-instruction('linebreak')">
    <fo:block/>
  </xsl:template>

  <xsl:template match="processing-instruction('bjfo')[. = 'page-break']">
    <fo:block break-before="page"/>
  </xsl:template>

  <!--  Use this mostly for keeping figures etc with
  previous paras. -->
  <xsl:template match="para[./processing-instruction('keep-with-previous')]">
    <fo:block keep-with-previous.within-column="always" keep-together.within-column="always"
      xsl:use-attribute-sets="normal.para.spacing">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>


  <xsl:template match="*[./processing-instruction('bjfo') = 'keep-with-previous']">
    <fo:block keep-together.within-column="always" keep-with-previous.within-column="always">
      <xsl:apply-imports/>
    </fo:block>
  </xsl:template>

  <xsl:template match="*[./processing-instruction('bjfo') = 'keep-with-next']" priority="10">
    <fo:block keep-together.within-column="always" keep-with-next.within-column="always">
      <xsl:apply-imports/>
    </fo:block>
  </xsl:template>

  <xsl:template
    match="note/para[1] | caution/para[1] | tip/para[1] | warning/para[1] | important/para[1]">
    <fo:block>
      <xsl:call-template name="anchor"/>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="*[processing-instruction('bjfo') = 'keep-together']">
    <fo:block keep-together.within-column="always">
      <xsl:apply-imports/>
    </fo:block>
  </xsl:template>

  <!--   <xsl:template match="/book/preface/section[@id = 'document.conventions']"> -->
  <!-- 	<xsl:message> -->
  <!-- 	  Matched section[@id = 'document.conventions'] -->
  <!-- 	</xsl:message> -->
  <!-- 	<xsl:apply-imports select="document('../../../../DocShared/content/enus/conventions.motive.xml')/section"/> -->
  <!--   </xsl:template> -->

  <!--   <xsl:template match="/book/preface/section[@id = 'customer.support']"> -->
  <!-- 	<xsl:apply-imports select="document('../../../../DocShared/content/enus/customer.support.motive-pdf.xml')/section"/> -->
  <!--   </xsl:template> -->

  <xsl:template match="comment|remark">
    <xsl:if test="$show.comments != 0">
      <xsl:choose>
        <xsl:when test="parent::para or parent::title">
          <fo:inline font-style="italic" font-size="{$body.font.size}" background-color="yellow">
            <xsl:call-template name="inline.charseq"/>
          </fo:inline>
        </xsl:when>
        <xsl:otherwise>
          <fo:block font-style="italic" background-color="yellow">
            <xsl:call-template name="inline.charseq"/>
          </fo:block>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template match="table[./processing-instruction('bjfo') = 'wide-table']">
    <fo:block margin-left="-.5in" margin-right="-.5in">
      <xsl:apply-imports/>
    </fo:block>
  </xsl:template>

  <xsl:template match="mediaobject[./processing-instruction('bjfo') = 'wide-figure']">
    <fo:block margin-left="-.75in" margin-right="-.75in">
      <xsl:apply-imports/>
    </fo:block>
  </xsl:template>

  <xsl:template match="*[./processing-instruction('bjfo') = 'wide-block-element']">
    <fo:block margin-left="-.75in" margin-right="-.75in">
      <xsl:apply-imports/>
    </fo:block>
  </xsl:template>

  <!-- params needed for keycaps uppercasing. -->
  <!-- 	<xsl:param name="uppercase.alpha"> -->
  <!-- 	  <xsl:call-template name="gentext"> -->
  <!-- 		<xsl:with-param name="key" select="'uppercase.alpha'"/> -->
  <!-- 	  </xsl:call-template> -->
  <!-- 	</xsl:param> -->
  <!-- 	<xsl:param name="lowercase.alpha"> -->
  <!-- 	  <xsl:call-template name="gentext"> -->
  <!-- 		<xsl:with-param name="key" select="'lowercase.alpha'"/> -->
  <!-- 	  </xsl:call-template> -->
  <!-- 	</xsl:param> -->


  <xsl:template match="legalnotice" mode="book.titlepage.verso.auto.mode">
    <fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format"
      xsl:use-attribute-sets="book.titlepage.verso.style" font-size="9pt">
      <xsl:apply-templates select="." mode="book.titlepage.verso.mode"/>
    </fo:block>
    <xsl:if test="position() = 1">
      <xsl:call-template name="biblioidAndRsa"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="biblioid" mode="book.titlepage.verso.auto.mode"> </xsl:template>

  <xsl:template name="biblioidAndRsa">
    <fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format"
      xsl:use-attribute-sets="book.titlepage.verso.style" font-size="10pt" font-weight="bold"
      space-before="2em">
      <fo:table table-layout="fixed" width="100%">
        <fo:table-body>
          <fo:table-row>
            <fo:table-cell>
              <fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xsl:use-attribute-sets="book.titlepage.verso.style" font-size="10pt"
                font-weight="bold" space-before="1em">
                <xsl:value-of select="../biblioid"/>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell>
              
              <fo:block text-align="end">
                <!-- Hiding RSA graphic, we no longer think it's important to display, 12/9/15 
                <fo:external-graphic width="auto" height="auto" content-width=".65in">
                  <xsl:attribute name="src">
                    <xsl:value-of
                      select="translate(concat('url(',$common.graphics.path,'/RSA_secured_logo.svg)'),'\','/')"
                    />
                  </xsl:attribute>
                  
                </fo:external-graphic> -->
                <!-- JCBG-76, for FOP, swapped \ for / in the path -->
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
        </fo:table-body>
      </fo:table>

    </fo:block>
  </xsl:template>

  <xsl:template name="original.nongraphical.admonition">
    <xsl:variable name="id">
      <xsl:call-template name="object.id"/>
    </xsl:variable>

    <fo:block space-before.minimum="0.8em" space-before.optimum="1em" space-before.maximum="1.2em"
      start-indent="0.5in" end-indent="0.5in" id="{$id}">
      <fo:block keep-with-next="always"
        xsl:use-attribute-sets="original.admonition.title.properties">
        <xsl:apply-templates select="." mode="object.title.markup"/>
      </fo:block>

      <fo:block xsl:use-attribute-sets="original.admonition.properties">
        <xsl:apply-templates/>
      </fo:block>
    </fo:block>
  </xsl:template>

  <xsl:attribute-set name="original.admonition.properties">
    <xsl:attribute name="space-before.optimum">.25em</xsl:attribute>
    <xsl:attribute name="space-before.minimum">0.2em</xsl:attribute>
    <xsl:attribute name="space-before.maximum">.3em</xsl:attribute>
    <xsl:attribute name="space-after.optimum">.5em</xsl:attribute>
    <xsl:attribute name="space-after.minimum">0.4em</xsl:attribute>
    <xsl:attribute name="space-after.maximum">.6em</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="original.admonition.title.properties">
    <xsl:attribute name="font-size">12pt</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="hyphenate">false</xsl:attribute>
    <xsl:attribute name="keep-with-next.within-column">auto</xsl:attribute>
    <xsl:attribute name="space-before.optimum">.5em</xsl:attribute>
    <xsl:attribute name="space-before.minimum">0.4em</xsl:attribute>
    <xsl:attribute name="space-before.maximum">.6em</xsl:attribute>
    <xsl:attribute name="space-after.optimum">.25em</xsl:attribute>
    <xsl:attribute name="space-after.minimum">0.2em</xsl:attribute>
    <xsl:attribute name="space-after.maximum">.3em</xsl:attribute>
  </xsl:attribute-set>

  <xsl:template match="errorcode">
    <xsl:call-template name="inline.charseq"/>
  </xsl:template>

  <xsl:param name="motivechaptercircles">
    <xsl:value-of
      select="translate(concat($common.graphics.path,'/motivechaptercircles.svg'),'\','/')"/>
  </xsl:param>
  <xsl:param name="motiveprefacecolorbar">
    <xsl:value-of
      select="translate(concat($common.graphics.path,'/motiveprefacecolorbar.svg'),'\','/')"/>
  </xsl:param>

  <xsl:template match="processing-instruction('ftilde')">
    <xsl:text disable-output-escaping="yes">&#xFF5E;</xsl:text>
  </xsl:template>

  <!--   <xsl:template match="text()[ancestor::filename]" priority="100"> -->
  <!-- 	<xsl:value-of select="translate(.,'\','^')"/> -->
  <!--   </xsl:template> -->
  <xsl:template match="processing-instruction('hbr')" mode="titlepage.mode">
    <fo:block/>
  </xsl:template>
  <xsl:template match="processing-instruction('hbr')" mode="section.titlepage.recto.auto.mode">
    <fo:block/>
  </xsl:template>
  <xsl:template match="processing-instruction('hbr')" mode="section.titlepage.recto.mode">
    <fo:block/>
  </xsl:template>
  <xsl:template
    match="processing-instruction('hbr')[not(ancestor::citetitle) and not(ancestor::title)]">
    <fo:block/>
  </xsl:template>
  <xsl:template match="processing-instruction('hbr')" mode="motive.cover.mode">
    <fo:block/>
  </xsl:template>

  <xsl:template match="phrase[@role = 'keep-together.within-line']">
    <fo:inline keep-together.within-line="always">
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>

  <xsl:template
    match="text()[ contains(concat(';',ancestor::*/@security,';'),';internal;') ] | xref[ contains(concat(';',ancestor::*/@security,';'),';internal;') ]">
    <fo:wrapper xmlns:fo="http://www.w3.org/1999/XSL/Format" color="blue">
      <xsl:apply-imports/>
    </fo:wrapper>
  </xsl:template>
  <xsl:template
    match="text()[ contains(concat(';',ancestor::*/@security,';'),';writeronly;') ] | xref[ contains(concat(';',ancestor::*/@security,';'),';writeronly;') ]"
    priority="10">
    <fo:wrapper xmlns:fo="http://www.w3.org/1999/XSL/Format" color="red">
      <xsl:apply-imports/>
    </fo:wrapper>
  </xsl:template>
  <xsl:template
    match="text()[ contains(concat(';',ancestor::*/@security,';'),';reviewer;') ] | xref[ contains(concat(';',ancestor::*/@security,';'),';reviewer;') ]"
    priority="10">
    <fo:inline xmlns:fo="http://www.w3.org/1999/XSL/Format" background-color="yellow">
      <xsl:apply-imports/>
    </fo:inline>
  </xsl:template>
  <xsl:template
    match="text()[ ancestor::*/@role = 'highlight' ] | xref[ ancestor::*/@role = 'highlight' ]"
    priority="10">
    <fo:inline xmlns:fo="http://www.w3.org/1999/XSL/Format" background-color="yellow">
      <xsl:apply-imports/>
    </fo:inline>
  </xsl:template>

  <xsl:template name="document.status.bar">
    <fo:block-container reference-orientation="90" absolute-position="fixed" height="3in"
      width="11in" z-index="1">
      <fo:block padding-before=".45in" font-size="1.5em" color="gray" font-weight="bold">
        <fo:leader leader-pattern="use-content" leader-length="15in" letter-spacing=".1em">
          <xsl:text> </xsl:text>
          <xsl:value-of select="$motive.footer.text"/>
          <xsl:text> </xsl:text>
        </fo:leader>
      </fo:block>
    </fo:block-container>
  </xsl:template>


  <xsl:template name="table.layout">
    <xsl:param name="table.content"/>

    <xsl:choose>
      <xsl:when test="$xep.extensions = 0 or self::informaltable">
        <xsl:copy-of select="$table.content"/>
      </xsl:when>
      <xsl:otherwise>
        <fo:table rx:table-omit-initial-header="true" width="100%">
          <fo:table-header start-indent="0pt">
            <fo:table-row>
              <fo:table-cell>
                <fo:block xsl:use-attribute-sets="formal.title.properties">
                  <xsl:apply-templates select="." mode="object.title.markup"/>
                  <fo:inline font-style="italic">
                    <xsl:call-template name="gentext">
                      <xsl:with-param name="key" select="'continued'"/>
                    </xsl:call-template>
                  </fo:inline>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-header>
          <fo:table-body start-indent="0pt">
            <fo:table-row>
              <fo:table-cell>
                <xsl:copy-of select="$table.content"/>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-body>
        </fo:table>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:attribute-set name="table.properties">
    <xsl:attribute name="keep-together.within-column">auto</xsl:attribute>
  </xsl:attribute-set>


  <xsl:template match="glossseealso" mode="glossary.as.blocks">
    <xsl:variable name="otherterm" select="@otherterm"/>
    <xsl:variable name="targets" select="key('id', $otherterm)"/>
    <xsl:variable name="target" select="$targets[1]"/>

    <xsl:choose>
      <xsl:when test="$target">
        <fo:basic-link internal-destination="{$otherterm}" xsl:use-attribute-sets="xref.properties">
          <xsl:apply-templates select="$target" mode="xref-to"/>
        </fo:basic-link>
      </xsl:when>
      <xsl:when test="$otherterm != '' and not($target)">
        <xsl:message>
          <xsl:text>Warning: glossseealso @otherterm reference not found: </xsl:text>
          <xsl:value-of select="$otherterm"/>
        </xsl:message>
        <xsl:apply-templates mode="glossary.as.blocks"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates mode="glossary.as.blocks"/>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:choose>
      <xsl:when test="position() = last()"/>
      <xsl:otherwise>
        <xsl:call-template name="gentext.template">
          <xsl:with-param name="context" select="'glossary'"/>
          <xsl:with-param name="name" select="'seealso-separator'"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="glossentry/glosssee" mode="glossary.as.blocks">
    <xsl:variable name="otherterm" select="@otherterm"/>
    <xsl:variable name="targets" select="key('id', $otherterm)"/>
    <xsl:variable name="target" select="$targets[1]"/>

    <xsl:variable name="template">
      <xsl:call-template name="gentext.template">
        <xsl:with-param name="context" select="'glossary'"/>
        <xsl:with-param name="name" select="'see'"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="title">
      <xsl:choose>
        <xsl:when test="$target">
          <fo:basic-link internal-destination="{$otherterm}"
            xsl:use-attribute-sets="xref.properties">
            <xsl:apply-templates select="$target" mode="xref-to"/>
          </fo:basic-link>
        </xsl:when>
        <xsl:when test="$otherterm != '' and not($target)">
          <xsl:message>
            <xsl:text>Warning: glosssee @otherterm reference not found: </xsl:text>
            <xsl:value-of select="$otherterm"/>
          </xsl:message>
          <xsl:apply-templates mode="glossary.as.blocks"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates mode="glossary.as.blocks"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:call-template name="substitute-markup">
      <xsl:with-param name="template" select="$template"/>
      <xsl:with-param name="title" select="$title"/>
    </xsl:call-template>
  </xsl:template>


  <!-- From table.xsl: Fix in base xsls? -->
  <xsl:template name="calsTable">

    <xsl:variable name="keep.together">
      <xsl:call-template name="dbfo-attribute">
        <xsl:with-param name="pis" select="processing-instruction('dbfo')"/>
        <xsl:with-param name="attribute" select="'keep-together'"/>
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:for-each select="tgroup">
      
      <fo:table xsl:use-attribute-sets="table.table.properties">
        <xsl:if test="$keep.together != ''">
          <xsl:attribute name="keep-together.within-column">
            <xsl:value-of select="$keep.together"/>
          </xsl:attribute>
        </xsl:if>
        
        <xsl:call-template name="table.frame"/>
       
        <xsl:if test="following-sibling::tgroup">
          
          <xsl:attribute name="border-bottom-width">0pt</xsl:attribute>
          <xsl:attribute name="border-bottom-style">none</xsl:attribute>
          <xsl:attribute name="padding-bottom">0pt</xsl:attribute>
          <xsl:attribute name="margin-bottom">0pt</xsl:attribute>
          <xsl:attribute name="space-after">0pt</xsl:attribute>
          <xsl:attribute name="space-after.minimum">0pt</xsl:attribute>
          <xsl:attribute name="space-after.optimum">0pt</xsl:attribute>
          <xsl:attribute name="space-after.maximum">0pt</xsl:attribute>
          
        </xsl:if>
        <xsl:if test="preceding-sibling::tgroup">
         
          <xsl:attribute name="border-top-width">0.5pt</xsl:attribute>
          <xsl:attribute name="border-top-style">solid</xsl:attribute>
          <xsl:attribute name="padding-top">0pt</xsl:attribute>
          <xsl:attribute name="margin-top">0pt</xsl:attribute>
          <xsl:attribute name="space-before">0pt</xsl:attribute>
          <xsl:attribute name="space-before.minimum">0pt</xsl:attribute>
          <xsl:attribute name="space-before.optimum">0pt</xsl:attribute>
          <xsl:attribute name="space-before.maximum">0pt</xsl:attribute>
          
        </xsl:if>

        
        <xsl:apply-templates select="."/>
        

      </fo:table>
    </xsl:for-each>
  </xsl:template>

  <!-- From table.xsl -->
  <xsl:template match="thead">
    <xsl:variable name="tgroup" select="parent::*"/>
    
    <fo:table-header start-indent="0pt" end-indent="0pt" background-color="rgb(230,230,230)">
      <xsl:apply-templates select="row[1]">
        <xsl:with-param name="spans">
          <xsl:call-template name="blank.spans">
            <xsl:with-param name="cols" select="../@cols"/>
          </xsl:call-template>
        </xsl:with-param>
      </xsl:apply-templates>
    </fo:table-header>
    
  </xsl:template>

  <!-- from table.xsl to fix FOP bug where indexterm targets that are in table or informatable are duped for every tgroup -->

  <xsl:template match="entry|entrytbl" name="entry">
    <xsl:param name="col" select="1"/>
    <xsl:param name="spans"/>

    <xsl:variable name="row" select="parent::row"/>
    <xsl:variable name="group" select="$row/parent::*[1]"/>
    <xsl:variable name="frame" select="ancestor::tgroup/parent::*/@frame"/>

    <xsl:variable name="empty.cell" select="count(node()) = 0"/>

    <xsl:variable name="named.colnum">
      <xsl:call-template name="entry.colnum"/>
    </xsl:variable>

    <xsl:variable name="entry.colnum">
      <xsl:choose>
        <xsl:when test="$named.colnum &gt; 0">
          <xsl:value-of select="$named.colnum"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$col"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="entry.colspan">
      <xsl:choose>
        <xsl:when test="@spanname or @namest">
          <xsl:call-template name="calculate.colspan"/>
        </xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="following.spans">
      <xsl:call-template name="calculate.following.spans">
        <xsl:with-param name="colspan" select="$entry.colspan"/>
        <xsl:with-param name="spans" select="$spans"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="rowsep">
      <xsl:choose>
        <!-- If this is the last row, rowsep never applies. -->
        <xsl:when
          test="not(ancestor-or-self::row[1]/following-sibling::row
                          or ancestor-or-self::thead/following-sibling::tbody
                          or ancestor-or-self::tbody/preceding-sibling::tfoot)">
          <xsl:value-of select="0"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="inherited.table.attribute">
            <xsl:with-param name="entry" select="."/>
            <xsl:with-param name="colnum" select="$entry.colnum"/>
            <xsl:with-param name="attribute" select="'rowsep'"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!--
  <xsl:message><xsl:value-of select="."/>: <xsl:value-of select="$rowsep"/></xsl:message>
-->

    <xsl:variable name="colsep">
      <xsl:choose>
        <!-- If this is the last column, colsep never applies. -->
        <xsl:when test="$following.spans = ''">0</xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="inherited.table.attribute">
            <xsl:with-param name="entry" select="."/>
            <xsl:with-param name="colnum" select="$entry.colnum"/>
            <xsl:with-param name="attribute" select="'colsep'"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="valign">
      <xsl:call-template name="inherited.table.attribute">
        <xsl:with-param name="entry" select="."/>
        <xsl:with-param name="colnum" select="$entry.colnum"/>
        <xsl:with-param name="attribute" select="'valign'"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="align">
      <xsl:call-template name="inherited.table.attribute">
        <xsl:with-param name="entry" select="."/>
        <xsl:with-param name="colnum" select="$entry.colnum"/>
        <xsl:with-param name="attribute" select="'align'"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="char">
      <xsl:call-template name="inherited.table.attribute">
        <xsl:with-param name="entry" select="."/>
        <xsl:with-param name="colnum" select="$entry.colnum"/>
        <xsl:with-param name="attribute" select="'char'"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="charoff">
      <xsl:call-template name="inherited.table.attribute">
        <xsl:with-param name="entry" select="."/>
        <xsl:with-param name="colnum" select="$entry.colnum"/>
        <xsl:with-param name="attribute" select="'charoff'"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$spans != '' and not(starts-with($spans,'0:'))">
        <xsl:call-template name="entry">
          <xsl:with-param name="col" select="$col+1"/>
          <xsl:with-param name="spans" select="substring-after($spans,':')"/>
        </xsl:call-template>
      </xsl:when>

      <xsl:when test="number($entry.colnum) &gt; $col">
        <xsl:call-template name="empty.table.cell">
          <xsl:with-param name="colnum" select="$col"/>
        </xsl:call-template>
        <xsl:call-template name="entry">
          <xsl:with-param name="col" select="$col+1"/>
          <xsl:with-param name="spans" select="substring-after($spans,':')"/>
        </xsl:call-template>
      </xsl:when>

      <xsl:otherwise>
        <xsl:variable name="cell.content">
          <fo:block>
            <xsl:call-template name="table.cell.block.properties"/>

            <!-- are we missing any indexterms? -->
            <xsl:if
              test="not(preceding-sibling::entry)
                        and not(parent::row/preceding-sibling::row)">
              <!-- this is the first entry of the first row -->
              <xsl:if
                test="ancestor::thead or
                          (ancestor::tbody
                           and not(ancestor::tbody/preceding-sibling::thead
                                   or ancestor::tbody/preceding-sibling::tbody))">
                <!-- of the thead or the first tbody -->
                <xsl:if test="not(ancestor::tgroup/preceding-sibling::tgroup)">                                
                  <!-- of the first tgroup (added for JCBG-1654) -->
                 
                  <xsl:apply-templates select="ancestor::tgroup/preceding-sibling::indexterm"/>
     
                </xsl:if>
              </xsl:if>
            </xsl:if>

            <!--
          <xsl:text>(</xsl:text>
          <xsl:value-of select="$rowsep"/>
          <xsl:text>,</xsl:text>
          <xsl:value-of select="$colsep"/>
          <xsl:text>)</xsl:text>
          -->
            <xsl:choose>
              <xsl:when test="$empty.cell">
                <xsl:text>&#160;</xsl:text>
              </xsl:when>
              <xsl:when test="self::entrytbl">
                <xsl:variable name="prop-columns" select=".//colspec[contains(@colwidth, '*')]"/>
                <fo:table xsl:use-attribute-sets="table.table.properties">
                  <xsl:if test="count($prop-columns) != 0">
                    <xsl:attribute name="table-layout">fixed</xsl:attribute>
                  </xsl:if>
                  <xsl:call-template name="tgroup"/>
                </fo:table>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates/>
              </xsl:otherwise>
            </xsl:choose>
          </fo:block>
        </xsl:variable>

        <xsl:variable name="cell-orientation">
          <xsl:call-template name="dbfo-attribute">
            <xsl:with-param name="pis"
              select="ancestor-or-self::entry/processing-instruction('dbfo')"/>
            <xsl:with-param name="attribute" select="'orientation'"/>
          </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="row-orientation">
          <xsl:call-template name="dbfo-attribute">
            <xsl:with-param name="pis" select="ancestor-or-self::row/processing-instruction('dbfo')"/>
            <xsl:with-param name="attribute" select="'orientation'"/>
          </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="cell-width">
          <xsl:call-template name="dbfo-attribute">
            <xsl:with-param name="pis"
              select="ancestor-or-self::entry/processing-instruction('dbfo')"/>
            <xsl:with-param name="attribute" select="'rotated-width'"/>
          </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="row-width">
          <xsl:call-template name="dbfo-attribute">
            <xsl:with-param name="pis" select="ancestor-or-self::row/processing-instruction('dbfo')"/>
            <xsl:with-param name="attribute" select="'rotated-width'"/>
          </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="orientation">
          <xsl:choose>
            <xsl:when test="$cell-orientation != ''">
              <xsl:value-of select="$cell-orientation"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$row-orientation"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <xsl:variable name="rotated-width">
          <xsl:choose>
            <xsl:when test="$cell-width != ''">
              <xsl:value-of select="$cell-width"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$row-width"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <xsl:variable name="bgcolor">
          <xsl:call-template name="dbfo-attribute">
            <xsl:with-param name="pis"
              select="ancestor-or-self::entry/processing-instruction('dbfo')"/>
            <xsl:with-param name="attribute" select="'bgcolor'"/>
          </xsl:call-template>
        </xsl:variable>

        <fo:table-cell xsl:use-attribute-sets="table.cell.padding">
          <xsl:call-template name="table.cell.properties">
            <xsl:with-param name="bgcolor.pi" select="$bgcolor"/>
            <xsl:with-param name="rowsep.inherit" select="$rowsep"/>
            <xsl:with-param name="colsep.inherit" select="$colsep"/>
            <xsl:with-param name="col" select="$col"/>
            <xsl:with-param name="valign.inherit" select="$valign"/>
            <xsl:with-param name="align.inherit" select="$align"/>
            <xsl:with-param name="char.inherit" select="$char"/>
          </xsl:call-template>

          <xsl:call-template name="anchor"/>

          <xsl:if test="@morerows">
            <xsl:attribute name="number-rows-spanned">
              <xsl:value-of select="@morerows+1"/>
            </xsl:attribute>
          </xsl:if>

          <xsl:if test="$entry.colspan &gt; 1">
            <xsl:attribute name="number-columns-spanned">
              <xsl:value-of select="$entry.colspan"/>
            </xsl:attribute>
          </xsl:if>

          <!--
        <xsl:if test="@charoff">
          <xsl:attribute name="charoff">
            <xsl:value-of select="@charoff"/>
          </xsl:attribute>
        </xsl:if>
-->

          <xsl:choose>
            <xsl:when
              test="$fop.extensions = 0 and $passivetex.extensions = 0
                          and $orientation != ''">
              <fo:block-container reference-orientation="{$orientation}">
                <xsl:if test="$rotated-width != ''">
                  <xsl:attribute name="width">
                    <xsl:value-of select="$rotated-width"/>
                  </xsl:attribute>
                </xsl:if>
                <xsl:copy-of select="$cell.content"/>
              </fo:block-container>
            </xsl:when>
            <xsl:otherwise>
              <xsl:copy-of select="$cell.content"/>
            </xsl:otherwise>
          </xsl:choose>
        </fo:table-cell>

        <xsl:choose>
          <xsl:when test="following-sibling::entry|following-sibling::entrytbl">
            <xsl:apply-templates
              select="(following-sibling::entry
                                       |following-sibling::entrytbl)[1]">
              <xsl:with-param name="col" select="$col+$entry.colspan"/>
              <xsl:with-param name="spans" select="$following.spans"/>
            </xsl:apply-templates>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="finaltd">
              <xsl:with-param name="spans" select="$following.spans"/>
              <xsl:with-param name="col" select="$col+$entry.colspan"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>



  <!-- for jcbg-786, updated text below from 'Motive - Internal' to Alcatel-Lucent - Internal -->
  <xsl:param name="internal-proprietary">
    <xsl:if test="not($security = 'external') or $nda.footer = 'true'">
      <fo:block text-align="center" font-size=".75em" font-family="Times"
        space-before.optimum="0.6em">
        <fo:block>Alcatel-Lucent &#8212; Internal</fo:block>
        <fo:block>Proprietary &#8212; Use pursuant to Company instruction</fo:block>
      </fo:block>
    </xsl:if>
  </xsl:param>

</xsl:stylesheet>
