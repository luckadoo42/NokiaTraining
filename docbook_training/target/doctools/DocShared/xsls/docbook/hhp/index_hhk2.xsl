<?xml version="1.0"?>
<!DOCTYPE xsl:stylesheet [
  <!-- Entity declarations from ../html/autoidx.xsl -->
<!ENTITY primary   'normalize-space(concat(primary/@sortas, primary[not(@sortas)]))'>
<!ENTITY secondary 'normalize-space(concat(secondary/@sortas, secondary[not(@sortas)]))'>

<!ENTITY sep '"::"'>
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		version="1.0">

<!-- Redefine this key to exclude indexterms without secondary terms -->
<xsl:key name="secondary"
         match="indexterm[secondary]"
         use="concat(&primary;, &sep;, &secondary;)"/>

<xsl:template match="*" mode="hhk">
  <!-- 'root' will be either the root element or the element whose id is 'rootid -->
  <xsl:param name="root" select="/"/>
  <xsl:variable name="unique-indexterms" 
    select="$root//indexterm[generate-id(.) = 
            generate-id(key('primary', &primary;))]"/>
  <xsl:for-each select="$unique-indexterms">
    <!-- This loops through each unique primary indexterm in the document, sorted alphabetically -->
    <xsl:sort select="&primary;"/>
    <xsl:variable name="thisPrimary" select="&primary;"/>

    <!-- All indexterms in "root element" that match the current primary -->
    <xsl:variable name="allPrimaries" select="$root//indexterm[&primary; = $thisPrimary]"/>

    <!-- Collection of secondary terms for the current primary -->
    <xsl:variable name="unique-secondaries"
      select="$root//indexterm[generate-id(.) =
              generate-id(key('secondary', concat($thisPrimary,&sep;,&secondary;)))] "/>
    <xsl:text disable-output-escaping="yes">
&#x9;<![CDATA[<LI> <OBJECT type="text/sitemap">]]>
&#x9;&#x9;<![CDATA[<param name="Name" value="]]></xsl:text>
    <xsl:value-of select="normalize-space(primary)"/>
    <xsl:text disable-output-escaping="yes">"></xsl:text>

    <xsl:for-each select="$allPrimaries">
      <!-- For each indexterm with the current primary, output the <param> elements -->
      <xsl:variable name="title">
        <xsl:call-template name="escape-attr">
          <xsl:with-param name="value">
            <xsl:call-template name="nearest.title">
              <xsl:with-param name="object" select=".."/>
            </xsl:call-template>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="href">
        <xsl:call-template name="href.target.with.base.dir"/>
      </xsl:variable>

      <xsl:text disable-output-escaping="yes">
&#x9;&#x9;<![CDATA[<param name="Name" value="]]></xsl:text>
      <xsl:value-of select="$title"/>
      <xsl:text disable-output-escaping="yes"><![CDATA[">]]>
&#x9;&#x9;<![CDATA[<param name="Local" value="]]></xsl:text>
      <xsl:value-of select="$href"/>
      <xsl:text disable-output-escaping="yes">"></xsl:text>
    </xsl:for-each>

    <xsl:text disable-output-escaping="yes">
&#x9;&#x9;<![CDATA[</OBJECT>]]></xsl:text>

    <xsl:if test="$unique-secondaries">
      <xsl:text disable-output-escaping="yes">
&#x9;&lt;UL&gt;</xsl:text>

      <xsl:for-each select="$unique-secondaries">
        <xsl:sort select="&secondary;"/>
        <xsl:variable name="thisSecondary" select="&secondary;"/>
        <xsl:variable name="allSecondaries" select="$allPrimaries[&secondary; = $thisSecondary]"/>
        <xsl:text disable-output-escaping="yes">
&#x9;&#x9;<![CDATA[<LI> <OBJECT type="text/sitemap">]]>
&#x9;&#x9;&#x9;<![CDATA[<param name="Name" value="]]></xsl:text>
        <xsl:value-of select="normalize-space(secondary)"/>
        <xsl:text disable-output-escaping="yes">"></xsl:text>

        <xsl:for-each select="$allSecondaries">
          <xsl:variable name="title">
            <xsl:call-template name="escape-attr">
              <xsl:with-param name="value">
                <xsl:call-template name="nearest.title">
                  <xsl:with-param name="object" select=".."/>
                </xsl:call-template>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:variable>
          <xsl:variable name="href">
            <xsl:call-template name="href.target.with.base.dir"/>
          </xsl:variable>

          <xsl:text disable-output-escaping="yes">
&#x9;&#x9;&#x9;<![CDATA[<param name="Name" value="]]></xsl:text>
          <xsl:value-of select="$title"/>
          <xsl:text disable-output-escaping="yes"><![CDATA[">]]>
&#x9;&#x9;&#x9;<![CDATA[<param name="Local" value="]]></xsl:text>
          <xsl:value-of select="$href"/>
          <xsl:text disable-output-escaping="yes">"></xsl:text>
        </xsl:for-each>
        <xsl:text disable-output-escaping="yes">
&#x9;&#x9;&#x9;<![CDATA[</OBJECT>]]></xsl:text>

      </xsl:for-each>
      <xsl:text disable-output-escaping="yes">
&#x9;&lt;/UL&gt;</xsl:text>
    </xsl:if>

  </xsl:for-each>
</xsl:template>  

<!-- ==================================================================== -->
<!-- Template for escaping <, & and " in attribute values. 
     We aren't using HTML output method, so we must do this job ourselves -->

<xsl:template name="escape-attr">
	<xsl:param name="value"/>
	<xsl:variable name="quote.char">'</xsl:variable>

  <xsl:variable name="amp.escaped">
    <xsl:call-template name="string.subst">
      <xsl:with-param name="string" select="$value"/>
      <xsl:with-param name="target" select="'&amp;'"/>
      <xsl:with-param name="replacement" select="'&amp;amp;'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="quot.escaped">
    <xsl:call-template name="string.subst">
      <xsl:with-param name="string" select="$amp.escaped"/>
      <xsl:with-param name="target" select="'&quot;'"/>
      <xsl:with-param name="replacement" select="'&amp;quot;'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="angle.escaped">
    <xsl:call-template name="string.subst">
      <xsl:with-param name="string" select="$quot.escaped"/>
      <xsl:with-param name="target" select="'&lt;'"/>
      <xsl:with-param name="replacement" select="'&amp;lt;'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="ndash.escaped">
    <xsl:call-template name="string.subst">
      <xsl:with-param name="string" select="$angle.escaped"/>
      <xsl:with-param name="target" select="'&#8211;'"/>
      <xsl:with-param name="replacement" select="'-'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="mdash.escaped">
    <xsl:call-template name="string.subst">
      <xsl:with-param name="string" select="$ndash.escaped"/>
      <xsl:with-param name="target" select="'&#8212;'"/>
      <xsl:with-param name="replacement" select="'-'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="lsquo.escaped">
    <xsl:call-template name="string.subst">
      <xsl:with-param name="string" select="$mdash.escaped"/>
      <xsl:with-param name="target" select="'&#8216;'"/>
      <xsl:with-param name="replacement" select="$quote.char"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="rsquo.escaped">
    <xsl:call-template name="string.subst">
      <xsl:with-param name="string" select="$lsquo.escaped"/>
      <xsl:with-param name="target" select="'&#8217;'"/>
      <xsl:with-param name="replacement" select="$quote.char"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="ldquo.escaped">
    <xsl:call-template name="string.subst">
      <xsl:with-param name="string" select="$rsquo.escaped"/>
      <xsl:with-param name="target" select="'&#8220;'"/>
      <xsl:with-param name="replacement" select="'&amp;quot;'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="rdquo.escaped">
    <xsl:call-template name="string.subst">
      <xsl:with-param name="string" select="$ldquo.escaped"/>
      <xsl:with-param name="target" select="'&#8221;'"/>
      <xsl:with-param name="replacement" select="'&amp;quot;'"/>
    </xsl:call-template>
  </xsl:variable>

<!-- 
	These last two are real ugly to do, but I haven't
	been able to get Saxon to work with ISO 8859-15-->
  <xsl:variable name="oe.escaped">
    <xsl:call-template name="string.subst">
      <xsl:with-param name="string" select="$rdquo.escaped"/>
      <xsl:with-param name="target" select="'&#339;'"/>
      <xsl:with-param name="replacement" select="'oe'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="OE.escaped">
    <xsl:call-template name="string.subst">
      <xsl:with-param name="string" select="$oe.escaped"/>
      <xsl:with-param name="target" select="'&#338;'"/>
      <xsl:with-param name="replacement" select="'OE'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:value-of select="$OE.escaped"/>

</xsl:template>

<!-- ==================================================================== -->

</xsl:stylesheet>