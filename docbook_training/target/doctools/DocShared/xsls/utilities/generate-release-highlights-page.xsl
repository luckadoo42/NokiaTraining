<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:db="http://docbook.org/ns/docbook" xmlns="http://docbook.org/ns/docbook" xmlns:xlink="http://www.w3.org/1999/xlink" version="2.0" exclude-result-prefixes="#default">
  <!-- for-each-group example at http://www.xmlplease.com/xmltraining/xslt-by-example/examples/for-each-group_1.html -->
  <!-- Group the generated links by keyword. Use each keyword as a listitem (bullet); each para under that bullet
	     then links to a topic that references that keyword. -->
  <!-- Note: This script is not concerned with duplicates or sorting. 
	     The writer can remove duplicates from the original doc (nongenerated) source. 
	     The writer can also order the generated links as desired. -->
  <!-- This XSL was added to the system to address JCBG-672. -->
  <!-- We do two passes:
     First pass: Creates a variable that contains an itemizedlist where each listitem is a keyword followed by links to relevant sections.

     Second pass: Manage security per listitem. 
     If a listitem has links all of the internal security level, set the security level for the listitem to internal.
     If a listitem has one or more links without security or security other than internal, do not set security level for the listitem.
  -->

  <!-- FIRST-PASS TEMPLATE -->
  <xsl:template match="/">
    <xsl:variable name="pass1">
      <para xmlns="http://docbook.org/ns/docbook" xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:xlink="http://www.w3.org/1999/xlink" xml:id="release_highlights" version="5.0-extension BroadBook-2.0">
        <!-- create a list for the whole -->
        <itemizedlist>
          <!-- note, I wanted to put role='linklist' on the itemized list, but that doesn't work, had to put it on each listitem -->
          <!-- Create a bullet for each keyword. -->
          <xsl:for-each-group select="//keyword" group-by="current()">
            <xsl:sort select="current-grouping-key()"/>
            <xsl:text>
							</xsl:text>
            <listitem role="linklist">
              <para>
                <phrase role="keyword">
                  <xsl:value-of select="current-grouping-key()"/>
                </phrase>
              </para>
              <xsl:text>
							</xsl:text>
              <!-- For each keyword, create a para with a link to each topic that has the given keyword. -->
              <xsl:for-each select="current-group()">
                <!-- JCBG-1691: Get targetdoc and create an olink. -->
                <xsl:variable name="targetdoc" select="./ancestor::document[@targetdoc][1]/@targetdoc"/>
                <xsl:variable name="targetptr" select="./ancestor::div[@targetptr][1]/@targetptr"/>
                <!-- JCBG-1786: Also get security level to use when creating a link so that the link has the same security level as the destination. -->
                <xsl:variable name="data-security" select="./ancestor::div[@data-security][1]/@data-security"/>
                <xsl:choose>
                  <!-- Check whether targetptr exists. -->
                  <xsl:when test="./ancestor::div[1]/@targetptr">
                    <!-- If targetptr exists, construct the link. -->
                    <xsl:variable name="link-name" select="./ancestor::div[@targetptr][1]/ttl"/>
                    <!-- JCBG-1970: Only insert security attributes when there are actually attributes to insert. Do not insert empty attributes. -->
                    <para> 
                      <xsl:if test="$data-security != ''">
			<xsl:attribute name="security"><xsl:value-of select="$data-security"/></xsl:attribute>
                      </xsl:if>
                      <olink targetdoc="{$targetdoc}" targetptr="{$targetptr}">
                          <xsl:value-of select="$link-name"/>
                      </olink>
                   </para>
                  </xsl:when>
                  <xsl:otherwise>
                    <!-- If targetptr does NOT exist, xml:id is missing. 
		       Construct a warning message to display in the generated file. -->
                    <para> WARNING: Missing xml:id attribute in <xsl:value-of select="$targetdoc"/>. Add an xml:id to the
											&lt;section&gt; element (or whatever element it is) that
											contains this keyword: <xsl:value-of select="."/> </para>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </listitem>
          </xsl:for-each-group>
        </itemizedlist>
      </para>
    </xsl:variable>

    <!-- DEBUGGING: Save $pass1 for debugging
    <xsl:message terminate="no">Generating copy of $pass1 in temp-pass1-genrh.xml</xsl:message>
    <xsl:result-document href="temp-pass1-genrh.xml">
      <xsl:copy-of select="$pass1/*"/>
    </xsl:result-document>
    -->

    <xsl:apply-templates select="$pass1" mode="pass2"/>
  </xsl:template>

  <!-- SECOND-PASS TEMPLATES -->
  <!-- JCBG-1786 -->
  <xsl:template match="@*|node()" mode="pass2">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="pass2"/>
    </xsl:copy>
  </xsl:template>
<!-- JCBG-2069: These two templates are based on the premise that if ALL the olinks within 
a listitem (for a keyword) are in paras that have internal security, the listitem needs a security="internal" attribute.
If any para/olink in the listitem has no security or a security other than internal, the second template is used.
That template just copies the whole listitem without setting the security for the listitem. -->
  <xsl:template match="db:listitem[count(./db:para[@security='internal'])=count(./db:para/db:olink)]" mode="pass2">
    <!-- listitem has only internal security items, so add internal security attribute to listitem element -->
<!-- DEBUGGING:
### In template where listitem has count(para[@security='internal']) = count(para/olink).
### Thus, all olinks are internal.
#psi = <xsl:value-of select="count(./db:para[@security='internal'])"/>
#po = <xsl:value-of select="count(./db:para/db:olink)"/>
-->
    <listitem role="linklist">
      <xsl:attribute name="security">internal</xsl:attribute>
      <xsl:copy-of select="node()"/>
    </listitem>
  </xsl:template>
  <xsl:template match="db:listitem" mode="pass2">
    <!-- listitem has multiple security levels, so just copy the entire listitem as is 
	 (more precisely, the listitem has at least one olink that has no security or has security other than internal)
    -->
<!-- DEBUGGING:
### In template where listitem has count(para[@security='internal']) != count(para/olink).
### Thus, olinks have mixed security or no security.
#psi = <xsl:value-of select="count(./db:para[@security='internal'])"/>
#po = <xsl:value-of select="count(./db:para/db:olink)"/>
-->
    <xsl:copy-of select="."/>
  </xsl:template>
</xsl:stylesheet>
