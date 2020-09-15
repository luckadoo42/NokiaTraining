<?xml version='1.0'?>

<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
  xmlns:rx="http://www.renderx.com/XSL/Extensions"
  exclude-result-prefixes="doc"
  version='1.1'>



  <!-- import the ones we need from elsewhere -->
   <xsl:import href="../motive-pdf/main.xsl"/>
   <xsl:import href="../common/olink.xsl"/>
  
  <!-- import files changed for this branding  -->
    <xsl:import href="cover.xsl"/> 

  <!-- JCBG-1983: Rotate figures that have the "dbfo landscape-figure" PI -->
  <xsl:template match="figure[processing-instruction('dbfo') = 'landscape-figure']">
    <fo:block-container reference-orientation="90">
      <xsl:apply-imports/>
    </fo:block-container>
  </xsl:template>

<!-- override various parameters -->
  <xsl:param name="double.sided" select="0"/>
  <xsl:param name="body.margin.bottom" select="'.75in'"/>
  <xsl:param name="body.margin.top" select="'0.5in'"/>
  <xsl:param name="page.margin.inner" select="'1.5cm'"/>
 <xsl:param name="body.start.indent" select="'4.5cm'"/> <!-- this has no effect, but it should b/c we are using post-1.68 xsls --> 
  <!-- <xsl:param name="title.margin.left" select="'-3cm'"/> -->

  <!-- override the motive-pdf body font with one for nokia -->
  <xsl:param name="body.font.family" select="'Arial,sans-serif,ZapfDingbats,LucidaSansUnicode,KozMinPro-Regular-Acro'"/>

  <!-- was
<xsl:param name="body.font.family" select="'Cheltenham,CheltenhamCdITC,CheltenhamCdITC-Light,CheltenhamCdITC-LightItalic,CheltenhamCdITC-Bold,CheltenhamCdITC-BoldItalic,ZapfDingbats'"/> -->   

  <xsl:param name="internal-proprietary">
    <xsl:if test="not($security = 'external') or $nda.footer = 'true'">
      <fo:block text-align="center" font-size=".75em" font-family="Times"
        space-before.optimum="0.6em">
        <fo:block>Nokia &#8212; Confidential</fo:block>
        <fo:block>Solely for authorized persons having a need to know</fo:block>
        <fo:block>Proprietary &#8212; Use pursuant to Company instructions</fo:block>
      </fo:block>
    </xsl:if>
  </xsl:param>  

<!-- if you put light italic first, then everythign is italic, but cites are still arial italic. 
<xsl:param name="body.font.family" select="'CheltenhamCdITC-LightItalic,Cheltenham,CheltenhamCdITC,CheltenhamCdITC-Light,CheltenhamCdITC-Bold,CheltenhamCdITC-BoldItalic,sans-serif,ZapfDingbats,LucidaSansUnicode,KozMinPro-Regular-Acro'"/>  -->

<!-- this is what we orig used for XEP, and with it, fop finds no Chelt fonts at all 
<xsl:param name="body.font.family" select="'Cheltenham,sans-serif,ZapfDingbats,LucidaSansUnicode,KozMinPro-Regular-Acro'"/> 
-->

<!-- the following works for all except body italic 
<xsl:param name="body.font.family" select="'Cheltenham,CheltenhamCdITC,CheltenhamCdITC-Light,CheltenhamCdITC-Bold,CheltenhamCdITC-Italic,CheltenhamCdITC-BoldItalic,CheltenhamCdITC-LightItalic,sans-serif,ZapfDingbats,LucidaSansUnicode,KozMinPro-Regular-Acro'"/> -->

<!-- shorter font names, listing only chelts; this gives you no bold, no italics...

<xsl:param name="body.font.family" select="'Cheltenham-Light,Cheltenham-Bold,Cheltenham-LightItalic,Cheltenham-BoldItalic'"/> -->

<!--
<xsl:param name="body.font.family" select="'CheltenhamCdITC-Light,CheltenhamCdITC-Bold,CheltenhamCdITC-BoldItalic,CheltenhamCdITC-LightItalic'"/>  gives no bold or ital... -->

<!-- THIS gives you Arial for your body text, Chelt bold for bold, and  no italic... 
<xsl:param name="body.font.family" select="'ITC Cheltenham,CheltenhamCdITC,CheltenhamCdITC-Light,CheltenhamCdITC-LightItalic,CheltenhamCdITC-Bold,CheltenhamCdITC-BoldItalic'"/>   -->


<!-- The following gives Chelt Light, Bold, and Ital, but the Ital is done in Times New Roman (in FOP); this works fine in XEP 
<xsl:param name="body.font.family" select="'Cheltenham,CheltenhamCdITC,CheltenhamCdITC-Light,CheltenhamCdITC-LightItalic,CheltenhamCdITC-Bold,CheltenhamCdITC-BoldItalic,ZapfDingbats'"/>   -->  

<!-- New param added for jcbg-76 to control fonts used when we use italics -->
  <xsl:param name="body.font.italics.family" select="'Arial,sans-serif,ZapfDingbats,LucidaSansUnicode,KozMinPro-Regular-Acro'"/>



  <!-- includes -->
  <xsl:include href="../alcatel-pdf/changebars.xsl"/>
  
  <!-- parameters changed at global level-->
  
  <!--  disable the preface color bar and component (chapter) cover by repl with a white bar -->
  

<xsl:param name="motiveprefacecolorbar"><xsl:value-of select="translate(concat($common.graphics.path,'/alcatel2/whiteprefacecolorbar.svg'), '\','/')"/></xsl:param> 

<!-- testing value: use this instead of the above to have a VISIBLE graphic for the preface color bar, a large 2-boxes thing 
<xsl:param name="motiveprefacecolorbar"><xsl:value-of select="translate(concat($common.graphics.path,'/restore.gif'), '\','/')"/></xsl:param> -->

  <xsl:param name="motive.component.cover.path"><xsl:value-of select="translate(concat($common.graphics.path,'/alcatel2/whiteprefacecolorbar.svg'), '\','/')"/></xsl:param> 

  
  
<xsl:attribute-set name="monospace.properties">
  <xsl:attribute name="font-size"><xsl:value-of select="$motive.monospace.font.size"/></xsl:attribute>
</xsl:attribute-set>

<!-- section properties -->
  
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
    <xsl:attribute name="margin-left">3cm</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="section.title.level4.properties">
    <xsl:attribute name="font-size">
      <!--     <xsl:value-of select="$body.font.master * 1.2"/> -->
      <xsl:text>14pt</xsl:text>
    </xsl:attribute>
    <xsl:attribute name="margin-left">3cm</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="section.title.level5.properties">
    <xsl:attribute name="font-size">
      <!--     <xsl:value-of select="$body.font.master"/> -->
      <xsl:text>13pt</xsl:text>
    </xsl:attribute>
    <xsl:attribute name="margin-left">3cm</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="section.title.level6.properties">
    <xsl:attribute name="font-size">
      <!--     <xsl:value-of select="$body.font.master"/> -->
      <xsl:text>12pt</xsl:text>
    </xsl:attribute>
    <xsl:attribute name="margin-left">3cm</xsl:attribute>
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

  <!-- Header and footer  (original code came from alcatel2/fo.xsl) -->
  <xsl:param name="header.column.widths">3 3 3</xsl:param>
  <xsl:param name="footer.column.widths">3 3 3</xsl:param>
  <xsl:param name="marker.section.level" select="0"/>
  
  <xsl:attribute-set name="header.content.properties">
    <xsl:attribute name="font-family"><xsl:value-of select="$body.font.family"/></xsl:attribute>
    <xsl:attribute name="font-size">9pt</xsl:attribute>
    <xsl:attribute name="font-style">normal</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:attribute-set name="footer.content.properties" use-attribute-sets="header.content.properties"/>
  
  <xsl:template name="head.sep.rule">
    <xsl:param name="pageclass"/>
    <xsl:param name="sequence"/>
    <xsl:param name="gentext-key"/>
    
    <xsl:if test="$header.rule != 0 and $sequence != 'first' and $pageclass != 'titlepage'">
      <xsl:attribute name="border-bottom-width">1pt</xsl:attribute>
      <xsl:attribute name="border-bottom-style">solid</xsl:attribute>
      <xsl:attribute name="border-bottom-color">black</xsl:attribute>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="foot.sep.rule">
    <xsl:param name="pageclass"/>
    <xsl:param name="sequence"/>
    <xsl:param name="gentext-key"/>
    
    <xsl:if test="$footer.rule != 0 and ($pageclass != 'titlepage')">
      <xsl:attribute name="border-top-width">1pt</xsl:attribute>
      <xsl:attribute name="border-top-style">solid</xsl:attribute>
      <xsl:attribute name="border-top-color">black</xsl:attribute>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="header.content">
    <xsl:param name="pageclass" select="''"/>
    <xsl:param name="sequence" select="''"/>
    <xsl:param name="position" select="''"/>
    <xsl:param name="gentext-key" select="''"/>
    
    <!--
  <fo:block>
    <xsl:value-of select="$pageclass"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$sequence"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$position"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$gentext-key"/>
  </fo:block>
-->
    
    <fo:block>
      
      <!-- sequence can be odd, even, first, blank -->
      <!-- position can be left, center, right -->
      <xsl:choose>
        <xsl:when test="$sequence = 'blank'">
          <!-- nothing -->
        </xsl:when>
        
        <xsl:when test="(($position='left' and $double.sided != 0 and $sequence='even') or
          ($position='right' and $double.sided != 0 and $sequence='odd'))
          and $pageclass = 'lot'">
          <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="'TableofContents'"/>
          </xsl:call-template>
        </xsl:when>
        
        <xsl:when test="(($position='left' and $double.sided != 0 and $sequence='even') or
          ($position='right' and $double.sided != 0 and $sequence='odd'))
          and $pageclass != 'titlepage'">
          <xsl:apply-templates select="." mode="object.title.markup"/>
        </xsl:when>
        
        <xsl:when test="$position='center'">
          <!-- nothing for empty and blank sequences -->
        </xsl:when>
        
        <xsl:when test="$position='right'">
          <!-- Same for odd, even, empty, and blank sequences -->
          <xsl:call-template name="draft.text"/>
        </xsl:when>
        
        <xsl:when test="$sequence = 'first'">
          <!-- nothing for first pages -->
        </xsl:when>
        
        <xsl:when test="$sequence = 'blank'">
          <!-- nothing for blank pages -->
        </xsl:when>
      </xsl:choose>
    </fo:block>
  </xsl:template>
  
  <xsl:template name="footer.content">
    <xsl:param name="pageclass" select="''"/>
    <xsl:param name="sequence" select="''"/>
    <xsl:param name="position" select="''"/>
    <xsl:param name="gentext-key" select="''"/>
    
    <!--
  <fo:block>
    <xsl:value-of select="$pageclass"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$sequence"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$position"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$gentext-key"/>
  </fo:block>
-->
    
    <fo:block>
      <!-- pageclass can be front, body, back -->
      <!-- sequence can be odd, even, first, blank -->
      <!-- position can be left, center, right -->
      <xsl:choose>
        <xsl:when test="$pageclass = 'titlepage'">
          <!-- nop; no footer on title pages -->
        </xsl:when>
        
        <xsl:when test="$double.sided != 0 and 
          (
          ($sequence = 'even' and $position='left')
          or (($sequence = 'odd' or $sequence = 'first') and $position='right')
          or ($sequence = 'blank' and $position = 'left')
          )">
          <fo:block margin-top="2pt">
            <xsl:apply-templates mode="page-number-prefix" select="."/>
            <fo:page-number/>
          </fo:block>
          <fo:block><fo:leader/></fo:block>
        </xsl:when>
        
        <xsl:when test="$double.sided != 0 and 
          (
          ($sequence = 'even' and $position='right')
          or (($sequence = 'odd' or $sequence = 'first') and $position='left')
          or  ($sequence = 'blank' and $position = 'right')
          )">
          <!-- standard page footer block starts here -->
          <fo:block margin-top="2pt"><xsl:value-of select="//productnumber[1]"/><xsl:text> </xsl:text><xsl:apply-templates select="/*[1]" mode="title.markup"/><xsl:if test="//releaseinfo[1]">, <xsl:value-of select="//releaseinfo[1]"/></xsl:if></fo:block>
          <fo:block><xsl:value-of select="/*[local-name(.) = 'book' or local-name(.) = 'article']/*[local-name() = 'bookinfo' or local-name() = 'articleinfo']/pubdate"/><xsl:if test="/*[local-name(.) = 'book' or local-name(.) = 'article']/*[local-name() = 'bookinfo' or local-name() = 'articleinfo']/biblioid"><fo:leader leader-pattern="space" leader-length="1.5em"/><xsl:value-of select="/*[local-name(.) = 'book' or local-name(.) = 'article']/*[local-name() = 'bookinfo' or local-name() = 'articleinfo']/biblioid"/></xsl:if><xsl:text> </xsl:text><xsl:value-of select="//edition[1]"/></fo:block>
        </xsl:when>
        <xsl:when test="$sequence='blank'">
          <!-- nop -->
        </xsl:when>
        
        <xsl:otherwise>
          <!-- nop -->
        </xsl:otherwise>
      </xsl:choose>
    </fo:block>
  </xsl:template>


<!-- admonitions -->
  <xsl:param name="motive.admon.title"/> <!-- defining this so can be used -->
 
  
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
    
    <xsl:variable
      name="motive.admon.title.width">
      <xsl:choose>
        <xsl:when test="string-length($motive.admon.title) &lt; 5">
          <xsl:value-of	select="string-length($motive.admon.title) * .63"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of	select="string-length($motive.admon.title) * .67"/>
        </xsl:otherwise>
      </xsl:choose>em</xsl:variable>
    
    <fo:block space-before.minimum="0.8em"
      space-before.optimum="1em"
      space-before.maximum="1.2em"
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
          <fo:list-item-label 
            end-indent="label-end()">
            <fo:block
              xsl:use-attribute-sets="admonition.title.properties">
              <fo:block>
                <xsl:apply-templates select="." mode="object.title.markup"/>
              </fo:block>
            </fo:block>
          </fo:list-item-label>
          <fo:list-item-body  
            start-indent="body-start()">
            <fo:block xsl:use-attribute-sets="admonition.properties">
              <xsl:apply-templates/>
            </fo:block>
          </fo:list-item-body>
        </fo:list-item>
      </fo:list-block>
    </fo:block>
  </xsl:template>


</xsl:stylesheet>
