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
  <xsl:import href="main.xsl"/>

  <xsl:key name="category" match="category" use="."/>

  <!-- TODO: Customize these for Scroll Wiki -->
  <xsl:param name="cover.path">../../../content/enus/commonimages/BroadJump/motivecover.svg</xsl:param>
  <xsl:param name="motive.component.cover.path">../../../content/enus/commonimages/BroadJump/motive.chapter.cover.svg</xsl:param>
  <xsl:param name="callout.graphics.path" select="'../common/'"/>
  <xsl:param name="debug">1</xsl:param>

  <xsl:param name="security">external</xsl:param>
  <xsl:output indent="no"/>

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
		<xsl:message>Stripping namespace from DocBook 5 document. </xsl:message>

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
		<xsl:message>No need to strip namespaces.</xsl:message>
		<xsl:message>
		  <xsl:text>Making </xsl:text>
		  <xsl:value-of select="$page.orientation"/>
		  <xsl:text> pages on </xsl:text>
		  <xsl:value-of select="$paper.type"/>
		  <xsl:text> paper (</xsl:text>
		  <xsl:value-of select="$page.width"/>
		  <xsl:text>x</xsl:text>
		  <xsl:value-of select="$page.height"/>
		  <xsl:text>)</xsl:text>
		</xsl:message>
		<xsl:variable name="document.element" select="*[1]"/>
		<xsl:variable name="title">
		  <xsl:choose>
			<xsl:when test="$rootid != ''">
			  <xsl:apply-templates select="id($rootid)/title[1]"  mode="motive.cover.mode"/>
			</xsl:when>
			<xsl:when test="$document.element/title[1]">
			  <xsl:apply-templates select="$document.element/title[1]"  mode="motive.cover.mode"/>
			</xsl:when>
			<xsl:otherwise>[could not find document title]</xsl:otherwise>
		  </xsl:choose>
		</xsl:variable>
		<fo:root font-family="{$body.font.family}"
		  font-size="{$body.font.size}"
		  text-align="{$alignment}">
		  <xsl:if test="$xep.extensions != 0">
			<xsl:call-template name="xep-document-information"/>
		  </xsl:if>
		  <xsl:call-template name="setup.pagemasters"/>
		  <xsl:choose>
			<xsl:when test="$rootid != ''">
			  <xsl:choose>
				<xsl:when test="count(id($rootid)) = 0">
				  <xsl:message terminate="yes">
					<xsl:text>ID '</xsl:text>
					<xsl:value-of select="$rootid"/>
					<xsl:text>' not found in document.</xsl:text>
				  </xsl:message>
				</xsl:when>
				<xsl:otherwise>
				  <xsl:if test="$fop.extensions != 0">
					<xsl:apply-templates select="id($rootid)" mode="outline"/>
				  </xsl:if>
				  <xsl:if test="$xep.extensions != 0 and (//chapter or //section)">
					<rx:outline xmlns:rx="http://www.renderx.com/XSL/Extensions">
					  <xsl:apply-templates select="id($rootid)" mode="xep.outline"/>
					</rx:outline>
				  </xsl:if>
				  <xsl:call-template name="insert-cover">
					<xsl:with-param name="title" select="$title"/>
					<xsl:with-param name="document.element" select="$document.element"/>
				  </xsl:call-template>
				  <fo:page-sequence format="i" force-page-count="no-force" master-reference="titlepage-even">
					<fo:flow flow-name="xsl-region-body">
					  <fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format" xsl:use-attribute-sets="book.titlepage.verso.style" font-size="9pt">
						<xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="//bookinfo[1]/productname"/>
						<xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="//bookinfo[1]/pubdate"/>
						<xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="//bookinfo[1]/copyright"/>
						<xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="//bookinfo[1]/legalnotice"/>
					  </fo:block>
					</fo:flow>
				  </fo:page-sequence>
				  <xsl:apply-templates select="id($rootid)"/>
				</xsl:otherwise>
			  </xsl:choose>
			</xsl:when>
			<xsl:otherwise>
			  <xsl:if test="$fop.extensions != 0">
				<xsl:apply-templates mode="outline"/>
			  </xsl:if>
			  <xsl:if test="$xep.extensions != 0 and (//chapter or //section)">
				<rx:outline xmlns:rx="http://www.renderx.com/XSL/Extensions">
				  <xsl:apply-templates mode="xep.outline"/>
				</rx:outline>
			  </xsl:if>

			  <xsl:call-template name="insert-cover">
				<xsl:with-param name="title" select="$title"/>
				<xsl:with-param name="document.element" select="$document.element"/>
			  </xsl:call-template>
			  
			  <xsl:apply-templates/>
			</xsl:otherwise>
		  </xsl:choose>
		  
		</fo:root>
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

</xsl:stylesheet>
