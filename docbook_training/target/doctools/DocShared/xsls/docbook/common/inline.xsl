<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.0'>

	<xsl:param name="uppercase.alpha">
	  <xsl:call-template name="gentext">
		<xsl:with-param name="key" select="'uppercase.alpha'"/>
	  </xsl:call-template>
	</xsl:param>
	<xsl:param name="lowercase.alpha">
	  <xsl:call-template name="gentext">
		<xsl:with-param name="key" select="'lowercase.alpha'"/>
	  </xsl:call-template>
	</xsl:param>

<xsl:template match="methodname[@role='bold']">
  <xsl:call-template name="inline.boldmonoseq"/>
</xsl:template>


<xsl:template match="productname">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<!-- Changed from inline.boldseq -->
<xsl:template match="command">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="property|action">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>


<xsl:template match="envar">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="errortext">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<!--=== changed from inline.charseq ===-->
<xsl:template match="guibutton">
  <xsl:call-template name="inline.boldseq"/>
</xsl:template>

<xsl:template match="guiicon">
  <xsl:call-template name="inline.boldseq"/>
</xsl:template>

<xsl:template match="guilabel">
  <xsl:call-template name="inline.boldseq"/>
</xsl:template>

<xsl:template match="guimenu">
  <xsl:call-template name="inline.boldseq"/>
</xsl:template>

<xsl:template match="guimenuitem">
  <xsl:call-template name="inline.boldseq"/>
</xsl:template>

<xsl:template match="guisubmenu">
  <xsl:call-template name="inline.boldseq"/>
</xsl:template>


<xsl:template match="interface">
	<xsl:choose>
	  <!-- DWC: This hack lets us make things tagged as
	  interface (e.g. window titles) be bold in german but
	  not in other languages -->
	  <xsl:when test="substring-before(//@lang[1], '_') = 'de' or //@lang[1] = 'de'">
		<xsl:call-template name="inline.boldseq"/>
	  </xsl:when>
	  <xsl:otherwise>
		<xsl:call-template name="inline.charseq"/>
	  </xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- ================================== -->

<!-- changed from boldseq -->
<!-- Now changes case of all keycaps to uppercase. Works -->
<!-- fine with English. Needs to be localized as soon as I -->
<!-- figure out how to retrieve the values of -->
<!-- uppercase.alpha and lowercase.alpha from Norm's stylesheets. -->
  <xsl:template match="keycap">
	<xsl:value-of 
	  select="translate(., 
	  $lowercase.alpha, 
	  $uppercase.alpha)"/>
	<!--xsl:call-template name="inline.charseq"/-->
  </xsl:template>

<!-- changed, added class = option test -->
<xsl:template match="replaceable">
 <xsl:choose>
  <xsl:when test="@class='option'">
   [<xsl:call-template name="inline.italicseq"/>]
  </xsl:when>
  <xsl:otherwise>
   <xsl:call-template name="inline.italicseq"/>
  </xsl:otherwise>
 </xsl:choose>  
</xsl:template>


  <!-- changed from boldmonoseq -->
  <xsl:template match="userinput | literal | database">
		<xsl:call-template name="inline.monoseq"/>
  </xsl:template>

  <xsl:template match="literal[@role = 'bold']">
		<xsl:call-template name="inline.boldmonoseq"/>
  </xsl:template>  

  <xsl:template match="filename">
		<xsl:call-template name="inline.monoseq"/>
  </xsl:template>

<!-- added tests -->
<xsl:template match="emphasis">
  <xsl:choose>
    <xsl:when test="@role='bold'">
	 <xsl:call-template name="inline.boldseq"/>
	</xsl:when>
	<xsl:when test="@role='monospace'">
      <xsl:call-template name="inline.monoseq"/>
    </xsl:when>
	<xsl:when test="@role='monospace_bold'">
      <xsl:call-template name="inline.boldmonoseq"/>
    </xsl:when>
	<xsl:when test="@role='monospace_italic'">
      <xsl:call-template name="inline.italicmonoseq"/>
    </xsl:when>
	<xsl:otherwise>
	 <xsl:call-template name="inline.italicseq"/>
	</xsl:otherwise>
  </xsl:choose>
</xsl:template>  

<!--xsl:template match="emphasis">
  <xsl:choose>
    <xsl:when test="@role='bold'">
	 <xsl:call-template name="inline.boldseq"/>
	</xsl:when>
	<xsl:otherwise>
	 <xsl:call-template name="inline.italicseq"/>
	</xsl:otherwise>
  </xsl:choose>
</xsl:template-->   


<!-- added tests -->
<xsl:template match="classname">
  <xsl:choose>
    <xsl:when test="@role='charseq'">
	 <xsl:call-template name="inline.charseq"/>
	</xsl:when>
	<xsl:otherwise>
	 <xsl:call-template name="inline.monoseq"/>
	</xsl:otherwise>
  </xsl:choose>
</xsl:template>  


<!-- added tests -->
<xsl:template match="systemitem">
  <!--xsl:choose>
    <xsl:when test="@class='groupname'">
	 <xsl:call-template name="inline.boldseq"/>
	</xsl:when>
	<xsl:when test="@class='username'">
      <xsl:call-template name="inline.boldseq"/>
    </xsl:when>
	<xsl:otherwise-->
	 <xsl:call-template name="inline.monoseq"/>
	<!--/xsl:otherwise>
  </xsl:choose-->
</xsl:template>  

<xsl:template match="ulink/citetitle">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template name="format.sgmltag">
  <xsl:param name="class">
    <xsl:choose>
      <xsl:when test="@class">
        <xsl:value-of select="@class"/>
      </xsl:when>
      <xsl:otherwise>element</xsl:otherwise>
    </xsl:choose>
  </xsl:param>
	<xsl:choose>
	  <xsl:when test="not(parent::title)">
  <tt xmlns="http://www.w3.org/1999/xhtml" class="sgmltag-{$class}">
    <xsl:choose>
      <xsl:when test="$class='attribute'">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:when test="$class='attvalue'">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:when test="$class='element'">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:when test="$class='endtag'">
        <xsl:text>&lt;/</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&gt;</xsl:text>
      </xsl:when>
      <xsl:when test="$class='genentity'">
        <xsl:text>&amp;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>;</xsl:text>
      </xsl:when>
      <xsl:when test="$class='numcharref'">
        <xsl:text>&amp;#</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>;</xsl:text>
      </xsl:when>
      <xsl:when test="$class='paramentity'">
        <xsl:text>%</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>;</xsl:text>
      </xsl:when>
      <xsl:when test="$class='pi'">
        <xsl:text>&lt;?</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&gt;</xsl:text>
      </xsl:when>
      <xsl:when test="$class='xmlpi'">
        <xsl:text>&lt;?</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>?&gt;</xsl:text>
      </xsl:when>
      <xsl:when test="$class='starttag'">
        <xsl:text>&lt;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&gt;</xsl:text>
      </xsl:when>
      <xsl:when test="$class='emptytag'">
        <xsl:text>&lt;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>/&gt;</xsl:text>
      </xsl:when>
      <xsl:when test="$class='sgmlcomment'">
        <xsl:text>&lt;!--</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>--&gt;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </tt>
		</xsl:when>
	  <xsl:otherwise>
    <xsl:choose>
      <xsl:when test="$class='attribute'">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:when test="$class='attvalue'">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:when test="$class='element'">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:when test="$class='endtag'">
        <xsl:text>&lt;/</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&gt;</xsl:text>
      </xsl:when>
      <xsl:when test="$class='genentity'">
        <xsl:text>&amp;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>;</xsl:text>
      </xsl:when>
      <xsl:when test="$class='numcharref'">
        <xsl:text>&amp;#</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>;</xsl:text>
      </xsl:when>
      <xsl:when test="$class='paramentity'">
        <xsl:text>%</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>;</xsl:text>
      </xsl:when>
      <xsl:when test="$class='pi'">
        <xsl:text>&lt;?</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&gt;</xsl:text>
      </xsl:when>
      <xsl:when test="$class='xmlpi'">
        <xsl:text>&lt;?</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>?&gt;</xsl:text>
      </xsl:when>
      <xsl:when test="$class='starttag'">
        <xsl:text>&lt;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&gt;</xsl:text>
      </xsl:when>
      <xsl:when test="$class='emptytag'">
        <xsl:text>&lt;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>/&gt;</xsl:text>
      </xsl:when>
      <xsl:when test="$class='sgmlcomment'">
        <xsl:text>&lt;!--</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>--&gt;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
	  </xsl:otherwise>
	</xsl:choose>
</xsl:template>


<xsl:template match="keycombo">
  <xsl:variable name="action" select="@action"/>
  <xsl:variable name="joinchar">
    <xsl:choose>
      <xsl:when test="$action='seq'"><xsl:text> </xsl:text></xsl:when>
      <xsl:when test="$action='simul'">+</xsl:when>
      <xsl:when test="$action='press'">-</xsl:when>
      <xsl:when test="$action='click'">-</xsl:when>
      <xsl:when test="$action='double-click'">-</xsl:when>
      <xsl:when test="$action='other'"></xsl:when>
      <xsl:otherwise>+</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:for-each select="*">
    <xsl:if test="position()>1"><xsl:value-of select="$joinchar"/></xsl:if>
    <xsl:apply-templates select="."/>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>

