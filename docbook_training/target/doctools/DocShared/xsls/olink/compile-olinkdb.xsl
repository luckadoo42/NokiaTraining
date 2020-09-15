<?xml version ="1.0"?>
<!-- 
  
  This xslt processes the module.xml file and generates an ant script that in turn 
  generates all the necessary target olink database files. 
  
  For each document we generate a target database file in html/reviewer format. 
  
  For now, I'll write the ant script beside the module.xml but someday it should go in target. 
  
-->
<xsl:stylesheet version="2.0"
  xmlns:mod="http://motive.com/techpubs/module"
  xmlns:xi="http://www.w3.org/2001/XInclude"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:output
    method="xml"
    indent="yes"/>
  
  <xsl:param name="module.dir"/>
  <xsl:param name="branchname"/>
  
  <xsl:template match="/">    
    <targetset>
      <sitemap>      
        <dir name="{$branchname}">
          <xsl:apply-templates/>        
	  <document targetdoc="Glossary">
	    <xsl:element name="xi:include">
	      <xsl:attribute name="href">target/doctools/SharedContent/en_US/glossary/target.db</xsl:attribute>
	    </xsl:element>            
	  </document>
        </dir> 
      </sitemap>
    </targetset>
  </xsl:template>
  
  <xsl:template match="mod:document[not(@disabled = 'true')]">
    <xsl:variable name="current.docid" select="document(concat(@dir,'/build.xml'),.)//property[@name = 'current.docid']/@value"/>
    <document targetdoc="{$current.docid}"> 
      <xsl:element name="xi:include">
        <xsl:attribute name="href" select="concat('file:///',$module.dir,'/target/target-',$current.docid,'.db')"/>
      </xsl:element>      
      <!--    <xsl:copy-of select="document(concat( 'file:///', translate($staging.top.dir,'\','/'),'/../target-',$current.docid,'.db'),.)/div" />-->
    </document>
  </xsl:template> 
  
  <xsl:template match="text()"/>
  
</xsl:stylesheet>
