<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:db="http://docbook.org/ns/docbook" xmlns:xlink="http://www.w3.org/1999/xlink"
  exclude-result-prefixes="db" version="2.0">
  <!-- xsl 2.0 required to allow use of replace() function -->

  <!-- Unescape the HTML in certain fields of jira RSS  -->

  <xsl:output method="xml" encoding="utf-8" indent="no" omit-xml-declaration="no"/>


  <!-- global params -->
  <xsl:param name="JIRAROOTID">default-id</xsl:param>
  <xsl:param name="TYPE">resolved</xsl:param>
  <xsl:param name="STYLE">list</xsl:param>
  <xsl:param name="JIRATITLE"/>
  
  <!-- title of the whole table or section-->

  <!-- templates -->

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match='*|@*'>
    <xsl:copy>
      <xsl:apply-templates select='node()|@*'/>
    </xsl:copy>
  </xsl:template>

  <!-- add the copy-all template... -->


<!-- templates for contents of customfieldvalue elements -->

 

<!-- handling escaped items in the customfieldvalue text ... -->

<!-- 3 nested replaces to do 3 replaces on one each text node 
  Initially I tried to do this with 3 separate templates catching text nodes that had the 
  relevant character. No good, though, only the last one would be processed.
  The nested approach works great though. It's just hard to read the code.
  
  the long match [] limits this to customfieldvalues of known issue or workaround only

customfieldvalue/text()[(string(../../customfieldname) = 'Known Issue') or (string(../../customfieldname) = 'Workaround')]

-->
  <xsl:template match="customfieldvalue/text()[(string(../../../customfieldname) = 'Known Issue') or (string(../../../customfieldname) = 'Workaround') or (string(../../../customfieldname) = 'Release Note Title')]">
    <xsl:value-of select="replace(replace(replace(.,'&amp;','@ampersand@'),'&gt;','@gt@'),'&lt;','@lt@')"/> 
  </xsl:template> 
  


</xsl:stylesheet>
