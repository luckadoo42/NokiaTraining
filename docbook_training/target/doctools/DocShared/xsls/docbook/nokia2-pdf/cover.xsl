<!DOCTYPE xsl:stylesheet>
<!-- This customization of the docbook xsls -->
<!-- (http://docbook.sourceforge.net/) adds a full page -->
<!-- cover to a pdf using an image as a background image. -->
<!-- eps images work best for this kind of thing and will -->
<!-- fill the entire page. If you are using xep, you can use a bitmap -->
<!-- size. The extension is only used if xep.extensions is -->
<!-- set to 1.  -->
<!-- To use this, just change the xsl:import to point to a -->
<!-- local version of the docbook xsls and put in a valid -->
<!-- vaue for the cover.path parameter (or pass it in from -->
<!-- the command line.  -->
<!-- I have only tested this with XEP. If it works with -->
<!-- other renderers or if it works, but only with some -->
<!-- changes, let me know: dcramer@broadjump.com -->
<!-- This can and probably be made to work with the -->
<!-- titlepage template system, so that you let the template -->
<!-- system control the text that appears on the -->
<!-- cover. Likewise, you can adapt it to give you full page -->
<!-- cover images on part titlepages. -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:rx="http://www.renderx.com/XSL/Extensions"
	version="1.0">
	<!-- Adjust this to point to your docbook distribution. I've -->
	<!-- tested it with 1.55.0, but it probably works with other -->
	<!-- versions. -->

	<!-- something like:
  <xsl:param name="cover.path"><xsl:value-of 
  select="normalize-space(//bookinfo//imagedata/@fileref)"/></xsl:param>
  Assuming that you've got an image defined in your bookinfo.
 -->
	<!-- For JCBG-823: create a covertitle var from value of a covertitle PI -->
	<xsl:param name="covertitle">
		<xsl:value-of select="//processing-instruction('covertitle')"/>
	</xsl:param>
	<xsl:param name="common.graphics.path"/>
	<xsl:param name="include.alcatel.cobranding" select="0"/>
	<xsl:param name="motive.alcatel.cobrand.logo.path"
		select="concat($common.graphics.path, '/motive_alcatel.pdf')"/>

	<!-- cover art: FOP needs svg, XEP needs pdf, JCBG-76 -->

	<xsl:param name="cover.path">
		<xsl:choose>
			<!-- XEP-->
			<xsl:when test="$xep.extensions !='0'">
				<xsl:value-of select="concat($common.graphics.path, '\nokia1\NOKIA_LOGO_RGB.svg')"/>
			</xsl:when>
			<!-- FOP -->
			<xsl:otherwise>
				<xsl:value-of select="concat($common.graphics.path, '\nokia1\NOKIA_LOGO_RGB.svg')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:param>


	<!--	<xsl:param name="motive.component.cover.path"
select="concat($common.graphics.path, '/motive.chapter.cover.svg')"/> -->
	<xsl:param name="motive.component.cover.path"
		select="concat($common.graphics.path, '/alcatel2/one-pixel-white.pdf')"/>
	<xsl:param name="motive.cover.title.font-family"
		>Arial,sans-serif,ZapfDingbats,LucidaSansUnicode,KozMinPro-Regular-Acro</xsl:param>

	<xsl:param name="motive.cover.subtitle.font-family"
		>Arial,sans-serif,ZapfDingbats,LucidaSansUnicode,KozMinPro-Regular-Acro</xsl:param>
	<xsl:param name="motive.cover.text.align">left</xsl:param>
	<xsl:param name="motive.component.cover.text.align">right</xsl:param>
	<xsl:param name="omit.cover"/>
	<xsl:param name="motive.cover.title.block.width">4.25in</xsl:param>
	<xsl:param name="motive.cover.subtitle.block.width">4.25in</xsl:param>
	<xsl:param name="motive.cover.title.left.margin">65mm</xsl:param>
	<xsl:param name="motive.cover.subtitle.left.margin">65mm</xsl:param>
	<xsl:param name="motive.cover.title.right.margin">1.5in</xsl:param>

	<xsl:param name="motive.component.cover.title.block.width">5.5in</xsl:param>
	<xsl:param name="motive.component.cover.title.left.margin">1.25in</xsl:param>

	<xsl:param name="motive.component.cover.title.font.size">24pt</xsl:param>
	<xsl:param name="motive.cover.productnumber.font.size">24pt</xsl:param>
	<xsl:param name="motive.cover.title.font.size">11.5pt</xsl:param>
	<xsl:param name="motive.cover.prodname.font.size">15pt</xsl:param>
	<xsl:param name="motive.cover.subtitle.font.size">11pt</xsl:param>
	<xsl:param name="nda.footer">false</xsl:param>
	<xsl:template name="user.pagemasters">
		<!-- Write FOP values out to the log (JCBG-76)-->
		<xsl:message>FOP/XEP values: fop.extensions=<xsl:value-of select="$fop.extensions"/>;
				fop1.extensions=<xsl:value-of select="$fop1.extensions"/>;
				xep.extensions=<xsl:value-of select="$xep.extensions"/>;</xsl:message>

		<fo:simple-page-master margin-right="0in" margin-left="0in" margin-bottom="0in"
			margin-top="0in" page-height="{$page.height}" page-width="{$page.width}"
			master-name="cover">

			<!-- margin-bottom="-.02in" margin-top="-.02in" margin-left="-.02in"
					margin-right="-.02in"-->

   <!-- @#@ the region-body for the cover -->

			<fo:region-body margin-bottom="1in" margin-top="10mm" margin-left="4cm"
				margin-right="1.75in" background-repeat="no-repeat">
				<!-- we could put the Nokia Logo here but we can't scale it if we do 
				background-image="url({$cover.path})">  
				the top and left margins above do position the logo though
				-->
				<!-- This _should_ work :) If the filename of the
cover doesn't end in eps and you're using XEP, then
use XEP's extensions to size the cover image to 8.5
x 11.  

(REMOVING THE RESIZE CODE for nokia branding 
				<xsl:if test="$xep.extensions != '0'">
					<xsl:choose>
						<xsl:when test="$paper.type = 'FOO'">
							<xsl:attribute name="rx:background-content-width"
								>211.016mm</xsl:attribute>
							<xsl:attribute name="rx:background-content-height"
								>298.016mm</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="rx:background-content-width"
								>8.54in</xsl:attribute>
							<xsl:attribute name="rx:background-content-height"
								>11.04in</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if> -->
			</fo:region-body>
			<fo:region-before extent="0pt" display-align="after"
				region-name="xsl-region-before-first"/>
			<fo:region-after extent="0pt" display-align="after" region-name="xsl-region-after-first"
			/>
		</fo:simple-page-master>
		<fo:page-sequence-master master-name="coversequence">
			<fo:repeatable-page-master-alternatives>
				<fo:conditional-page-master-reference master-reference="cover" page-position="first"/>
				<fo:conditional-page-master-reference master-reference="blank"
					blank-or-not-blank="blank"/>
			</fo:repeatable-page-master-alternatives>
		</fo:page-sequence-master>

		<fo:simple-page-master margin-right="0in" margin-left="0in" margin-bottom="0in"
			margin-top="0in" page-height="{$page.height}" page-width="{$page.width}"
			master-name="motive.component.cover">
			<fo:region-body margin-bottom="-.02in" margin-top="-.02in" margin-left="-.02in"
				margin-right="-.02in" background-repeat="no-repeat"
				background-image="url({$motive.component.cover.path})">
				<!-- This _should_ work :) If the filename of the
cover doesn't end in eps and you're using XEP, then
use XEP's extensions to side the cover image to 8.5
x 11.  -->
				<xsl:if test="$xep.extensions != '0'">
					<xsl:attribute name="rx:background-content-width"
						>8.54in<!--  <xsl:value-of select="$page.width"/> --></xsl:attribute>
					<xsl:attribute name="rx:background-content-height"
						><!--  <xsl:value-of select="$page.height"/> -->11.04in</xsl:attribute>
				</xsl:if>
			</fo:region-body>
			<fo:region-before extent="0pt" display-align="after"
				region-name="xsl-region-before-first"/>
			<fo:region-after extent="0pt" display-align="after" region-name="xsl-region-after-first"
			/>
		</fo:simple-page-master>
		<fo:page-sequence-master master-name="motive.component.coversequence">
			<fo:repeatable-page-master-alternatives>
				<fo:conditional-page-master-reference master-reference="motive.component.cover"
					page-position="first"/>
				<fo:conditional-page-master-reference master-reference="blank"
					blank-or-not-blank="blank"/>
			</fo:repeatable-page-master-alternatives>
		</fo:page-sequence-master>
	</xsl:template>
	<!-- This overrides a template in fo/docbook.xsl  -->
	<xsl:template match="/">
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
				<!-- for JCBG-823: use covertitle when that is non-null -->
				<xsl:when test="$covertitle !=''">
					<xsl:value-of select="$covertitle"/>
					<xsl:message>JCBG-823 title is now <xsl:value-of select="$covertitle"
						/></xsl:message>
				</xsl:when>
				<xsl:when test="$rootid != ''">
					<xsl:apply-templates select="id($rootid)/title[1]" mode="motive.cover.mode"/>
				</xsl:when>
				<xsl:when test="$document.element/title[1]">
					<xsl:apply-templates select="$document.element/title[1]"
						mode="motive.cover.mode"/>
				</xsl:when>
				<xsl:otherwise>[could not find document title]</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<fo:root font-family="{$body.font.family}" font-size="{$body.font.size}"
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
							<xsl:if test="$fop1.extensions != 0">
								<xsl:apply-templates select="id($rootid)" mode="fop1.outline"/>
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
							<fo:page-sequence format="i" force-page-count="no-force"
								master-reference="titlepage-even">
								<fo:flow flow-name="xsl-region-body">
									<fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format"
										xsl:use-attribute-sets="book.titlepage.verso.style"
										font-size="9pt">
										<xsl:apply-templates mode="book.titlepage.verso.auto.mode"
											select="//bookinfo[1]/productname"/>
										<xsl:apply-templates mode="book.titlepage.verso.auto.mode"
											select="//bookinfo[1]/pubdate"/>
										<xsl:apply-templates mode="book.titlepage.verso.auto.mode"
											select="//bookinfo[1]/copyright"/>
										<xsl:apply-templates mode="book.titlepage.verso.auto.mode"
											select="//bookinfo[1]/legalnotice"/>
									</fo:block>
								</fo:flow>
							</fo:page-sequence>
							<xsl:apply-templates select="id($rootid)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="$fop1.extensions != 0">
						<xsl:variable name="bookmarks">
							<xsl:apply-templates select="$document.element" mode="fop1.outline"/>
						</xsl:variable>
						<xsl:if test="string($bookmarks) != ''">
							<fo:bookmark-tree>
								<xsl:copy-of select="$bookmarks"/>
							</fo:bookmark-tree>
						</xsl:if>

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
	</xsl:template>

	<xsl:template name="motive.component.cover">
		<xsl:param name="id"/>
		<!-- this template is called from component.xsl -->
		<!-- put page sequence that holds cover/title for chapters and appendices. -->

		<!-- the id WAS on the page-sequence here, but I moved it to the following block container to make FOP happy for jcbg-76 -->
		<fo:page-sequence hyphenate="{$hyphenate}" master-reference="motive.component.coversequence"
			force-page-count="no-force">
			<xsl:choose>
				<xsl:when
					test="not(preceding::chapter
                          or preceding::appendix
                          or preceding::article
                          or preceding::dedication
                          or parent::part
                          or parent::reference)">
					<!-- if there is a preceding component or we're in a part, the -->
					<!-- page numbering will already be adjusted -->
					<xsl:attribute name="initial-page-number">1</xsl:attribute>
				</xsl:when>
				<xsl:otherwise/>
			</xsl:choose>

			<fo:flow flow-name="xsl-region-body">

				<xsl:call-template name="document.status.bar"/>


				<!-- big chapter number -->
				<!-- moved id to here from the preceding page-sequence, for jcbg-76, fop -->

				<fo:block-container id="{$id}" absolute-position="fixed" top="2.8in" right=".85in"
					left="4.5in" z-index="-1" text-align="{$motive.component.cover.text.align}">
					<fo:block width="3in" color="silver" font-size="250pt">
						<xsl:choose>
							<xsl:when test="local-name(.) = 'chapter'">
								<xsl:number from="book" count="chapter" format="1" level="any"/>
							</xsl:when>
							<xsl:when test="local-name(.) = 'appendix'">
								<xsl:number from="book" count="appendix" format="A" level="any"/>
							</xsl:when>
							<xsl:otherwise/>
						</xsl:choose>
					</fo:block>
				</fo:block-container>
				<!-- title -->
				<fo:block-container absolute-position="fixed" top="3.06in" left=".78in"
					text-align="{$motive.component.cover.text.align}">

					<fo:table table-layout="fixed">
						<fo:table-column column-width="6.84in"/>
						<fo:table-body>
							<fo:table-row height="1.66in">
								<xsl:attribute name="border-bottom-width">1pt</xsl:attribute>
								<xsl:attribute name="border-bottom-style">solid</xsl:attribute>
								<xsl:attribute name="border-bottom-color">black</xsl:attribute>
								<fo:table-cell display-align="after">
									<fo:block
										margin-left="{$motive.component.cover.title.left.margin}"
										width="{$motive.component.cover.title.block.width}"
										font-size="{$motive.component.cover.title.font.size}">
										<xsl:apply-templates select="title" mode="motive.cover.mode"
										/>
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
						</fo:table-body>
					</fo:table>
				</fo:block-container>
				<!-- 				  <fo:block-container -->
				<!-- 					absolute-position="fixed" -->
				<!-- 					top="8.7in" -->
				<!-- 					left=".5in" -->
				<!-- 					right=".5in"> -->
				<!-- 					<fo:block -->
				<!-- 					  width="7.5in" -->
				<!-- 					  color="silver" -->
				<!-- 					  font-family="Helvetica" -->
				<!-- 					  text-align="center" -->
				<!-- 					  font-size="40pt"> -->
				<!-- 					  <xsl:value-of select="$motive.footer.text"/> -->
				<!-- 					</fo:block> -->
				<!-- 				  </fo:block-container> -->
				<!-- toc -->
				<xsl:if test="section or simplesect">
					<fo:block-container absolute-position="fixed" top="5.66in" left="1in"
						text-align="left">
						<fo:block space-after.optimum=".75em" font-weight="bold" font-size="11pt">
							<xsl:choose>
								<xsl:when test="self::chapter">
									<xsl:call-template name="gentext">
										<xsl:with-param name="key" select="'ThisChapterCovers'"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:when test="self::appendix">
									<xsl:call-template name="gentext">
										<xsl:with-param name="key" select="'ThisAppendixCovers'"/>
									</xsl:call-template>
								</xsl:when>
							</xsl:choose>
						</fo:block>

						<fo:list-block>
							<!-- generate list of titles text -->
							<!-- Note the [] filter on the for-each...it selects only sections/simplesects
			          whose position is <19, so that if you have more than 18 sections, the extra
			          ones (which will not fit on the page) are omitted from the local TOC. -->
							<xsl:for-each
								select="section[position() &lt; 19]|simplesect[position() &lt; 19]">
								<fo:list-item space-after=".30em">
									<fo:list-item-label end-indent="label-end()"
										provisional-distance-between-starts=".2in">
										<fo:block padding-top=".2em" font-family="ZapfDingbats"
											font-size="9pt">&#x25A0;</fo:block>
									</fo:list-item-label>
									<fo:list-item-body start-indent="body-start()">
										<fo:block width="6in">
											<fo:basic-link>
												<xsl:attribute name="internal-destination">
												<xsl:call-template name="object.id"/>
												</xsl:attribute>
												<xsl:value-of select="title"/>
											</fo:basic-link>
										</fo:block>
									</fo:list-item-body>
								</fo:list-item>
							</xsl:for-each>
						</fo:list-block>
						<!-- list of section titles -->

					</fo:block-container>
				</xsl:if>

				<!-- page number -->
				<fo:block-container absolute-position="fixed" top="10.05in" right="1.3in"
					left="5.2in" text-align="{$motive.component.cover.text.align}">
					<fo:block width="1in" font-size="9pt" font-weight="bold">
						<fo:page-number/>
					</fo:block>
				</fo:block-container>
			</fo:flow>
		</fo:page-sequence>

	</xsl:template>

	<xsl:template name="motive.part.cover">
		<xsl:param name="id"/>
		<!-- this template is called from component.xsl -->
		<!-- put page sequence that holds cover/title for chapters and appendices. -->
		<!-- What about parts? -->
		<!-- TODO: move chapter's id to here -->
		<fo:page-sequence id="{$id}" hyphenate="{$hyphenate}"
			master-reference="motive.component.coversequence" force-page-count="even">
			<xsl:choose>
				<xsl:when test="not(preceding::part) and not(preceding::chapter)">
					<!-- if there is a preceding part -->
					<!-- page numbering will already be adjusted -->
					<xsl:attribute name="initial-page-number">1</xsl:attribute>
				</xsl:when>
				<xsl:otherwise/>
			</xsl:choose>

			<fo:flow flow-name="xsl-region-body">


				<xsl:call-template name="document.status.bar"/>


				<!-- big chapter number -->
				<!--fo:block-container
		  absolute-position="fixed"
		  top="2.5in"
		  left="3.75in"
		  text-align="{$motive.component.cover.text.align}">
		  <fo:block
			width="3in"
			color="silver"
			font-size="250pt">
			<xsl:choose>
			  <xsl:when test="local-name(.) = 'chapter'">
				<xsl:number from="book" count="chapter" format="1" level="any"/>
			  </xsl:when>
			  <xsl:when test="local-name(.) = 'appendix'">
				<xsl:number from="book" count="appendix" format="A" level="any"/>
			  </xsl:when>
			  <xsl:otherwise></xsl:otherwise>
			</xsl:choose>
			</fo:block>
		</fo:block-container-->
				<!-- title -->
				<fo:block-container absolute-position="fixed" top="3.06in" left=".78in"
					text-align="{$motive.component.cover.text.align}">

					<fo:table table-layout="fixed">
						<fo:table-column column-width="6.84in"/>
						<fo:table-body>
							<fo:table-row height="1.66in">
								<xsl:attribute name="border-bottom-width">1pt</xsl:attribute>
								<xsl:attribute name="border-bottom-style">solid</xsl:attribute>
								<xsl:attribute name="border-bottom-color">black</xsl:attribute>
								<fo:table-cell display-align="after">
									<fo:block
										margin-left="{$motive.component.cover.title.left.margin}"
										width="{$motive.component.cover.title.block.width}"
										font-size="{$motive.component.cover.title.font.size}">
										<xsl:apply-templates select="title|partinfo/title"
											mode="motive.cover.mode"/>
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
						</fo:table-body>
					</fo:table>
				</fo:block-container>
				<!-- 				  <fo:block-container -->
				<!-- 					absolute-position="fixed" -->
				<!-- 					top="8.7in" -->
				<!-- 					left=".5in" -->
				<!-- 					right=".5in"> -->
				<!-- 					<fo:block -->
				<!-- 					  width="7.5in" -->
				<!-- 					  color="silver" -->
				<!-- 					  font-family="Helvetica" -->
				<!-- 					  text-align="center" -->
				<!-- 					  font-size="40pt"> -->
				<!-- 					  <xsl:value-of select="$motive.footer.text"/> -->
				<!-- 					</fo:block> -->
				<!-- 				  </fo:block-container> -->
				<!-- toc -->
				<xsl:if test="chapter">
					<fo:block-container absolute-position="fixed" top="5.66in" left="1in"
						text-align="left">
						<fo:block space-after.optimum=".75em" font-weight="bold" font-size="11pt">
							<xsl:call-template name="gentext">
								<xsl:with-param name="key" select="'ThisPartCovers'"/>
							</xsl:call-template>
						</fo:block>

						<fo:list-block>
							<xsl:for-each select="chapter|appendix">
								<fo:list-item space-after=".65em">
									<fo:list-item-label end-indent="label-end()"
										provisional-distance-between-starts=".2in">
										<fo:block padding-top=".1em" font-family="ZapfDingbats"
											font-size="9pt">&#x25A0;</fo:block>
									</fo:list-item-label>
									<fo:list-item-body start-indent="body-start()">
										<fo:block width="4in">
											<!-- FIXME: use xref code -->
											<fo:basic-link>
												<xsl:attribute name="internal-destination">
												<xsl:call-template name="object.id"/>
												</xsl:attribute>
												<xsl:apply-templates select="." mode="xref-to"/>
												<!-- <xsl:choose> -->
												<!-- <xsl:when test="self::chapter"><xsl:call-template name="gentext"> -->
												<!-- 			  <xsl:with-param name="key" select="'Chapter'"></xsl:with-param> -->
												<!-- 			</xsl:call-template><xsl:text> </xsl:text><xsl:number from="book" -->
												<!-- 					  count="chapter" format="1" -->
												<!-- 					  level="any"/>, <xsl:call-template name="gentext.startquote"/><xsl:value-of select="title"/><xsl:call-template name="gentext.endquote"/> -->
												<!-- </xsl:when> -->
												<!-- <xsl:when test="self::appendix"><xsl:call-template name="gentext"> -->
												<!-- 			  <xsl:with-param name="key" select="'Appendix'"></xsl:with-param> -->
												<!-- 			</xsl:call-template><xsl:text> </xsl:text><xsl:number from="book" -->
												<!-- 					  count="appendix" format="A" -->
												<!-- 					  level="any"/>, <xsl:call-template name="gentext.startquote"/><xsl:value-of select="title"/><xsl:call-template name="gentext.endquote"/> -->
												<!-- </xsl:when> -->
												<!-- </xsl:choose> -->
											</fo:basic-link>
										</fo:block>
									</fo:list-item-body>
								</fo:list-item>
							</xsl:for-each>
						</fo:list-block>
						<!-- list of section titles -->

					</fo:block-container>
				</xsl:if>

				<!-- page number -->
				<!--fo:block-container
		  absolute-position="fixed"
		  top="9.33in"
		  left="6.65in"
		  text-align="{$motive.component.cover.text.align}">
		  <fo:block
			width=".2in"
			font-size="9pt"
			font-weight="bold">
			<fo:page-number/>
		  </fo:block>
		</fo:block-container-->
			</fo:flow>
		</fo:page-sequence>

	</xsl:template>
	<!-- @#@ the insert-cover template -->
	<xsl:template name="insert-cover">
		<xsl:param name="title"/>
		<xsl:param name="document.element"/>
		<xsl:if test="$omit.cover = ''">
			<fo:page-sequence format="i" master-reference="coversequence">
				<!-- Use no-force to prevent a blank page after the
cover. -->
				<xsl:attribute name="force-page-count">no-force</xsl:attribute>
				<fo:flow flow-name="xsl-region-body">

					<!-- LOGO
						inserting cover logo via a block-container w abs pos, for jcbg-76; this works as a way to place some art, 
					but i'm using the background image above instead -->


					<fo:block-container absolute-position="absolute" top="0" left="0"
						background-repeat="no-repeat">
						<!-- position is top 0, left 0 because earlier box positions the logo -->

						<fo:block>
							<fo:external-graphic>
								<xsl:attribute name="src">
									<xsl:value-of
										select="translate(concat('url(',$cover.path,')'),'\','/')"/>
								</xsl:attribute>
								<!-- enlarge it from 5mm to 7mm height -->
								<xsl:attribute name="content-height">150%</xsl:attribute>
							</fo:external-graphic>
						</fo:block>
					</fo:block-container>

					<!-- Put whatever fo you want here. Note that if
  you don't put at least _something_ on the
  cover, the page isn't generated. So if you
  have a cover graphic that already has the
  title on it, you need to put some kind of
  invisible character here, like a . that's 1pt.
-->



					<!-- cover text @#@ -->


					<fo:block-container absolute-position="fixed"
						text-align="{$motive.cover.text.align}" top="7.8cm"
						left="{$motive.cover.title.left.margin}" right="{$motive.cover.title.right.margin}">
						<!-- top is from MARGIN of the region-body to baseline of first line of text -->

						<!-- product number, name, and version -->
						<fo:block width="{$motive.cover.title.block.width}" color="grey"
							font-weight="bold" font-family="{$motive.cover.title.font-family}"
							font-size="{$motive.cover.productnumber.font.size}">
							<xsl:value-of select="/book/bookinfo/productnumber"/>
							<xsl:text> </xsl:text>
							<xsl:value-of select="/book/bookinfo/productname"/>
						</fo:block>
						<!-- release in a sep block so that it gets a newline -->
						<fo:block width="{$motive.cover.title.block.width}" color="grey"
							font-weight="bold" font-family="{$motive.cover.title.font-family}"
							font-size="{$motive.cover.productnumber.font.size}">
							<xsl:value-of select="/book/bookinfo/releaseinfo"/>
						</fo:block>
					</fo:block-container>

					<fo:block-container absolute-position="fixed"
						text-align="{$motive.cover.text.align}" top="11.3cm"
						left="{$motive.cover.title.left.margin}" right="{$motive.cover.title.right.margin}" >
						<!-- title -->
						<!-- do we have to put position on a block container? maybe so -->
						<fo:block width="{$motive.cover.title.block.width}" color="black"
							font-weight="bold" font-family="{$motive.cover.title.font-family}"
							font-size="{$motive.cover.productnumber.font.size}">
							<xsl:copy-of select="$title"/>
						</fo:block>


					</fo:block-container>

					<!-- now the rest of cover text items, grouped in a table to create new lines-->


					<fo:block-container absolute-position="fixed"
						text-align="{$motive.cover.text.align}" top="14.3cm"
						left="{$motive.cover.title.left.margin}" right="{$motive.cover.title.right.margin}">
						<fo:table table-layout="fixed">
							<fo:table-column column-width="{$motive.cover.title.block.width}"/>
							<fo:table-body>

								<!-- row height measures from bottom of row above, to bottom of this row; full height
										of the row. If < than font+ some min, seems to be ignored-->

								<fo:table-row height=".22in">
									<fo:table-cell display-align="after">
										<fo:block width="{$motive.cover.title.block.width}"
											color="black" font-weight="bold"
											font-family="{$motive.cover.title.font-family}"
											font-size="{$motive.cover.subtitle.font.size}">
											<xsl:value-of select="/book/bookinfo/biblioid"/>
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
								<!-- issue number: note that it's under an IF and doesn't appear if not set -->
								<xsl:if test="/book/bookinfo/issuenum !=''">
									<fo:table-row height=".22in">
										<fo:table-cell display-align="after">
											<fo:block width="{$motive.cover.title.block.width}"
												color="black" font-weight="bold"
												font-family="{$motive.cover.title.font-family}"
												font-size="{$motive.cover.subtitle.font.size}">
												Issue <xsl:value-of select="/book/bookinfo/issuenum"
												/>
											</fo:block>
										</fo:table-cell>
									</fo:table-row>
								</xsl:if>
								<fo:table-row height=".22in">
									<fo:table-cell display-align="after">
										<fo:block width="{$motive.cover.title.block.width}"
											color="black" font-weight="bold"
											font-family="{$motive.cover.title.font-family}"
											font-size="{$motive.cover.subtitle.font.size}">

											<xsl:value-of select="/book/bookinfo/pubdate"/>


										</fo:block>
									</fo:table-cell>
								</fo:table-row>

							</fo:table-body>
						</fo:table>
					</fo:block-container>
					<fo:block-container absolute-position="fixed"
						text-align="{$motive.cover.text.align}" top="6in"
						left="{$motive.cover.subtitle.left.margin}" right="0in">

						<fo:table table-layout="fixed">
							<fo:table-column column-width="{$motive.cover.subtitle.block.width}"/>
							<fo:table-body>
								<fo:table-row height="4in">
									<fo:table-cell display-align="before">

										<fo:block width="{$motive.cover.subtitle.block.width}"
											padding-right="1in" color="black" font-weight="normal"
											font-family="{$motive.cover.subtitle.font-family}"
											font-size="{$motive.cover.subtitle.font.size}">
											<xsl:apply-templates
												select="$document.element/subtitle[1]"
												mode="motive.cover.mode"/>
										</fo:block>

									</fo:table-cell>
								</fo:table-row>
							</fo:table-body>
						</fo:table>
					</fo:block-container>
					<xsl:choose>
						<xsl:when test="$draft.mode = 'no'">
							<!-- nop -->
						</xsl:when>
						<xsl:when
							test="$draft.mode = 'yes' or ancestor-or-self::*[@status][1]/@status = 'draft'">
							<fo:block-container absolute-position="fixed" top="7in" left="1.75in"
								right="1.75in">
								<fo:block width="5in" color="silver" font-family="Helvetica"
									text-align="center" font-size="80pt"> DRAFT </fo:block>
							</fo:block-container>
						</xsl:when>
						<xsl:when
							test="
				  $nda.footer = 'true' or
			      $protected = 'yes' or 
				  $security = 'internal' or
				  $security = 'writeronly' or
				  $security = 'reviewer'">
							<fo:block-container absolute-position="fixed" top="7.2in" left=".5in"
								right=".5in">
								<fo:block width="7.5in" color="silver" font-family="Helvetica"
									text-align="center" font-size="20pt">
									<xsl:value-of select="$motive.footer.text"/>
								</fo:block>
								<xsl:copy-of select="$internal-proprietary"/>
							</fo:block-container>
						</xsl:when>
						<xsl:otherwise>
							<!-- nop -->
						</xsl:otherwise>
					</xsl:choose>
					<!-- old placement of releaseinfo, lower right corner
	<fo:block-container 
				absolute-position="fixed"
				top="8.5in"
				left="6.67in"
				right="0in"
				text-align="left"
				>

			  	<fo:block
				  width="1.33in"
				  color="black" 
				  font-weight="normal"
				  font-family="{$motive.cover.subtitle.font-family}" 
				  font-size="{$motive.cover.subtitle.font.size}">
				  <xsl:value-of select="/book/bookinfo/releaseinfo"/>
				</fo:block>
			  </fo:block-container> -->


				</fo:flow>
			</fo:page-sequence>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
