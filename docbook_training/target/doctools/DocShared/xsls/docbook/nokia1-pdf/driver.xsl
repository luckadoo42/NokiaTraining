<?xml version='1.0'?>

<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
  xmlns:rx="http://www.renderx.com/XSL/Extensions" exclude-result-prefixes="doc" version="1.1">


  <!-- imports @#@ -->

  <!-- import the files we need from elsewhere -->
  <xsl:import href="../motive-pdf/main.xsl"/>
  <xsl:import href="../common/olink.xsl"/>

  <!-- JCBG-1983: Rotate figures that have the "dbfo landscape-figure" PI -->
  <xsl:template match="figure[processing-instruction('dbfo') = 'landscape-figure']">
    <fo:block-container reference-orientation="90">
      <xsl:apply-imports/>
    </fo:block-container>
  </xsl:template>

  <!-- JCBG-1727: Add PDF metadata to FOP output -->
  <xsl:template name="fop-document-information">

    <xsl:variable name="title">
      <xsl:apply-templates select="/*[1]" mode="label.markup"/>
      <xsl:apply-templates select="/*[1]" mode="title.markup"/>
    </xsl:variable>

    <fo:declarations>
      <x:xmpmeta xmlns:x="adobe:ns:meta/">
	<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
	  <rdf:Description rdf:about=""
			   xmlns:dc="http://purl.org/dc/elements/1.1/"
			   xmlns:pdf="http://ns.adobe.com/pdf/1.3/">

	    <!-- Dublin Core properties go here -->
	    <dc:title><xsl:value-of select="normalize-space($title)"/></dc:title>
	    <dc:creator>Nokia</dc:creator>
	    <pdf:Keywords>
Vol 1 of 1 <xsl:value-of select="//biblioid[1]"/> Issue 1 Date <xsl:value-of select="//pubdate[1]"/>

            <!-- Also, include any keywords that are in the document ... -->
	    <xsl:for-each select="//keyword">
	      <xsl:value-of select="normalize-space(.)"/>
	      <xsl:if test="position() != last()">
		<xsl:text>, </xsl:text>
	      </xsl:if>
	    </xsl:for-each>
	  </pdf:Keywords>
	</rdf:Description>

	<rdf:Description rdf:about=""
			 xmlns:xmp="http://ns.adobe.com/xap/1.0/">
	  <!-- XMP properties go here -->
	  <xmp:CreatorTool>FOP</xmp:CreatorTool>
	</rdf:Description>
	</rdf:RDF>
      </x:xmpmeta>
    </fo:declarations>
  </xsl:template>

  <xsl:variable name="ISSUE">
    <xsl:choose>
      <!-- first, use issuenum, when not null -->
      <xsl:when test="//issuenum[1] !=''"><xsl:value-of select="//issuenum[1]"/></xsl:when>
      <!-- next, use edition, when not null -->
      <xsl:when test="//edition[1] !=''"><xsl:value-of select="//edition[1]"/></xsl:when>
      <xsl:otherwise/> <!-- otherwise null-->
    </xsl:choose>
  </xsl:variable>

 <xsl:variable name="header.footer.borders">0</xsl:variable> <!-- set this to 1 to turn on borders, anything else turns them off; these are purely for debuggging purposes -->

  <!-- import files changed for this branding  -->
  <xsl:include href="cover.xsl"/>



  <!-- For JCBG-823: create a covertitle var from value of a covertitle PI 
  <xsl:variable name="covertitle">
    <xsl:value-of select="//processing-instruction('covertitle')"/>
    <xsl:message>driver.xsl defines covertitle as <xsl:value-of select="//processing-instruction('covertitle')"/></xsl:message>
  </xsl:variable>
  -->

 

  <!-- override various parameters  @#@ -->
  <xsl:param name="double.sided" select="1"/>

  <!-- undoing these overrides to return to original layout
  <xsl:param name="body.margin.bottom" select="'.1n'"/>
  <xsl:param name="body.margin.top" select="'0.5in'"/>
  <xsl:param name="page.margin.inner" select="'1.5cm'"/>
 <xsl:param name="body.start.indent" select="'4.5cm'"/> -->
  <!-- this has no effect, but it should b/c we are using post-1.68 xsls -->
  <!-- <xsl:param name="title.margin.left" select="'-3cm'"/> -->

  <!-- override the motive-pdf body font with one for nokia -->
  <xsl:param name="body.font.family"
    select="'Arial,sans-serif,ZapfDingbats,LucidaSansUnicode,KozMinPro-Regular-Acro'"/>

  <!-- revert to original fonts to make layouts more secure 
<xsl:param name="body.font.family" select="'Cheltenham,CheltenhamCdITC,CheltenhamCdITC-Light,CheltenhamCdITC-LightItalic,CheltenhamCdITC-Bold,CheltenhamCdITC-BoldItalic,ZapfDingbats'"/>   -->

  <!-- New param added for jcbg-76 to control fonts used when we use italics -->
  <xsl:param name="body.font.italics.family"
    select="'Arial,sans-serif,ZapfDingbats,LucidaSansUnicode,KozMinPro-Regular-Acro'"/>

  <xsl:param name="internal-proprietary">
    <xsl:if test="not($security = 'external') or $nda.footer = 'true'">
      <fo:block text-align="center" font-size=".75em" font-family="Arial"
        space-before.optimum="0.6em">
        <fo:block>Nokia &#8212; Confidential &#8212; Solely for authorized persons</fo:block>
        <fo:block>having a need to know  &#8212; Proprietary &#8212; Use pursuant to Company instructions.  </fo:block>
      </fo:block>
    </xsl:if>
  </xsl:param>






  <!-- includes  @#@ -->
  <xsl:include href="../alcatel-pdf/changebars.xsl"/>

  <!-- parameters changed at global level @#@ -->

  <!--  disable the preface color bar and component (chapter) cover by repl with a white bar -->


  <xsl:param name="motiveprefacecolorbar">
    <xsl:value-of
      select="translate(concat($common.graphics.path,'/alcatel2/whiteprefacecolorbar.svg'), '\','/')"
    />
  </xsl:param>

  <!-- testing value: use this instead of the above to have a VISIBLE graphic for the preface color bar, a large 2-boxes thing 
<xsl:param name="motiveprefacecolorbar"><xsl:value-of select="translate(concat($common.graphics.path,'/restore.gif'), '\','/')"/></xsl:param> -->

<!--  <xsl:param name="motive.component.cover.path">
    <xsl:value-of
      select="translate(concat($common.graphics.path,'/alcatel2/whiteprefacecolorbar.svg'), '\','/')"
    />
  </xsl:param> -->



  <xsl:attribute-set name="monospace.properties">
    <xsl:attribute name="font-size">
      <xsl:value-of select="$motive.monospace.font.size"/>
    </xsl:attribute>
  </xsl:attribute-set>

  <!-- section properties @#@ -->

  <xsl:attribute-set name="section.title.level1.properties">
    <xsl:attribute name="font-size">
      <!--     <xsl:value-of select="$body.font.master * 2.0736"/> -->
      <xsl:text>19pt</xsl:text>
    </xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="section.title.level2.properties">
    <xsl:attribute name="font-size">
      <!--     <xsl:value-of select="$body.font.master * 1.728"/> -->
      <xsl:text>17pt</xsl:text>
    </xsl:attribute>
    <xsl:attribute name="margin-left">1.5cm</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="section.title.level3.properties">
    <xsl:attribute name="font-size">
      <!--     <xsl:value-of select="$body.font.master * 1.44"/> -->
      <xsl:text>15pt</xsl:text>
    </xsl:attribute>
    <xsl:attribute name="margin-left">1.5cm</xsl:attribute><!-- for JCBG-1848, changed this value and all deeper titles from 3cm to 1.5cm -->
  </xsl:attribute-set>
  <xsl:attribute-set name="section.title.level4.properties">
    <xsl:attribute name="font-size">
      <!--     <xsl:value-of select="$body.font.master * 1.2"/> -->
      <xsl:text>14pt</xsl:text>
    </xsl:attribute>
    <xsl:attribute name="margin-left">1.5cm</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="section.title.level5.properties">
    <xsl:attribute name="font-size">
      <!--     <xsl:value-of select="$body.font.master"/> -->
      <xsl:text>13pt</xsl:text>
    </xsl:attribute>
    <xsl:attribute name="margin-left">1.5cm</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="section.title.level6.properties">
    <xsl:attribute name="font-size">
      <!--     <xsl:value-of select="$body.font.master"/> -->
      <xsl:text>12pt</xsl:text>
    </xsl:attribute>
    <xsl:attribute name="margin-left">1.5cm</xsl:attribute>
    <xsl:attribute name="font-style">italic</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:attribute-set name="section.title.properties">
    <xsl:attribute name="font-family">
      <xsl:value-of select="$title.font.family"/>
    </xsl:attribute>
    <xsl:attribute name="font-weight">normal</xsl:attribute>
    <!-- 	<xsl:attribute name="margin-left"> -->
    <!-- 	  <xsl:choose> -->
    <!-- This is a hack. For some reason bridge heads are misbehaving. -->
    <!-- When you upgrade the base xsls, try removing this whole attr and see if bridgeheads still work. -->
    <!-- 		<xsl:when test="self::bridgehead">-.5in</xsl:when> -->
    <!-- 		<xsl:otherwise>0in</xsl:otherwise> -->
    <!-- 	  </xsl:choose> -->
    <!-- 	</xsl:attribute> -->
    <!-- font size is calculated dynamically by section.heading template -->
    <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
    <xsl:attribute name="space-before.minimum">.355in</xsl:attribute>
    <xsl:attribute name="space-before.optimum">.375in</xsl:attribute>
    <xsl:attribute name="space-before.maximum">.385in</xsl:attribute>
    <xsl:attribute name="space-after.minimum">.15in</xsl:attribute>
    <xsl:attribute name="space-after.optimum">.20in</xsl:attribute>
    <xsl:attribute name="space-after.maximum">.25in</xsl:attribute>
  </xsl:attribute-set>

  <!-- footer  changes for nokia1 -->

  <!-- footer params taken from motive-pdf/param.xsl and modded -->
  <xsl:attribute-set name="footer.content.properties">
    <xsl:attribute name="font-family">
      <xsl:value-of select="$body.fontset"/>
    </xsl:attribute>
    <xsl:attribute name="margin-left">0in<!-- -.5in --></xsl:attribute>
    <xsl:attribute name="margin-right">0in</xsl:attribute>
  </xsl:attribute-set>
  <xsl:param name="footer.rule" select="0"/>
  <!-- turn off footer rule line -->
  <xsl:param name="footer.column.widths" select="'3 3 3'"/>
  <xsl:param name="footer.table.height" select="'54pt'"/>
  <!-- was 14 pt -->
  <xsl:param name="footers.on.blank.pages" select="1"/>
  <!-- from motive-pdf/pagesetup.xsl -->
  <xsl:param name="nda.footer.text">Nokia Confidential</xsl:param>


  <!-- footer.content originally taken from alcatel2 fo.xsl; rename it to .disabled it or take it out to revert to motive-pdf style footers -->


  <xsl:template name="footer.content">
    <xsl:param name="pageclass" select="''"/>
    <xsl:param name="sequence" select="''"/>
    <xsl:param name="position" select="''"/>
    <xsl:param name="gentext-key" select="''"/>


    <fo:block-container>
      <!-- use this block to add border attributes to anything, and then turn all of them on/off with header.footer.borders -->
       <xsl:if test="$header.footer.borders=1">
         <xsl:attribute name="border-color">black</xsl:attribute>
         <xsl:attribute name="border-style">solid</xsl:attribute>
         <xsl:attribute name="border-width">1pt</xsl:attribute>
       </xsl:if>
      <fo:block>
        <!-- pageclass can be front, body, back -->
        <!-- sequence can be odd, even, first, blank -->
        <!-- position can be left, center, right -->

        <!-- debug 
        [<xsl:value-of select="substring($pageclass,1,2)"/>/<xsl:value-of select="substring($sequence,1,2)"/>/<xsl:value-of select="substring($position,1,2)"/>]  -->
        <xsl:choose>
          <xsl:when test="$pageclass = 'titlepage'">
            <!-- nop; no footer on title pages -->
            <fo:block/>
          </xsl:when>

          <xsl:when
            test="$double.sided != 0 and 
          (
          ($sequence = 'even' and $position='left')
          or (($sequence = 'odd' or $sequence = 'first') and $position='right')
          or ($sequence = 'blank' and $position = 'left')
          )">
            <fo:block margin-top="2pt">
              <fo:page-number/>
            </fo:block>
          </xsl:when>

          <xsl:when
            test="$double.sided != 0 and 
          (
          ($sequence = 'even' and $position='right')
          or (($sequence = 'odd' or $sequence = 'first') and $position='left')
          or  ($sequence = 'blank' and $position = 'right')
          )">
            <!-- Here's the footer block to contain the issue num -->
            <fo:block margin-top="2pt">

              <xsl:if test="$ISSUE !=''">Issue <xsl:value-of select="$ISSUE"/></xsl:if>
            </fo:block>
          </xsl:when>

          <xsl:when test="$position='center'">
            <fo:block margin-top="2pt" text-align="center">
              <!-- [<xsl:value-of select="$sequence"/>] [<xsl:value-of select="$position"/>]  -->
              <xsl:if
                test="/*[local-name(.) = 'book' or local-name(.) = 'article']/*[local-name() = 'bookinfo' or local-name() = 'articleinfo']/biblioid">
                <xsl:value-of
                  select="/*[local-name(.) = 'book' or local-name(.) = 'article']/*[local-name() = 'bookinfo' or local-name() = 'articleinfo']/biblioid"
                />
              </xsl:if>
            </fo:block>
          </xsl:when>
          <xsl:otherwise>
            <!-- nop -->
          </xsl:otherwise>
        </xsl:choose>
      </fo:block>
    </fo:block-container>
  </xsl:template>


  <xsl:template name="footer.table">
    <xsl:param name="pageclass" select="''"/>
    <xsl:param name="sequence" select="''"/>
    <xsl:param name="gentext-key" select="''"/>

    <!-- default is a single table style for all footers -->
    <!-- Customize it for different page classes or sequence location -->

    <xsl:variable name="candidate">
      <fo:table table-layout="fixed" width="100%">
        <xsl:call-template name="foot.sep.rule"/>
        <xsl:choose>
          <xsl:when test="$double.sided != 0 and ($sequence = 'odd' or $sequence = 'first')">
            <fo:table-column column-number="1" column-width="1in"/>
            <fo:table-column column-number="2" column-width="proportional-column-width(1)"/>
            <fo:table-column column-number="3" column-width="1in"/>
          </xsl:when>
          <xsl:when test="$double.sided != 0 and ($sequence = 'even' or $sequence = 'blank')">
            <fo:table-column column-number="1" column-width="1in"/>
            <fo:table-column column-number="2" column-width="proportional-column-width(1)"/>
            <fo:table-column column-number="3" column-width="1in"/>
          </xsl:when>
          <xsl:otherwise>
            <fo:table-column column-number="1" column-width="proportional-column-width(1)"/>
            <fo:table-column column-number="2" column-width="proportional-column-width(1)"/>
            <fo:table-column column-number="3" column-width="proportional-column-width(1)"/>
          </xsl:otherwise>
        </xsl:choose>

        <fo:table-body>
          <fo:table-row height="14pt">
            <fo:table-cell>
              <xsl:attribute name="text-align">left</xsl:attribute>
              <xsl:attribute name="display-align">after</xsl:attribute>
              
              <xsl:if test="$fop.extensions = 0">
                <xsl:attribute name="relative-align">baseline</xsl:attribute>
              </xsl:if>
              <xsl:choose>
                <xsl:when test="$double.sided != 0 and ($sequence = 'even' or $sequence = 'blank')">
                  <xsl:attribute name="display-align">before</xsl:attribute>


                  <fo:block>
                    <xsl:call-template name="footer.content">
                      <xsl:with-param name="pageclass" select="$pageclass"/>
                      <xsl:with-param name="sequence" select="$sequence"/>
                      <xsl:with-param name="position" select="'left'"/>
                      <xsl:with-param name="gentext-key" select="$gentext-key"/>
                    </xsl:call-template>
                  </fo:block>

                </xsl:when>
                <xsl:otherwise>
                  <fo:block>
                    <xsl:call-template name="footer.content">
                      <xsl:with-param name="pageclass" select="$pageclass"/>
                      <xsl:with-param name="sequence" select="$sequence"/>
                      <xsl:with-param name="position" select="'left'"/>
                      <xsl:with-param name="gentext-key" select="$gentext-key"/>
                    </xsl:call-template>
                  </fo:block>
                </xsl:otherwise>
              </xsl:choose>
            </fo:table-cell>
            <fo:table-cell>
               
              <fo:block  > 
                <xsl:call-template name="footer.content">
                  <xsl:with-param name="pageclass" select="$pageclass"/>
                  <xsl:with-param name="sequence" select="$sequence"/>
                  <xsl:with-param name="position" select="'center'"/>
                  <xsl:with-param name="gentext-key" select="$gentext-key"/>
                </xsl:call-template>
              </fo:block>
              
            </fo:table-cell>
            <fo:table-cell>
              <xsl:attribute name="text-align">right</xsl:attribute>
              <xsl:attribute name="display-align">after</xsl:attribute>
              <xsl:if test="$fop.extensions = 0">
                <xsl:attribute name="relative-align">baseline</xsl:attribute>
              </xsl:if>
              <xsl:choose>
                <xsl:when test="$double.sided != 0 and ($sequence = 'odd' or $sequence = 'first')">
                  <xsl:attribute name="display-align">before</xsl:attribute>
                  <fo:table table-layout="fixed">
                    
                    <fo:table-column column-number="1" column-width="1in"/>
                    <fo:table-body>
                      <fo:table-row height="14pt">
                        <fo:table-cell>
                          <xsl:attribute name="display-align">center</xsl:attribute>
                          <!-- @#@ -->
                          <fo:block>
                            <xsl:call-template name="footer.content">
                              <xsl:with-param name="pageclass" select="$pageclass"/>
                              <xsl:with-param name="sequence" select="$sequence"/>
                              <xsl:with-param name="position" select="'right'"/>
                              <xsl:with-param name="gentext-key" select="$gentext-key"/>
                            </xsl:call-template>
                          </fo:block>
                        </fo:table-cell>
                      </fo:table-row>
                    </fo:table-body>
                  </fo:table>
                </xsl:when>
                <xsl:otherwise>
                  <fo:block>
                    <xsl:call-template name="footer.content">
                      <xsl:with-param name="pageclass" select="$pageclass"/>
                      <xsl:with-param name="sequence" select="$sequence"/>
                      <xsl:with-param name="position" select="'right'"/>
                      <xsl:with-param name="gentext-key" select="$gentext-key"/>
                    </xsl:call-template>
                  </fo:block>
                </xsl:otherwise>
              </xsl:choose>
            </fo:table-cell>
          </fo:table-row>
        </fo:table-body>
      </fo:table>

    </xsl:variable>

    <!-- Really output a footer? -->
    <xsl:choose>
      <xsl:when test="$pageclass='titlepage' and $gentext-key='book'
        and $sequence='first'">
        <!-- no, book titlepages have no footers at all -->
        <xsl:copy-of select="$internal-proprietary"/>
      </xsl:when>
      <xsl:when test="$sequence = 'blank' and $footers.on.blank.pages = 0">
        <!-- no output -->
        <xsl:copy-of select="$internal-proprietary"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$candidate"/>
        <xsl:copy-of select="$internal-proprietary"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  
  <!-- ==================================================================== -->



  <!-- headers -->

  <xsl:param name="suppress.headers" select="0"/>
  <!-- probably don't need, but can't hurt -->
  <xsl:param name="header.rule" select="1"/>


  <!-- header.column.widths.preface needs a wide last col for preface/index/gloss titles to be wider, use more page space -->
  <xsl:param name="header.column.widths.preface" select="'1 1 9'"/>
  <xsl:param name="header.column.widths" select="'9 1 9'"/>

  <xsl:template name="head.sep.rule">
    <xsl:param name="pageclass"/>
    <xsl:param name="sequence"/>
    <xsl:param name="gentext-key"/>

    <xsl:if
      test="$header.rule != 0 and $pageclass='body' or ($sequence !='first' and ($pageclass='body-preface' or $pageclass = 'index'))">
      <!-- put rule on body, and on non-first body-preface, and index pages -->
      <!--    <xsl:if test="$header.rule != 0 and $pageclass != 'titlepage' and $pageclass != 'lot' and ($sequence != 'first')"> j-->
      <xsl:attribute name="border-bottom-width">1pt</xsl:attribute>
      <xsl:attribute name="border-bottom-style">solid</xsl:attribute>
      <xsl:attribute name="border-bottom-color">black</xsl:attribute>
    </xsl:if>
  </xsl:template>



  <xsl:template name="header.table">
    <xsl:param name="pageclass" select="''"/>
    <xsl:param name="sequence" select="''"/>
    <xsl:param name="gentext-key" select="''"/>

    <!-- default is a single table style for all headers -->
    <!-- Customize it for different page classes or sequence location -->

    <!--   <xsl:choose> -->
    <!--       <xsl:when test="$pageclass = 'index'"> -->
    <!--           <xsl:attribute name="margin-left">0pt</xsl:attribute> -->
    <!--       </xsl:when> -->
    <!--   </xsl:choose> -->

    <xsl:param name="node" select="."/>
    <xsl:variable name="id">
      <xsl:call-template name="object.id">
        <xsl:with-param name="object" select="$node"/>
      </xsl:call-template>
    </xsl:variable>

    <!-- debug message: shows what pageclass and sequences are being used  
    <xsl:message>header.table: pageclass=<xsl:value-of select="$pageclass"/>, sequence=<xsl:value-of select="$sequence"/></xsl:message> -->

    <!-- Set the col type... i'm not too sure what this is for actually, but you need a 3 for 'first' AND a 1 1 9 for header widths for preface headers to be wide enough -->

    <xsl:variable name="column1">
      <xsl:choose>
        <xsl:when test="$double.sided = 0">1</xsl:when>
        <xsl:when test="$sequence = 'first' or $sequence = 'odd'">1</xsl:when>
        <xsl:otherwise>3</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="column3">
      <xsl:choose>

        <xsl:when test="$sequence = 'first' or $sequence = 'odd'">3</xsl:when>
        <xsl:when test="$double.sided = 0">3</xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="candidate">
     
    
      <!--I really don't get why, but the header is not using same width as footer; I came up with settings below for width and margin via trial and error. Note that
        the header width is diff on body pages if you don't use these numbers. -->
      <fo:table table-layout="fixed" width="6.2in" margin-left=".7in"> 
        
        <!-- use this block to add border attributes to anything, and then turn all of them on/off with header.footer.borders -->
        <xsl:if test="$header.footer.borders=1">
          <xsl:attribute name="border-color">black</xsl:attribute>
          <xsl:attribute name="border-style">solid</xsl:attribute>
          <xsl:attribute name="border-width">1pt</xsl:attribute>
        </xsl:if>
        
        <xsl:call-template name="head.sep.rule">
          <xsl:with-param name="pageclass" select="$pageclass"/>
          <xsl:with-param name="sequence" select="$sequence"/>
          <xsl:with-param name="gentext-key" select="$gentext-key"/>
        </xsl:call-template>

        <fo:table-column>
          <xsl:attribute name="column-width">
            <xsl:text>proportional-column-width(</xsl:text>
            <xsl:call-template name="header.footer.width">
              <xsl:with-param name="location">header</xsl:with-param>
              <xsl:with-param name="position" select="$column1"/>
              <xsl:with-param name="pageclass" select="$pageclass"/>
              <xsl:with-param name="sequence" select="$sequence"/>
            </xsl:call-template>
            <xsl:text>)</xsl:text>
          </xsl:attribute>
        </fo:table-column>
        <fo:table-column column-number="2">
          <xsl:attribute name="column-width">
            <xsl:text>proportional-column-width(</xsl:text>
            <xsl:call-template name="header.footer.width">
              <xsl:with-param name="location">header</xsl:with-param>
              <xsl:with-param name="position" select="2"/>
              <xsl:with-param name="pageclass" select="$pageclass"/>
              <xsl:with-param name="sequence" select="$sequence"/>
            </xsl:call-template>
            <xsl:text>)</xsl:text>
          </xsl:attribute>
        </fo:table-column>
        <fo:table-column column-number="3">
          <xsl:attribute name="column-width">
            <xsl:text>proportional-column-width(</xsl:text>
            <xsl:call-template name="header.footer.width">
              <xsl:with-param name="location">header</xsl:with-param>
              <xsl:with-param name="position" select="$column3"/>
              <xsl:with-param name="pageclass" select="$pageclass"/>
              <xsl:with-param name="sequence" select="$sequence"/>
            </xsl:call-template>
            <xsl:text>)</xsl:text>
          </xsl:attribute>
        </fo:table-column>

        <fo:table-body>
          <fo:table-row>
            <xsl:attribute name="block-progression-dimension.minimum">
              <xsl:value-of select="$header.table.height"/>
            </xsl:attribute>
            <fo:table-cell text-align="left" display-align="before">
          
              <!-- if using FOP, then add this attribute... why did we add this? now getting an issue with this...ok, without it, 
                fop text starts at left edge; with it, starts .7 padded; both are wrong 
              <xsl:if test="$fop.extensions = 1">
                <xsl:attribute name="padding-left">0.7in</xsl:attribute>               
              </xsl:if> --> 
              
              <xsl:if test="$fop.extensions = 0">
                <xsl:attribute name="relative-align">baseline</xsl:attribute>
              </xsl:if>
              <fo:block>
                <xsl:call-template name="header.content">
                  <xsl:with-param name="pageclass" select="$pageclass"/>
                  <xsl:with-param name="sequence" select="$sequence"/>
                  <xsl:with-param name="position" select="'left'"/>
                  <xsl:with-param name="gentext-key" select="$gentext-key"/>
                </xsl:call-template>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell text-align="center" display-align="before">
              <xsl:if test="$fop.extensions = 0">
                <xsl:attribute name="relative-align">baseline</xsl:attribute>
              </xsl:if>
              <fo:block>
                
                <xsl:call-template name="header.content">
                  <xsl:with-param name="pageclass" select="$pageclass"/>
                  <xsl:with-param name="sequence" select="$sequence"/>
                  <xsl:with-param name="position" select="'center'"/>
                  <xsl:with-param name="gentext-key" select="$gentext-key"/>
                </xsl:call-template>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell text-align="right" display-align="before">

         
              <!-- for JCBG-76, fop adjustments: in FOP, the table, at fixed and 100%, is 0.7in farther to the right, putting the
                headers in the right margin; this padding fixes that. But if you use it in XEP, it makes the items be right-indented by 0.7in too much. 
              
              also, we need to avoid it in preface headers...
                  unfortunately we need to express that as a not, so we have
                    $fop.extensions = 1 and (($pageclass != 'body-preface' and $pageclass != 'index' and $pageclass != 'lot' ) or $sequence != 'first')
                    which means, use the padding only if all of these are true:
                       we're using fop
                       pageclass is not one of these (body-preface,index,lot), OR sequence is not first  <- avoids preface pages
                           
              -->
              <xsl:if test="$fop.extensions = 1 and (($pageclass != 'body-preface' and $pageclass != 'index' and $pageclass != 'lot' ) or $sequence != 'first')">
                <xsl:attribute name="padding-right">0.7in</xsl:attribute>
              </xsl:if>

              <!-- if using XEP, then add THIS attribute -->
              <xsl:if test="$fop.extensions = 0">
                <xsl:attribute name="relative-align">baseline</xsl:attribute>
              </xsl:if>


              <fo:block>
                <xsl:call-template name="header.content">
                  <xsl:with-param name="pageclass" select="$pageclass"/>
                  <xsl:with-param name="sequence" select="$sequence"/>
                  <xsl:with-param name="position" select="'right'"/>
                  <xsl:with-param name="gentext-key" select="$gentext-key"/>
                </xsl:call-template>
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
        </fo:table-body>
      </fo:table>
    </xsl:variable>

    <!-- Really output a header? -->
    <xsl:choose>
      <xsl:when
        test="$sequence = 'first' and 
		($pageclass = 'body-preface' or $pageclass = 'index' or $pageclass = 'lot')">
        <fo:block> <!-- removed: has no effect in either fop or xep: space-after=".25in" -->
          <xsl:copy-of select="$candidate"/>
        </fo:block>
      </xsl:when>
      <xsl:when test="$suppress.headers != '0'">
        <!-- no output -->
      </xsl:when>
      <xsl:when
        test="$pageclass = 'titlepage' and $gentext-key = 'book'
                    and $sequence='first'">
        <!-- no, book titlepages have no headers at all -->
      </xsl:when>
      <xsl:when test="$sequence = 'blank' and $headers.on.blank.pages = 0">
        <!-- no output -->
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$candidate"/>
        <!-- actually insert headers on some pages -->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="header.content">
    <xsl:param name="pageclass" select="''"/>
    <xsl:param name="sequence" select="''"/>
    <xsl:param name="position" select="''"/>
    <xsl:param name="gentext-key" select="''"/>


    <fo:block >
      <!-- use this block to add border attributes to anything, and then turn all of them on/off with header.footer.borders -->
      <xsl:if test="$header.footer.borders=1">
        <xsl:attribute name="border-color">black</xsl:attribute>
        <xsl:attribute name="border-style">solid</xsl:attribute>
        <xsl:attribute name="border-width">1pt</xsl:attribute>
      </xsl:if>
      <!-- debug: show important inputs on each header element 
    [<xsl:value-of select="$pageclass"/>/<xsl:value-of select="substring($sequence,1,2)"/>/<xsl:value-of select="substring($position,1,2)"/>]-->

      <!-- sequence can be odd, even, first, blank -->
      <!-- position can be left, center, right -->
      <xsl:choose>


        <xsl:when test="$position = 'center'">
          <!-- nothing in the center of the header, ever; do this first to catch all such cases -->
        </xsl:when>

        <!-- two cases for preface-style header w/ title... 
		    case 1 -->
        <xsl:when
          test="($position = 'right' and $sequence='first') and contains('glossary index preface',local-name(.))">
          <fo:block space-before=".25in" text-align="right" >  <!-- was margin-right=".66in", but put that as fop-only below b/c it right-indents xep -->           
            <xsl:if test="$fop.extensions = 1">
              <xsl:attribute name="margin-right">0.66in</xsl:attribute>
            </xsl:if>
            
            <!-- use this block to add border attributes to anything, and then turn all of them on/off with header.footer.borders -->
            <xsl:if test="$header.footer.borders=1">
              <xsl:attribute name="border-color">black</xsl:attribute>
              <xsl:attribute name="border-style">solid</xsl:attribute>
              <xsl:attribute name="border-width">1pt</xsl:attribute>
            </xsl:if>
            
            <fo:inline font-size="30pt">
              <xsl:apply-templates select="." mode="object.title.markup">
                <xsl:with-param name="allow-anchors" select="1"/>
              </xsl:apply-templates>
            </fo:inline>
          </fo:block>
        </xsl:when>
        <!-- case 2 -->
        <xsl:when
          test="($position = 'right' and $sequence='first') and ($pageclass = 'body-preface' or $pageclass = 'index' or $pageclass = 'lot')">
          <fo:block space-before=".25in" text-align="right" >  <!-- was margin-right=".66in", but put that as fop-only below b/c it right-indents xep -->           
            <xsl:if test="$fop.extensions = 1">
              <xsl:attribute name="margin-right">0.66in</xsl:attribute>
            </xsl:if>
            <!-- use this block to add border attributes to anything, and then turn all of them on/off with header.footer.borders -->
            <xsl:if test="$header.footer.borders=1">
              <xsl:attribute name="border-color">black</xsl:attribute>
              <xsl:attribute name="border-style">solid</xsl:attribute>
              <xsl:attribute name="border-width">1pt</xsl:attribute>
            </xsl:if>
            
            <fo:inline font-size="30pt">
              <xsl:call-template name="gentext">
                <xsl:with-param name="key" select="'TableofContents'"/>
              </xsl:call-template>
            </fo:inline>
          </fo:block>
        </xsl:when>
        
        <!-- the next case is same as above two, but for when position != right ... thus it makes sure the first two positions of preface pages are empty -->
        <xsl:when test="$sequence='first' and (contains('glossary index preface',local-name(.)) or $pageclass = 'body-preface' or $pageclass = 'index' or $pageclass = 'lot')">
          <!-- nothing -->
        </xsl:when>

        <xsl:when test="$pageclass='lot'">
          <!-- nothing -->
        </xsl:when>

        <!-- body pages -->

        <xsl:when
          test="(($sequence='even' or $sequence='blank') and $position='left') or (($sequence='first' or $sequence='odd') and $position='right')">
          <!-- output topic title -->
          <xsl:apply-templates select="."  mode="title.markup"/>
       

        </xsl:when>

        <xsl:when
          test="(($sequence='even' or $sequence='blank') and $position='right') or (($sequence='first'  or $sequence='odd') and $position='left')">
          <!-- output book title -->
          <xsl:apply-templates select="/" mode="title.markup"/>
                 <!-- neither this nor covertitle var seems to work <xsl:value-of  select="//processing-instruction('covertitle')"/> -->
      
        </xsl:when>



      </xsl:choose>
    </fo:block>
  </xsl:template>

  <xsl:template name="header.footer.width">
    <xsl:param name="location" select="'header'"/>
    <xsl:param name="position" select="1"/>
    <xsl:param name="pageclass"/>
    <xsl:param name="sequence"/>

    <xsl:variable name="width.set">
      <xsl:choose>
        <xsl:when test="$location = 'header'">
          <xsl:choose>
            <xsl:when test="$pageclass = 'body-preface' and $sequence = 'first'">
              <xsl:value-of select="normalize-space($header.column.widths.preface)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="normalize-space($header.column.widths)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="normalize-space($footer.column.widths)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="width">
      <xsl:choose>
        <xsl:when test="$position = 1">
          <xsl:value-of select="substring-before($width.set, ' ')"/>
        </xsl:when>
        <xsl:when test="$position = 2">
          <xsl:value-of select="substring-before(substring-after($width.set, ' '), ' ')"/>
        </xsl:when>
        <xsl:otherwise>

          <xsl:value-of select="substring-after(substring-after($width.set, ' '), ' ')"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- Make sure it is a number, default to 1-->
    <xsl:choose>
      <xsl:when test="$width = number($width)">
        <xsl:value-of select="$width"/>
        <!-- debug
      <xsl:message>Successfully found number [<xsl:value-of select="$width"/>] in  <xsl:value-of select="$location"/>.column.widths<xsl:if test="$pageclass='body-preface' and $sequence='first'">.preface</xsl:if> at position <xsl:value-of select="$position"/>  </xsl:message> -->
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>Error: (pc/s:[<xsl:value-of select="$pageclass"/>/<xsl:value-of
            select="$sequence"/>]) value [<xsl:value-of select="$width"/>] in <xsl:value-of
            select="$location"/>.column.widths<xsl:if
            test="$pageclass='body-preface' and $sequence='first'">.preface</xsl:if> at position
            <xsl:value-of select="$position"/> is not a number.</xsl:message>
        <xsl:text>1</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- admonitions @#@ -->
  <xsl:param name="motive.admon.title"/>
  <!-- defining this so can be used -->


  <xsl:param name="admon.graphics.extension" select="'.svg'"/>
  <xsl:param name="admon.graphics" select="0"/>
  <xsl:param name="admon.graphics.path" select="concat($common.graphics.path,'')"/>
  <xsl:param name="admon.textlabel" select="1"/>
  <xsl:attribute-set name="graphical.admonition.properties">
    <xsl:attribute name="space-before.optimum">1em</xsl:attribute>
    <xsl:attribute name="space-before.minimum">0.8em</xsl:attribute>
    <xsl:attribute name="space-before.maximum">1.2em</xsl:attribute>
    <xsl:attribute name="space-after.optimum">1em</xsl:attribute>
    <xsl:attribute name="space-after.minimum">0.8em</xsl:attribute>
    <xsl:attribute name="space-after.maximum">1.2em</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="nongraphical.admonition.properties">
    <xsl:attribute name="space-before.optimum">.5em</xsl:attribute>
    <xsl:attribute name="space-before.minimum">0.4em</xsl:attribute>
    <xsl:attribute name="space-before.maximum">.6em</xsl:attribute>
    <xsl:attribute name="space-after.optimum">1em</xsl:attribute>
    <xsl:attribute name="space-after.minimum">0.8em</xsl:attribute>
    <xsl:attribute name="space-after.maximum">1.2em</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="admonition.title.properties">
    <xsl:attribute name="font-size">12pt</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="hyphenate">false</xsl:attribute>
    <xsl:attribute name="keep-with-next.within-column">auto</xsl:attribute>
    <xsl:attribute name="space-before.optimum">.5em</xsl:attribute>
    <xsl:attribute name="space-before.minimum">0.4em</xsl:attribute>
    <xsl:attribute name="space-before.maximum">.6em</xsl:attribute>
    <xsl:attribute name="space-after.optimum">.5em</xsl:attribute>
    <xsl:attribute name="space-after.minimum">0.4em</xsl:attribute>
    <xsl:attribute name="space-after.maximum">.6em</xsl:attribute>
  </xsl:attribute-set>

  <!-- adding this whole template so can modify the width -->
  <xsl:template name="nongraphical.admonition">
    <xsl:variable name="id">
      <xsl:call-template name="object.id"/>
    </xsl:variable>

    <xsl:variable name="motive.admon.title">
      <xsl:apply-templates select="." mode="object.title.markup"/>
    </xsl:variable>

    <xsl:variable name="motive.admon.title.width">
      <xsl:choose>
        <xsl:when test="string-length($motive.admon.title) &lt; 5">
          <xsl:value-of select="string-length($motive.admon.title) * .63"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="string-length($motive.admon.title) * .67"/>
        </xsl:otherwise>
      </xsl:choose>em</xsl:variable>

    <fo:block space-before.minimum="0.8em" space-before.optimum="1em" space-before.maximum="1.2em"
      id="{$id}">
      <!-- dwc: Putting admon in a single item list to have the label float to the left of the admon body.  -->
      <fo:list-block provisional-distance-between-starts="{$motive.admon.title.width}">
        <fo:list-item>
          <xsl:attribute name="border-top-width">0.5pt</xsl:attribute>
          <xsl:attribute name="border-top-style">solid</xsl:attribute>
          <xsl:attribute name="border-top-color">black</xsl:attribute>
          <xsl:attribute name="border-bottom-width">0.5pt</xsl:attribute>
          <xsl:attribute name="border-bottom-style">solid</xsl:attribute>
          <xsl:attribute name="border-bottom-color">black</xsl:attribute>
          <fo:list-item-label end-indent="label-end()">
            <fo:block xsl:use-attribute-sets="admonition.title.properties">
              <fo:block>
                <xsl:apply-templates select="." mode="object.title.markup"/>
              </fo:block>
            </fo:block>
          </fo:list-item-label>
          <fo:list-item-body start-indent="body-start()">
            <fo:block xsl:use-attribute-sets="admonition.properties">
              <xsl:apply-templates/>
            </fo:block>
          </fo:list-item-body>
        </fo:list-item>
      </fo:list-block>
    </fo:block>
  </xsl:template>


</xsl:stylesheet>
