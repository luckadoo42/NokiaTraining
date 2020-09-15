<?xml version ="1.0"?>
<!-- single-purpose xsl to convert ScrollWiki confluence docbook output to our docbook-->
  <xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns="http://docbook.org/ns/docbook"
    xmlns:db="http://docbook.org/ns/docbook"
    exclude-result-prefixes="db"  >

	<xsl:output
	  method="xml"
	  indent="no"/>

    <xsl:template match="@*|node()">
      <xsl:copy copy-namespaces="no">
        <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
    </xsl:template>
    
    <!-- convert scroll error para to a comment -->
    
    <xsl:template match="db:para[@role='scroll-error']">
      <xsl:comment>
         <xsl:value-of select="."/>
      </xsl:comment>
      
    </xsl:template>
  
<!-- convert article to book -->
    
    <xsl:template match="db:article">
      <book>
        <xsl:attribute name="version">5.0-extension BroadBook-2.0</xsl:attribute>
        <xsl:apply-templates select="@xml:id|node()"/>
      </book>
      
    </xsl:template>
    
 <!-- convert top article sections to chapters -->
    
    <xsl:template match="db:article/db:section">
      <chapter>
        <xsl:apply-templates select="@*|node()"/>
      </chapter>
      
    </xsl:template>
    
    <xsl:template match="@xml:id">
      <xsl:attribute name="xml:id">
        <!-- if the id starts with a number, prepend the letter A 
          to prevent Oxygen/Xerces from complaining -->
        
        <xsl:if test="contains('0123456789', substring(@value,1,1))">A<xsl:message>Prepending A to xml:id <xsl:copy-of select="."/>, because it starts with a number.</xsl:message></xsl:if>
        <xsl:value-of select="."/>     
      </xsl:attribute>
    </xsl:template>
    
  
  </xsl:stylesheet>