<?xml version ="1.0"?>
<!--
	preprocess.xsl
	
	This XSLT stylesheet provides a "catch-all" spot for transforms that we
	need to apply to all broadbookx-compliant documents, regardless of their
	output formats.  
	

	Notice that the output of this XSLT is being passed to the validation step!
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:db="http://docbook.org/ns/docbook" xmlns="http://docbook.org/ns/docbook"
	xmlns:xlink="http://www.w3.org/1999/xlink" version="2.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:functx="http://www.functx.com"
	exclude-result-prefixes="#all">


	<!-- The templates for the JCBG-64 fix below simply call other templates. The following line imports the file that defines the called templates. -->
	<xsl:import href="../../../docbook-xsl/1.72.0/lib/lib.xsl"/>

	<xsl:import href="../utilities/functx-1.0-doc-2007-01.xsl"/>
	<!-- adding function library for general use -->


	<!-- The templates for the JCBG-64 fix below simply call other templates. The following line imports the file that defines the called templates. -->
	<xsl:import href="../../../docbook-xsl/1.72.0/lib/lib.xsl"/>
	<xsl:key name="id" match="*" use="@xml:id"/>

	<!-- JCBG-2129 -->
	<xsl:param name="inherit.book.keywords">false</xsl:param>

	<xsl:param name="skip.olink.conversion"/>
	<!-- JCBG-1656 -->
	<xsl:param name="olink.debug">0</xsl:param>
	<!-- JCBG-1656 -->
	<xsl:param name="remove.xrefs.and.links"/>
	<!-- JCBG-1657 -->
	<xsl:param name="fail.on.error"/>
	<!-- JCBG-1658 -->
	<xsl:param name="language"/>
	<xsl:param name="doc-lang">
		<xsl:value-of select="substring($language,1,2)"/>
		<xsl:if test="string-length(substring($language,4,2)) = 2">_<xsl:value-of
				select="translate(substring($language,4,2),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"
			/></xsl:if>
	</xsl:param>
	<xsl:param name="debug">false</xsl:param>
	<xsl:param name="branding"/>
	<xsl:param name="current.docid"/>
	<xsl:param name="output_file_name">MyBook</xsl:param>
	<xsl:param name="format">pdf</xsl:param>
	<xsl:param name="doctools"/>
	<xsl:param name="glossary.disable">0</xsl:param>
	<xsl:param name="common.graphics.path"/>
	<!-- added for use with JCBG-76 -->
	<xsl:template match="/">
		<xsl:message> In preprocess.xsl, branding="<xsl:value-of select="$branding"/>" and
				olink.debug="<xsl:value-of select="$olink.debug"/>" </xsl:message>
		<xsl:variable name="pass1">
			<xsl:apply-templates/>
		</xsl:variable>
		<xsl:apply-templates select="$pass1" mode="pass2"/>
	</xsl:template>


	<xsl:template match="db:book|db:article">
	  <!-- testing functx below. Sticking this here to run once per book. -->
	      <xsl:if test="$debug='true'">
		<xsl:message>Demo of using functx functions: Today is <xsl:value-of select="current-date()"
			/>, a <xsl:value-of select="functx:day-of-week-name-en(current-date())"/>. </xsl:message></xsl:if>

		<xsl:element name="{local-name(.)}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
			<xsl:processing-instruction name="insert-backcover"/>
		</xsl:element>
	</xsl:template>




	<!-- for JCBG-234, catch soft breaks in bad places -->
	<xsl:template
		match="db:book/processing-instruction('sbr') | db:article/processing-instruction('sbr') | db:chapter/processing-instruction('sbr')">
		<xsl:message>WARNING: Found a soft break whose parent is: <xsl:value-of
				select="local-name(..)"/>; this would cause a FO error, so I'm removing
			it.</xsl:message>
	</xsl:template>


	<!-- for JCBG-346, convert book/info/title to book/title because our layer doesn't handle book/info/title 
    - match on info
    - output <title> and <info> 
    - have a separate template that eats title when parent is info 

-->

	<xsl:template match="db:book/db:info[db:title] | db:article/db:info[db:title]">
		<xsl:copy-of select="db:title"/>
		<info>
			<xsl:apply-templates select="node()|@*"/>
			<!-- was <xsl:apply-templates select="@*|*"/> but that was eating PIs, so replaced with above 12/16/15 re: jcbg-1780, nokia rebranding -->
		</info>
	</xsl:template>

	<!-- to prevent duplication, eat the title when it is in book/info or article/info 
-->
	<xsl:template match="db:book/db:info/db:title | db:article/db:info/db:title"/>

	<!-- JCBG-1659 FOP doesn't like naked indexterms in question, answer elements, so let's wrap them in paras-->

	<xsl:template match="db:question/db:indexterm | db:answer/db:indexterm">
		<para>
			<xsl:copy-of select="."/>
		</para>
		<xsl:if test="$debug='true'">
		  <xsl:message>Wrapped an indexterm () in a para, within a question or answer element.</xsl:message></xsl:if>
	</xsl:template>


	<!-- for JCBG-540, magic indexterm that inserts value of parent element's title -->
	<!-- JCBG-1156: Allow text other than @@title@@ in the indexterm. Preserve that text in the output. -->

	<xsl:template match="db:indexterm/*[contains(., '@@title@@')]">
		<!-- match on any of the indexterm subelements when value is @@title@@ -->
		<!-- ok, we want to copy the element and any attribs over...but repl the value. Hmm
   - create element of same name
   - process attribs using apply-templates
   - then output the value...
 -->
		<xsl:element name="{local-name()}">
			<!-- process the attributes of the original element -->
			<xsl:apply-templates select="@*"/>

			<!-- output the title of the parent of the indexterm... -->
			<xsl:choose>
				<!-- when parent element has a title-->
				<xsl:when test="../../db:title">

					<!-- output any content BEFORE the special string, unchanged:-->
					<xsl:value-of select="substring-before(.,'@@title@@')"/>

					<xsl:value-of select="../../db:title/node()[not(self::db:remark)]"/>
					<!-- Note the expression above excludes remarks. Without this, remarks become part of the content
                  			    of the indexterm, and bypass security filtering. So I'm just excluding them.
  				
                  		            Another way to do this, if we needed to process the title in more complex ways, would be to 
  				            apply-templates here, to a mode, and have several templates to process the nodes, one for remark
    				            to omit them, others for other kinds, and one general one for all other nodes.
            			        -->


					<!-- output any content after the special string, unchanged:-->
					<xsl:value-of select="substring-after(.,'@@title@@')"/>

				</xsl:when>

				<!-- when parent element has info/title -->
				<xsl:when test="../../db:info/db:title">

					<xsl:value-of select="substring-before(.,'@@title@@')"/>

					<xsl:value-of select="../../db:info/db:title/node()[not(self::db:remark)]"/>

					<xsl:value-of select="substring-after(.,'@@title@@')"/>

				</xsl:when>
				<xsl:otherwise>@@title@@ <xsl:message>WARNING: You have used @@title@@ in an
						indexterm in a location where I can't find a title to replace it with. So,
						I'm outputting the original string @@title@@ in the index. @@title@@ should
						be used in a location where the indexterm's PARENT element has a title
						child: so put it in the section or table, but not in a para within a
						section, or entry within a table. </xsl:message>
				</xsl:otherwise>
			</xsl:choose>

		</xsl:element>
	</xsl:template>

	<!-- end of code for JCBG-540 @@title@@ -->

	<!-- for JCBG-840, magic indexterm that inserts value of parent element's title AND downcases the first char -->
	<!-- JCBG-1156: Allow text other than @@title-downcase@@ in the indexterm. Preserve that text in the output. -->

	<xsl:template match="db:indexterm/*[contains(., '@@title-downcase@@')]">
		<!-- match on any of the indexterm subelements when value is @@title-downcase@@ -->
		<!-- ok, we want to copy the element and any attribs over...but repl the value. Hmm
			- create element of same name
			- process attribs using apply-templates
			- then downcase the first char, concat with the rest of the substring as is, and output the value...
			- (The substring() function args were returning multiple strings, so I added string-join() to get a single string.)
		-->
		<xsl:element name="{local-name()}">
			<!-- process the attributes of the original element -->
			<xsl:apply-templates select="@*"/>

			<!-- output the title of the parent of the indexterm... -->
			<xsl:choose>
				<!-- when parent element has a title-->
				<xsl:when test="../../db:title">

					<!-- output any content BEFORE the special string, unchanged:-->
					<xsl:value-of select="substring-before(.,'@@title-downcase@@')"/>

					<xsl:value-of
						select="concat(lower-case(substring(string-join((../../db:title/node()[not(self::db:remark)]), ''),1,1)), substring(string-join((../../db:title/node()[not(self::db:remark)]), ''),2))"/>
					<!-- Note the expression above excludes remarks. Without this, remarks become part of the content
						of the indexterm, and bypass security filtering. So I'm just excluding them.
						
						Another way to do this, if we needed to process the title in more complex ways, would be to 
						apply-templates here, to a mode, and have several templates to process the nodes, one for remark
						to omit them, others for other kinds, and one general one for all other nodes.
					-->

					<!-- output any content after the special string, unchanged:-->
					<xsl:value-of select="substring-after(.,'@@title-downcase@@')"/>

				</xsl:when>
				<!-- when parent element has info/title -->
				<xsl:when test="../../db:info/db:title">

					<xsl:value-of select="substring-before(.,'@@title-downcase@@')"/>

					<xsl:value-of
						select="concat(lower-case(substring(string-join((../../db:info/db:title/node()[not(self::db:remark)]), ''),1,1)), substring(string-join((../../db:info/db:title/node()[not(self::db:remark)]), ''),2))"/>

					<xsl:value-of select="substring-after(.,'@@title-downcase@@')"/>


				</xsl:when>
				<xsl:otherwise> @@title-downcase@@ <xsl:message>WARNING: You have used
						@@title-downcase@@ in an indexterm in a location where I can't find a title
						to replace it with. So, I'm outputting the original string
						@@title-downcase@@ in the index. @@title-downcase@@ should be used in a
						location where the indexterm's PARENT element has a title child: so put it
						in the section or table, but not in a para within a section, or entry within
						a table. </xsl:message>
				</xsl:otherwise>
			</xsl:choose>

		</xsl:element>
	</xsl:template>
	<!-- end of code for JCBG-840 @@title-downcase@@ -->

	<!-- for JCBG-1080, @@sibling@@: magic indexterm string that inserts value of preceding non-indexterm sibling -->
	<xsl:template match="db:indexterm/*[contains(., '@@sibling@@')]">
		<!-- match on any of the indexterm subelements when contains @@sibling@@ -->
		<!-- ok, we want to copy the element and any attribs over...but repl the value. Hmm
			- create element of same name
			- process attribs using apply-templates
			- then output the value...
		-->
		<xsl:element name="{local-name()}">
			<!-- process the attributes of the original element -->
			<xsl:apply-templates select="@*"/>

			<!-- output the content of the preceding sibling, ignore other indexterms -->

			<!-- our current context is: a subelement of an indexterm... -->

			<!-- output any content BEFORE the special string, unchanged:-->
			<xsl:value-of select="substring-before(.,'@@sibling@@')"/>
			<!-- get the sibling content;
				Get the node children of the 1st preceding sibling of the parent indexterm, 
			provided it is not itself an indexterm
			-->

			<xsl:copy-of select="../preceding-sibling::*[not(self::db:indexterm)][1]/node()"/>
			<!-- output any content after the special string, unchanged:-->
			<xsl:value-of select="substring-after(.,'@@sibling@@')"/>
			<xsl:message>=========== For @@sibling@@, where self= <xsl:value-of select="."/>, I find
				my sibling to be: <xsl:value-of
					select="../preceding-sibling::*[not(self::indexterm)][1]"/> =============== </xsl:message>


		</xsl:element>
	</xsl:template>

	<!-- end of code for JCBG-1080 -->



	<!-- for JCBG-345, catch empty index, output nothing -->
	<xsl:template match="db:index[not(//db:indexterm)]"/>


	<xsl:template match="@*|node()" mode="pass2">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="pass2"/>
		</xsl:copy>
	</xsl:template>


	<!-- JCBG-1611 catch and fix colspecs that lack units 
	    the expression below is to match on colwidth whose last char = any digit
	-->
	<xsl:template match="@colwidth[. !=''][contains('0123456789',substring(., string-length(.)))]">

		<!-- code to REPLACE the attribute...but note this caused errors with FOP/testProduct's testDeployGuide, so test it
		<xsl:attribute name="colwidth"><xsl:value-of select="."/>in</xsl:attribute>
		<xsl:message>Found colwidth with value <xsl:value-of select="."/>; added units 'in'. </xsl:message>-->

		<xsl:message terminate="{$fail.on.error}"> Found colwidth value with no units: colwidth=
				&quot;<xsl:value-of select="."/>&quot;; this will cause PDF output to have tiny
			columns. Check the colspec elements of the table and add units (for example, 'in') at
			the end of each colwidth value that lacks them. Table: title "<xsl:value-of
				select="../../../title"/>", xml:id=<xsl:value-of select="../../../@xml:id"/>, first
			cell = <xsl:value-of select="../../thead/row[1]/entry[1]"/> root element = <xsl:value-of
				select="name(../../..)"/> First 512 characters of the table content: <xsl:value-of
				select="substring(normalize-space(../../..),1,512)"/>
		</xsl:message>

	</xsl:template>

	<!-- catch attributes with null values, remove them -->

	<!-- This section came from JCBG-279: when contentwidth="", remove it, because we get a build fail in the FO processing
step if it is still around -->

	<!-- The following lines handle specific attributes that cause problems, but see below for current general solution.	
<xsl:template match="@contentwidth[. = '']"/>
<xsl:template match="@contentdepth[. = '']"/>
<xsl:template match="@align[. = '']"/>
<xsl:template match="@condition[. = '']"/>
<xsl:template match="@depth[. = '']"/>
	-->

	<!-- The following template removes ALL attributes that have null values, and outputs a warning message. -->

	<xsl:template match="@*[. = '']">
		<xsl:message>WARNING: Removed empty @<xsl:value-of select="local-name(.)"/> attribute on
			element <xsl:value-of select="local-name(..)"/>.</xsl:message>
	</xsl:template>

	<!-- for JCBG-796, convert hrefs when format is pdf... 
               11/7/14:   removing this because  I am no longer trying to do embeds for pdf
		  also, this code didn't WORK=, anyway; the links are NOT modified - Aaron DaMommio
	     

	<xsl:template match="@xlink:href[starts-with(., 'embed/')]">
		<xsl:choose>
			<xsl:when test="$format = 'pdf'">
				<xsl:attribute name="xlink:href">
					<xsl:value-of select="$output_file_name"/>_<xsl:value-of select="."/>
				</xsl:attribute>

			</xsl:when>
			<xsl:otherwise>
				<xsl:copy/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>  -->


	<!-- For JCBG-424, optional preprocess step to convert <database> items into links.
	This only gets used if build property 'database.linking.enable' is set to 1.
Adding this replaces the local_preproces step that was formerly required for data dictionary (schema) documents -->

	<!-- first, create a key of all ids in the book -->
	<xsl:key name="id-key" match="*[@xml:id]" use="@xml:id"/>

	<!-- default value for parameter database.linking.enable is 0, which disables this feature -->
	<xsl:param name="database.linking.enable">0</xsl:param>

	<!-- now here's the template for making database into link -->

	<xsl:template match="db:database[$database.linking.enable='1']">
		<xsl:variable name="name">
			<xsl:value-of select="normalize-space(.)"/>
		</xsl:variable>
		<xsl:choose>

			<!-- 1st case: make <database> into a link,
				if its content matches the ID of something in the book, 
				and it does not satisfy:
				- ./link: contains a link
				- parent::link : parent is a link
				- ancester::*[etc]: is contained in that item already (ie, if you reference a table within its section or a column within its row, we'll ignore it, no need to make a link then -->


			<xsl:when
				test="key('id-key',$name) and 
				not(./link) and 
				not(parent::link) and 
				not(ancestor::*[@xml:id = $name])">

				<db:database>
					<xsl:copy-of select="@*"/>
					<db:link linkend="{$name}">
						<xsl:value-of select="$name"/>
					</db:link>
				</db:database>
                                <xsl:if test="$debug='true'">
				<xsl:message>Preproc found database element <xsl:value-of
						select="normalize-space(.)"/> and converted it into a link.</xsl:message></xsl:if>
			</xsl:when>

			<!-- 2nd case: a <database> whose name fits one of the NOT conditions above is copied over without making it into a link -->
			<xsl:when
				test="./link or parent::link or ancestor::*[@xml:id = $name] or key('id-key',$name) or (@class = 'field' and not(contains(.,'.')))">
			  <xsl:copy-of select="."/>
			  <xsl:if test="$debug='true'">
				<xsl:message>Preproc found database element <xsl:value-of
						select="normalize-space(.)"/> but it tripped one of the NOT conditions, so
					did NOT make it into a link.</xsl:message></xsl:if>
			</xsl:when>
			<!-- 3rd case: any other database is one whose name DOES NOT MATCH the ID of something already in the book, therefore it would be a bad link. Either we're talking about some OTHER database, or we made a mistake, so we throw an error. -->
			<xsl:otherwise>
				<xsl:copy-of select="."/>
				<xsl:message>Warning (preprocess.xsl): Tried to make &lt;database&gt; element with
					content = '''<xsl:value-of select="normalize-space(.)"/>''' into a link, but
					could not find a matching ID. </xsl:message>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>







	<xsl:template match="remark">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:attribute name="security">reviewer</xsl:attribute>
			<xsl:apply-templates select="node()"/>
		</xsl:copy>
	</xsl:template>

	<!-- Here we need to catch a few things that can cause problems downstream and rewrite them.
		If the writer puts one of our keep-* pis as the direct child of a listitem, it will 
		cause the fo renderer to explode because my docbook xsl customizations that 
		handle them aren't perfect, but it's easier just to do this than to fix them or 
		explain to writers that they can't make thes pis the children of listitems. 
		
		If a keep-together or keep-with-next pi is the child of a listitem, then
		rewrite it as the child of the first element within the listitem. -->
	<xsl:template
		match="processing-instruction('bjfo')[(normalize-space(.) = 'keep-with-next' or normalize-space(.) = 'keep-together') and parent::db:listitem]"/>
	<xsl:template match="*[parent::listitem[normalize-space(./processing-instruction('bjfo'))]]">
		<xsl:element name="{local-name(.)}">
			<xsl:copy-of select="@*"/>
			<xsl:if test="normalize-space(../processing-instruction('bjfo')) = 'keep-with-next'">
				<xsl:processing-instruction name="bjfo">keep-with-next</xsl:processing-instruction>
			</xsl:if>
			<xsl:if test="normalize-space(../processing-instruction('bjfo')) = 'keep-together'">
				<xsl:processing-instruction name="bjfo">keep-together</xsl:processing-instruction>
			</xsl:if>
			<xsl:copy-of select="node()"/>
		</xsl:element>
	</xsl:template>

	<!-- If you have a nested list and the containing list uses compact spacing, then use compact spacing too unless normal spacing is explicitly called for :-) -->
	<xsl:template
		match="*[(self::db:itemizedlist or self::db:orderedlist) and (ancestor::db:listitem[1][parent::*[@spacing = 'compact']] or ancestor::db:calloutlist)]">
		<xsl:element name="{local-name(.)}">
			<xsl:copy-of select="@*"/>
			<xsl:if test="not(@spacing = 'normal')">
				<xsl:attribute name="spacing">compact</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="db:itemizedlist[@role='checklist']">
		<variablelist>
			<xsl:apply-templates select="@*"/>
			<xsl:processing-instruction name="dbfo">list-presentation="table"</xsl:processing-instruction>
			<!-- JCBG-1401: change this to table, was 'list', which worked until the fix for JCBG-435 swapped the two terms'
						meanings back to what they SHOULD be. -->
			<xsl:processing-instruction name="dbfo">term-width=".25in"</xsl:processing-instruction>
			<xsl:processing-instruction name="dbhtml">list-presentation="table"</xsl:processing-instruction>
			<xsl:processing-instruction name="dbhtml">term-width=".25in"</xsl:processing-instruction>
			<xsl:apply-templates/>
		</variablelist>
	</xsl:template>

	<xsl:template match="db:listitem[parent::db:itemizedlist[@role='checklist']]">
		<varlistentry>
			<xsl:copy-of select="@*"/>
			<term>
				<inlinemediaobject>
					<imageobject condition="online">
						<imagedata fileref="images/_common/checkbox.png"/>
					</imageobject>
					<imageobject condition="print">
						<imagedata>
							<xsl:attribute name="fileref">
								<!-- JCBG-76, making the checkbox use common.graphics.path -->
								<xsl:value-of
									select="translate(concat($common.graphics.path,'/checkbox.png'),'\','/')"
								/>
							</xsl:attribute>
						</imagedata>
					</imageobject>
				</inlinemediaobject>
				<!-- added translate above to condition-print item, to fix all \ to /, for fop JCBG-76-->
			</term>
			<listitem>
				<xsl:apply-templates/>
			</listitem>
		</varlistentry>
	</xsl:template>

	<!-- temp fix for fop: throw away simplelist... testing this 10/28/14 @#@ -->
	<xsl:template match="db:xxxsimplelist">
		<db:itemizedlist>
			<db:listitem>
				<db:para>@#@ A SIMPLELIST WAS REMOVED HERE BY PREPROC</db:para>
			</db:listitem>
		</db:itemizedlist>
		<xsl:message>Preproc detected and removed a SIMPLELIST @#@</xsl:message>
	</xsl:template>



	<!-- Give tables the formatting we want -->
	<xsl:template
		match="db:table[not(contains(child::processing-instruction('bj'),'custom-table-format'))]|db:informaltable[not(contains(descendant::processing-instruction('bj'),'custom-table-format'))]">
		<xsl:element name="{name(.)}">
			<xsl:apply-templates select="@*"/>
			<xsl:attribute name="frame">all</xsl:attribute>
			<xsl:attribute name="colsep">1</xsl:attribute>
			<xsl:if test="not(@pgwide)">
				<xsl:attribute name="pgwide">1</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template
		match="db:row[not(contains(../../../processing-instruction('bj'),'custom-table-format'))]">
		<row>
			<xsl:apply-templates select="@*"/>
			<xsl:attribute name="rowsep">1</xsl:attribute>
			<xsl:apply-templates select="*"/>
		</row>
	</xsl:template>

	<!-- If glossary.disable = 1, throw away glossterm wrappers, but keep their contents. 
	Note that this only operates on glossterms with linkends (ie, in text, NOT ones in a local <glossary/>) -->

	<xsl:template match="db:glossterm[@linkend][$glossary.disable = '1']">
		<xsl:apply-templates/>
	</xsl:template>

<!-- If glossterm has title ancestor, throw it away but keep contents (JCBG-1103) -->
	<xsl:template match="db:glossterm[ancestor::db:title]">
		<xsl:message>Warning: removed glossterm with linkend='<xsl:value-of select="@linkend"/>' and contents [<xsl:value-of select="."/>] because it's inside a title element.</xsl:message>
		<xsl:apply-templates/>
	</xsl:template>


	<!-- Is this still needed? -->
	<xsl:param name="include.alcatel.cobranding">0</xsl:param>

	<xsl:template
		match="db:section[@xml:id='customer.support' or @xml:id='customer.support.motive-alcatel']">
		<xsl:choose>
			<xsl:when
				test="$include.alcatel.cobranding != 0 and @xml:id='customer.support.motive-alcatel'">
				<xsl:copy-of select="."/>
			</xsl:when>
			<xsl:when test="$include.alcatel.cobranding = 0 and @xml:id='customer.support'">
				<xsl:copy-of select="."/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>







	<!-- Processing instructions that insert shared content -->

	<!-- The legalnotice processing instruction -->

	<!-- for the NEW legalnotice pi, <?auto-legalnotice?>, see glossify.xsl -->

	<!-- original case: when <?legalnotice?> used in book's info element, replace it with content of the legal notice file -->
	<xsl:template match="db:info/processing-instruction('legalnotice')">
		<!-- debug msg, delete this later
		<xsl:message terminate="no">I found a legalnotice PI in preprocess.xsl, branding is <xsl:value-of select="$branding"/>, and the content of the legal is
		
		nokia: <xsl:value-of
			select="document('../../../SharedContent/en_US/legal/nokia_notice.xml')/node()"/>
			regular: <xsl:value-of
				select="document('../../../SharedContent/en_US/legal/important_notice.xml')/node()"/>
		
		</xsl:message> -->
		<xsl:comment>I found a legalnotice PI in preprocess.xsl, and my branding is <xsl:value-of select="$branding"/></xsl:comment>
		<xsl:choose>
			<!-- added for nokia branding-->
			<xsl:when test="substring($branding,1,5) = 'nokia'">
				<xsl:copy-of
					select="document('../../../SharedContent/en_US/legal/nokia_notice.xml')/node()"
				/>
			</xsl:when>
			<xsl:otherwise>
				<!-- otherwise just use the normal notice file -->
				<xsl:copy-of
					select="document('../../../SharedContent/en_US/legal/important_notice.xml')/node()"
				/>
			</xsl:otherwise>
		</xsl:choose>
		

			<!-- JCBG-1832: Add timestamp to HTML / PDF output-->
			<legalnotice>
			  <para><xsl:value-of select="current-dateTime()" /></para>
			</legalnotice>

	</xsl:template>


	<!-- second case:  when <?legalnotice?> used in a <legalnotice> element,
	insert content of <legalnotice> between the first and second phrases of the legal notice (jcbg-688)-->

	<xsl:template match="db:legalnotice[processing-instruction('legalnotice')]">
		<!-- define a var for the legal file's contents, and use that so can easily switch files, for diff branding for example -->
		<xsl:variable name="LEGALFILE">
			<xsl:choose>
				<xsl:when test="substring($branding,1,5)='nokia'">
					<xsl:copy-of select="document('../../../SharedContent/en_US/legal/nokia_notice.xml')/node()"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="document('../../../SharedContent/en_US/legal/important_notice.xml')/node()"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!-- jcbg-825: test for failure of legalnotice mixing expressions, and throw errors if nothing found -->
		<xsl:if
			test="normalize-space($LEGALFILE/db:legalnotice/db:para[1]) = ''">
			<xsl:message terminate="{$fail.on.error}"> No legalnotice TITLE para found in the
				target\doctools\SharedContent\en_US\legal\important_notice.xml file; verify that you
				have a glossary or CommonContent version of 2.0.14 or later.</xsl:message>
		</xsl:if>
		<xsl:if
			test="normalize-space($LEGALFILE/db:legalnotice//db:phrase[1]) = ''">
			<xsl:message terminate="{$fail.on.error}"> No legalnotice FIRST PHRASE found in the
				target\doctools\SharedContent\en_US\legal\important_notice.xml file; verify that you
				have a glossary or CommonContent version of 2.0.14 or later.</xsl:message>
		</xsl:if>
		<xsl:if
			test="normalize-space($LEGALFILE/db:legalnotice//db:phrase[2]) = ''">
			<xsl:message terminate="{$fail.on.error}"> No legalnotice SECOND PHRASE para found in
				the target\doctools\SharedContent\en_US\legal\important_notice.xml file; verify that
				you have a glossary or CommonContent version of 2.0.14 or later.</xsl:message>
		</xsl:if>
		<legalnotice>
			<!-- first output the legalnotice title -->
			<xsl:copy-of
				select="$LEGALFILE/db:legalnotice/db:para[1]"/> 

			<!-- then the first phrase-->
			<para><xsl:copy-of select="$LEGALFILE/db:legalnotice//db:phrase[1]" /></para>

			<!-- now write out the original content of the legalnotice element from the source document, which will be in one or more paras 
				
				We could put this all in one para, but that change the writer's content if the content was in >1 para. We'd have to strip off any para
				 elements, and just output the content of them. We could do that, but it's a little messy. -->

			<xsl:apply-templates select="*"/>

			<!-- then the second phrase-->
			<para><xsl:copy-of select="$LEGALFILE/db:legalnotice//db:phrase[2]" /></para>

			<xsl:if test="substring($branding,1,5)='nokia'">

			  <para><xsl:copy-of select="$LEGALFILE/db:legalnotice//db:phrase[3]" /></para>
			  <para><xsl:copy-of select="$LEGALFILE/db:legalnotice//db:phrase[4]" /></para>
			  <para><xsl:copy-of select="$LEGALFILE/db:legalnotice//db:phrase[5]" /></para>
			  <para><xsl:copy-of select="$LEGALFILE/db:legalnotice//db:phrase[6]" /></para>
			  <para><xsl:copy-of select="$LEGALFILE/db:legalnotice//db:phrase[7]" /></para>
			  <para><xsl:copy-of select="$LEGALFILE/db:legalnotice//db:phrase[8]" /></para>
			  <important><title><xsl:copy-of select="$LEGALFILE/db:legalnotice//db:phrase[9]" /></title>
 			     <para><xsl:copy-of select="$LEGALFILE/db:legalnotice//db:phrase[10]" /></para>
 			     <para><xsl:copy-of select="$LEGALFILE/db:legalnotice//db:phrase[11]" /></para>
 			     <para><xsl:copy-of select="$LEGALFILE/db:legalnotice//db:phrase[12]" /></para>
			  </important>
 			  <para><xsl:copy-of select="$LEGALFILE/db:legalnotice//db:phrase[13]" /></para>
 			  <para><xsl:copy-of select="$LEGALFILE/db:legalnotice//db:phrase[14]" /></para>

			</xsl:if>
			
			<!-- JCBG-1832: Add timestamp to HTML / PDF output-->
			<para><xsl:value-of select="current-dateTime()" /></para>

		</legalnotice>
	</xsl:template>



	<!-- The conventions processing instruction -->
	<xsl:template match="processing-instruction('conventions')">
		<xsl:copy-of
			select="document('../../../SharedContent/en_US/conventions/conventions.xml')/node()"/>
	</xsl:template>

	<!-- The customersupport processing instruction -->
	<xsl:template match="processing-instruction('customersupport')">
		<xsl:copy-of
			select="document('../../../SharedContent/en_US/support/customer.support.xml')/node()"/>
	</xsl:template>

	<xsl:template match="db:copyright" xmlns:xlink="http://www.w3.org/1999/xlink">
		<!-- first decide what company name to use 
			Note that we'd expect this code to change after we've settled into Nokia ownership; we only really need this for the period where we need the ability 
			to use the doctools and only use Nokia naming when the branding = nokia. The below uses 'Nokia' when the $branding starts with 'nokia'.
		-->
		<xsl:variable name="HOLDER">
			<xsl:choose>
				<xsl:when test="substring($branding,1,5) = 'nokia'">
				  <link	xlink:href="http://www.nokia.com">Nokia</link>. <!-- JCBG-1845: Removed "All rights reserved." -->
				</xsl:when>
				<xsl:otherwise>
				  <link xlink:href="http://www.alcatel-lucent.com">Alcatel-Lucent</link>. All rights reserved.
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<!-- If the document hasn't been preprocessed (i.e. for localization), then we add the right copyright holder -->
			<xsl:when
				test="($doc-lang = 'en_US' or $doc-lang='' or substring($doc-lang,1,2) = 'en') and $include.alcatel.cobranding != 0">
				<copyright>
					<xsl:copy-of select="db:year"/>
					<holder>
						<xsl:value-of select="$HOLDER"/>
					</holder>
				</copyright>
			</xsl:when>
			<xsl:when test="$doc-lang = 'en_US' or $doc-lang='' or substring($doc-lang,1,2) = 'en'">
				<copyright>
					<xsl:copy-of select="db:year"/>
					<xsl:choose>
						<!-- AaronD 12/8/15: not real sure we need the case below any more -->
						<xsl:when
							test="./holder and not(contains(./holder,'Motive Communications'))">
							<xsl:copy-of select="./holder"/>
						</xsl:when>
						<xsl:otherwise>
							<holder>
								<xsl:value-of select="$HOLDER"/>
							</holder>
						</xsl:otherwise>
					</xsl:choose>
				</copyright>
			</xsl:when>
			<!-- If the doc isn't en_US, then it's already been pre-processed and the right copyright holder is there. -->
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- check page 62 also -->
	<xsl:template match="db:xref[(@linkend or @share_linkend) and @xrefstyle[contains(.,'label')]]"
		mode="pass2">
		<xsl:choose>
			<xsl:when
				test="$branding = 'alcatel' and key('id', concat(@linkend,@share_linkend))[self::db:section and ancestor::db:section]">
				<xsl:message> ============================================== Warning: Fixing
					xrefstyle attribute to remove "label" on <xsl:copy><xsl:apply-templates
							select="@*" mode="pass2"/></xsl:copy> which is in: <xsl:for-each
						select="ancestor::*[db:title]">"<xsl:value-of select="./db:title"/>"
							(<xsl:value-of select="local-name(.)"/>), </xsl:for-each> The xref
					points to the section titled "<xsl:value-of
						select="key('id', concat(@targetptr,@linkend,@share_linkend))/db:title"/>" <xref>
						<xsl:copy-of select="@*[not(local-name(.) = 'xrefstyle')]"/>
						<xsl:if test="contains(@xrefstyle, 'nopage')">
							<xsl:attribute name="xrefstyle">select: nopage</xsl:attribute>
						</xsl:if>
					</xref> ============================================== </xsl:message>
				<xref>
					<xsl:copy-of select="@*[not(local-name(.) = 'xrefstyle')]"/>
					<xsl:if test="contains(@xrefstyle, 'nopage')">
						<xsl:attribute name="xrefstyle">select: nopage</xsl:attribute>
					</xsl:if>
				</xref>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:apply-templates select="@*|node()" mode="pass2"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>


	<!-- for JCBG-1657, remove link and xref if $remove.xrefs.and.links = true -->

	<xsl:template match="db:xref[$remove.xrefs.and.links = 'true']"/>
	<xsl:template match="db:link[$remove.xrefs.and.links = 'true']"/>
	<xsl:template match="db:olink[$remove.xrefs.and.links = 'true']"/>


	<!-- 
		Convert olinks that point inside the same doc to xrefs to simplify processing.
		However, if xrefstyle="select: linktext" and it points inside this doc, convert to a link.
		If it points outside this doc and xrefstyle="select: linktext" is not set, then remove the 
		linktext. 
		
		Adding for JCBG-1656: testing  property skip.olink.conversion to decide whether to convert.
	-->

	<xsl:template
		match="db:olink[($skip.olink.conversion = 'false') and ($remove.xrefs.and.links = 'false')]">
		<xsl:variable name="baseuri" select="base-uri(.)"/>
		<!-- when nokia branding, don't use label b/c no numbering; this only affects NA docs, we think 
			the following variable examines @xrefstyle and creates a new value to be used in nokia case. 
		because we know NA only uses a few variations, we're pruning off the initial 'select: label', if present.
		-->
		<xsl:variable name="XREFSTYLE">
			<xsl:choose> 
				<xsl:when test="substring($branding,1,5)='nokia' and substring(normalize-space(@xrefstyle),1,13)='select: label'">
					  <!-- prepend a 'select: ', but only if pruning off select: label' doesn't leave the null string, because if there's nothing left we want XREFSTYLE to be empty
					  	      so it can be ignored later
					     bug kludge: make it a 'select: title' because 'select: nopage' doesn't work in html...
					  -->
					<xsl:if test="normalize-space(substring-after(normalize-space(@xrefstyle),'select: label')) !=''">select: 
						<xsl:if test="not(contains(@xrefstyle, 'title'))"> title </xsl:if>  <!-- nested if means you only get title if no title in the original; fixes case 
							where we prune 'select: label nopage' down to 'select: nopage' when we really need 'select: title nopage' -->
					</xsl:if>
					<xsl:value-of select="normalize-space(substring-after(normalize-space(@xrefstyle),'select: label'))"/>
				</xsl:when>
				  <!-- otherwise use the value as is -->
				<xsl:otherwise><xsl:value-of select="@xrefstyle"/></xsl:otherwise>
			</xsl:choose>			
		</xsl:variable>
		<!-- debug msg, improved per JCBG-1856 -->
		 <xsl:if test="$olink.debug != '0'">
		 	<!-- Note that unlike elsewhere in the codebase where we test whether [$olink.debug != 0] without quotes, here we must use quotes, I think b/c this script uses XSL 2.0 
		 		... I was getting operand errors where it complained that it could not compare using != when first operand was a string. To prevent that I had to make sure olink.debug got SOME value to start with,
		 	and test it as string. I therefore set it a default value in main-build.xml. Not sure why I couldn't pass it down as a number, maybe that's a limit of ant properties. - Aaron DaMommio 4/20/16-->
		   <xsl:message>Olink: doc[<xsl:value-of select="@targetdoc"/>]/ptr[<xsl:value-of select="@targetptr"/>]/content[<xsl:value-of select="normalize-space(.)"/>]/$XREFSTYLE[<xsl:value-of select="$XREFSTYLE"/>]</xsl:message>
		 </xsl:if> 
			
			<!-- next, decide whether the olink is IN this doc or not and if it is, convert to xref -->
		<xsl:choose>
			<!-- 
				We can tell if the target is in this doc in three ways:
				1. If the value of the targetdoc attr is the same as the current.docid, then we're xrefing.
				2. If there's an element in the current doc that has an xml:id the same as our targetptr AND the base-uri 
				   of that element and this olink are the same, then we have a case where the xref is within a file that's 
				   xincluded wholesale.
				3. A superset of #3, if the first part of the olink's base-uri and the target element's base-uri is the same,
				   e.g. if our base-uri is ../foo/foo.xml and the target element's base-uri is ../foo/fragments/bar.xml, 
				   then we can assume the target is really ours. 
			-->
			<!-- JCBG-1776: added [1] to the two base-uri(key)) function expressions below, to make sure they only get ONE item back; this means they won't fail when dupe IDs, 
					and that is ok b/c we detect dupe ids later during validate-filtered and throw an appropriate error message for that. -->
			<xsl:when
				test="
				@targetdoc = $current.docid or 
				base-uri(key('id',@targetptr)[1]) = $baseuri or 
				replace(base-uri(key('id',@targetptr)[1]), '((../)*[a-zA-Z0-9\-_]+/).*','$2') = replace($baseuri, '((../)*[a-zA-Z0-9\-_]+/).*','$2')">
				<xsl:choose>
					<!-- if xrefstyle="select: linktext" then we turn it into a <link> instead of an xref -->
					<xsl:when test="contains(@xrefstyle,'linktext')">
						<link xlink:href="#{@targetptr}" xlink:role="generated">
							<xsl:if test="contains(@xrefstyle,'nopage')">
								<xsl:attribute name="xrefstyle">select: nopage</xsl:attribute>
							</xsl:if>
							<xsl:apply-templates/>
						</link>
					</xsl:when>
					<xsl:otherwise>
						<xref linkend="{@targetptr}">
							<!-- output the value of var XREFSTYLE to replace @xrefstyle -->
							<xsl:if test="$XREFSTYLE != ''">
								<xsl:attribute name="xrefstyle"><xsl:value-of select="$XREFSTYLE"/></xsl:attribute></xsl:if>
							 <!-- before I added checking for nokia branding here, had this: 
							 	<xsl:apply-templates select="@xrefstyle"/> -->
						</xref>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="not(@xrefstyle = 'select: linktext')">
				<olink>
					<xsl:copy-of select="@targetptr"/>
					<xsl:copy-of select="@targetdoc"/>
					<!-- We're not passing on @xrefstyle because we don't want to use it for olinked links, just for xrefs -->
				</olink>
			</xsl:when>
			<xsl:otherwise> <!-- copy the olink forward, but omit the xrefstyle, as it's an external link -->
				<xsl:copy>
					<xsl:copy-of select="@targetptr"/>
					<xsl:copy-of select="@targetdoc"/>
					<xsl:apply-templates select="node()"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="@is_holmanized"/>


	<!-- Adding the three following templates to handle <programlisting> element issues mentioned in JCBG-64, JCBG-264, and JCBG-296.
	     Pulled the templates from https://lists.oasis-open.org/archives/docbook-apps/201011/msg00012.html. -->

	<!-- There are three templates because programlisting allows element content as well as text content. So the three templates 
	     apply when the first node is a text node (uses trim-left), the last node is a text node (uses trim-right), and when the 
	     programlisting contains a single node that is a text node (uses trim.text), respectively. -->

	<!-- Selects the programlisting's first node, if it is a text node, and if it has a 
	     following sibling (which means it is not the only node) -->
	<xsl:template match="db:programlisting/node()[1][self::text()][following-sibling::node()]">
		<xsl:call-template name="trim-left">
			<xsl:with-param name="contents" select="."/>
		</xsl:call-template>
	</xsl:template>

	<!-- Selects the programlisting's last node, if it is a text node, and if it has a 
	     preceding sibling (which means it is not the only node) -->
	<xsl:template
		match="db:programlisting/node()[position() = last()][self::text()][preceding-sibling::node()]">
		<xsl:call-template name="trim-right">
			<xsl:with-param name="contents" select="."/>
		</xsl:call-template>
	</xsl:template>

	<!-- Selects the programlistings first node that is also the last node, if it is a text node -->
	<xsl:template
		match="db:programlisting/node()[position() = 1 and position() = last()][self::text()]"
		priority="1">
		<xsl:call-template name="trim.text">
			<xsl:with-param name="contents" select="."/>
		</xsl:call-template>
	</xsl:template>


	<!-- JCBG-2129: Inherit keywords. -->
	<!-- Definitions:
         * nonrh keyword: keyword with no role="rh" attribute
         * rh keyword: keyword with a role="rh" attribute 
	-->
	
	<xsl:variable name="book-level-keywords" select="db:book/db:info/db:keywordset/db:keyword[not(@role='rh')]"/>
	
	<!-- Case 1/3: Current topic has nonrh keywords, with or without rh keywords.
	     => No-op because nonrh keywords indicate a desire to override book-level keywords. -->
	
	<!-- Case 2/3: Current topic has no keywordset. 
	     => Inherit nonrh keywords from book level. -->
	
	<!-- Case 2a: Template output includes <info> -->  
	<xsl:template match="db:title[parent::db:chapter |  
		parent::db:section | 
		parent::db:part][not(ancestor::*[1]/descendant::db:keywordset)]
		[$inherit.book.keywords = 'true']" mode="pass2">
		
		<!-- Pass title through -->    
		<xsl:copy-of select="."/> 
		
		<xsl:if test="$book-level-keywords"> <!-- JCBG-2142: Test for book-level-keywords before inserting XML. -->
		  <xsl:comment>### Topic has no kws; insert book-level-keywords</xsl:comment>
		  <info>
		    <keywordset>
		      <xsl:copy-of select="$book-level-keywords"/>
		    </keywordset>
		  </info>
		</xsl:if>
	</xsl:template>
	
	<!-- Case 2b: Template output does not include <info> because we are inside <info> already -->
	<xsl:template match="db:title[parent::db:info][not(ancestor::*[1]/descendant::db:keywordset)][$inherit.book.keywords = 'true']" mode="pass2">
		
		<!-- Pass title through -->    
		<xsl:copy-of select="."/> 
		
		<xsl:if test="$book-level-keywords"> <!-- JCBG-2142: Test for book-level-keywords before inserting XML. -->
		  <xsl:comment>### Topic has no kws; insert book-level-keywords.</xsl:comment>
		  <keywordset>
		    <xsl:copy-of select="$book-level-keywords"/>
		  </keywordset>
		</xsl:if>
	</xsl:template>
	
	<!-- Case 3/3: Current topic has only rh keywords.
	     => Inherit nonrh keywords from book level and merge with the rh keywords -->
	
	<xsl:template match="db:keywordset[child::db:keyword[@role='rh'] and not(child::db:keyword[not(@role='rh')])][$inherit.book.keywords = 'true']" mode="pass2">
		<xsl:comment>### Topic has only rh keywords; insert book-level-keywords and keep the rh keywords</xsl:comment>  
		<xsl:variable name="topic-level-keywords" select="db:keyword"/>    
		<keywordset>
			<xsl:copy-of select="$book-level-keywords"/>
			<xsl:copy-of select="$topic-level-keywords"/>
		</keywordset>    
	</xsl:template>
	

</xsl:stylesheet>
