<?xml version="1.0" encoding="US-ASCII"?>


<xsl:stylesheet
  xmlns="http://www.w3.org/1999/xhtml" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
  exclude-result-prefixes="doc" version="1.0">

<xsl:import href="../../../../docbook-xsl/1.72.0/xhtml/docbook.xsl"/>
<xsl:import href="titlepage.templates.xsl"/>
<xsl:import href="l10n.xsl"/>

<xsl:include href="main.xsl"/>
<xsl:include href="html.xsl"/>
<!--
  Don't use ../common/css.xsl until it figures out how to find (relative to
  *its* directory) "../../../content/<LANGUAGE>/css/<BRAND>/html.css"; right
  now it looks for "../../../css/html.css", which has been moved to the former
  location. -DJMII

<xsl:include href="../common/css.xsl"/>
-->

</xsl:stylesheet>
