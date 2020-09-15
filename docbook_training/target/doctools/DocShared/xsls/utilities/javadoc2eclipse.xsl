<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  version="2.0">
  
  <xsl:output
	method="xml"
	indent="yes"/>

  <xsl:param name="eclipse.title">Javadocs</xsl:param>

  <!-- This xsl takes one specific html file from a javadoc fileset, and from it generates an eclipse toc.xml file.

The usual file we process, in the java 1.8 or so type of javadoc, is overview-frame.html.
    We're processing it looking for links that are NOT to allclasses-frame.html, converting those to toc topic items.

If there's only ONE package in the javadoc, then overview-frame.html is not present, and we follow a different path;
we determine which one, by testing the base-uri() value. If that value contains allclasses-frame, then we know that we got passed in the allclasses-frame.html file to process
(we know the ant file passed that in, that is), and we do things differently.
  
  -->

  <xsl:template match="/">

    <xsl:message>Using: <xsl:value-of select="concat(system-property('xsl:vendor'), ' ', system-property('xsl:vendor-url'), ' and base file URI: ',base-uri())"/></xsl:message>

    
	<toc label="{$eclipse.title}">
	  <!-- now choose the target topic for the toc element, based on the input file-->
	  <xsl:attribute name="topic">
	    <xsl:choose>
	    <xsl:when test="contains(base-uri(),'allclasses-frame')"> 
	      <!-- in the allclasses-frame case, for 1 package, we don't have an overview-summary.html file to point to;
	        so we have to find the value for the toc's topic attribute. 
	        We're going to use the package-summary.html file in the single package's folder.
	        To find the first part of that path, we'll use the first part of the path of the first 'a' in the file 
	        
	        the expression for the href of the first a is:  (//xhtml:a)[1]/@href
	        
	        We want to get all of that href before its final filename; since we know the filename is the a's content + html,
	        we can use the value of the a as the 2nd param of a substring-before
	      
	      the complex expression below thus says
	          take the href of the first a element, get the substring before the a's content, then glue on package-summary.html instead -->
   
	      <xsl:value-of select="concat(substring-before((//xhtml:a)[1]/@href,(//xhtml:a)[1]),'package-summary.html')"/> 
	    </xsl:when>
	      <!-- otherwise, the more common case, when more than 1 package is present... use overview-summary.html -->
	    <xsl:otherwise>overview-summary.html</xsl:otherwise>
	    </xsl:choose>
	  </xsl:attribute>
	  <xsl:apply-templates/>
	</toc>	
  </xsl:template>

  <!-- when called in the normal mode, throw away text() or certain xhtml:a nodes -->
  <xsl:template match="text()|xhtml:a[@href='allclasses-frame.html']"/>

  <!-- when called in package-frame mode, throw away text nodes or xhtml:a whose href=allclasses-frame.html -->
  <xsl:template match="text()|xhtml:a[@href='allclasses-frame.html']" mode="package-frame"/>

  <!-- when we're processing allclasses-frame.html as our input file (base-uri), 
    we simply process every 'a' in the input file, 
    then just use the href unchanged in the topic we make -->
  <xsl:template match="xhtml:a[contains(base-uri(),'allclasses-frame')]">
          <xsl:message>Processing an 'a' element (allclasses-frame): <xsl:value-of select="."/></xsl:message>
        <topic label="{normalize-space(.)}" href="{@href}"/>
          
  </xsl:template>

<!-- this is the default overview-frame.html pathway;
  
  Notice that it processes each 'a' element in overview-frame, to make a topic, but then also
  processes all the 'a' elements IN THE FILE REFERENCED BY THE first 'a', to create subtopics.
  
  
  -->
  <xsl:template match="xhtml:a">
	<topic label="{normalize-space(.)}" href="{concat(substring-before(@href,'/package-frame.html'),'/package-summary.html')}">
	  <xsl:message>Processing an 'a' element (overview-frame): <xsl:value-of select="."/></xsl:message>
	  <xsl:apply-templates select="document(@href)//xhtml:a" mode="package-frame">
		<xsl:with-param name="path"><xsl:value-of select="substring-before(@href, '/package-frame.html')"/></xsl:with-param>
	  </xsl:apply-templates>
	
	</topic>
  </xsl:template>

  <xsl:template match="xhtml:a" mode="package-frame">
	<xsl:param name="path"/>
	<xsl:if test="not(contains(@href,'../'))">
	  <topic label="{normalize-space(.)}" href="{concat($path,'/',@href)}"/>
	</xsl:if>
  </xsl:template>

  
</xsl:stylesheet>
