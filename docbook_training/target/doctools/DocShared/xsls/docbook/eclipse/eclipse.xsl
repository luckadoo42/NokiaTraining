<?xml version="1.0"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		version="1.1">
  
<!-- ********************************************************************
     $Id: eclipse.xsl,v 1.17 2008/12/09 14:15:40 dcramer Exp $
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://nwalsh.com/docbook/xsl/ for copyright
     and other information.

     ******************************************************************** -->
 <!-- <xsl:import href="../common/olink.xsl"/>  added for jcbg-18 -->
  <xsl:include href="../../utilities/make-hta.xsl"/>

  <xsl:output 
	method="xml" 
	omit-xml-declaration="no"/>

<!--
<xsl:param name="target.database">DUMMY</xsl:param> added for jcbg-18 -->
  
<xsl:param name="manifest.in.base.dir">1</xsl:param>
<xsl:param name="eclipse.plugin.version"/>
<xsl:param name="procedures.in.toc">1</xsl:param>
<xsl:param name="olink.debug">1</xsl:param>  <!-- set to 1 to display debug messages -->
 <!-- adding a param and a variable  for JCBG-672, to support detecting Release  Highlights docs and doing different values for them --> 
<xsl:param name="css.filename">html.css</xsl:param>   
<xsl:variable name="eclipse.toc.file.visibility">
  <xsl:choose>
    <xsl:when test="$css.filename='rh.css'">false</xsl:when> <!-- for release highlights documents, we'll make the toc.xml invisible -->
    <xsl:otherwise>true</xsl:otherwise>
  </xsl:choose>
</xsl:variable>  

  <xsl:variable name="plugin.version">
	<xsl:call-template name="datetime.format">  
	  <xsl:with-param name="date" select="date:date-time()" xmlns:date="http://exslt.org/dates-and-times"/>  
	  <xsl:with-param name="format" select="'Y-m-d.H-M-S'"/>  
	</xsl:call-template>
  </xsl:variable>

  <xsl:param name="eclipse.plugin.version.internal">
	<xsl:choose>
	  <xsl:when test="$eclipse.plugin.version = ''"><xsl:value-of select="translate($plugin.version,'-','')"/></xsl:when>
	  <xsl:otherwise><xsl:value-of select="$eclipse.plugin.version"/></xsl:otherwise>
	</xsl:choose>
  </xsl:param>

<xsl:template match="/">
  <xsl:choose>
    <xsl:when test="$rootid != ''">
      <xsl:choose>
        <xsl:when test="count(key('id',$rootid)) = 0">
          <xsl:message terminate="yes">
            <xsl:text>ID '</xsl:text>
            <xsl:value-of select="$rootid"/>
            <xsl:text>' not found in document.</xsl:text>
          </xsl:message>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="$collect.xref.targets = 'yes' or
                        $collect.xref.targets = 'only'">
            <xsl:apply-templates select="key('id', $rootid)"
                        mode="collect.targets"/>
          </xsl:if>
          <xsl:if test="$collect.xref.targets != 'only'">
            <xsl:message>Formatting from <xsl:value-of 
	                          select="$rootid"/></xsl:message>
            <xsl:apply-templates select="key('id',$rootid)"
                        mode="process.root"/>
            <xsl:call-template name="etoc"/>
            <xsl:call-template name="plugin.xml"/>
				<xsl:call-template name="helpidx"/>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:if test="$collect.xref.targets = 'yes' or
                    $collect.xref.targets = 'only'">
        <xsl:apply-templates select="/" mode="collect.targets"/>
      </xsl:if>
      <xsl:if test="$collect.xref.targets != 'only'">
        <xsl:apply-templates select="/" mode="process.root"/>
        <xsl:call-template name="etoc"/>
        <xsl:call-template name="plugin.xml"/>
		  <xsl:call-template name="helpidx"/>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>

	<xsl:call-template name="make-frameset"/>
</xsl:template>

<xsl:template name="etoc">
  <xsl:call-template name="write.chunk">
    <xsl:with-param name="filename">
      <xsl:if test="$manifest.in.base.dir != 0">
        <xsl:value-of select="$base.dir"/>
      </xsl:if>
      <xsl:value-of select="'toc.xml'"/>
    </xsl:with-param>
    <xsl:with-param name="method" select="'xml'"/>
    <xsl:with-param name="encoding" select="'utf-8'"/>
    <xsl:with-param name="indent" select="'yes'"/>
    <xsl:with-param name="content">
	  <xsl:comment> Copyright (c) <xsl:value-of select="translate(//year[1],'&#x2013;','-')"/> Alcatel-Lucent. All Rights Reserved. </xsl:comment>
      <xsl:choose>

        <xsl:when test="$rootid != ''">
          <xsl:variable name="title">
            <xsl:if test="$eclipse.autolabel=1">
              <xsl:variable name="label.markup">
                <xsl:apply-templates select="key('id',$rootid)" mode="label.markup"/>
              </xsl:variable>
              <xsl:if test="normalize-space($label.markup)">
                <xsl:value-of select="concat($label.markup,$autotoc.label.separator)"/>
              </xsl:if>
            </xsl:if>
            <xsl:apply-templates select="key('id',$rootid)" mode="title.markup"/>
          </xsl:variable>
          <xsl:variable name="href">
            <xsl:call-template name="href.target.with.base.dir">
              <xsl:with-param name="object" select="key('id',$rootid)"/>
            </xsl:call-template>
          </xsl:variable>
          
          <toc label="{translate(translate(normalize-space($title),'&#x201C;' ,''), '&#x201D;','')}" topic="{$href}">
            <xsl:apply-templates select="key('id',$rootid)/*" mode="etoc"/>
          </toc>
        </xsl:when>

        <xsl:otherwise>
          <xsl:variable name="title">
            <xsl:if test="$eclipse.autolabel=1">
              <xsl:variable name="label.markup">
                <xsl:apply-templates select="/*" mode="label.markup"/>
              </xsl:variable>
              <xsl:if test="normalize-space($label.markup)">
                <xsl:value-of select="concat($label.markup,$autotoc.label.separator)"/>
              </xsl:if>
            </xsl:if>
            <xsl:apply-templates select="/*" mode="title.markup"/>
          </xsl:variable>
          <xsl:variable name="href">
            <xsl:call-template name="href.target.with.base.dir">
              <xsl:with-param name="object" select="/"/>
            </xsl:call-template>
          </xsl:variable>
          
          <toc label="{translate(translate(normalize-space($title),'&#x201C;' ,''), '&#x201D;','')}" topic="{$href}">
            <xsl:apply-templates select="/*/*" mode="etoc"/>
          </toc>
        </xsl:otherwise>

      </xsl:choose>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="book|part|reference|preface|chapter|bibliography|appendix|article|glossary|section|procedure|simplesect|sect1|sect2|sect3|sect4|sect5|refentry|colophon|bibliodiv|index" mode="etoc">
  <xsl:variable name="title">
    <xsl:if test="$eclipse.autolabel=1">
      <xsl:variable name="label.markup">
        <xsl:apply-templates select="." mode="label.markup"/>
      </xsl:variable>
      <xsl:if test="normalize-space($label.markup)">
        <xsl:value-of select="concat($label.markup,$autotoc.label.separator)"/>
      </xsl:if>
    </xsl:if>
    <xsl:apply-templates select="." mode="title.markup"/>
  </xsl:variable>

  <xsl:variable name="href">
    <xsl:call-template name="href.target.with.base.dir">
      <xsl:with-param name="context" select="/"/>        <!-- Generate links relative to the location of root file/toc.xml file -->
    </xsl:call-template>
  </xsl:variable>
	<xsl:if test="not(self::procedure) or $procedures.in.toc != '0'">
	  <topic label="{translate(translate(normalize-space($title),'&#x201C;' ,''), '&#x201D;','')}" href="{$href}">
		<xsl:apply-templates select="part|reference|preface|chapter|bibliography|appendix|article|glossary|section|procedure|simplesect|sect1|sect2|sect3|sect4|sect5|refentry|colophon|bibliodiv|index" mode="etoc"/>
	  </topic>
	</xsl:if>

</xsl:template>

<xsl:template match="text()" mode="etoc"/>

<xsl:template name="plugin.xml">
  <xsl:call-template name="write.chunk">
    <xsl:with-param name="filename">
      <xsl:if test="$manifest.in.base.dir != 0">
        <xsl:value-of select="$base.dir"/>
      </xsl:if>
      <xsl:value-of select="'plugin.xml'"/>
    </xsl:with-param>
    <xsl:with-param name="method" select="'xml'"/>
    <xsl:with-param name="encoding" select="'utf-8'"/>
    <xsl:with-param name="indent" select="'yes'"/>
    <xsl:with-param name="content">
		<xsl:comment> Copyright (c) <xsl:value-of select="translate(//year[1],'&#x2013;','-')"/> Alcatel-Lucent. All Rights Reserved. </xsl:comment>
      <plugin name="{$eclipse.plugin.name}"
        id="{$eclipse.plugin.id}"
        version="{$eclipse.plugin.version.internal}"
        provider-name="{$eclipse.plugin.provider}">

        <extension point="org.eclipse.help.toc">
          <toc file="toc.xml" primary="{$eclipse.toc.file.visibility}"/> <!-- for JCBG-672, made the value of primary variable, so that release highlights docs can have it false
                                                                                  to make their toc.xml files invisible to eclipse -->
		  <index path="index"/>
        </extension>
		  <extension point="org.eclipse.help.index">
			<index file="index.xml"/>
		  </extension>
      </plugin>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->
<!-- The following templates come from the javahelp xsls with modifications needed to make them generate and ecilpse index.xml file -->

<xsl:template name="helpidx">
  <xsl:call-template name="write.chunk.with.doctype">
    <xsl:with-param name="filename" select="concat($base.dir, 'index.xml')"/>
    <xsl:with-param name="method" select="'xml'"/>
    <xsl:with-param name="indent" select="'yes'"/>
    <xsl:with-param name="doctype-public" select="''"/>
    <xsl:with-param name="doctype-system" select="''"/>
    <xsl:with-param name="encoding" select="'utf-8'"/>
    <xsl:with-param name="content">
      <xsl:call-template name="helpidx.content"/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

  <xsl:template name="helpidx.content">
	<index>
	  <xsl:choose>
		<xsl:when test="$rootid != ''">
		  <xsl:apply-templates select="key('id',$rootid)//indexterm" mode="idx">
			<xsl:sort select="normalize-space(concat(primary/@sortas, primary[not(@sortas) or @sortas = '']))"/>
			<xsl:sort select="normalize-space(concat(secondary/@sortas, secondary[not(@sortas) or @sortas = '']))"/>
			<xsl:sort select="normalize-space(concat(tertiary/@sortas, tertiary[not(@sortas) or @sortas = '']))"/>
		  </xsl:apply-templates>
		</xsl:when>
		<xsl:otherwise>
		  <xsl:apply-templates select="//indexterm" mode="idx">
			<xsl:sort select="normalize-space(concat(primary/@sortas, primary[not(@sortas) or @sortas = '']))"/>
			<xsl:sort select="normalize-space(concat(secondary/@sortas, secondary[not(@sortas) or @sortas = '']))"/>
			<xsl:sort select="normalize-space(concat(tertiary/@sortas, tertiary[not(@sortas) or @sortas = '']))"/>
		  </xsl:apply-templates>
		</xsl:otherwise>
	  </xsl:choose>
	</index>
  </xsl:template>
  
  <xsl:template match="indexterm[@class='endofrange']" mode="idx"/>
  
  <xsl:template match="indexterm|primary|secondary|tertiary" mode="idx">

	<xsl:variable name="href">
	  <xsl:call-template name="href.target.with.base.dir">
		<xsl:with-param name="context" select="/"/>        <!-- Generate links relative to the location of root file/toc.xml file -->
	  </xsl:call-template>
	</xsl:variable>

	<xsl:variable name="text">
	  <xsl:value-of select="normalize-space(.)"/>
	  <xsl:if test="following-sibling::*[1][self::see]">
		<xsl:text> (</xsl:text><xsl:call-template name="gentext">
		  <xsl:with-param name="key" select="'see'"/>
		</xsl:call-template><xsl:text> </xsl:text>
		<xsl:value-of select="following-sibling::*[1][self::see]"/>)</xsl:if>
	</xsl:variable>
	
	<xsl:choose>
	  <xsl:when test="self::indexterm">
		<xsl:apply-templates select="primary" mode="idx"/>
	  </xsl:when>
	  <xsl:when test="self::primary">
		<entry keyword="{$text}">
		  <topic href="{$href}"/>
		  <xsl:apply-templates select="following-sibling::secondary"  mode="idx"/>
		</entry>
	  </xsl:when>
	  <xsl:otherwise>
		<entry keyword="{$text}">
		  <topic href="{$href}"/>
		  <xsl:apply-templates select="following-sibling::tertiary"  mode="idx"/>
		</entry>
	  </xsl:otherwise>
	</xsl:choose>
  </xsl:template>

  <!-- ==================================================================== -->
 <!-- convert them to links for use in infocenter JCBG-18 -->

  <!-- this works as far as taking over the output when a link is in an eclipse format; however, it needs to be finished. Right now I don't have the eclipseID.
      ... however, the targetpointer works fine... 
      
      So, to finish this: need to grab the xref text from olink file, and also the eclipse id. 

expressions from release highlights, where... it is processing olink.db as the input
<xsl:variable name="eclipseID" select="./ancestor::div[@data-eclipseid][1]/@data-eclipseid"/>
    <xsl:variable name="targetptr" select="./ancestor::div[@targetptr][1]/@targetptr"/>
    <xsl:variable name="link-name" select="./ancestor::div[@targetptr][1]/ttl"/>
    
    $target.database.filename = the filename
    $target.database = the contents of olink file...
  
  an olink looks like this: <olink targetdoc="DOC1" targetptr="test_section_1">A section</olink>

  merging in the olink template from xref.xsl...
  -->
  
  <!-- You can revert to having external olinks = textual references, by simply commenting out this template, or change its name to olinksDISABLED. -Aaron D, 12/10/14 -->
  
  <xsl:template match="olink" name="olink">
  
  <!-- most of this content is copied from ../xhtml/xref.xsl's olink template ... then modded; using it here to set up getting the info about an olink, from olink.db -->  
    <xsl:call-template name="anchor"/>
    
    <xsl:variable name="localinfo" select="@localinfo"/>
    
    <xsl:choose>
      <!-- olinks resolved by stylesheet and target database -->
      <xsl:when test="@targetdoc or @targetptr">
        <xsl:variable name="targetdoc.att" select="@targetdoc"/>
        <xsl:variable name="targetptr.att" select="@targetptr"/>
        
        <xsl:variable name="olink.lang">
          <xsl:call-template name="l10n.language">
            <xsl:with-param name="xref-context" select="true()"/>
          </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="target.database.filename">
          <xsl:call-template name="select.target.database">
            <xsl:with-param name="targetdoc.att" select="$targetdoc.att"/>
            <xsl:with-param name="targetptr.att" select="$targetptr.att"/>
            <xsl:with-param name="olink.lang" select="$olink.lang"/>
          </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="target.database" select="document($target.database.filename,/)"/>
        
        <xsl:if test="$olink.debug != 0">
          <xsl:message>
            <xsl:text>Olink debug: root element of target.database '</xsl:text>
            <xsl:value-of select="$target.database.filename"/>
            <xsl:text>' is '</xsl:text>
            <xsl:value-of select="local-name($target.database/*[1])"/>
            <xsl:text>'.</xsl:text>
          </xsl:message>
        </xsl:if>
        
        <xsl:variable name="olink.key">
          <xsl:call-template name="select.olink.key">
            <xsl:with-param name="targetdoc.att" select="$targetdoc.att"/>
            <xsl:with-param name="targetptr.att" select="$targetptr.att"/>
            <xsl:with-param name="olink.lang" select="$olink.lang"/>
            <xsl:with-param name="target.database" select="$target.database"/>
          </xsl:call-template>
        </xsl:variable>
        
        <xsl:if test="string-length($olink.key) = 0">
          <xsl:message>
            <xsl:text>Error: unresolved olink: </xsl:text>
            <xsl:text>targetdoc/targetptr = '</xsl:text>
            <xsl:value-of select="$targetdoc.att"/>
            <xsl:text>/</xsl:text>
            <xsl:value-of select="$targetptr.att"/>
            <xsl:text>'.</xsl:text>
          </xsl:message>
          <!-- adding a fail msg for JCBG-89 -->
          <xsl:if test="$fail.on.bad.olink != 'no'"><xsl:message terminate="yes"/></xsl:if>
        </xsl:if>
        
        <xsl:variable name="href">
          <xsl:call-template name="make.olink.href">
            <xsl:with-param name="olink.key" select="$olink.key"/>
            <xsl:with-param name="target.database" select="$target.database"/>
          </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="hottext">
          <xsl:call-template name="olink.hottext">
            <xsl:with-param name="target.database" select="$target.database"/>
            <xsl:with-param name="olink.key" select="$olink.key"/>
            <xsl:with-param name="olink.lang" select="$olink.lang"/>
          </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="olink.docname.citation">
          <xsl:call-template name="olink.document.citation">
            <xsl:with-param name="olink.key" select="$olink.key"/>
            <xsl:with-param name="target.database" select="$target.database"/>
            <xsl:with-param name="olink.lang" select="$olink.lang"/>
          </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="olink.page.citation">
          <xsl:call-template name="olink.page.citation">
            <xsl:with-param name="olink.key" select="$olink.key"/>
            <xsl:with-param name="target.database" select="$target.database"/>
            <xsl:with-param name="olink.lang" select="$olink.lang"/>
          </xsl:call-template>
        </xsl:variable>
         
        <xsl:variable name="eclipseID" select="normalize-space($target.database//document[@targetdoc = current()/@targetdoc]/div/@data-eclipseid)"/>
        
  
        <!-- JCBG-1680: need to choose what HTML filename we'll target; normally it's based on the targetptr, but when the target is a book element, can't do that -->
   
        <!-- first we'll need some utility variables for this logic -->
        <xsl:variable name="targetelement">
          <!-- utility variable used here only, to carry the value of the target element's name -->
          <xsl:value-of select="$target.database//document[@targetdoc = current()/@targetdoc]//*[@targetptr = current()/@targetptr]/@element"/>
        </xsl:variable>
         
        <!-- utility variable used here only, to hold a list of the elements that get their own pages 
        note that I carefully used a comma delimiter and NO spaces, so that if targetelement resolves to a space, it is NOT found in the list
        -->
        <xsl:variable name="pageelements">part,chapter,section,glossary,index,preface,appendix</xsl:variable>
         
       


        <xsl:variable name="topicfilename">
          <xsl:choose>
            <!-- links to a book element need special handling b/c we don't make an html page with the book's id -->
            <xsl:when test="$targetelement='book'">
               <!-- if it IS a book, we'll take the targetptr value of the first child div that HAS a targetptr, instead of the targetptr of the whole book -->
              <xsl:value-of select="($target.database//document[@targetdoc = current()/@targetdoc]//div[@targetptr = current()/@targetptr]//div[@targetptr][1]/@targetptr)[1]"/>
            </xsl:when>
            <!-- if there's a stop-chunking in the ancestor path, we need to do things differently:
               if there's a stop-chunking, then our topicfilename needs to be the targetptr of the ancestor that has the stop-chunking-->
            <xsl:when test="$target.database//document[@targetdoc = current()/@targetdoc]//*[@targetptr = current()/@targetptr]/ancestor::*[@data-stopchunk='true']">
              <xsl:value-of select="$target.database//document[@targetdoc = current()/@targetdoc]//*[@targetptr = current()/@targetptr]/ancestor::*[@data-stopchunk='true'][last()]/@targetptr"/>
            </xsl:when> 
            <!-- next case: if it's an element that gets its own page, then topicfilename = targetptr -->
            <xsl:when test="contains($pageelements,$targetelement)">
              <xsl:value-of select="@targetptr"/>
            </xsl:when>            
            <!-- in other cases, it's a sub-page link and we need to set topicfilename = the first ancestor that is a page -->
            <xsl:otherwise><xsl:value-of select="$target.database//document[@targetdoc = current()/@targetdoc]//*[@targetptr = current()/@targetptr]/ancestor::*[contains($pageelements,@element)][1]/@targetptr"/></xsl:otherwise> 
          </xsl:choose>
        </xsl:variable>
        
        <xsl:if test="$olink.debug != 0"><xsl:message>targeptr=<xsl:value-of select="@targetptr"/>, $topicfilename[<xsl:value-of select="$topicfilename"/>]</xsl:message></xsl:if>
        
        
        <!-- JCBG-1681: if the target is not part/chapter/section/preface/appendix/glossary/index
            or if there is a stop-chunk in the ancestor path, 
          then create an anchor value-->
        <!-- the normal value of this var is null, so that we can append it to a link and if it's not used, it's not there -->
        <xsl:variable name="anchor"><xsl:if test="not(contains($pageelements,$targetelement)) or $target.database//document[@targetdoc = current()/@targetdoc]//*[@targetptr = current()/@targetptr]/ancestor::*[@data-stopchunk='true']">#<xsl:value-of select="@targetptr"/></xsl:if></xsl:variable>
       

       
        <xsl:if test="$olink.debug != 0">
          <xsl:message>For [<xsl:value-of select="@targetdoc"/>]/[<xsl:value-of select="@targetptr"/>], targetelement[<xsl:value-of select="$targetelement"/>] anchor[<xsl:value-of select="$anchor"/>]</xsl:message>
       <xsl:message>
         <xsl:if test="contains($pageelements,$targetelement)">Target element [<xsl:value-of select="$targetelement"/>] is in the pageelements list [<xsl:value-of select="$pageelements"/>]</xsl:if>
         <xsl:if test="not(contains($pageelements,$targetelement))">Target element [<xsl:value-of select="$targetelement"/>] is NOT in the pageelements list [<xsl:value-of select="$pageelements"/>]</xsl:if></xsl:message>
          
        </xsl:if>
       
       
        <!-- this works, but we don't actually need it because we are using olink vars instead
        <xsl:variable name="link-text" select="normalize-space($target.database//document[@targetdoc = current()/@targetdoc]//div[@targetptr = current()/@targetptr]/xreftext)"/>
        -->
        
       <!-- debug: this outputs entire olink.db, so, ... use sparingly 
       target database = <xsl:value-of select="$target.database"/> 
        eclipseID=<xsl:value-of select="$eclipseID"/>; /
        link-text=<xsl:value-of select="$link-text"/>; -->
              
         <!-- debug line useful for JCBG-1680     
        <xsl:message>JCBG-1680 debug: $topicfilename = <xsl:value-of select="$topicfilename"/> and @targetptr=<xsl:value-of select="@targetptr"/></xsl:message> -->
        
        <!-- Here's the money shot for jcbg-18 ... where we write out the link -->
        <a href="../{$eclipseID}/{$topicfilename}.html{$anchor}"> <span class="olink"><xsl:copy-of select="$hottext"/></span></a>
          <xsl:copy-of select="$olink.page.citation"/><xsl:copy-of select="$olink.docname.citation"/>
        
        <xsl:if test="$olink.debug != 0">
          
          <xsl:message>Link URL[../<xsl:value-of select="$eclipseID"/>/<xsl:value-of select="$topicfilename"/>.html<xsl:value-of select="$anchor"/>], text=[<xsl:copy-of select="$hottext"/>]</xsl:message>
        </xsl:if>
        
        
        
          <!-- commenting out marker for external olinks... 
           <span style="background-color:yellow;">[[external olink]] </span> -->
        
        <!-- rest of code in this section is not used -->
        
        <!--
        <xsl:choose>
          <xsl:when test="$href != ''">
            <a href="{$href}" class="olink">
              <xsl:copy-of select="$hottext"/>
            </a>
            <xsl:copy-of select="$olink.page.citation"/>
            <xsl:copy-of select="$olink.docname.citation"/>
          </xsl:when>
          <xsl:otherwise>
            <span class="olink"><xsl:call-template name="gentext.startquote"/><xsl:copy-of select="$hottext"/><xsl:call-template name="gentext.endquote"/></span>
            <xsl:copy-of select="$olink.page.citation"/>
            <xsl:copy-of select="$olink.docname.citation"/>
          </xsl:otherwise>
        </xsl:choose>-->
        
      </xsl:when>

      <xsl:otherwise>
        <xsl:variable name="href">
          <xsl:choose>
            <xsl:when test="@linkmode">
             
              <xsl:variable name="modespec" select="key('id',@linkmode)"/>
              <xsl:if test="count($modespec) != 1                           or local-name($modespec) != 'modespec'">
                <xsl:message>Warning: olink linkmode pointer is wrong.</xsl:message>
              </xsl:if>
              <xsl:value-of select="$modespec"/>
              <xsl:if test="@localinfo">
                <xsl:text>#</xsl:text>
                <xsl:value-of select="@localinfo"/>
              </xsl:if>
            </xsl:when>
            <xsl:when test="@type = 'href'">
              <xsl:call-template name="olink.outline">
                <xsl:with-param name="outline.base.uri" select="unparsed-entity-uri(@targetdocent)"/>
                <xsl:with-param name="localinfo" select="@localinfo"/>
                <xsl:with-param name="return" select="'href'"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$olink.resolver"/>
              <xsl:text>?</xsl:text>
              <xsl:value-of select="$olink.sysid"/>
              <xsl:value-of select="unparsed-entity-uri(@targetdocent)"/>
            
              <xsl:if test="@localinfo">
                <xsl:text>&amp;</xsl:text>
                <xsl:value-of select="$olink.fragid"/>
                <xsl:value-of select="@localinfo"/>
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        
        <xsl:choose>
          <xsl:when test="$href != ''">
            <a href="{$href}" class="olink">
              <xsl:call-template name="olink.hottext"/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="olink.hottext"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose> 
    
  </xsl:template>  

</xsl:stylesheet>
