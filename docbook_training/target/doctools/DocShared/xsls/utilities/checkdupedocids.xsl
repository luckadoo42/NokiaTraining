<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xlink="http://www.w3.org/1999/xlink" 
    xmlns:mod="http://motive.com/techpubs/module"
    exclude-result-prefixes="#all"
    version="2.0">

	<!-- JCBG-991, No error when two documents in same project have same current.docid
-->

<!-- Declare parameter so that I can use it later. Value should be set already. -->
<xsl:param name="module.dir"/>

	

	<xsl:template match="/" >
			
		
		<xsl:for-each select="//document/@targetdoc">
			<xsl:sort/>
			<xsl:value-of select="."/> <xsl:text> </xsl:text><xsl:value-of select="count(//document[@targetdoc=current()])"/>
		
			<xsl:text>
				</xsl:text>
			<xsl:if test="count(//document[@targetdoc=current()])>1">
				<xsl:message terminate="yes">ERROR: There's at least one duplicate current.docid in this project; the current.docid [<xsl:value-of select="."/>] is used more than once. Examine the current.docid values in all build.xml files for duplicates. (JCBG-991)</xsl:message>
				</xsl:if>
				
			
		</xsl:for-each>
		
		
	</xsl:template>
	

		
</xsl:stylesheet>