<?xml version='1.0'?>

<!DOCTYPE xsl:stylesheet[

<!ENTITY en.xml SYSTEM "l10n/en.xml">
<!ENTITY de.xml SYSTEM "l10n/de.xml">
<!ENTITY it.xml SYSTEM "l10n/it.xml">
<!ENTITY es.xml SYSTEM "l10n/es.xml">
<!ENTITY fr.xml SYSTEM "l10n/fr.xml">
<!ENTITY es_es.xml SYSTEM "l10n/es_es.xml">
<!ENTITY ja.xml SYSTEM "l10n/ja.xml">
<!ENTITY nl.xml SYSTEM "l10n/nl.xml">
<!ENTITY pt_br.xml SYSTEM "l10n/pt_br.xml">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                exclude-result-prefixes="doc"
                version='1.0'>

<xsl:param name="local.l10n.xml" select="document('')"/>

<i18n xmlns="http://docbook.sourceforge.net/xmlns/l10n/1.0">

&en.xml;
&de.xml;
&it.xml;
<!-- es.xml is mid-atlantic spanish, es_ES is Castillian -->
&es.xml;
&es_es.xml;
&fr.xml;
&ja.xml;
&nl.xml;
&pt_br.xml;
</i18n>

</xsl:stylesheet>