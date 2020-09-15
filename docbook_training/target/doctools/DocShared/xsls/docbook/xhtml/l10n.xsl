<?xml version='1.0'?>
<!DOCTYPE xsl:stylesheet[
<!ENTITY en.xml SYSTEM "l10n/en.xml">
<!ENTITY ja.xml SYSTEM "l10n/ja.xml">
<!ENTITY de.xml SYSTEM "l10n/de.xml">
<!ENTITY es.xml SYSTEM "l10n/es.xml">
<!ENTITY fr.xml SYSTEM "l10n/fr.xml">
<!ENTITY es_es.xml SYSTEM "l10n/es_es.xml">
<!ENTITY it.xml SYSTEM "l10n/it.xml">
<!ENTITY nl.xml SYSTEM "l10n/nl.xml">
<!ENTITY pt_br.xml SYSTEM "l10n/pt_br.xml">
<!ENTITY ru.xml SYSTEM "l10n/ru.xml">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.0'>

<xsl:param name="local.l10n.xml" select="document('')"/>

<i18n xmlns="http://docbook.sourceforge.net/xmlns/l10n/1.0">

&en.xml;
&ja.xml;
&de.xml;
<!-- es.xml is mid-atlantic spanish, es_ES is Castillian -->
&es.xml;
&es_es.xml;
&it.xml;
&fr.xml;
&nl.xml;
&pt_br.xml;
&ru.xml;

</i18n>

</xsl:stylesheet>