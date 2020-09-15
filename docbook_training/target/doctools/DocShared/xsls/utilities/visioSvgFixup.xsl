<?xml version ="1.0"?>
<!DOCTYPE xsl:stylesheet>
<!-- Workaround for: http://issues.apache.org/bugzilla/show_bug.cgi?id=38831 -->
<!-- Adds overflow="visible" to all <marker> elements. -->
  <xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:svg="http://www.w3.org/2000/svg"
	xmlns:v="http://schemas.microsoft.com/visio/2003/SVGExtensions/"
	xmlns="http://www.w3.org/2000/svg">

	<xsl:output
	  method="xml"
	  indent="no"/>
  	
  	<xsl:template match="/">
  		<xsl:choose>
  			<xsl:when test="//v:*">
  				<xsl:message>Applying visio-fixup to svg file.</xsl:message>  				
  			</xsl:when>
  			<xsl:otherwise>
  				<xsl:message>Removing DOCTYPE from svg file. No MS namespace found.</xsl:message>
  			</xsl:otherwise>
  		</xsl:choose>
  		<xsl:apply-templates/>
  	</xsl:template>
  	
  	<xsl:template match="svg:marker">
  		<xsl:choose>
  			<xsl:when test="//v:*">
  				<xsl:element name="marker" xmlns="http://www.w3.org/2000/svg">
  					<xsl:copy-of select="@*"/>
  					<xsl:attribute name="overflow">visible</xsl:attribute>
  					<xsl:copy-of select="node()"/>
  				</xsl:element>
  			</xsl:when>
  			<xsl:otherwise>
  				<xsl:copy>
  					<xsl:apply-templates select="@*|node()"/>
  				</xsl:copy>
  			</xsl:otherwise>
  		</xsl:choose>
  	</xsl:template>

    <xsl:template match="@*|node()">
      <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
    </xsl:template>

  </xsl:stylesheet>
