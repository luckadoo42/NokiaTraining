<?xml version="1.0"?>

<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:mml="http://www.w3.org/1998/Math/MathML"
                version='1.0'>


<xsl:import href="../../../../DocBookXSL/1.70.0/xhtml/docbook.xsl"/>
<xsl:import href="../common/css.xsl"/>

<xsl:import href="main.xsl"/>
<xsl:import href="titlepage.templates.xsl"/>

	<xsl:param name="uppercase.alpha">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:param>
	<xsl:param name="lowercase.alpha">abcdefghijklmnopqrstuvwxyz</xsl:param>
<xsl:param name="local.l10n.xml" select="document('l10n/en.xml')"/>
<!--
	This stylesheet lets you preview a document without 
	including a glossary. Glossterms are also green so that 
	you can spot them easily. The reason for this stylesheet
	is that you must include the entire glossary in your 
	document even while editing so that your glossterms linkends
	will have corresponding ids.
-->
<xsl:param name="show.comments">1</xsl:param>
<!-- ==================================================================== -->
<xsl:param name="section.autolabel" select="0"/>
<!-- ==================================================================== -->
<xsl:param name="section.label.includes.component.label" select="1"/>
<!-- ==================================================================== -->
<xsl:param name="chapter.autolabel" select="1"/>
<xsl:param name="appendix.autolabel" select="1"/>
<!-- ==================================================================== -->
<xsl:param name="preface.autolabel" select="1"/>
<!-- ==================================================================== -->
<xsl:param name="part.autolabel" select="1"/>
<xsl:param name='callout.graphics.path' select="'http://docbook.sourceforge.net/release/xsl/current/images/callouts/'"/>
<!-- ==================================================================== -->
<xsl:param name="tooltip.glossterms" select="0"/>

<xsl:attribute-set name="body.attrs">
  <xsl:attribute name="bgcolor">white</xsl:attribute>
  <xsl:attribute name="text">black</xsl:attribute>
  <xsl:attribute name="link">#0000FF</xsl:attribute>
  <xsl:attribute name="vlink">#840084</xsl:attribute>
  <xsl:attribute name="alink">#0000FF</xsl:attribute>
  <xsl:attribute name="style">background-image:
  url(http://dcramer/images/draft.gif);
  background-attachment: fixed; margin-left: 4em;  FONT: 16px/19px  Verdana, Arial, Helvetica, sans-serif;
</xsl:attribute>
</xsl:attribute-set>

<xsl:template match="glossterm">
	<span style="color: green; text-decoration: underline">
	  <xsl:copy-of select="."/>
	</span>
</xsl:template>

  <xsl:template match="glossary">
	<p><strong>Preview mode.</strong> Glossary
	Omitted. Words tagged with <tt>&lt;glossterm&gt;</tt> in this
	document appear in <span style="color: green;
	text-decoration: underline">green and underlined</span>
	to make them more visible. In production, they will be
	hyperlinks to the glossary.</p>

</xsl:template>

<xsl:template match="title" mode="titlepage.mode">
  <xsl:variable name="id">
    <xsl:choose>
      <!-- if title is in an *info wrapper, get the grandparent -->
      <xsl:when test="contains(local-name(..), 'info')">
        <xsl:call-template name="object.id">
          <xsl:with-param name="object" select="../.."/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="object.id">
          <xsl:with-param name="object" select=".."/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <h1 xmlns="http://www.w3.org/1999/xhtml" class="{name(.)}">
    <a id="{$id}"/>
    <xsl:choose>
      <xsl:when test="$show.revisionflag and @revisionflag">
	<span class="{@revisionflag}">
	  <xsl:apply-templates mode="titlepage.mode"/>
	</span>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates mode="titlepage.mode"/>
      </xsl:otherwise>
    </xsl:choose>
	  <xsl:text> [</xsl:text>
	  <xsl:choose>
		<xsl:when test="../@id">
		  <xsl:value-of select="../@id"/>
		</xsl:when>
		<xsl:otherwise>
		  <xsl:text>No ID</xsl:text>
		</xsl:otherwise>
	  </xsl:choose>
		  <xsl:text> ]</xsl:text>
	</h1>
</xsl:template>


<xsl:template match="comment|remark">
  <xsl:if test="$show.comments != 0">
	  <i style="background-color: yellow; font-weight: bold" xmlns="http://www.w3.org/1999/xhtml">
		<xsl:call-template name="inline.charseq"/>
	  </i>
  </xsl:if>
</xsl:template>


  <xsl:template match="indexterm">
	<xsl:variable name="term">
	  <xsl:value-of select="normalize-space(primary)"/>
	  <xsl:choose>
		<xsl:when test="tertiary">
		  <xsl:text>, 
  </xsl:text>
		  <xsl:value-of
		  select="normalize-space(secondary)"/>
		  <xsl:text>, 
    </xsl:text>
		  <xsl:value-of
		  select="normalize-space(tertiary)"/>
		</xsl:when>
		<xsl:when test="secondary">
		  <xsl:text>, 
  </xsl:text>
		  <xsl:value-of
		  select="normalize-space(secondary)"/>
		</xsl:when>
	  </xsl:choose>
	</xsl:variable>
	<dfn title="{$term}"><b style="color: red"> &#x25CA; </b></dfn>
  </xsl:template>



</xsl:stylesheet>
