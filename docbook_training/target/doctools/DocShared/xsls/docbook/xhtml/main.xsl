<?xml version="1.0" encoding="US-ASCII"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://icl.com/saxon"
  xmlns:lxslt="http://xml.apache.org/xslt"
  xmlns:xalanredirect="org.apache.xalan.xslt.extensions.Redirect"
  xmlns:exsl="http://exslt.org/common" xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
  xmlns="http://www.w3.org/1999/xhtml" version="1.1" exclude-result-prefixes="doc"
  extension-element-prefixes="saxon xalanredirect lxslt exsl">


  <xsl:import href="../common/common.xsl"/>
  <!-- added to fix jcbg-718-->
  <xsl:import href="../common/inline.xsl"/>
  <xsl:import href="admon.xsl"/>
  <xsl:import href="keywords.xsl"/>
  <xsl:import href="param.xsl"/>
  <!-- each output calls it on its own?
  <xsl:import href="../xhtml/titlepage.xsl"/>-->
  <xsl:import href="table.xsl"/>
  <xsl:import href="lists.xsl"/>
  <xsl:import href="xref.xsl"/>
  <xsl:import href="qandaset.xsl"/>
  <xsl:param name="dest.dir"/>
  <xsl:param name="tooltip.glossterms"/>
  <xsl:param name="feedback.email">mpd-techpubsall@list.nokia.com</xsl:param> <!-- JCBG-2073-->
  <xsl:param name="feedback.type">jira</xsl:param>
  <xsl:param name="feedback.component">nothing</xsl:param>
  <xsl:param name="feedback.assignee">nobody</xsl:param>
  <xsl:param name="feedback.project">noproject</xsl:param>
  <xsl:param name="feedback.version">noversion</xsl:param>
  <xsl:param name="feedback.jirahostname">nojira.nomotive.nocom</xsl:param>
  <xsl:param name="feedback.issuetype">noissuetype</xsl:param> <!-- JCBG-2017 -->

  <!-- oops, turns out this is dangerous...you get line breaks -->
  <!-- in the output in unwanted places :( -->
  <!--xsl:param name="chunker.output.indent" select="'yes'"/ -->

  <xsl:param name="debug" value="false"/>
  <!-- Including for a reason? -->
  <xsl:param name="shade.verbatim" select="0"/>
  <xsl:param name="security"/>
  <xsl:param name="formal.title.placement"> figure before example before equation before table
    before procedure before </xsl:param>

  <xsl:param name="chunk.quietly" select="1"/>
  <xsl:param name="chunker.output.omit-xml-declaration" select="'yes'"/>
  <!-- autolabeling: i.e. '1. How to foo the bar' -->
  <!-- yes, autolabel chapters and parts -->
  <xsl:param name="chapter.autolabel" select="1"/>
  <xsl:param name="part.autolabel" select="1"/>

  <!-- no, don't autolabel sections, to fix chm bug JCBG-98 -->
  <xsl:param name="section.autolabel" select="0"/>
  <!-- turn the include component off or else, with chapter # on, you 
		   get labels like 1.. on sections, in chapter 1 -->
  <xsl:param name="section.label.includes.component.label" select="0"/>


  <xsl:param name="appendix.autolabel" select="1"/>

  <xsl:param name="qanda.defaultlabel">qanda</xsl:param>

  <!-- Admonitions: Yes to graphics, as .gif -->
  <xsl:param name="admon.graphics" select="0"/>
  <xsl:param name="admon.graphics.path" select="'./common/'"/>
  <xsl:param name="admon.graphics.extension" select="'.gif'"/>
  <xsl:param name="admon.style" select="'margin-left: 0in; margin-right: 0.5in;'"/>
  <xsl:param name="runin.admon.style" select="'margin-left: 0.5in; margin-right: 0.5in;'"/>
  <!-- callouts -->
  <xsl:param name="callout.graphics.extension" select="'.png'"/>
  <xsl:param name="callout.graphics.path" select="'images/_common/'"/>

  <xsl:param name="PLANID"/>
  <xsl:param name="BUILDNUMBER"/>


  <!-- css -->

  <!-- for JCBG-1585 and JCBG-672, new param css.filename -->
  <xsl:param name="css.filename" select="'html.css'"/>
  <xsl:param name="html.stylesheet" select="concat('common/css/', $css.filename)"/>

  <xsl:param name="css.decoration">1</xsl:param>

  <xsl:param name="spacing.paras" select="1"/>

  <xsl:param name="glossterm.auto.link" select="'1'"/>

  <xsl:param name="runinhead.default.title.end.punct" select="'.'"/>



  <!-- Removing this. It's just too dangerous. -->
  <!--   <xsl:template match="processing-instruction('sbr')"><xsl:text>&#x200B;</xsl:text></xsl:template> -->

  <!-- DWC: Adding [position() &gt; 1] predicate to para because we have customized the
  dtd such that formal paras can now contain more than one para.  -->
  <xsl:template match="formalpara/para[position() &gt; 1]">
    <xsl:call-template name="paragraph">
      <xsl:with-param name="class">
        <xsl:if test="@role and $para.propagates.style != 0">
          <xsl:value-of select="@role"/>
        </xsl:if>
      </xsl:with-param>
      <xsl:with-param name="content">
        <xsl:if test="position() = 1 and parent::listitem">
          <xsl:call-template name="anchor">
            <xsl:with-param name="node" select="parent::listitem"/>
          </xsl:call-template>
        </xsl:if>

        <xsl:call-template name="anchor"/>
        <xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <!-- <xsl:template match="comment|remark"> -->
  <!--   <xsl:if test="$show.comments != 0"> -->
  <!--     <span style="background-color: yellow" xmlns="http://www.w3.org/1999/xhtml"><xsl:call-template name="inline.charseq"/></span> -->
  <!--   </xsl:if> -->
  <!-- </xsl:template> -->

  <!-- ==================================================================== -->

  <xsl:template
    match="comment[parent::answer|parent::appendix|parent::article|parent::bibliodiv|                                   parent::bibliography|parent::blockquote|parent::caution|parent::chapter|                                   parent::glossary|parent::glossdiv|parent::important|parent::index|                                   parent::indexdiv|parent::listitem|parent::note|parent::orderedlist|                                   parent::partintro|parent::preface|parent::procedure|parent::qandadiv|                                   parent::qandaset|parent::question|parent::refentry|parent::refnamediv|                                   parent::refsect1|parent::refsect2|parent::refsect3|parent::refsection|                                   parent::refsynopsisdiv|parent::sect1|parent::sect2|parent::sect3|parent::sect4|                                   parent::sect5|parent::section|parent::setindex|parent::sidebar|                                   parent::simplesect|parent::taskprerequisites|parent::taskrelated|                                   parent::tasksummary|parent::warning]|remark[parent::answer|parent::appendix|parent::article|parent::bibliodiv|                                   parent::bibliography|parent::blockquote|parent::caution|parent::chapter|                                   parent::glossary|parent::glossdiv|parent::important|parent::index|                                   parent::indexdiv|parent::listitem|parent::note|parent::orderedlist|                                   parent::partintro|parent::preface|parent::procedure|parent::qandadiv|                                   parent::qandaset|parent::question|parent::refentry|parent::refnamediv|                                   parent::refsect1|parent::refsect2|parent::refsect3|parent::refsection|                                   parent::refsynopsisdiv|parent::sect1|parent::sect2|parent::sect3|parent::sect4|                                   parent::sect5|parent::section|parent::setindex|parent::sidebar|                                   parent::simplesect|parent::taskprerequisites|parent::taskrelated|                                   parent::tasksummary|parent::warning]">
    <xsl:if test="$show.comments != 0">
      <p class="remark">
        <span>
          <xsl:if test="ancestor-or-self::*[@security='internal']">
            <xsl:attribute name="class">internal</xsl:attribute>
          </xsl:if>
          <xsl:call-template name="inline.charseq"/>
        </span>
      </p>
    </xsl:if>
  </xsl:template>

  <!-- added name to template below, so that a template in monolithic-html.xsl could call this, for JCBG-933-->
  <xsl:template name="main.comment.remark.xhmtl" match="comment|remark">
    <xsl:if test="$show.comments != 0">
      <span>
        <xsl:if test="ancestor-or-self::*[@security='internal']">
          <xsl:attribute name="class">internal</xsl:attribute>
        </xsl:if>
        <span class="remark">
          <xsl:call-template name="inline.charseq"/>
        </span>
      </span>
    </xsl:if>
  </xsl:template>


  <xsl:template name="next.itemsymbol">
    <xsl:param name="itemsymbol" select="'default'"/>
    <xsl:choose>
      <!-- Change this list if you want to change the order of symbols -->
      <xsl:when test="$itemsymbol = 'disc'">square</xsl:when>
      <xsl:when test="$itemsymbol = 'square'">circle</xsl:when>
      <xsl:when test="$itemsymbol = 'round'">disc</xsl:when>
      <xsl:otherwise>disc</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- This comes from xhtml/inline.xsl -->
  <xsl:template name="inline.monoseq">
    <xsl:param name="content">
      <xsl:call-template name="anchor"/>
      <xsl:call-template name="simple.xlink">
        <xsl:with-param name="content">
          <xsl:apply-templates/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:param>
    <xsl:choose>
      <xsl:when test="not(parent::title)">
        <tt xmlns="http://www.w3.org/1999/xhtml">
          <xsl:copy-of select="$content"/>
        </tt>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$content"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="biblioid">
    <div class="biblioid">
      <xsl:apply-templates/>
    </div>
  </xsl:template>


  <xsl:template match="email">
    <a xmlns="http://www.w3.org/1999/xhtml">
      <xsl:if test="@id">
        <xsl:attribute name="id">
          <xsl:value-of select="@id"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:attribute name="href">mailto:<xsl:value-of select="normalize-space(.)"/></xsl:attribute>
      <xsl:apply-templates/>
    </a>
  </xsl:template>


  <xsl:template match="errorcode">
    <xsl:call-template name="inline.charseq"/>
  </xsl:template>

  <xsl:template match="glossentry/glosssee">
    <xsl:variable name="otherterm" select="@otherterm"/>
    <xsl:variable name="targets" select="//node()[@id=$otherterm]"/>
    <xsl:variable name="target" select="$targets[1]"/>

    <xsl:variable name="current.language">
      <xsl:call-template name="l10n.language"/>
    </xsl:variable>

    <xsl:variable name="dfn">
      <xsl:if test="$tooltip.glossterms != 0">
        <xsl:apply-templates
          select="//book/glossary//glossentry[./@id = current()/@otherterm]/glossdef" mode="overLib"
        />
      </xsl:if>
    </xsl:variable>

    <dd xmlns="http://www.w3.org/1999/xhtml">
      <p>

        <xsl:choose>
          <!-- DWC: HACK HACK HACK. We have to do this because
		this template is not adequately i18nized and you
		can't change the order of the gentext and the term. Same with
		glossseealso below. -->
          <xsl:when test="substring(normalize-space($current.language),1,2) = 'ja'">
                &#x300C;<xsl:choose><xsl:when test="$target">
                <a href="#{@otherterm}" class="glossterm">
                  <xsl:if test="$tooltip.glossterms != 0">
                    <xsl:attribute name="onmouseover">return overlib('<xsl:value-of select="$dfn"
                      />');</xsl:attribute>
                    <xsl:attribute name="onmouseout">return nd();</xsl:attribute>
                  </xsl:if>
                  <xsl:value-of select="translate(.,'&#x3002;','')"/>
                </a>
              </xsl:when>
              <xsl:when test="$otherterm != '' and not($target)">
                <xsl:message>
                  <xsl:text>Warning: glosssee @otherterm reference not found: </xsl:text>
                  <xsl:value-of select="$otherterm"/>
                </xsl:message>
                <xsl:apply-templates/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates/>
              </xsl:otherwise>
            </xsl:choose>&#x300D;&#x3092;&#x53C2;&#x7167;&#x3057;&#x3066;&#x304F;&#x3060;&#x3055;&#x3044;&#x3002; </xsl:when>
          <xsl:otherwise>

            <xsl:variable name="template">
              <xsl:call-template name="gentext.template">
                <xsl:with-param name="context" select="'glossary'"/>
                <xsl:with-param name="name" select="'see'"/>
              </xsl:call-template>
            </xsl:variable>

            <xsl:variable name="title">
              <xsl:choose>
                <xsl:when test="$target">
                  <a xmlns="http://www.w3.org/1999/xhtml" href="#{@otherterm}" class="glossterm">
                    <xsl:if test="$tooltip.glossterms != 0">
                      <xsl:attribute name="onmouseover">return overlib('<xsl:value-of select="$dfn"
                        />');</xsl:attribute>
                      <xsl:attribute name="onmouseout">return nd();</xsl:attribute>
                    </xsl:if>
                    <xsl:apply-templates select="$target" mode="xref-to"/>
                  </a>
                </xsl:when>
                <xsl:when test="$otherterm != '' and not($target)">
                  <xsl:message>
                    <xsl:text>Warning: glosssee @otherterm reference not found: </xsl:text>
                    <xsl:value-of select="$otherterm"/>
                  </xsl:message>
                  <xsl:apply-templates/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:apply-templates/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>

            <xsl:call-template name="substitute-markup">
              <xsl:with-param name="template" select="$template"/>
              <xsl:with-param name="title" select="$title"/>
            </xsl:call-template>
            <!-- DWC: Removing this period...can't recall why -->
            <!--xsl:text>.</xsl:text-->

          </xsl:otherwise>
        </xsl:choose>
      </p>
    </dd>
  </xsl:template>


  <!-- This template removes empty glossterms rather than -->
  <!-- inserting an <a href="blah.glossary"><em -->
  <!-- class="glossary"/></a>. We need to do this becasue that -->
  <!-- empty element causes everything after it to be -->
  <!-- italicized. -->
  <xsl:template match="glossterm[normalize-space(.) = '']" priority="100"/>


  <xsl:template match="*" mode="overLib">
    <xsl:for-each select="*[not(self::glossseealso)]">
      <xsl:value-of select='normalize-space(translate(.,"&#39;","&#8217;"))'/>
      <xsl:if test="self::para">
        <xsl:text>&lt;br/></xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:apply-templates select="glossseealso" mode="overLib"/>
  </xsl:template>

  <xsl:template match="glossseealso[1]" mode="overLib"> See also: <xsl:value-of
      select='normalize-space(translate(.,"&#39;","&#8217;"))'/></xsl:template>
  <xsl:template match="glossseealso" mode="overLib">, <xsl:value-of
      select='normalize-space(translate(.,"&#39;","&#8217;"))'/></xsl:template>

  <!-- All this just to change italics to normal -->
  <xsl:template match="glossterm[not(parent::glossentry)]" name="glossterm">
    <xsl:param name="firstterm" select="0"/>

    <!-- To avoid extra <a name=""> anchor from inline.italicseq -->
    <xsl:variable name="content">
      <xsl:apply-templates/>
    </xsl:variable>

    <xsl:variable name="dfn">
      <xsl:if test="$tooltip.glossterms != 0">
        <xsl:apply-templates
          select="//book/glossary//glossentry[./@id = current()/@linkend]/glossdef" mode="overLib"/>
      </xsl:if>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="($firstterm.only.link = 0 or $firstterm = 1) and @linkend">
        <xsl:variable name="targets" select="key('id',@linkend)"/>
        <xsl:variable name="target" select="$targets[1]"/>

        <xsl:call-template name="check.id.unique">
          <xsl:with-param name="linkend" select="@linkend"/>
        </xsl:call-template>

        <a xmlns="http://www.w3.org/1999/xhtml" class="glossterm">
          <xsl:if test="@id">
            <xsl:attribute name="id">
              <xsl:value-of select="@id"/>
            </xsl:attribute>
          </xsl:if>

          <xsl:attribute name="href">
            <xsl:call-template name="href.target">
              <xsl:with-param name="object" select="$target"/>
            </xsl:call-template>
          </xsl:attribute>

          <xsl:if test="$tooltip.glossterms != 0">
            <xsl:attribute name="onmouseover">return overlib('<xsl:value-of select="$dfn"
              />');</xsl:attribute>
            <xsl:attribute name="onmouseout">return nd();</xsl:attribute>
          </xsl:if>

          <xsl:call-template name="inline.charseq">
            <xsl:with-param name="content" select="$content"/>
          </xsl:call-template>
        </a>
      </xsl:when>

      <xsl:when
        test="not(@linkend)                     and ($firstterm.only.link = 0 or $firstterm = 1)                     and ($glossterm.auto.link != 0)                     and $glossary.collection != ''">
        <xsl:variable name="term">
          <xsl:choose>
            <xsl:when test="@baseform">
              <xsl:value-of select="@baseform"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="."/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <xsl:variable name="cterm"
          select="(document($glossary.collection,.)//glossentry[glossterm=$term])[1]"/>

        <!-- HACK HACK HACK! But it works... -->
        <!-- You'd need to do more work if you wanted to chunk on glossdiv, though -->

        <xsl:variable name="glossary" select="//glossary[@role='auto']"/>

        <xsl:if test="count($glossary) != 1">
          <xsl:message>
            <xsl:text>Warning: glossary.collection specified, but there are </xsl:text>
            <xsl:value-of select="count($glossary)"/>
            <xsl:text> automatic glossaries</xsl:text>
          </xsl:message>
        </xsl:if>

        <xsl:variable name="glosschunk">
          <xsl:call-template name="href.target">
            <xsl:with-param name="object" select="$glossary"/>
          </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="chunkbase">
          <xsl:choose>
            <xsl:when test="contains($glosschunk, '#')">
              <xsl:value-of select="substring-before($glosschunk, '#')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$glosschunk"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <xsl:choose>
          <xsl:when test="not($cterm)">
            <xsl:message>
              <xsl:text>There's no entry for </xsl:text>
              <xsl:value-of select="$term"/>
              <xsl:text> in </xsl:text>
              <xsl:value-of select="$glossary.collection"/>
            </xsl:message>
            <xsl:call-template name="inline.charseq"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="id">
              <xsl:choose>
                <xsl:when test="$cterm/@id">
                  <xsl:value-of select="$cterm/@id"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="generate-id($cterm)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <a xmlns="http://www.w3.org/1999/xhtml" href="{$chunkbase}#{$id}">
              <xsl:call-template name="inline.charseq">
                <xsl:with-param name="content" select="$content"/>
              </xsl:call-template>
            </a>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when
        test="not(@linkend)                     and ($firstterm.only.link = 0 or $firstterm = 1)                     and $glossterm.auto.link != 0">
        <xsl:variable name="term">
          <xsl:choose>
            <xsl:when test="@baseform">
              <xsl:value-of select="normalize-space(@baseform)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="normalize-space(.)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="targets"
          select="//glossentry[normalize-space(glossterm)=$term                               or normalize-space(glossterm/@baseform)=$term]"/>
        <xsl:variable name="target" select="$targets[1]"/>

        <xsl:choose>
          <xsl:when test="count($targets)=0">
            <xsl:message>
              <xsl:text>Error: no glossentry for glossterm: </xsl:text>
              <xsl:value-of select="."/>
              <xsl:text>.</xsl:text>
            </xsl:message>
            <xsl:call-template name="inline.charseq"/>
          </xsl:when>
          <xsl:otherwise>
            <a xmlns="http://www.w3.org/1999/xhtml" class="glossterm">
              <xsl:if test="@id">
                <xsl:attribute name="id">
                  <xsl:value-of select="@id"/>
                </xsl:attribute>
              </xsl:if>

              <xsl:attribute name="href">
                <xsl:call-template name="href.target">
                  <xsl:with-param name="object" select="$target"/>
                </xsl:call-template>
              </xsl:attribute>

              <xsl:if test="$tooltip.glossterms != 0">
                <xsl:attribute name="onmouseover">return overlib('<xsl:value-of select="$dfn"
                  />');</xsl:attribute>
                <xsl:attribute name="onmouseout">return nd();</xsl:attribute>
              </xsl:if>

              <xsl:call-template name="inline.charseq">
                <xsl:with-param name="content" select="$content"/>
              </xsl:call-template>
            </a>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:otherwise>
        <xsl:call-template name="inline.charseq"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- Overriding a template from the distribution. We don't -->
  <!-- want our xrefs to be italics. -->
  <xsl:template match="chapter|appendix" mode="insert.title.markup">
    <xsl:param name="purpose"/>
    <xsl:param name="xrefstyle"/>
    <xsl:param name="title"/>

    <xsl:choose>
      <xsl:when test="$purpose = 'xref'">
        <!--i-->
        <xsl:copy-of select="$title"/>
        <!--/i-->
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$title"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="write.chunk">
    <xsl:param name="filename" select="''"/>
    <xsl:param name="dest.dir.filename">
      <xsl:if test="$dest.dir">
        <xsl:value-of select="concat($dest.dir,'/')"/>
      </xsl:if>
      <xsl:value-of select="$filename"/>
    </xsl:param>
    <xsl:param name="quiet" select="0"/>

    <xsl:param name="method" select="$chunker.output.method"/>
    <xsl:param name="encoding" select="$chunker.output.encoding"/>
    <xsl:param name="indent" select="$chunker.output.indent"/>
    <xsl:param name="omit-xml-declaration" select="$chunker.output.omit-xml-declaration"/>
    <xsl:param name="standalone" select="$chunker.output.standalone"/>
    <xsl:param name="doctype-public" select="$chunker.output.doctype-public"/>
    <xsl:param name="doctype-system" select="$chunker.output.doctype-system"/>
    <xsl:param name="media-type" select="$chunker.output.media-type"/>
    <xsl:param name="cdata-section-elements" select="$chunker.output.cdata-section-elements"/>

    <xsl:param name="content"/>

    <xsl:if test="$quiet = 0">
      <xsl:message>
        <xsl:text>Writing </xsl:text>
        <xsl:value-of select="$filename"/>
        <xsl:if test="name(.) != ''">
          <xsl:text> for </xsl:text>
          <xsl:value-of select="name(.)"/>
          <xsl:if test="@id">
            <xsl:text>(</xsl:text>
            <xsl:value-of select="@id"/>
            <xsl:text>)</xsl:text>
          </xsl:if>
        </xsl:if>
      </xsl:message>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="element-available('exsl:document')">
        <xsl:choose>
          <!-- Handle the permutations ... -->
          <xsl:when test="$media-type != ''">
            <xsl:choose>
              <xsl:when test="$doctype-public != '' and $doctype-system != ''">
                <exsl:document href="{$dest.dir.filename}" method="{$method}" encoding="{$encoding}"
                  indent="{$indent}" omit-xml-declaration="{$omit-xml-declaration}"
                  cdata-section-elements="{$cdata-section-elements}" media-type="{$media-type}"
                  doctype-public="{$doctype-public}" doctype-system="{$doctype-system}"
                  standalone="{$standalone}">
                  <xsl:copy-of select="$content"/>
                </exsl:document>
              </xsl:when>
              <xsl:when test="$doctype-public != '' and $doctype-system = ''">
                <exsl:document href="{$dest.dir.filename}" method="{$method}" encoding="{$encoding}"
                  indent="{$indent}" omit-xml-declaration="{$omit-xml-declaration}"
                  cdata-section-elements="{$cdata-section-elements}" media-type="{$media-type}"
                  doctype-public="{$doctype-public}" standalone="{$standalone}">
                  <xsl:copy-of select="$content"/>
                </exsl:document>
              </xsl:when>
              <xsl:when test="$doctype-public = '' and $doctype-system != ''">
                <exsl:document href="{$dest.dir.filename}" method="{$method}" encoding="{$encoding}"
                  indent="{$indent}" omit-xml-declaration="{$omit-xml-declaration}"
                  cdata-section-elements="{$cdata-section-elements}" media-type="{$media-type}"
                  doctype-system="{$doctype-system}" standalone="{$standalone}">
                  <xsl:copy-of select="$content"/>
                </exsl:document>
              </xsl:when>
              <xsl:otherwise>
                <!-- $doctype-public = '' and $doctype-system = ''"> -->
                <exsl:document href="{$dest.dir.filename}" method="{$method}" encoding="{$encoding}"
                  indent="{$indent}" omit-xml-declaration="{$omit-xml-declaration}"
                  cdata-section-elements="{$cdata-section-elements}" media-type="{$media-type}"
                  standalone="{$standalone}">
                  <xsl:copy-of select="$content"/>
                </exsl:document>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="$doctype-public != '' and $doctype-system != ''">
                <exsl:document href="{$dest.dir.filename}" method="{$method}" encoding="{$encoding}"
                  indent="{$indent}" omit-xml-declaration="{$omit-xml-declaration}"
                  cdata-section-elements="{$cdata-section-elements}"
                  doctype-public="{$doctype-public}" doctype-system="{$doctype-system}"
                  standalone="{$standalone}">
                  <xsl:copy-of select="$content"/>
                </exsl:document>
              </xsl:when>
              <xsl:when test="$doctype-public != '' and $doctype-system = ''">
                <exsl:document href="{$dest.dir.filename}" method="{$method}" encoding="{$encoding}"
                  indent="{$indent}" omit-xml-declaration="{$omit-xml-declaration}"
                  cdata-section-elements="{$cdata-section-elements}"
                  doctype-public="{$doctype-public}" standalone="{$standalone}">
                  <xsl:copy-of select="$content"/>
                </exsl:document>
              </xsl:when>
              <xsl:when test="$doctype-public = '' and $doctype-system != ''">
                <exsl:document href="{$dest.dir.filename}" method="{$method}" encoding="{$encoding}"
                  indent="{$indent}" omit-xml-declaration="{$omit-xml-declaration}"
                  cdata-section-elements="{$cdata-section-elements}"
                  doctype-system="{$doctype-system}" standalone="{$standalone}">
                  <xsl:copy-of select="$content"/>
                </exsl:document>
              </xsl:when>
              <xsl:otherwise>
                <!-- $doctype-public = '' and $doctype-system = ''"> -->
                <exsl:document href="{$dest.dir.filename}" method="{$method}" encoding="{$encoding}"
                  indent="{$indent}" omit-xml-declaration="{$omit-xml-declaration}"
                  cdata-section-elements="{$cdata-section-elements}" standalone="{$standalone}">
                  <xsl:copy-of select="$content"/>
                </exsl:document>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="element-available('saxon:output')">
        <xsl:choose>
          <!-- Handle the permutations ... -->
          <xsl:when test="$media-type != ''">
            <xsl:choose>
              <xsl:when test="$doctype-public != '' and $doctype-system != ''">
                <saxon:output saxon:character-representation="{$saxon.character.representation}"
                  href="{$dest.dir.filename}" method="{$method}" encoding="{$encoding}"
                  indent="{$indent}" omit-xml-declaration="{$omit-xml-declaration}"
                  cdata-section-elements="{$cdata-section-elements}" media-type="{$media-type}"
                  doctype-public="{$doctype-public}" doctype-system="{$doctype-system}"
                  standalone="{$standalone}">
                  <xsl:copy-of select="$content"/>
                </saxon:output>
              </xsl:when>
              <xsl:when test="$doctype-public != '' and $doctype-system = ''">
                <saxon:output saxon:character-representation="{$saxon.character.representation}"
                  href="{$dest.dir.filename}" method="{$method}" encoding="{$encoding}"
                  indent="{$indent}" omit-xml-declaration="{$omit-xml-declaration}"
                  cdata-section-elements="{$cdata-section-elements}" media-type="{$media-type}"
                  doctype-public="{$doctype-public}" standalone="{$standalone}">
                  <xsl:copy-of select="$content"/>
                </saxon:output>
              </xsl:when>
              <xsl:when test="$doctype-public = '' and $doctype-system != ''">
                <saxon:output saxon:character-representation="{$saxon.character.representation}"
                  href="{$dest.dir.filename}" method="{$method}" encoding="{$encoding}"
                  indent="{$indent}" omit-xml-declaration="{$omit-xml-declaration}"
                  cdata-section-elements="{$cdata-section-elements}" media-type="{$media-type}"
                  doctype-system="{$doctype-system}" standalone="{$standalone}">
                  <xsl:copy-of select="$content"/>
                </saxon:output>
              </xsl:when>
              <xsl:otherwise>
                <!-- $doctype-public = '' and $doctype-system = ''"> -->
                <saxon:output saxon:character-representation="{$saxon.character.representation}"
                  href="{$dest.dir.filename}" method="{$method}" encoding="{$encoding}"
                  indent="{$indent}" omit-xml-declaration="{$omit-xml-declaration}"
                  cdata-section-elements="{$cdata-section-elements}" media-type="{$media-type}"
                  standalone="{$standalone}">
                  <xsl:copy-of select="$content"/>
                </saxon:output>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="$doctype-public != '' and $doctype-system != ''">
                <saxon:output saxon:character-representation="{$saxon.character.representation}"
                  href="{$dest.dir.filename}" method="{$method}" encoding="{$encoding}"
                  indent="{$indent}" omit-xml-declaration="{$omit-xml-declaration}"
                  cdata-section-elements="{$cdata-section-elements}"
                  doctype-public="{$doctype-public}" doctype-system="{$doctype-system}"
                  standalone="{$standalone}">
                  <xsl:copy-of select="$content"/>
                </saxon:output>
              </xsl:when>
              <xsl:when test="$doctype-public != '' and $doctype-system = ''">
                <saxon:output saxon:character-representation="{$saxon.character.representation}"
                  href="{$dest.dir.filename}" method="{$method}" encoding="{$encoding}"
                  indent="{$indent}" omit-xml-declaration="{$omit-xml-declaration}"
                  cdata-section-elements="{$cdata-section-elements}"
                  doctype-public="{$doctype-public}" standalone="{$standalone}">
                  <xsl:copy-of select="$content"/>
                </saxon:output>
              </xsl:when>
              <xsl:when test="$doctype-public = '' and $doctype-system != ''">
                <saxon:output saxon:character-representation="{$saxon.character.representation}"
                  href="{$dest.dir.filename}" method="{$method}" encoding="{$encoding}"
                  indent="{$indent}" omit-xml-declaration="{$omit-xml-declaration}"
                  cdata-section-elements="{$cdata-section-elements}"
                  doctype-system="{$doctype-system}" standalone="{$standalone}">
                  <xsl:copy-of select="$content"/>
                </saxon:output>
              </xsl:when>
              <xsl:otherwise>
                <!-- $doctype-public = '' and $doctype-system = ''"> -->
                <saxon:output saxon:character-representation="{$saxon.character.representation}"
                  href="{$dest.dir.filename}" method="{$method}" encoding="{$encoding}"
                  indent="{$indent}" omit-xml-declaration="{$omit-xml-declaration}"
                  cdata-section-elements="{$cdata-section-elements}" standalone="{$standalone}">
                  <xsl:copy-of select="$content"/>
                </saxon:output>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="element-available('xalanredirect:write')">
        <!-- Xalan uses xalanredirect -->
        <xalanredirect:write file="{$dest.dir.filename}">
          <xsl:copy-of select="$content"/>
        </xalanredirect:write>
      </xsl:when>

      <xsl:otherwise>
        <!-- it doesn't matter since we won't be making chunks... -->
        <xsl:message terminate="yes">
          <xsl:text>Can't make chunks with </xsl:text>
          <xsl:value-of select="system-property('xsl:vendor')"/>
          <xsl:text>'s processor.</xsl:text>
        </xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="system.head.content">
    <xsl:param name="node" select="."/>
    <xsl:text>
</xsl:text>
    <meta http-equiv="X-UA-Compatible" content="IE=7"/>
    <xsl:text>
</xsl:text>
  </xsl:template>

  <xsl:template name="user.head.content" xmlns="http://www.w3.org/1999/xhtml">
    <xsl:text>
</xsl:text>
    <meta name="date">
      <xsl:attribute name="content">
        <xsl:call-template name="datetime.format">
          <xsl:with-param name="date" select="date:date-time()"
            xmlns:date="http://exslt.org/dates-and-times"/>
          <xsl:with-param name="format" select="'m/d/Y H:M:S'"/>
        </xsl:call-template>
      </xsl:attribute>
    </meta>
    <xsl:text>
</xsl:text>
    <meta name="copyright">
      <xsl:attribute name="content">Copyright (c) <xsl:value-of select="//year[1]"
        /><xsl:text> </xsl:text>Alcatel-Lucent. All rights reserved. </xsl:attribute>
    </meta>
    <xsl:text>
</xsl:text>
    <xsl:if test="$hostname">
      <xsl:text>
</xsl:text>
      <meta name="build-info-maker" content="DocShared\docbook\xhtml\main.xsl"/>
      <meta name="buildinfo" content="{$hostname}"/>
    </xsl:if>
    <xsl:if test="$docfilename">
      <xsl:text>
</xsl:text>
      <meta name="docfilename" content="{$docfilename}"/>
    </xsl:if>
    <xsl:if test="$buildtag">
      <xsl:text>
</xsl:text>
      <meta name="buildtag" content="{$buildtag}"/>
    </xsl:if>
    <xsl:if test="$PLANID">
      <meta name="Build" content="{$PLANID}-{$BUILDNUMBER}"/>
    </xsl:if>
    <xsl:text>
</xsl:text>
    <xsl:call-template name="keywordset"/>
    <xsl:text>
</xsl:text>
  </xsl:template>

  <!-- JCBG-1596, adding a template to do a replace -->
  <xsl:template name="feedback.replace">
    <!-- named utility template used by later template feedback, to do recursive replaces-->
    <xsl:param name="text"/>
    <xsl:param name="replace"/>
    <xsl:param name="with"/>
    <xsl:choose>
      <xsl:when test="contains($text,$replace)">
        <!-- do the replace on the first catch-->
        <xsl:value-of select="substring-before($text,$replace)"/>
        <xsl:value-of select="$with"/>
        <!-- call self to catch any further cases-->
        <xsl:call-template name="feedback.replace">
          <xsl:with-param name="text" select="substring-after($text,$replace)"/>
          <xsl:with-param name="replace" select="$replace"/>
          <xsl:with-param name="with" select="$with"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <!-- return the original text -->
        <xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="feedback" xmlns="http://www.w3.org/1999/xhtml">
    <xsl:variable name="feedback.email.role.or.param">
      <xsl:choose>
        <xsl:when test="ancestor-or-self::*/@role[starts-with(.,'feedback: ')]">
          <xsl:value-of
            select="substring-after((ancestor-or-self::*/@role[starts-with(.,'feedback: ')])[position() = last()],'feedback: ')"
          />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$feedback.email"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- the code that follows creates a succession of variables, each one with some changes over the previous one. Only the last one, feedback.email.final, 
         actually gets used in the output template content -->

    <xsl:variable name="feedback.email.nocommas">
      <!-- before, we stopped the build and threw error when we found commas in the value; now, for JCBG-1578, we'll actually
     swap them for semicolons -->
      <xsl:value-of select="translate($feedback.email.role.or.param,',',';')"/>
    </xsl:variable>
    
    <xsl:if test="$debug='true'">
    <xsl:message>DEBUG: value of feedback.email.nocommas = <xsl:value-of
        select="$feedback.email.nocommas"/> 
    </xsl:message></xsl:if>
      
    <xsl:variable name="feedback.email.downcased.alcatel">
      <!-- this takes the above var and further processes it, converting LIST.ALCATEL-LUCENT.COM-> list.alcatel-lucent.com 
	 per JCBG-1344 and JCBG-1596 -->
      <xsl:call-template name="feedback.replace">
        <xsl:with-param name="text" select="$feedback.email.nocommas"/>
        <!-- on the below, it was important to NOT use 'select' b/c that becomes an xpath expression, where here, when you want to give
                   the param value as plain text...you should use the content of the with-param... -->
        <xsl:with-param name="replace">LIST.ALCATEL-LUCENT.COM</xsl:with-param>
        <xsl:with-param name="with">list.alcatel-lucent.com</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:if test="$debug='true'">
    <xsl:message>DEBUG: value of feedback.email.downcased.alcatel = <xsl:value-of
      select="$feedback.email.downcased.alcatel"/> 
    </xsl:message></xsl:if>
    
    <xsl:variable name="feedback.email.downcased.nokia">
      <!-- this takes the above var and further processes it, converting LIST.ALCATEL-LUCENT.COM-> list.alcatel-lucent.com 
	 per JCBG-1344 and JCBG-1596 -->
      <xsl:call-template name="feedback.replace">
        <xsl:with-param name="text" select="$feedback.email.downcased.alcatel"/>
        <!-- on the below, it was important to NOT use 'select' b/c that becomes an xpath expression, where here, when you want to give
                   the param value as plain text...you should use the content of the with-param... -->
        <xsl:with-param name="replace">LIST.NOKIA.COM</xsl:with-param>
        <xsl:with-param name="with">list.nokia.com</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="$debug='true'">
   <xsl:message>DEBUG: value of feedback.email.downcased.nokia = <xsl:value-of
        select="$feedback.email.downcased.nokia"/>
    </xsl:message> </xsl:if>

    <xsl:variable name="feedback.email.listchecked">
      <xsl:choose>
        <!-- This behavior modified per JCBG-1344, JCBG-2073; now:
	  if security internal or external, use the feedback.email.role.or.param, and add mpd-techpubsall@list.nokia.com ONLY if no lists in that param
	           AND it doesn't already have mpd-techpubsall@list.nokia.com
	           
	           I'm using the string '@list' to check for lists. So, any addres with '@list.' in it will prevent pubs-feedback from being added.
	               Doing this for JCBG-2046, because we're changing from '@list.alcatel-lucent.com' to '@list.nokia.com'
	           
	  otherwise, (ie, reviewer or writeronly), just use the bare feedback.email.role.or.param
	  -->
        <xsl:when test="($security = 'internal') or ($security='external')">
          <xsl:value-of select="$feedback.email.downcased.nokia"/>
          <xsl:if test="not(contains($feedback.email.downcased.nokia,'@list'))"
            >;mpd-techpubsall@list.nokia.com</xsl:if>
        </xsl:when>


        <!-- the otherwise trips if security= reviewer or writeronly; it uses unmod feedback.email.downcased -->
        <xsl:otherwise>
          <xsl:value-of select="$feedback.email.downcased.nokia"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

  

    <xsl:variable name="feedback.email.final">
      <!-- this takes the above var and further processes it, converting list.alcatel-lucent.com to alcatel-lucent.com
        this is needed b/c alcatel lists need the @alcatel-lucent.com form for external use
	 per JCBG-1344 and JCBG-1596; this does not affect list.nokia.com, and is not needed there-->
      <xsl:choose>
        <xsl:when test="$security = 'external'">

          <xsl:call-template name="feedback.replace">
            <xsl:with-param name="text" select="$feedback.email.listchecked"/>
            <!-- on the below, it was important to NOT use 'select' b/c that becomes an xpath expression, where here, when you want to give
                   the param value as plain text...you should use the content of the with-param... -->
            <xsl:with-param name="replace">list.alcatel-lucent.com</xsl:with-param>
            <xsl:with-param name="with">alcatel-lucent.com</xsl:with-param>
          </xsl:call-template>

        </xsl:when>
        <xsl:otherwise><xsl:value-of select="$feedback.email.listchecked"/> </xsl:otherwise>
      </xsl:choose>



    </xsl:variable>

    <xsl:if test="$debug='true'">    <xsl:message>DEBUG: value of feedback.email.final = <xsl:value-of select="$feedback.email.final"
      /> 
    </xsl:message></xsl:if>

    <xsl:variable name="quote.char">'</xsl:variable>
    <xsl:variable name="dbl.quote.char">"</xsl:variable>
    
    <!-- JCBG-2059, we don't want to use feedback.type=jira when we build external docs, so: force the feedback type to email when seucrity=external. 
      Doing this via a new variable final.feedback.type, which we use in the div that follows, when we call requestComments().-->
    <xsl:variable name="final.feedback.type">
      <xsl:choose>
        <xsl:when test="$security = 'external'">email</xsl:when>
        <xsl:otherwise><xsl:value-of select="$feedback.type"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <div class="internal"
      style="font-weight: bold; padding-top: 0.5em; font-style: italic;text-align:right">
      <xsl:if test="$motive.include.infocenter.footer != '' or $security = 'reviewer'">
        <script language="Javascript" type="text/javascript"><xsl:comment><xsl:text>
	  </xsl:text>try{ requestComments('<xsl:value-of select="$final.feedback.type"/>', '<xsl:value-of select="$feedback.issuetype"/>', '<xsl:value-of select="$feedback.component"/>', '<xsl:value-of select="$feedback.assignee"/>', '<xsl:value-of select="$feedback.project"/>', '<xsl:value-of select="$feedback.version"/>', '<xsl:value-of select="$feedback.jirahostname"/>', '<xsl:value-of select="translate(translate(normalize-space(//title[1]), $quote.char,''),$dbl.quote.char,'')"/>','<xsl:value-of select="$timestamp"/>','<xsl:value-of select="$feedback.email.final"/>')}catch(e){}<xsl:text>
</xsl:text>//</xsl:comment></script>
      </xsl:if>
    </div>

  </xsl:template>

  <xsl:template match="bridgehead">
    <xsl:variable name="container"
      select="(ancestor::appendix                         |ancestor::article                         |ancestor::bibliography                         |ancestor::chapter                         |ancestor::glossary                         |ancestor::glossdiv                         |ancestor::index                         |ancestor::partintro                         |ancestor::preface                         |ancestor::refsect1                         |ancestor::refsect2                         |ancestor::refsect3                         |ancestor::sect1                         |ancestor::sect2                         |ancestor::sect3                         |ancestor::sect4                         |ancestor::sect5                         |ancestor::section                         |ancestor::setindex                         |ancestor::simplesect)[last()]"/>

    <xsl:variable name="clevel">
      <xsl:choose>
        <xsl:when
          test="local-name($container) = 'appendix'                       or local-name($container) = 'chapter'                       or local-name($container) = 'article'                       or local-name($container) = 'bibliography'                       or local-name($container) = 'glossary'                       or local-name($container) = 'index'                       or local-name($container) = 'partintro'                       or local-name($container) = 'preface'                       or local-name($container) = 'setindex'"
          >1</xsl:when>
        <xsl:when test="local-name($container) = 'glossdiv'">
          <xsl:value-of select="count(ancestor::glossdiv)+1"/>
        </xsl:when>
        <xsl:when
          test="local-name($container) = 'sect1'                       or local-name($container) = 'sect2'                       or local-name($container) = 'sect3'                       or local-name($container) = 'sect4'                       or local-name($container) = 'sect5'                       or local-name($container) = 'refsect1'                       or local-name($container) = 'refsect2'                       or local-name($container) = 'refsect3'                       or local-name($container) = 'section'                       or local-name($container) = 'simplesect'">
          <xsl:variable name="slevel">
            <xsl:call-template name="section.level">
              <xsl:with-param name="node" select="$container"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:value-of select="$slevel + 1"/>
        </xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- HTML H level is one higher than section level -->
    <xsl:variable name="hlevel">
      <xsl:choose>
        <xsl:when test="@renderas = 'sect1'">1</xsl:when>
        <xsl:when test="@renderas = 'sect2'">2</xsl:when>
        <xsl:when test="@renderas = 'sect3'">3</xsl:when>
        <xsl:when test="@renderas = 'sect4'">4</xsl:when>
        <xsl:when test="@renderas = 'sect5'">5</xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$clevel + 1"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:element name="h{$hlevel}" namespace="http://www.w3.org/1999/xhtml">
      <!-- DWC: Adding class="title" to bridgeheads so they'll be blue from our css. -->
      <xsl:attribute name="class">title</xsl:attribute>
      <xsl:call-template name="anchor">
        <xsl:with-param name="conditional" select="0"/>
      </xsl:call-template>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <!-- You can get rid of this when you upgrade the base xsls. It's checked into the DocBook Open Repository. -->
  <xsl:template match="step[not(./title)]" mode="title.markup">
    <xsl:call-template name="gentext">
      <xsl:with-param name="key" select="'Step'"/>
    </xsl:call-template>
    <xsl:text> </xsl:text>
    <xsl:apply-templates select="." mode="number"/>
  </xsl:template>

  <xsl:template
    match="text()[ contains(concat(';',ancestor::*/@security,';'),';internal;') ] | xref[ contains(concat(';',ancestor::*/@security,';'),';internal;') ]">
    <span class="internal">
      <xsl:apply-imports/>
    </span>
  </xsl:template>
  <xsl:template
    match="text()[ contains(concat(';',ancestor::*/@security,';'),';writeronly;') ] | xref[ contains(concat(';',ancestor::*/@security,';'),';writeronly;') ]">
    <span class="writeronly">
      <xsl:apply-imports/>
    </span>
  </xsl:template>
  <xsl:template
    match="text()[ contains(concat(';',ancestor::*/@security,';'),';reviewer;') ] | xref[ contains(concat(';',ancestor::*/@security,';'),';reviewer;') ]">
    <span class="remark">
      <xsl:apply-imports/>
    </span>
  </xsl:template>
  <xsl:template
    match="text()[ ancestor::*/@role = 'highlight' ] | xref[ ancestor::*/@role = 'highlight' ]"
    priority="10">
    <span class="remark">
      <xsl:apply-imports/>
    </span>
  </xsl:template>

  <!-- You can remove these two once you upgrade the xslts.  -->
  <xsl:template match="glossseealso">
    <xsl:variable name="otherterm" select="@otherterm"/>
    <xsl:variable name="targets" select="key('id', $otherterm)"/>
    <xsl:variable name="target" select="$targets[1]"/>

    <xsl:choose>
      <xsl:when test="$target">
        <a>
          <xsl:attribute name="href">
            <xsl:call-template name="href.target">
              <xsl:with-param name="object" select="$target"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:apply-templates select="$target" mode="xref-to"/>
        </a>
      </xsl:when>
      <xsl:when test="$otherterm != '' and not($target)">
        <xsl:message>
          <xsl:text>Warning: glossseealso @otherterm reference not found: </xsl:text>
          <xsl:value-of select="$otherterm"/>
        </xsl:message>
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:choose>
      <xsl:when test="position() = last()"/>
      <xsl:otherwise>
        <xsl:call-template name="gentext.template">
          <xsl:with-param name="context" select="'glossary'"/>
          <xsl:with-param name="name" select="'seealso-separator'"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
