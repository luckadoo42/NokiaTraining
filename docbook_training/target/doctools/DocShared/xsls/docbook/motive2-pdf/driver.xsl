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
            <dc:creator>Alcatel-Lucent</dc:creator>
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
  
<!-- to use TTF cheltenhams... (when those are supplied in the fonts dir)
    <xsl:param name="body.font.family" select="'Cheltenham-Normal, Cheltenham-No i, Cheltenham-Bold,Cheltenham-Bo-i,sans-serif,ZapfDingbats,LucidaSansUnicode,KozMinPro-Regular-Acro'"/>
-->
<!-- override the motive-pdf body font with one for motive-2,
 aimed for use with FOP, with lots of specific Chelt font names... -->
<xsl:param name="body.font.family" select="'Cheltenham,CheltenhamCdITC,CheltenhamCdITC-Light,CheltenhamCdITC-LightItalic,CheltenhamCdITC-Bold,CheltenhamCdITC-BoldItalic,ZapfDingbats'"/>   

  

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
<xsl:param name="body.font.italics.family" select="'CheltenhamCdITC-LightItalic,Cheltenham'"/>



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



</xsl:stylesheet>
