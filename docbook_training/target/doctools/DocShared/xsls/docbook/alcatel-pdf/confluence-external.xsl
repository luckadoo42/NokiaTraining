<!DOCTYPE xsl:stylesheet>
<!-- 
Scenarios:

TODO:
 * Create wrappers for different formats:
  * Wrapper sets param, then main xslt munges
  * motive-pdf as release notes: no cover? Leave as <article> and adjust base xslts to do article w/o cover.
  * motive-pdf as book: cover, toc, etc. Preprocess into a book and first level sections into chapters.
  * alcatel-pdf: Only as book for now?
  * html: 
 -->

<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:ng="http://docbook.org/docbook-ng"
  xmlns:db="http://docbook.org/ns/docbook"
  xmlns:d="http://docbook.org/ns/docbook"
  xmlns:exsl="http://exslt.org/common"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:rx="http://www.renderx.com/XSL/Extensions"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  exclude-result-prefixes="db ng exsl d xlink"
  version='1.0'>

  <xsl:import href="../common/stripns.xsl"/>
  <xsl:import href="fo.xsl"/>

  <xsl:key name="category" match="category" use="."/>

  <xsl:param name="security">external</xsl:param>
  <xsl:param name="admon.graphics.path">../../../content/enus/commonimages/BroadJump/alcatel/</xsl:param>
  <xsl:param name="debug">1</xsl:param>
  <xsl:param name="generate.toc">
	article   toc,title
	book      toc,title,figure,table,example,equation
  </xsl:param>

  <xsl:output indent="no"/>

<xsl:param name="toc.section.depth">4</xsl:param>

  <xsl:param name="allowed-metadata">copyright+year;title;productnumber;releaseinfo;edition;pubdate;productname;productversion;invpartnumber</xsl:param>

  <xsl:param name="metadata">
	<xsl:for-each select="//d:para[@role = 'scroll-error' and parent::d:article]/text()[normalize-space(.) != '']">
	  <xsl:if test="contains(concat(';',$allowed-metadata,';'),concat(';',normalize-space(substring-before(.,':')),';')) and not(normalize-space(substring-after(.,':')) = '')">
		<!-- 
		productnuber
		releaseinfo
		edition
		pubdate
		productname
		productversion
		invpartnumber
		-->
		<xsl:call-template name="unpack-element">
		  <xsl:with-param name="element" select="normalize-space(substring-before(.,':'))"/>
		  <xsl:with-param name="content" select="normalize-space(substring-after(.,':'))"/>
		</xsl:call-template>
	  </xsl:if>
	</xsl:for-each>
  </xsl:param>

  <xsl:template name="unpack-element">
	<xsl:param name="element"/>
	<xsl:param name="content"/>
	<xsl:choose>
	  <xsl:when test="contains($element,'+')">
		<xsl:element name="{substring-before($element,'+')}">
		  <xsl:call-template name="unpack-element">
			<xsl:with-param name="element" select="substring-after($element,'+')"/>
			<xsl:with-param name="content" select="$content"/>
		  </xsl:call-template>
		</xsl:element><xsl:text>
		</xsl:text>
	  </xsl:when>
	  <xsl:otherwise>
		<xsl:element name="{$element}">
		  <xsl:value-of select="$content"/>
		</xsl:element><xsl:text>
		</xsl:text>
	  </xsl:otherwise>
	</xsl:choose>
  </xsl:template>

  <xsl:param name="copyright-year">
	<xsl:choose>
	  <xsl:when test="normalize-space(exsl:node-set($metadata)//copyright/year) != ''"><xsl:value-of select="normalize-space(exsl:node-set($metadata)//copyright/year)"/></xsl:when>
	  <xsl:when test="contains(normalize-space(exsl:node-set($metadata)//pubdate), ' ') != ''"><xsl:value-of select="substring-after(normalize-space(exsl:node-set($metadata)//pubdate), ' ')"/></xsl:when>
	  <xsl:when test="normalize-space(exsl:node-set($metadata)//pubdate) "><xsl:value-of select="normalize-space(exsl:node-set($metadata)//pubdate)"/></xsl:when>
	  <!-- This should work with Xalan, but doesn't: -->
	  <!--xsl:otherwise>
		<xsl:call-template name="datetime.format">  
		  <xsl:with-param name="date" select="date:date-time()" xmlns:date="http://exslt.org/dates-and-times"/>  
		  <xsl:with-param name="format" select="'Y'"/>  
		</xsl:call-template>
	  </xsl:otherwise-->
	</xsl:choose>
  </xsl:param>

  <xsl:template match="/">
	<xsl:choose>
	  <!-- include extra test for Xalan quirk -->
	  <xsl:when test="(function-available('exsl:node-set') or
		contains(system-property('xsl:vendor'),
		'Apache Software Foundation'))
		and (*/self::ng:* or */self::db:* or */self::d:*)">
		<!-- DWC: Adding support for d:* namespace prefix -->
		<!-- Hack! If someone hands us a DocBook V5.x or DocBook NG document,
		toss the namespace and continue. Someday we'll reverse this logic
		and add the namespace to documents that don't have one.
		But not before the whole stylesheet has been converted to use
		namespaces. i.e., don't hold your breath -->
		<xsl:message>Stripping namespace from DocBook 5 document.</xsl:message>

		<xsl:variable name="nons">
		  <xsl:apply-templates mode="stripNS"/>
		</xsl:variable>
		
		<xsl:if test="$debug != '0'">
		  <xsl:call-template name="write.chunk">
			<xsl:with-param name="filename">01.nons.xml</xsl:with-param>
			<xsl:with-param name="content">
			  <xsl:copy-of select="$nons"/>
			</xsl:with-param>
		  </xsl:call-template>
		</xsl:if>

		<!-- First we remove the namespace prefix. -->
		<xsl:variable name="releasenotes-tables-filtered">
		  <xsl:apply-templates select="exsl:node-set($nons)" mode="filter-releasenotes-tables"/>
		</xsl:variable>

		<xsl:if test="$debug != '0'">
		  <xsl:call-template name="write.chunk">
			<xsl:with-param name="filename">02.releasenotes-tables-filtered.xml</xsl:with-param>
			<xsl:with-param name="content">
			  <xsl:copy-of select="$releasenotes-tables-filtered"/>
			</xsl:with-param>
		  </xsl:call-template>
		</xsl:if>

		<!-- Now we categorize the release notes tables -->
		<xsl:variable name="releasenotes-tables-categorized">
		  <xsl:apply-templates select="exsl:node-set($releasenotes-tables-filtered)" mode="categorize-releasenotes-tables"/>
		</xsl:variable>

		<xsl:if test="$debug != '0'">
		  <xsl:call-template name="write.chunk">
			<xsl:with-param name="filename">03.releasenotes-tables-categorized.xml</xsl:with-param>
			<xsl:with-param name="content">
			  <xsl:copy-of select="$releasenotes-tables-categorized"/>
			</xsl:with-param>
		  </xsl:call-template>
		</xsl:if>
		<!-- Now process doc with regular templates -->
		<xsl:apply-templates select="exsl:node-set($releasenotes-tables-categorized)"/>
	  </xsl:when>

	  <!-- Can't process unless namespace removed -->
	  <xsl:when test="*/self::ng:* or */self::d:* or */self::db:*">
		<xsl:message terminate="yes">
		  <xsl:text>Unable to strip the namespace from DB5 document,</xsl:text>
		  <xsl:text> cannot proceed.</xsl:text>
		</xsl:message>
	  </xsl:when>
	  <xsl:otherwise>
		<!-- Really process doc without stripping ns. -->
		<!-- Normal stuff from DocBook xsls -->
		<xsl:choose>
		  <xsl:when test="$rootid != ''">
			<xsl:variable name="root.element" select="key('id', $rootid)"/>
			<xsl:choose>
			  <xsl:when test="count($root.element) = 0">
				<xsl:message terminate="yes">
				  <xsl:text>ID '</xsl:text>
				  <xsl:value-of select="$rootid"/>
				  <xsl:text>' not found in document.</xsl:text>
				</xsl:message>
			  </xsl:when>
			  <xsl:when test="not(contains($root.elements, concat(' ', local-name($root.element), ' ')))">
				<xsl:message terminate="yes">
				  <xsl:text>ERROR: Document root element ($rootid=</xsl:text>
				  <xsl:value-of select="$rootid"/>
				  <xsl:text>) for FO output </xsl:text>
				  <xsl:text>must be one of the following elements:</xsl:text>
				  <xsl:value-of select="$root.elements"/>
				</xsl:message>
			  </xsl:when>
			  <!-- Otherwise proceed -->
			  <xsl:otherwise>
				<xsl:if test="$collect.xref.targets = 'yes' or
				  $collect.xref.targets = 'only'">
				  <xsl:apply-templates select="$root.element"
					mode="collect.targets"/>
				</xsl:if>
				<xsl:if test="$collect.xref.targets != 'only'">
				  <xsl:apply-templates select="$root.element"
					mode="process.root"/>
				</xsl:if>
			  </xsl:otherwise>
			</xsl:choose>
		  </xsl:when>
		  <!-- Otherwise process the document root element -->
		  <xsl:otherwise>
			<xsl:variable name="document.element" select="*[1]"/>
			<xsl:choose>
			  <xsl:when test="not(contains($root.elements,
				concat(' ', local-name($document.element), ' ')))">
				<xsl:message terminate="yes">
				  <xsl:text>ERROR: Document root element for FO output </xsl:text>
				  <xsl:text>must be one of the following elements:</xsl:text>
				  <xsl:value-of select="$root.elements"/>
				</xsl:message>
			  </xsl:when>
			  <!-- Otherwise proceed -->
			  <xsl:otherwise>
				<xsl:if test="$collect.xref.targets = 'yes' or
				  $collect.xref.targets = 'only'">
				  <xsl:apply-templates select="/"
					mode="collect.targets"/>
				</xsl:if>
				<xsl:if test="$collect.xref.targets != 'only'">
				  <xsl:apply-templates select="/"
					mode="process.root"/>
				</xsl:if>
			  </xsl:otherwise>
			</xsl:choose>
		  </xsl:otherwise>
		</xsl:choose>
	  </xsl:otherwise>
	</xsl:choose>
  </xsl:template>

  <xsl:template match="d:itemizedlist[parent::d:article and normalize-space(.) = '']" mode="stripNS">
	<!-- nuke  -->
  </xsl:template>


  <xsl:template match="articleinfo|bookinfo" mode="filter-releasenotes-tables">
	<xsl:copy>
	<xsl:apply-templates select="@*|node()"  mode="filter-releasenotes-tables"/>
	  <xsl:copy-of select="$metadata"/>
	</xsl:copy>
  </xsl:template>

  <xsl:template match="*[@role = 'scroll-error' and parent::article]" mode="filter-releasenotes-tables"/>

  <xsl:template match="row" mode="filter-releasenotes-tables">
	<xsl:choose>
	  <xsl:when test="(normalize-space(entry[5]) = 'Internal' and $security = 'external') or normalize-space(entry[5]) = '&#160;' "/>
	  <xsl:otherwise>
		<xsl:copy>
		  <xsl:apply-templates select="@*|node()"  mode="filter-releasenotes-tables"/>
		</xsl:copy>
	  </xsl:otherwise>
	</xsl:choose>
  </xsl:template>

  <xsl:template match="entry[4][normalize-space(.) = '&#160;']" mode="filter-releasenotes-tables">
	<entry><para>Miscellaneous</para></entry>
  </xsl:template>

  <xsl:template match="@*|node()" mode="filter-releasenotes-tables">
	<xsl:copy>
	  <xsl:apply-templates select="@*|node()"  mode="filter-releasenotes-tables"/>
	</xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()" mode="categorize-releasenotes-tables">
	<xsl:copy>
	  <xsl:apply-templates select="@*|node()"  mode="categorize-releasenotes-tables"/>
	</xsl:copy>
  </xsl:template>

  <xsl:template match="emphasis[@role='strong']" mode="categorize-releasenotes-tables">
	<emphasis role="bold"><xsl:apply-templates/></emphasis>
  </xsl:template>

  <xsl:template match="informaltable" mode="categorize-releasenotes-tables">
	<xsl:choose>
	  <xsl:when test="tgroup/@cols = '6' and (tgroup/thead/row/entry[1]/para = 'Known ID' or tgroup/thead/row/entry[1]/para = 'Resolved ID') and tgroup/thead/row/entry[2]/para = 'Title' and tgroup/thead/row/entry[3]/para = 'Description' and tgroup/thead/row/entry[4]/para = 'Category' and tgroup/thead/row/entry[5]/para = 'Audience' and tgroup/thead/row/entry[6]/para = 'Status' ">
	<xsl:variable name="original-table">
	  <xsl:copy-of select="node()"/>
	</xsl:variable>
	<xsl:variable name="context-section">
		  <xsl:choose>
			<xsl:when test="tgroup/thead/row/entry[1]/para = 'Resolved ID'">RESOLVED ISSUES</xsl:when>
			<xsl:otherwise>KNOWN ISSUES</xsl:otherwise>
		  </xsl:choose>
		  <!--xsl:value-of select="translate(normalize-space(ancestor::section[1]/title),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/-->
	</xsl:variable>
	<xsl:variable name="cols">
	  <xsl:choose>
		<xsl:when test="$context-section = 'KNOWN ISSUES'">3</xsl:when>
		<xsl:otherwise>2</xsl:otherwise>
	  </xsl:choose>
	</xsl:variable>
	<xsl:variable name="categories">
	  <xsl:for-each select="tgroup/tbody/row/entry[4]">
			<category><xsl:value-of select="normalize-space(.)"/></category>
	  </xsl:for-each>
	</xsl:variable>

	<xsl:variable name="categories-unique">
	  <xsl:for-each select="exsl:node-set($categories)//category[generate-id() = generate-id(key('category',.)[1])]">
		<xsl:sort/>
		<category>
		  <xsl:copy-of select="normalize-space(.)"/>
		</category>
	  </xsl:for-each>
	</xsl:variable>
	<!-- Categorize -->
	<informaltable rowsep="1" colsep="1" pgwide="1">
	  <xsl:for-each select="exsl:node-set($categories-unique)/node()">
		<xsl:message>
		  ------------------
		  Processing category: <xsl:value-of select="."/> (<xsl:value-of select="$context-section"/>)
		  ------------------
		</xsl:message>
		<tgroup cols="{$cols}" rowsep="1" colsep="1">
		  <colspec colname="col1" colnum="1" colwidth="1in"/>
		  <colspec colname="col2" colnum="2">
			<xsl:attribute name="colwidth">
			  <xsl:choose>
				<xsl:when test="$context-section = 'KNOWN ISSUES'">2in</xsl:when>
				<xsl:otherwise>5in</xsl:otherwise>
			  </xsl:choose>
			</xsl:attribute>
		  </colspec>
		  <xsl:if test="$context-section = 'KNOWN ISSUES'">
			<colspec colname="col3" colnum="3" colwidth="3in"/>
		  </xsl:if>
		  <thead>
			<xsl:if test="position() = 1">
			<row>
			  <entry rowsep="1">ID</entry>
			  <entry rowsep="1">Title</entry>
			  <xsl:if test="$context-section = 'KNOWN ISSUES'">
				<entry rowsep="1">Description</entry>
			  </xsl:if>
			</row>
			</xsl:if>
			<xsl:if test="count(exsl:node-set($categories-unique)/node()) &gt; 1">
			  <row>
				<entry rowsep="1" namest="col1" nameend="col{$cols}">
				  <xsl:choose>
					<xsl:when test="normalize-space(.) = '' or normalize-space(.) = '&#160;'">Miscellaneous</xsl:when>
					<xsl:otherwise><xsl:value-of select="normalize-space(.)"/></xsl:otherwise>
				  </xsl:choose>
				</entry>
			  </row>
			</xsl:if>
		  </thead>
		  <tbody>
			<xsl:apply-templates select="exsl:node-set($original-table)//tbody/row" mode="categorize-releasenotes-tables">
			  <xsl:with-param name="category"><xsl:value-of select="."/></xsl:with-param>
			  <xsl:with-param name="cols" select="$cols"/>
			  <xsl:sort select="entry[1]"/>
			</xsl:apply-templates>
		  </tbody>
		</tgroup>			
	  </xsl:for-each>
	</informaltable>
	  </xsl:when>
	  <xsl:otherwise>
		<xsl:copy-of select="."/>
	  </xsl:otherwise>
	</xsl:choose>
  </xsl:template>

  <xsl:template match="article"  mode="categorize-releasenotes-tables">
	<article>
	  <xsl:choose>
		<xsl:when test="exsl:node-set($metadata)//title"><xsl:copy-of select="exsl:node-set($metadata)//title[1]"/></xsl:when>
		<xsl:otherwise><xsl:copy-of select="./articleinfo/title"/></xsl:otherwise>
	  </xsl:choose>
	  <xsl:apply-templates mode="categorize-releasenotes-tables"/>
	</article>
  </xsl:template>

  <xsl:template match="articleinfo/title|articleinfo/authorgroup"  mode="categorize-releasenotes-tables"/>

  <xsl:template match="row"  mode="categorize-releasenotes-tables">
	<xsl:param name="category"/>
	<xsl:param name="cols"/>
	<xsl:variable name="this-row-security">
	  <xsl:choose>
		<xsl:when test="normalize-space(entry[5]) = 'Internal'">internal</xsl:when>
		<xsl:otherwise>external</xsl:otherwise>
	  </xsl:choose>	  
	</xsl:variable>
	<xsl:if test="normalize-space(entry[4]) = normalize-space($category) and ($this-row-security = 'external' or $this-row-security = $security)">
	  <row security="{$this-row-security}">
		<xsl:choose>
		  <xsl:when test="$security = 'external'">
			<entry rowsep="1">
			  <xsl:value-of select="entry[1]"/>
			</entry>
		  </xsl:when>
		  <xsl:otherwise>
			<entry rowsep="1">
			  <para>
				<ulink xrefstyle="ulink.hide" url="{entry[1]/para/ulink/@url}"><xsl:value-of select="./entry[1]/para/ulink"/></ulink>
			  </para>
			</entry>
		  </xsl:otherwise>
		</xsl:choose>
		<entry rowsep="1">
		  <xsl:value-of select="entry[2]"/>
		</entry>
		<xsl:apply-templates select="entry[position() &gt; 2 and position() &lt; $cols + 1]" mode="categorize-releasenotes-tables"/>
	  </row>
	</xsl:if>
  </xsl:template>
  

<xsl:template match="*" mode="process.root">
  <xsl:variable name="document.element" select="self::*"/>

  <xsl:call-template name="root.messages"/>

  <xsl:variable name="title">
    <xsl:choose>
      <xsl:when test="$document.element/title[1]">
        <xsl:value-of select="$document.element/title[1]"/>
      </xsl:when>
      <xsl:otherwise>[could not find document title]</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <!-- Include all id values in XEP output -->
  <xsl:if test="$xep.extensions != 0">
    <xsl:processing-instruction 
     name="xep-pdf-drop-unused-destinations">false</xsl:processing-instruction>
  </xsl:if>

  <fo:root xsl:use-attribute-sets="root.properties">
    <xsl:attribute name="language">
      <xsl:call-template name="l10n.language">
        <xsl:with-param name="target" select="/*[1]"/>
      </xsl:call-template>
    </xsl:attribute>

    <xsl:if test="$xep.extensions != 0">
      <xsl:call-template name="xep-pis"/>
      <xsl:call-template name="xep-document-information"/>
    </xsl:if>
    <xsl:if test="$axf.extensions != 0">
      <xsl:call-template name="axf-document-information"/>
    </xsl:if>

    <xsl:call-template name="setup.pagemasters"/>

    <xsl:if test="$fop.extensions != 0">
      <xsl:apply-templates select="$document.element" mode="fop.outline"/>
    </xsl:if>

    <xsl:if test="$fop1.extensions != 0">
      <xsl:variable name="bookmarks">
        <xsl:apply-templates select="$document.element" 
                             mode="fop1.outline"/>
      </xsl:variable>
      <xsl:if test="string($bookmarks) != ''">
        <fo:bookmark-tree>
          <xsl:copy-of select="$bookmarks"/>
        </fo:bookmark-tree>
      </xsl:if>
    </xsl:if>

    <xsl:if test="$xep.extensions != 0">
      <xsl:variable name="bookmarks">
        <xsl:apply-templates select="$document.element" mode="xep.outline"/>
      </xsl:variable>
      <xsl:if test="string($bookmarks) != ''">
        <rx:outline xmlns:rx="http://www.renderx.com/XSL/Extensions">
          <xsl:copy-of select="$bookmarks"/>
        </rx:outline>
      </xsl:if>
    </xsl:if>

    <xsl:if test="$arbortext.extensions != 0 and $ati.xsl11.bookmarks != 0">
      <xsl:variable name="bookmarks">
        <xsl:apply-templates select="$document.element"
                             mode="ati.xsl11.bookmarks"/>
      </xsl:variable>
      <xsl:if test="string($bookmarks) != ''">
        <fo:bookmark-tree>
          <xsl:copy-of select="$bookmarks"/>
        </fo:bookmark-tree>
      </xsl:if>
    </xsl:if>

	  <!-- Here we emit the cover for articles -->
	  <fo:page-sequence
		id="cover"
		hyphenate="false"
		master-reference="titlepage-first"
		force-page-count="no-force">
		<fo:flow flow-name="xsl-region-body" start-indent="0pc" end-indent="0pt">
		  <fo:block>
			<fo:block>
			  <fo:block>
				<fo:block-container absolute-position="fixed" left="0pt" top="0pt" z-index="-1">
				  <fo:block>
					<fo:external-graphic src="url({$admon.graphics.path}cover.pdf)"/>
				  </fo:block>
				</fo:block-container>
				<fo:block-container absolute-position="fixed" left="1in" top="2in" z-index="1">
				  <fo:block font-weight="bold" xsl:use-attribute-sets="book.titlepage.recto.style"  text-align="left" font-size="15pt" letter-spacing=".25em" font-family="Trebuchet">
					<xsl:call-template name="string.upper">
					  <xsl:with-param name="string"><xsl:value-of select="//article/title[1]"/></xsl:with-param>
					</xsl:call-template>
				  </fo:block>
				</fo:block-container>
				<fo:block-container absolute-position="fixed" left="1in" top="7in" z-index="1">
				  <fo:block xsl:use-attribute-sets="book.titlepage.recto.style" text-align="left" font-size="30pt" font-weight="normal" font-family="Trebuchet">
					<xsl:value-of select="exsl:node-set($metadata)//productnumber"/>
				  </fo:block>
				  <fo:block xsl:use-attribute-sets="book.titlepage.recto.style" text-align="left" space-before="-.1em" font-size="16pt" font-weight="normal" font-family="Trebuchet">
					<xsl:call-template name="string.upper">
					  <xsl:with-param name="string"><xsl:value-of select="exsl:node-set($metadata)//productname"/></xsl:with-param>
					</xsl:call-template>
					<xsl:if test="exsl:node-set($metadata)//releaseinfo"><xsl:text> | </xsl:text>
					  <xsl:call-template name="string.upper">
						<xsl:with-param name="string"><xsl:value-of select="exsl:node-set($metadata)//releaseinfo"/></xsl:with-param>
					  </xsl:call-template>
					</xsl:if>					
				  </fo:block>
				  <fo:block xsl:use-attribute-sets="book.titlepage.recto.style"  text-align="left" font-size="12pt" font-weight="normal" font-family="Trebuchet">
					<xsl:value-of select="exsl:node-set($metadata)//invpartnumber"/>, <xsl:if test="not(starts-with(normalize-space(translate(exsl:node-set($metadata)//edition,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')), 'EDITION'))">Edition </xsl:if><xsl:value-of select="exsl:node-set($metadata)//edition"/>
				  </fo:block>
				  <fo:block margin-right="1in" space-before="2em" text-align="left" font-size="9pt" font-weight="normal" font-family="Trebuchet">
					<fo:block space-before="1em">IMPORTANT NOTICE: This document contains confidential information that is proprietary to Alcatel-Lucent. No part of its contents may be used, copied, disclosed or conveyed to any party in any manner whatsoever without prior written permission from Alcatel-Lucent.</fo:block>
					<fo:block space-before="1em">www.alcatel-lucent.com</fo:block>
					<fo:block space-before="1em">Alcatel, Lucent, Alcatel-Lucent, and the Alcatel-Lucent logo are registered trademarks of Alcatel-Lucent. All other trademarks are the property of their respective owners. The information presented is subject to change without notice. Alcatel-Lucent assumes no responsibility for inaccuracies contained herein. &#169; <xsl:value-of select="$copyright-year"/> Alcatel-Lucent. All rights reserved.</fo:block>
				  </fo:block>
				  <fo:block space-before="2em" font-size="8pt" margin-right="3in">
					<fo:block font-weight="bold">Alcatel-Lucent Proprietary</fo:block>
					<fo:block font-weight="bold">This document contains propritary information of Alcatel-Lucent and is not to be disclosed or used except in accordance with applicable agreements. </fo:block>
					<fo:block font-weight="bold">Copyright &#169; <xsl:value-of select="$copyright-year"/> Alcatel-Lucent. All rights reserved.</fo:block>
					<!-- TODO: Put copyright stuff here and Internal if applicable -->
				  </fo:block>
				</fo:block-container>
				<fo:block break-after="page"/>
			  </fo:block>
			</fo:block>
		  </fo:block>
		</fo:flow>
	  </fo:page-sequence>

    <xsl:apply-templates select="$document.element"/>
  </fo:root>
</xsl:template>

  <xsl:template xmlns:xlink="http://www.w3.org/1999/xlink" match="xref[@xlink:href]" mode="filter-releasenotes-tables">
	<ulink url="{@xlink:href}"><xsl:value-of select="."/></ulink>
  </xsl:template>

  <xsl:template match="ulink[starts-with(@url,'mailto:')]" mode="filter-releasenotes-tables">
	<email><xsl:value-of select="."/></email>
  </xsl:template> 

<xsl:template match="programlisting|screen|synopsis">
  <xsl:param name="suppress-numbers" select="'0'"/>
  <xsl:variable name="id"><xsl:call-template name="object.id"/></xsl:variable>

  <xsl:variable name="content">
    <xsl:choose>
      <xsl:when test="$suppress-numbers = '0'
                      and @linenumbering = 'numbered'
                      and $use.extensions != '0'
                      and $linenumbering.extension != '0'">
        <xsl:call-template name="number.rtf.lines">
          <xsl:with-param name="rtf">
	    <xsl:call-template name="apply-highlighting"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<xsl:call-template name="apply-highlighting"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$shade.verbatim != 0">
      <fo:block id="{$id}"
                xsl:use-attribute-sets="monospace.verbatim.properties shade.verbatim.style">
        <xsl:choose>
          <xsl:when test="$hyphenate.verbatim != 0 and function-available('exsl:node-set')">
            <xsl:apply-templates select="exsl:node-set($content)" mode="hyphenate.verbatim"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy-of select="$content"/>
          </xsl:otherwise>
        </xsl:choose>
      </fo:block>
    </xsl:when>
    <xsl:otherwise>
      <fo:block id="{$id}"
                xsl:use-attribute-sets="monospace.verbatim.properties">
        <xsl:choose>
          <xsl:when test="$hyphenate.verbatim != 0 "><!-- DWC: Removing "and function-available('exsl:node-set')" from this test to work around Xalan bug. -->
            <xsl:apply-templates select="exsl:node-set($content)" mode="hyphenate.verbatim"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy-of select="$content"/>
          </xsl:otherwise>
        </xsl:choose>
      </fo:block>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- Overriding this template from fo.xsl so we get a good toc when we start with an article -->
<xsl:template name="component.toc">
  <xsl:param name="toc-context" select="."/>
  <xsl:param name="toc.title.p" select="true()"/>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="cid">
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="$toc-context"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="nodes" select="section|sect1|refentry
                                     |article|bibliography|glossary
                                     |appendix|index"/>

  <xsl:if test="$nodes">
    <fo:block id="toc...{$id}"
              xsl:use-attribute-sets="toc.margin.properties">
      <xsl:if test="$toc.title.p">
        <xsl:call-template name="table.of.contents.titlepage"/>
      </xsl:if>

      <xsl:apply-templates select="$nodes" mode="toc">
        <xsl:with-param name="toc-context" select="$toc-context"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
