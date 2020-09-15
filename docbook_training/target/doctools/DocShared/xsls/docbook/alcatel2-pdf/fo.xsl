<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY lowercase "'Aa&#192;&#224;&#193;&#225;&#194;&#226;&#195;&#227;&#196;&#228;&#197;&#229;&#256;&#257;&#258;&#259;&#260;&#261;&#461;&#462;&#478;&#479;&#480;&#481;&#506;&#507;&#512;&#513;&#514;&#515;&#550;&#551;&#7680;&#7681;&#7834;&#7840;&#7841;&#7842;&#7843;&#7844;&#7845;&#7846;&#7847;&#7848;&#7849;&#7850;&#7851;&#7852;&#7853;&#7854;&#7855;&#7856;&#7857;&#7858;&#7859;&#7860;&#7861;&#7862;&#7863;Bb&#384;&#385;&#595;&#386;&#387;&#7682;&#7683;&#7684;&#7685;&#7686;&#7687;Cc&#199;&#231;&#262;&#263;&#264;&#265;&#266;&#267;&#268;&#269;&#391;&#392;&#597;&#7688;&#7689;Dd&#270;&#271;&#272;&#273;&#394;&#599;&#395;&#396;&#453;&#498;&#545;&#598;&#7690;&#7691;&#7692;&#7693;&#7694;&#7695;&#7696;&#7697;&#7698;&#7699;Ee&#200;&#232;&#201;&#233;&#202;&#234;&#203;&#235;&#274;&#275;&#276;&#277;&#278;&#279;&#280;&#281;&#282;&#283;&#516;&#517;&#518;&#519;&#552;&#553;&#7700;&#7701;&#7702;&#7703;&#7704;&#7705;&#7706;&#7707;&#7708;&#7709;&#7864;&#7865;&#7866;&#7867;&#7868;&#7869;&#7870;&#7871;&#7872;&#7873;&#7874;&#7875;&#7876;&#7877;&#7878;&#7879;Ff&#401;&#402;&#7710;&#7711;Gg&#284;&#285;&#286;&#287;&#288;&#289;&#290;&#291;&#403;&#608;&#484;&#485;&#486;&#487;&#500;&#501;&#7712;&#7713;Hh&#292;&#293;&#294;&#295;&#542;&#543;&#614;&#7714;&#7715;&#7716;&#7717;&#7718;&#7719;&#7720;&#7721;&#7722;&#7723;&#7830;Ii&#204;&#236;&#205;&#237;&#206;&#238;&#207;&#239;&#296;&#297;&#298;&#299;&#300;&#301;&#302;&#303;&#304;&#407;&#616;&#463;&#464;&#520;&#521;&#522;&#523;&#7724;&#7725;&#7726;&#7727;&#7880;&#7881;&#7882;&#7883;Jj&#308;&#309;&#496;&#669;Kk&#310;&#311;&#408;&#409;&#488;&#489;&#7728;&#7729;&#7730;&#7731;&#7732;&#7733;Ll&#313;&#314;&#315;&#316;&#317;&#318;&#319;&#320;&#321;&#322;&#410;&#456;&#564;&#619;&#620;&#621;&#7734;&#7735;&#7736;&#7737;&#7738;&#7739;&#7740;&#7741;Mm&#625;&#7742;&#7743;&#7744;&#7745;&#7746;&#7747;Nn&#209;&#241;&#323;&#324;&#325;&#326;&#327;&#328;&#413;&#626;&#414;&#544;&#459;&#504;&#505;&#565;&#627;&#7748;&#7749;&#7750;&#7751;&#7752;&#7753;&#7754;&#7755;Oo&#210;&#242;&#211;&#243;&#212;&#244;&#213;&#245;&#214;&#246;&#216;&#248;&#332;&#333;&#334;&#335;&#336;&#337;&#415;&#416;&#417;&#465;&#466;&#490;&#491;&#492;&#493;&#510;&#511;&#524;&#525;&#526;&#527;&#554;&#555;&#556;&#557;&#558;&#559;&#560;&#561;&#7756;&#7757;&#7758;&#7759;&#7760;&#7761;&#7762;&#7763;&#7884;&#7885;&#7886;&#7887;&#7888;&#7889;&#7890;&#7891;&#7892;&#7893;&#7894;&#7895;&#7896;&#7897;&#7898;&#7899;&#7900;&#7901;&#7902;&#7903;&#7904;&#7905;&#7906;&#7907;Pp&#420;&#421;&#7764;&#7765;&#7766;&#7767;Qq&#672;Rr&#340;&#341;&#342;&#343;&#344;&#345;&#528;&#529;&#530;&#531;&#636;&#637;&#638;&#7768;&#7769;&#7770;&#7771;&#7772;&#7773;&#7774;&#7775;Ss&#346;&#347;&#348;&#349;&#350;&#351;&#352;&#353;&#536;&#537;&#642;&#7776;&#7777;&#7778;&#7779;&#7780;&#7781;&#7782;&#7783;&#7784;&#7785;Tt&#354;&#355;&#356;&#357;&#358;&#359;&#427;&#428;&#429;&#430;&#648;&#538;&#539;&#566;&#7786;&#7787;&#7788;&#7789;&#7790;&#7791;&#7792;&#7793;&#7831;Uu&#217;&#249;&#218;&#250;&#219;&#251;&#220;&#252;&#360;&#361;&#362;&#363;&#364;&#365;&#366;&#367;&#368;&#369;&#370;&#371;&#431;&#432;&#467;&#468;&#469;&#470;&#471;&#472;&#473;&#474;&#475;&#476;&#532;&#533;&#534;&#535;&#7794;&#7795;&#7796;&#7797;&#7798;&#7799;&#7800;&#7801;&#7802;&#7803;&#7908;&#7909;&#7910;&#7911;&#7912;&#7913;&#7914;&#7915;&#7916;&#7917;&#7918;&#7919;&#7920;&#7921;Vv&#434;&#651;&#7804;&#7805;&#7806;&#7807;Ww&#372;&#373;&#7808;&#7809;&#7810;&#7811;&#7812;&#7813;&#7814;&#7815;&#7816;&#7817;&#7832;Xx&#7818;&#7819;&#7820;&#7821;Yy&#221;&#253;&#255;&#376;&#374;&#375;&#435;&#436;&#562;&#563;&#7822;&#7823;&#7833;&#7922;&#7923;&#7924;&#7925;&#7926;&#7927;&#7928;&#7929;Zz&#377;&#378;&#379;&#380;&#381;&#382;&#437;&#438;&#548;&#549;&#656;&#657;&#7824;&#7825;&#7826;&#7827;&#7828;&#7829;&#7829;'">
<!ENTITY uppercase "'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABBBBBBBBBBBBBCCCCCCCCCCCCCCCCCDDDDDDDDDDDDDDDDDDDDDDDDEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEFFFFFFGGGGGGGGGGGGGGGGGGGGHHHHHHHHHHHHHHHHHHHHIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIJJJJJJKKKKKKKKKKKKKKLLLLLLLLLLLLLLLLLLLLLLLLLLMMMMMMMMMNNNNNNNNNNNNNNNNNNNNNNNNNNNOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOPPPPPPPPQQQRRRRRRRRRRRRRRRRRRRRRRRSSSSSSSSSSSSSSSSSSSSSSSTTTTTTTTTTTTTTTTTTTTTTTTTUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUVVVVVVVVWWWWWWWWWWWWWWWXXXXXXYYYYYYYYYYYYYYYYYYYYYYYZZZZZZZZZZZZZZZZZZZZZ'">
<!ENTITY primary   'normalize-space(concat(primary/@sortas, primary[not(@sortas) or @sortas = ""]))'>
<!ENTITY secondary 'normalize-space(concat(secondary/@sortas, secondary[not(@sortas) or @sortas = ""]))'>
<!ENTITY tertiary  'normalize-space(concat(tertiary/@sortas, tertiary[not(@sortas) or @sortas = ""]))'>

<!ENTITY sep '" "'>
<!ENTITY scope 'count(ancestor::node()|$scope) = count(ancestor::node())
                and ($role = @role or $type = @type or
                (string-length($role) = 0 and string-length($type) = 0))'>
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:rx="http://www.renderx.com/XSL/Extensions"
                xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
                version="1.0">

  <xsl:import href="../../../../docbook-xsl/1.72.0/fo/docbook.xsl"/>

 <xsl:import href="../common/common.xsl"/> <!-- added to fix jcbg-718-->

  <xsl:import href="tp-fo.xsl"/>
  <!-- Importing this from motive-pdf so we won't get page numbers after xrefs to steps. -->
  <xsl:import href="../motive-pdf/xref.xsl"/>
<!-- <xsl:import href="http://docbook.sourceforge.net/release/xsl/current/fo/docbook.xsl"/> -->

  <!-- Font setup -->
  <xsl:param name="i18n.font.family"/><!-- SimplifiedChinese,TradChinese,KozMinPro-Regular-Acro -->
  <xsl:param name="i18n.font.family.processed">
	<xsl:choose>
	  <xsl:when test="not($i18n.font.family) = ''"><xsl:value-of select="$i18n.font.family"/>,</xsl:when>
	  <xsl:otherwise/>
	</xsl:choose>
  </xsl:param>
  <xsl:param name="symbol.font.family" select="concat($i18n.font.family.processed,'Symbol,ZapfDingbats,LucidaUnicode,ArialUnicode,Times')"></xsl:param>
  <xsl:param name="sans.font.family" select="concat($i18n.font.family.processed,'sans-serif')"/>
  <xsl:param name="title.font.family" select="concat($i18n.font.family.processed,'Trebuchet')"/>
  <xsl:param name="body.font.family" select="concat($i18n.font.family.processed,'Times,ZapfDingbats,LucidaSansUnicode,KozMinPro-Regular-Acro')"/>
  <xsl:param name="body.font.master">11</xsl:param>

<!-- Paper format -->
<xsl:param name="paper.type" select="'USLetter'"/>
<xsl:param name="page.margin.inner">1in</xsl:param>
<xsl:param name="page.margin.outer">1in</xsl:param>
<xsl:param name="page.margin.top">0.75in</xsl:param>
<xsl:param name="page.margin.bottom">0.55in</xsl:param>

<xsl:param name="insert.link.page.number">yes</xsl:param>
<xsl:param name="insert.xref.page.number">yes</xsl:param>

  <xsl:param name="security">external</xsl:param>
  <xsl:param name="nda.footer">false</xsl:param>

  <xsl:param name="nda.footer.text">Alcatel-Lucent Confidential</xsl:param>
  <xsl:param name="alcatel.footer.text">
	<xsl:choose>
	  <xsl:when test="$security = 'external' and $nda.footer = 'true'"><xsl:value-of select="$nda.footer.text"/></xsl:when>
	  <xsl:when test="$security = 'external'"/>
	  <xsl:when test="$security = 'writeronly'">Writer Only Copy - Internal Only</xsl:when>
	  <xsl:when test="$security = 'reviewer'">Reviewer Copy - Internal Only</xsl:when>
	  <xsl:when test="$security = 'internal'">Internal Only</xsl:when>
	  <xsl:otherwise/>
	</xsl:choose>
  </xsl:param>

<!-- XSLT procesor může používat rozšíření pro callouts apod. -->
<xsl:param name="use.extensions" select="1"/>

<!-- Rozšíření specifická pro daný FO procesor -->
<xsl:param name="xep.extensions" select="1"/>

<xsl:param name="tablecolumns.extension" select="0"/>

<!-- We use svg graphics. -->
<xsl:param name="use.svg" select="1"/>

<!-- Nechceme obrázek -->
<xsl:param name="draft.watermark.image" select="''"/>

<!-- Callouts will be done by characters -->
<xsl:param name="callout.unicode" select="0"/>
<xsl:param name="callout.graphics" select="'1'"/>
<xsl:param name="callout.graphics.extension" select="'.svg'"/>
  <xsl:param name="common.graphics.path"/>
  <xsl:param name="callout.graphics.path" select="concat($common.graphics.path,'/callouts/')"/>  

<!-- Labelling -->
<xsl:param name="section.autolabel" select="1"/>
<xsl:param name="section.label.includes.component.label" select="1"/>
<xsl:param name="section.autolabel.max.depth">1</xsl:param>


<xsl:template name="label.this.section">
  <xsl:param name="section" select="."/>

  <xsl:variable name="level">
    <xsl:call-template name="section.level"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$section/ancestor::preface">1</xsl:when>
    <xsl:when test="$level &lt;= $section.autolabel.max.depth">      
      <xsl:value-of select="$section.autolabel"/>
    </xsl:when>
    <xsl:otherwise>0</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:param name="alignment">left</xsl:param>
<xsl:param name="hyphenate">false</xsl:param>

<xsl:attribute-set name="section.title.level1.properties">
  <xsl:attribute name="font-size">14pt</xsl:attribute>
</xsl:attribute-set>

<xsl:template name="section.heading">
  <xsl:param name="level" select="1"/>
  <xsl:param name="marker" select="1"/>
  <xsl:param name="title"/>
  <xsl:param name="marker.title"/>

  <fo:block xsl:use-attribute-sets="section.title.properties">
    <xsl:if test="$marker != 0">
      <fo:marker marker-class-name="section.head.marker">
        <xsl:copy-of select="$marker.title"/>
      </fo:marker>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="$level=1">
	<fo:list-block provisional-distance-between-starts="5pc" 
		       xsl:use-attribute-sets="section.title.level1.properties">
	  <fo:list-item>
	    <fo:list-item-label end-indent="label-end()">
	      <fo:block><xsl:value-of select="substring-before($title, ' ')"/></fo:block>
	    </fo:list-item-label>
	    <fo:list-item-body start-indent="body-start()">
	      <fo:block><xsl:value-of select="substring-after($title, ' ')"/></fo:block>
	    </fo:list-item-body>
	  </fo:list-item>
	</fo:list-block>
      </xsl:when>
      <xsl:when test="$level=2">
        <fo:block xsl:use-attribute-sets="section.title.level2.properties">
          <xsl:copy-of select="$title"/>
        </fo:block>
      </xsl:when>
      <xsl:when test="$level=3">
        <fo:block xsl:use-attribute-sets="section.title.level3.properties">
          <xsl:copy-of select="$title"/>
        </fo:block>
      </xsl:when>
      <xsl:when test="$level=4">
        <fo:block xsl:use-attribute-sets="section.title.level4.properties">
          <xsl:copy-of select="$title"/>
        </fo:block>
      </xsl:when>
      <xsl:when test="$level=5">
        <fo:block xsl:use-attribute-sets="section.title.level5.properties">
          <xsl:copy-of select="$title"/>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:block xsl:use-attribute-sets="section.title.level6.properties">
          <xsl:copy-of select="$title"/>
        </fo:block>
      </xsl:otherwise>
    </xsl:choose>
  </fo:block>
</xsl:template>

<xsl:attribute-set name="section.title.level2.properties">
  <xsl:attribute name="font-size">12pt</xsl:attribute>
  <xsl:attribute name="start-indent">5pc</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="section.title.level3.properties">
  <xsl:attribute name="font-size">11pt</xsl:attribute>
  <xsl:attribute name="start-indent">5pc</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="section.title.level4.properties">
  <xsl:attribute name="font-size">10pt</xsl:attribute>
  <xsl:attribute name="start-indent">5pc</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="section.title.level5.properties">
  <xsl:attribute name="font-size">9pt</xsl:attribute>
  <xsl:attribute name="start-indent">5pc</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="component.title.properties">
  <xsl:attribute name="font-family">Trebuchet,<xsl:value-of select="$symbol.font.family"/></xsl:attribute>
  <xsl:attribute name="font-size">22pt</xsl:attribute>
  <xsl:attribute name="font-weight">bold</xsl:attribute>
  <xsl:attribute name="font-style">italic</xsl:attribute>
  <xsl:attribute name="margin-top">5.5cm</xsl:attribute>
  <xsl:attribute name="border-bottom">solid 1pt black</xsl:attribute>
  <xsl:attribute name="space-after">4pc</xsl:attribute>
</xsl:attribute-set>

<xsl:param name="generate.toc">
appendix  toc
book      toc,title
chapter   toc
part      nop
preface   nop
qandadiv  toc
qandaset  toc
</xsl:param>

<xsl:attribute-set name="toc.line.properties">
  <xsl:attribute name="font-size">
    <xsl:choose>
      <xsl:when test="self::preface | self::chapter | self::appendix | self::part | self::index | self::glossary">14pt</xsl:when>
      <xsl:otherwise>10pt</xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
  <xsl:attribute name="font-family">Trebuchet,<xsl:value-of select="$symbol.font.family"/></xsl:attribute>
  <xsl:attribute name="font-weight">
    <xsl:choose>
      <xsl:when test="self::preface | self::chapter | self::appendix | self::part | self::index | self::glossary">bold</xsl:when>
      <xsl:otherwise>normal</xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
  <xsl:attribute name="space-before">
    <xsl:choose>
      <xsl:when test="self::part">3pc</xsl:when>
      <xsl:when test="self::preface | self::chapter | self::appendix | self::index | self::glossary">2pc</xsl:when>
      <xsl:otherwise>0pt</xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
  <xsl:attribute name="keep-with-next">
    <xsl:choose>
      <xsl:when test="self::preface | self::chapter | self::appendix | self::part | self::index | self::glossary">always</xsl:when>
      <xsl:otherwise>auto</xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>    
</xsl:attribute-set>

<xsl:template name="component.toc">
  <xsl:param name="toc-context" select="."/>
  <xsl:param name="toc.title.p" select="true()"/>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="cid">
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="$toc-context"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="nodes" select="section|sect1|refentry
                                     |article|bibliography|glossary
                                     |appendix|index"/>
  <xsl:if test="$nodes">
    <fo:block id="toc...{$id}"
              xsl:use-attribute-sets="toc.margin.properties">
      <xsl:if test="$toc.title.p">
        <xsl:call-template name="table.of.contents.titlepage"/>
      </xsl:if>
      <xsl:apply-templates select="$nodes" mode="toc2">
        <xsl:with-param name="toc-context" select="$toc-context"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template match="section" mode="toc2">
  <xsl:param name="toc-context" select="."/>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="cid">
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="$toc-context"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="depth" select="count(ancestor::section) + 1"/>
  <xsl:variable name="reldepth"
                select="count(ancestor::*)-count($toc-context/ancestor::*)"/>

  <xsl:variable name="depth.from.context" select="count(ancestor::*)-count($toc-context/ancestor::*)"/>

  <xsl:if test="$toc.section.depth &gt;= $depth">
    <xsl:call-template name="toc2.line"/>
  </xsl:if>
</xsl:template>

<xsl:template name="toc2.line">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="label">
    <xsl:apply-templates select="." mode="label.markup"/>
  </xsl:variable>

  <fo:list-block provisional-distance-between-starts="10pc" 
		 start-indent="0pt"
		 provisional-label-separation="8pt"
		 font-family="Trebuchet,{$symbol.font.family}"
		 font-weight="bold"
		 font-size="11pt"
		 space-after="12pt">
    <fo:list-item>
      <fo:list-item-label end-indent="label-end()" text-align="right">
	<fo:block>
	  <xsl:value-of select="$label"/>
	</fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
	<fo:block end-indent="{$toc.indent.width}pt"
		  last-line-end-indent="-{$toc.indent.width}pt">
	  <fo:inline keep-with-next.within-line="always">
	    <fo:basic-link internal-destination="{$id}">
	      <xsl:apply-templates select="." mode="titleabbrev.markup"/>
	    </fo:basic-link>
	  </fo:inline>
	  <fo:inline keep-together.within-line="always">
	    <xsl:text> </xsl:text>
	    <fo:leader leader-length="2em"
		       keep-with-next.within-line="always"/>
	    <xsl:text> </xsl:text> 
	    <fo:basic-link internal-destination="{$id}">
	      <xsl:apply-templates mode="page-number-prefix" select="."/>
	      <fo:page-number-citation ref-id="{$id}"/>
	    </fo:basic-link>
	  </fo:inline>
	</fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </fo:list-block>
</xsl:template>

<xsl:template name="component.toc.separator">
  <xsl:if test="section">
    <fo:block break-after="page"/>
  </xsl:if>
</xsl:template>

<xsl:attribute-set name="table.table.properties">
  <xsl:attribute name="font-size">8pt</xsl:attribute>
  <xsl:attribute name="font-family">Trebuchet,LucidaSansUnicode,<xsl:value-of select="$symbol.font.family"/></xsl:attribute>
</xsl:attribute-set>

<xsl:template name="table.container">
  <xsl:param name="table.block"/>
  <xsl:choose>
    <xsl:when test="@orient='land' and 
                    $fop.extensions = 0 and 
                    $passivetex.extensions = 0" >
      <fo:block-container reference-orientation="90"
            padding="6pt"
            xsl:use-attribute-sets="list.block.spacing">
        <xsl:attribute name="width">
          <xsl:call-template name="table.width"/>
        </xsl:attribute>
        <fo:block start-indent="0pt" end-indent="0pt">
          <xsl:copy-of select="$table.block"/>
        </fo:block>
      </fo:block-container>
    </xsl:when>
    <xsl:when test="@pgwide = 1">
      <fo:block start-indent="0pt" end-indent="0pt" margin-left="auto">
        <xsl:copy-of select="$table.block"/>
      </fo:block>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$table.block"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="table.layout">  
  <xsl:param name="table.content"/>  

  <xsl:choose>
    <xsl:when test="$xep.extensions = 0 or self::informaltable">  
      <xsl:copy-of select="$table.content"/>
    </xsl:when>
    <xsl:otherwise>
      <fo:table rx:table-omit-initial-header="true"  width="100%">  
        <fo:table-header start-indent="0pt">
          <fo:table-row>
            <fo:table-cell>
              <fo:block xsl:use-attribute-sets="formal.title.properties">  
                <xsl:apply-templates select="." mode="object.title.markup"/>
				  <fo:inline font-style="italic">
					<xsl:call-template name="gentext">
					  <xsl:with-param name="key" select="'continued'"/>
					</xsl:call-template>
				  </fo:inline>
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
        </fo:table-header>
        <fo:table-body start-indent="0pt">
          <fo:table-row>
            <fo:table-cell>
              <xsl:copy-of select="$table.content"/>  
            </fo:table-cell>
          </fo:table-row>
        </fo:table-body>
      </fo:table>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:attribute-set name="table.properties">
  <xsl:attribute name="keep-together.within-column">auto</xsl:attribute> 
</xsl:attribute-set>
<!--
<xsl:template name="table.layout">
  <xsl:param name="table.content" select="NOTANODE"/>

  <xsl:choose>
    <xsl:when test="@pgwide = '1'">
      <fo:table width="100%"> 
	<fo:table-column column-width="proportional-column-width(1)"/> 
	<fo:table-column/> 
	<fo:table-column/> 
	<fo:table-body> 
	  <fo:table-row> 
	    <fo:table-cell/> 
	    <fo:table-cell> 
	      <xsl:copy-of select="$table.content"/>
	    </fo:table-cell> 
	    <fo:table-cell/> 
	  </fo:table-row> 
	</fo:table-body> 
      </fo:table>
      <xsl:copy-of select="$table.content"/>
    </xsl:when>
    <xsl:otherwise>
      <fo:table width="5.1in" start-indent="{$body.start.indent}"> 
	<fo:table-column column-width="proportional-column-width(1)"/> 
	<fo:table-column/> 
	<fo:table-column column-width="proportional-column-width(1)"/> 
	<fo:table-body> 
	  <fo:table-row> 
	    <fo:table-cell/> 
	    <fo:table-cell>
	      <fo:block start-indent="0pt">
		<xsl:copy-of select="$table.content"/>
	      </fo:block>
	    </fo:table-cell> 
	    <fo:table-cell/> 
	  </fo:table-row> 
	</fo:table-body> 
      </fo:table>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
-->

<xsl:attribute-set name="formal.title.properties">
  <xsl:attribute name="font-size">
    <xsl:choose>
      <xsl:when test="self::procedure">11.5pt</xsl:when>
      <xsl:when test="parent::variablelist or parent::itemizedlist or parent::orderedlist">11pt</xsl:when>
      <xsl:otherwise>9pt</xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
  <xsl:attribute name="font-family">Trebuchet,<xsl:value-of select="$symbol.font.family"/></xsl:attribute>
  <xsl:attribute name="border-bottom">
    <xsl:choose>
      <xsl:when test="self::procedure">solid 1pt black</xsl:when>
      <xsl:otherwise>none 0pt black</xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
  <xsl:attribute name="text-align">
    <xsl:choose>
      <xsl:when test="@pgwide = '1'">center</xsl:when>
      <xsl:otherwise>left</xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
</xsl:attribute-set>  

<xsl:attribute-set name="formal.object.properties">
  <xsl:attribute name="keep-together.within-column">auto</xsl:attribute>
</xsl:attribute-set>

<xsl:param name="body.start.indent">6.5pc</xsl:param>

<xsl:param name="monospace.font.family">monospace,ArialUnicode,LucidaSansUnicode,<xsl:value-of select="$symbol.font.family"/></xsl:param>

<xsl:attribute-set name="monospace.properties">
  <xsl:attribute name="font-stretch">narrower</xsl:attribute>
  <xsl:attribute name="font-size">105%</xsl:attribute>
</xsl:attribute-set>

<xsl:param name="hyphenate.verbatim" select="1"/>
<xsl:param name="hyphenate.verbatim.characters" select="'()+=,/\>&#60;:?%-&amp;.'"/>
<xsl:attribute-set name="monospace.verbatim.properties">
  <xsl:attribute name="wrap-option">wrap</xsl:attribute>
  <xsl:attribute name="hyphenation-character">&#x21E6;<!-- Blockish left arrow --><!--&#x02190;--><!--&#x25BA;--><!--&#x21A9;--></xsl:attribute>
  <xsl:attribute name="font-size">88%</xsl:attribute>
</xsl:attribute-set>

<xsl:param name="ulink.hyphenate" select="'&#x200B;'"></xsl:param>
<xsl:param name="ulink.hyphenate.chars" select="'/?=+%&amp;'"/>

<xsl:param name="double.sided" select="1"/>

<xsl:attribute-set name="list.item.spacing">
  <xsl:attribute name="space-before.optimum">
    <xsl:choose>
      <xsl:when test="self::varlistentry">1em</xsl:when>
      <xsl:otherwise>2pt</xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
  <xsl:attribute name="space-after.optimum">
    <xsl:choose>
      <xsl:when test="*[2]">0.5em</xsl:when>
      <xsl:otherwise>0pt</xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="list.block.spacing">
  <xsl:attribute name="space-before.optimum">1em</xsl:attribute>
  <xsl:attribute name="space-before.minimum">0.8em</xsl:attribute>
  <xsl:attribute name="space-before.maximum">1.2em</xsl:attribute>
  <xsl:attribute name="space-after.optimum">1em</xsl:attribute>
  <xsl:attribute name="space-after.minimum">0.8em</xsl:attribute>
  <xsl:attribute name="space-after.maximum">1.2em</xsl:attribute>
</xsl:attribute-set>

<xsl:param name="itemizedlist.label.width">1.5em</xsl:param>
<xsl:param name="orderedlist.label.width">1.5em</xsl:param>

<!-- Handle the case where itemizedlist is only child of para -->
<xsl:attribute-set name="normal.para.spacing">
  <xsl:attribute name="space-before.optimum">
    <xsl:choose>
      <xsl:when test="itemizedlist and not(*[local-name() != 'itemizedlist']) and parent::listitem">0pt</xsl:when>
      <xsl:otherwise>1em</xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
  <xsl:attribute name="space-before.minimum">
    <xsl:choose>
      <xsl:when test="itemizedlist and not(*[local-name() != 'itemizedlist']) and parent::listitem">0pt</xsl:when>
      <xsl:otherwise>0.8em</xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
  <xsl:attribute name="space-before.maximum">
    <xsl:choose>
      <xsl:when test="itemizedlist and not(*[local-name() != 'itemizedlist']) and parent::listitem">0pt</xsl:when>
      <xsl:otherwise>1.2em</xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
  <xsl:attribute name="keep-together">
    <xsl:choose>
      <xsl:when test="self::glossentry">always</xsl:when>
      <xsl:otherwise>auto</xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
</xsl:attribute-set>

<!-- For long terms block presentation is used -->
<xsl:param name="variablelist.max.termlength" select="16"/>

<xsl:template match="variablelist">
  <xsl:variable name="presentation">
    <xsl:call-template name="dbfo-attribute">
      <xsl:with-param name="pis"
                      select="processing-instruction('dbfo')"/>
      <xsl:with-param name="attribute" select="'list-presentation'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="longest.term">
    <xsl:call-template name="longest.term">
      <xsl:with-param name="terms" select="varlistentry/term"/>
      <xsl:with-param name="maxlength" select="$variablelist.max.termlength"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$presentation = 'table'">
      <xsl:apply-templates select="." mode="vl.as.list"/>
    </xsl:when>
    <xsl:when test="$presentation = 'blocks'">
      <xsl:apply-templates select="." mode="vl.as.blocks"/>
    </xsl:when>
    <xsl:when test="($variablelist.as.blocks != 0) or ($longest.term = $variablelist.max.termlength)">
      <xsl:apply-templates select="." mode="vl.as.blocks"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="." mode="vl.as.list"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Admonitions -->
<xsl:param name="admon.graphics" select="1"/>
<xsl:param name="admon.graphics.extension">.jpeg</xsl:param>
<xsl:param name="admon.graphics.path" select="concat($common.graphics.path, '/alcatel2/')"/>

<xsl:template name="graphical.admonition">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>
  <xsl:variable name="graphic.width">
     <xsl:apply-templates select="." mode="admon.graphic.width"/>
  </xsl:variable>

  <fo:block id="{$id}"
            xsl:use-attribute-sets="graphical.admonition.properties">
    <fo:list-block provisional-distance-between-starts="{$graphic.width} + 18pt"
                    provisional-label-separation="18pt">
      <fo:list-item>
          <fo:list-item-label end-indent="label-end()">
            <fo:block>
              <fo:external-graphic width="auto" height="auto"
                                         content-width="{$graphic.width}" >
                <xsl:attribute name="src">
                  <xsl:call-template name="admon.graphic"/>
                </xsl:attribute>
              </fo:external-graphic>
            </fo:block>
          </fo:list-item-label>
          <fo:list-item-body start-indent="body-start()">
            <fo:block xsl:use-attribute-sets="admonition.properties">
              <xsl:apply-templates/>
            </fo:block>
          </fo:list-item-body>
      </fo:list-item>
    </fo:list-block>
  </fo:block>
</xsl:template>

<xsl:template match="para[1][parent::note|parent::important|parent::warning|parent::caution|parent::tip]" priority="10">
  <fo:block xsl:use-attribute-sets="normal.para.spacing">
    <xsl:call-template name="anchor"/>
    <xsl:if test="$admon.textlabel != 0 or ../title or ../info/title">
      <fo:inline xsl:use-attribute-sets="admonition.title.properties">
	<xsl:apply-templates select=".." mode="object.title.markup"/>
	<xsl:text> — </xsl:text>
      </fo:inline>
    </xsl:if>
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<xsl:attribute-set name="admonition.title.properties">
  <xsl:attribute name="font-size">100%</xsl:attribute>
  <xsl:attribute name="font-weight">bold</xsl:attribute>
  <xsl:attribute name="font-family">Trebuchet,<xsl:value-of select="$symbol.font.family"/></xsl:attribute>
  <xsl:attribute name="hyphenate">false</xsl:attribute>
</xsl:attribute-set>

<xsl:param name="glossterm.width">10pc</xsl:param>

<xsl:template match="glossentry/glossterm" mode="glossary.as.list">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>
  <fo:inline id="{$id}" font-weight="bold">
    <xsl:apply-templates/>
  </fo:inline>
  <xsl:if test="following-sibling::glossterm">, </xsl:if>
</xsl:template>

<xsl:template match="glossentry" mode="glossary.as.list">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <fo:list-item xsl:use-attribute-sets="normal.para.spacing">
    <xsl:call-template name="anchor">
      <xsl:with-param name="conditional">
        <xsl:choose>
          <xsl:when test="$glossterm.auto.link != 0
                          or $glossary.collection != ''">0</xsl:when>
          <xsl:otherwise>1</xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>

    <fo:list-item-label end-indent="label-end()">
      <fo:block keep-together="auto">
        <xsl:choose>
          <xsl:when test="$glossentry.show.acronym = 'primary'">
            <xsl:choose>
              <xsl:when test="acronym|abbrev">
                <xsl:apply-templates select="acronym|abbrev" mode="glossary.as.list"/>
                <xsl:text> (</xsl:text>
                <xsl:apply-templates select="glossterm" mode="glossary.as.list"/>
                <xsl:text>)</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates select="glossterm" mode="glossary.as.list"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>

          <xsl:when test="$glossentry.show.acronym = 'yes'">
            <xsl:apply-templates select="glossterm" mode="glossary.as.list"/>

            <xsl:if test="acronym|abbrev">
              <xsl:text> (</xsl:text>
              <xsl:apply-templates select="acronym|abbrev" mode="glossary.as.list"/>
              <xsl:text>)</xsl:text>
            </xsl:if>
          </xsl:when>

          <xsl:otherwise>
            <xsl:apply-templates select="glossterm" mode="glossary.as.list"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates select="indexterm"/>
      </fo:block>
    </fo:list-item-label>

    <fo:list-item-body start-indent="body-start()">
      <xsl:apply-templates select="glosssee|glossdef" mode="glossary.as.list"/>
    </fo:list-item-body>
  </fo:list-item>
</xsl:template>

<!-- Menuchoices -->
<xsl:param name="menuchoice.menu.separator" select="' &#x279D; '"/>  
<xsl:param name="menuchoice.separator" select="' &#x279D; '"/>  

<xsl:template match="guimenu|guisubmenu|guilabel|guimenuitem|guiicon|guibutton">
  <fo:inline font-family="{$title.font.family},LucidaUnicode">
    <xsl:choose>
      <xsl:when test="ancestor::procedure | ancestor::table | ancestor::informaltable">
	<xsl:attribute name="font-weight">bold</xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
	<xsl:attribute name="font-size">90%</xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-imports/>
  </fo:inline>
</xsl:template>

<!-- Black and white links -->
<xsl:param name="bw" select="0"/>

<xsl:attribute-set name="xref.properties">
  <xsl:attribute name="color">
    <xsl:choose>
      <xsl:when test="ancestor-or-self::*/@security = 'internal'">red</xsl:when>
      <xsl:when test="$bw = 0">blue</xsl:when>
      <xsl:otherwise>black</xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
</xsl:attribute-set>

<!-- Custom translations -->
<xsl:param name="local.l10n.xml" select="document('')"/>
<i18n xmlns="http://docbook.sourceforge.net/xmlns/l10n/1.0">

  <l10n language="en">

    <gentext key="TableofContents" text="Contents"/> 
	<gentext key="continued" text=" (continued) "/>

    <context name="title">
      <template name="procedure.formal" text="Procedure %n  %t"/>     
    </context>

    <context name="title-numbered">
      <template name="chapter" text="%n —  %t"/> 
      <template name="appendix" text="%n —  %t"/> 
      <template name="part" text="Part %n —  %t"/> 
      <template name="section" text="%n %t"/> 
      <template name="sect1" text="%n %t"/> 
    </context>

    <context name="xref">
      <template name="section" text="&#8220;%t&#8221;"/> 
      <template name="procedure" text="Procedure&#160;%n, &#8220;%t&#8221;"/>
      <template name="page.citation" text=" (page&#160;%p)"/>
      <template name="olink.document.citation" text=" in the %o"/>
    </context>

  </l10n>

  <l10n language="ru">

    <!--gentext key="TableofContents" text="Contents"/--> 
	<gentext key="continued" text=" (continued) "/>

    <!--context name="title">
      <template name="procedure.formal" text="Procedure %n  %t"/>     
    </context-->

    <context name="title-numbered">
      <template name="chapter" text="%n —  %t"/> 
      <template name="appendix" text="%n —  %t"/> 
      <template name="part" text="&#1063;&#1072;&#1089;&#1090;&#1100;&#160;%n —  %t"/> 
      <template name="section" text="%n %t"/> 
      <template name="sect1" text="%n %t"/> 
    </context>

    <context name="xref">
      <!--template name="section" text="&#8220;%t&#8221;"/--> 
      <template name="procedure" text="&#1055;&#1088;&#1086;&#1094;&#1077;&#1076;&#1091;&#1088;&#1072;&#160;%n.&#160;%t"/>
      <template name="page.citation" text=" (%p)"/>
    </context>

  </l10n>
</i18n>

<!-- Numbers of formal objects use x-y format -->
<xsl:template match="figure|table|example" mode="label.markup">
  <xsl:variable name="pchap"
                select="ancestor::chapter
                        |ancestor::appendix
                        |ancestor::article[ancestor::book]"/>

  <xsl:variable name="prefix">
    <xsl:if test="count($pchap) &gt; 0">
      <xsl:apply-templates select="$pchap" mode="label.markup"/>
    </xsl:if>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="@label">
      <xsl:value-of select="@label"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="$prefix != ''">
            <xsl:apply-templates select="$pchap" mode="label.markup"/>
	    <xsl:text>-</xsl:text>
          <xsl:number format="1" from="chapter|appendix" level="any"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:number format="1" from="book|article" level="any"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="procedure" mode="label.markup">
  <xsl:variable name="pchap"
                select="ancestor::chapter
                        |ancestor::appendix
                        |ancestor::article[ancestor::book]"/>

  <xsl:variable name="prefix">
    <xsl:if test="count($pchap) &gt; 0">
      <xsl:apply-templates select="$pchap" mode="label.markup"/>
    </xsl:if>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="@label">
      <xsl:value-of select="@label"/>
    </xsl:when>
    <xsl:when test="$formal.procedures = 0">
      <!-- No label -->
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="count($pchap)>0">
          <xsl:if test="$prefix != ''">
            <xsl:apply-templates select="$pchap" mode="label.markup"/>
	    <xsl:text>-</xsl:text>
          </xsl:if>
          <xsl:number count="procedure[title]" format="1" 
                      from="chapter|appendix" level="any"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:number count="procedure[title]" format="1" 
                      from="book|article" level="any"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:attribute-set name="procedure.properties">
  <xsl:attribute name="font-family">Trebuchet,<xsl:value-of select="$symbol.font.family"/>,LucidaUnicode</xsl:attribute>
  <xsl:attribute name="font-size">9.5pt</xsl:attribute>
</xsl:attribute-set>

<xsl:template match="procedure/step|substeps/step">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <fo:list-item xsl:use-attribute-sets="list.item.spacing">
    <fo:list-item-label end-indent="label-end()">
      <fo:block id="{$id}">
        <!-- dwc: fix for one step procedures. Use a bullet if there's no step 2 -->
        <xsl:choose>
          <xsl:when test="count(../step) = 1">
            <xsl:text>&#x2022;</xsl:text>
          </xsl:when>
          <xsl:otherwise>
	    <fo:inline font-weight="bold">
	      <xsl:apply-templates select="." mode="number">
		<xsl:with-param name="recursive" select="0"/>
	      </xsl:apply-templates>
	    </fo:inline>
          </xsl:otherwise>
        </xsl:choose>
      </fo:block>
    </fo:list-item-label>
    <fo:list-item-body start-indent="body-start()">
      <fo:block>
        <xsl:apply-templates/>
      </fo:block>
    </fo:list-item-body>
  </fo:list-item>
</xsl:template>

<xsl:attribute-set name="index.div.title.properties">
  <xsl:attribute name="font-size">12pt</xsl:attribute>
  <xsl:attribute name="space-after">12pt</xsl:attribute>
</xsl:attribute-set>

<xsl:template name="indexdiv.title">
  <xsl:param name="title"/>
  <xsl:param name="titlecontent"/>

  <fo:block xsl:use-attribute-sets="index.div.title.properties">
    <xsl:if test="$titlecontent = 'A'">
      <xsl:attribute name="space-before.optimum">0pt</xsl:attribute>
      <xsl:attribute name="space-before.minimum">0pt</xsl:attribute>
      <xsl:attribute name="space-before.maximum">0pt</xsl:attribute>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="$title">
        <xsl:apply-templates select="." mode="object.title.markup">
          <xsl:with-param name="allow-anchors" select="1"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$titlecontent"/>
      </xsl:otherwise>
    </xsl:choose>
  </fo:block>
</xsl:template>

<xsl:template match="book/index|part/index">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

 <xsl:if test="$generate.index != 0">
  <xsl:variable name="master-reference">
    <xsl:call-template name="select.pagemaster">
      <xsl:with-param name="pageclass">
        <xsl:if test="$make.index.markup != 0">body</xsl:if>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:variable>

  <fo:page-sequence hyphenate="{$hyphenate}"
                    master-reference="{$master-reference}">
    <xsl:attribute name="language">
      <xsl:call-template name="l10n.language"/>
    </xsl:attribute>
    <xsl:attribute name="format">
      <xsl:call-template name="page.number.format">
        <xsl:with-param name="master-reference" select="$master-reference"/>
      </xsl:call-template>
    </xsl:attribute>

    <xsl:attribute name="initial-page-number">
      <xsl:call-template name="initial.page.number">
        <xsl:with-param name="master-reference" select="$master-reference"/>
      </xsl:call-template>
    </xsl:attribute>

    <xsl:attribute name="force-page-count">
      <xsl:call-template name="force.page.count">
        <xsl:with-param name="master-reference" select="$master-reference"/>
      </xsl:call-template>
    </xsl:attribute>

    <xsl:attribute name="hyphenation-character">
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'hyphenation-character'"/>
      </xsl:call-template>
    </xsl:attribute>
    <xsl:attribute name="hyphenation-push-character-count">
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'hyphenation-push-character-count'"/>
      </xsl:call-template>
    </xsl:attribute>
    <xsl:attribute name="hyphenation-remain-character-count">
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'hyphenation-remain-character-count'"/>
      </xsl:call-template>
    </xsl:attribute>

    <xsl:apply-templates select="." mode="running.head.mode">
      <xsl:with-param name="master-reference" select="$master-reference"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="." mode="running.foot.mode">
      <xsl:with-param name="master-reference" select="$master-reference"/>
    </xsl:apply-templates>

    <fo:flow flow-name="xsl-region-body">
      <xsl:call-template name="set.flow.properties">
        <xsl:with-param name="element" select="local-name(.)"/>
        <xsl:with-param name="master-reference" select="$master-reference"/>
      </xsl:call-template>

      <fo:block id="{$id}" span="all">
        <xsl:call-template name="index.titlepage"/>
      </fo:block>
      <xsl:apply-templates/>
      <xsl:if test="count(indexentry) = 0 and count(indexdiv) = 0">

        <xsl:choose>
          <xsl:when test="$make.index.markup != 0">
            <fo:block wrap-option='no-wrap'
                      white-space-collapse='false'
                      xsl:use-attribute-sets="monospace.verbatim.properties"
                      linefeed-treatment="preserve">
              <xsl:call-template name="generate-index-markup">
                <xsl:with-param name="scope" select="(ancestor::book|/)[last()]"/>
              </xsl:call-template>
            </fo:block>
          </xsl:when>
          <xsl:when test="indexentry|indexdiv/indexentry">
            <xsl:apply-templates/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="generate-index">
              <xsl:with-param name="scope" select="(ancestor::book|/)[last()]"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
    </fo:flow>
  </fo:page-sequence>
 </xsl:if>
</xsl:template>

<!-- Header and footer -->
<xsl:param name="header.column.widths">0 0 1</xsl:param>
<xsl:param name="footer.column.widths">9 0 1</xsl:param>
<xsl:param name="marker.section.level" select="0"/>

<xsl:attribute-set name="header.content.properties">
  <xsl:attribute name="font-family">Trebuchet,<xsl:value-of select="$symbol.font.family"/></xsl:attribute>
  <xsl:attribute name="font-size">9pt</xsl:attribute>
  <xsl:attribute name="font-style">italic</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="footer.content.properties" use-attribute-sets="header.content.properties"/>

<xsl:template name="head.sep.rule">
  <xsl:param name="pageclass"/>
  <xsl:param name="sequence"/>
  <xsl:param name="gentext-key"/>

  <xsl:if test="$header.rule != 0 and $sequence != 'first' and $pageclass != 'titlepage'">
    <xsl:attribute name="border-bottom-width">1pt</xsl:attribute>
    <xsl:attribute name="border-bottom-style">solid</xsl:attribute>
    <xsl:attribute name="border-bottom-color">black</xsl:attribute>
  </xsl:if>
</xsl:template>

<xsl:template name="foot.sep.rule">
  <xsl:param name="pageclass"/>
  <xsl:param name="sequence"/>
  <xsl:param name="gentext-key"/>

  <xsl:if test="$footer.rule != 0 and ($pageclass != 'titlepage')">
    <xsl:attribute name="border-top-width">1pt</xsl:attribute>
    <xsl:attribute name="border-top-style">solid</xsl:attribute>
    <xsl:attribute name="border-top-color">black</xsl:attribute>
  </xsl:if>
</xsl:template>

<xsl:template name="header.content">
  <xsl:param name="pageclass" select="''"/>
  <xsl:param name="sequence" select="''"/>
  <xsl:param name="position" select="''"/>
  <xsl:param name="gentext-key" select="''"/>

<!--
  <fo:block>
    <xsl:value-of select="$pageclass"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$sequence"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$position"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$gentext-key"/>
  </fo:block>
-->

  <fo:block>

    <!-- sequence can be odd, even, first, blank -->
    <!-- position can be left, center, right -->
    <xsl:choose>
      <xsl:when test="$sequence = 'blank'">
        <!-- nothing -->
      </xsl:when>

      <xsl:when test="(($position='left' and $double.sided != 0 and $sequence='even') or
		      ($position='right' and $double.sided != 0 and $sequence='odd'))
		      and $pageclass = 'lot'">
		  <xsl:call-template name="gentext">
			<xsl:with-param name="key" select="'TableofContents'"/>
		  </xsl:call-template>
      </xsl:when>

      <xsl:when test="(($position='left' and $double.sided != 0 and $sequence='even') or
		      ($position='right' and $double.sided != 0 and $sequence='odd'))
		      and $pageclass != 'titlepage'">
	<xsl:apply-templates select="." mode="object.title.markup"/>
      </xsl:when>

      <xsl:when test="$position='center'">
        <!-- nothing for empty and blank sequences -->
      </xsl:when>

      <xsl:when test="$position='right'">
        <!-- Same for odd, even, empty, and blank sequences -->
        <xsl:call-template name="draft.text"/>
      </xsl:when>

      <xsl:when test="$sequence = 'first'">
        <!-- nothing for first pages -->
      </xsl:when>

      <xsl:when test="$sequence = 'blank'">
        <!-- nothing for blank pages -->
      </xsl:when>
    </xsl:choose>
  </fo:block>
</xsl:template>

<xsl:template name="footer.content">
  <xsl:param name="pageclass" select="''"/>
  <xsl:param name="sequence" select="''"/>
  <xsl:param name="position" select="''"/>
  <xsl:param name="gentext-key" select="''"/>

<!--
  <fo:block>
    <xsl:value-of select="$pageclass"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$sequence"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$position"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$gentext-key"/>
  </fo:block>
-->

  <fo:block>
    <!-- pageclass can be front, body, back -->
    <!-- sequence can be odd, even, first, blank -->
    <!-- position can be left, center, right -->
    <xsl:choose>
      <xsl:when test="$pageclass = 'titlepage'">
        <!-- nop; no footer on title pages -->
      </xsl:when>

      <xsl:when test="$double.sided != 0 and 
		      (
		       ($sequence = 'even' and $position='left')
		       or (($sequence = 'odd' or $sequence = 'first') and $position='right')
		       or ($sequence = 'blank' and $position = 'left')
		       )">
	<fo:block margin-top="2pt">
	  <xsl:apply-templates mode="page-number-prefix" select="."/>
	  <fo:page-number/>
	</fo:block>
	<fo:block><fo:leader/></fo:block>
      </xsl:when>

      <xsl:when test="$double.sided != 0 and 
		      (
		      ($sequence = 'even' and $position='right')
		      or (($sequence = 'odd' or $sequence = 'first') and $position='left')
		      or  ($sequence = 'blank' and $position = 'right')
		      )">
        <!-- standard page footer block starts here -->
        <fo:block margin-top="2pt"><xsl:value-of select="//productnumber[1]"/><xsl:text> </xsl:text><xsl:apply-templates select="/*[1]" mode="title.markup"/><xsl:if test="//releaseinfo[1]">, <xsl:value-of select="//releaseinfo[1]"/></xsl:if></fo:block>
	<fo:block><xsl:value-of select="/*[local-name(.) = 'book' or local-name(.) = 'article']/*[local-name() = 'bookinfo' or local-name() = 'articleinfo']/pubdate"/><xsl:if test="/*[local-name(.) = 'book' or local-name(.) = 'article']/*[local-name() = 'bookinfo' or local-name() = 'articleinfo']/biblioid"><fo:leader leader-pattern="space" leader-length="1.5em"/><xsl:value-of select="/*[local-name(.) = 'book' or local-name(.) = 'article']/*[local-name() = 'bookinfo' or local-name() = 'articleinfo']/biblioid"/></xsl:if><xsl:text> </xsl:text><xsl:value-of select="//edition[1]"/></fo:block>
      </xsl:when>
      <xsl:when test="$sequence='blank'">
	<!-- nop -->
      </xsl:when>

      <xsl:otherwise>
        <!-- nop -->
      </xsl:otherwise>
    </xsl:choose>
  </fo:block>
</xsl:template>

<!-- Page number prefixes -->
<xsl:param name="prefix-separator">-</xsl:param>

<xsl:template match="chapter|chapter//*" mode="page-number-prefix">
<!--   <xsl:number count="chapter" from="book" level="any"/> -->
<!--   <xsl:copy-of select="$prefix-separator"/> -->
</xsl:template>

<xsl:template match="appendix|appendix//*" mode="page-number-prefix">
<!--   <xsl:number count="appendix" from="book" level="any" format="A"/> -->
<!--   <xsl:copy-of select="$prefix-separator"/> -->
</xsl:template>

<xsl:template match="glossary|glossary//*" mode="page-number-prefix">
<!--   <xsl:variable name="glossname"> -->
<!--     <xsl:call-template name="gentext"> -->
<!--       <xsl:with-param name="key" select="'glossary'"/> -->
<!--     </xsl:call-template> -->
<!--   </xsl:variable> -->
<!--   <xsl:value-of select="translate(substring($glossname, 1, 2), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/> -->
<!--   <xsl:copy-of select="$prefix-separator"/> -->
</xsl:template>

<xsl:template match="index|index//*" mode="page-number-prefix">
<!--   <xsl:variable name="indexname"> -->
<!--     <xsl:call-template name="gentext"> -->
<!--       <xsl:with-param name="key" select="'index'"/> -->
<!--     </xsl:call-template> -->
<!--   </xsl:variable> -->
<!--   <xsl:value-of select="translate(substring($indexname, 1, 2), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/> -->
<!--   <xsl:copy-of select="$prefix-separator"/> -->
</xsl:template>

<xsl:template match="reference|reference//*" mode="page-number-prefix">
<!--   <xsl:apply-templates select="preceding::chapter[1]" mode="page-number-prefix"/> -->
</xsl:template>

<xsl:template match="refentry|refentry//*" mode="page-number-prefix">
<!--   <xsl:apply-templates select="preceding::chapter[1]" mode="page-number-prefix"/> -->
</xsl:template>

<xsl:template match="*" mode="page-number-prefix"/>

<xsl:template name="initial.page.number-noop">
  <xsl:param name="element" select="local-name(.)"/>
  <xsl:param name="master-reference" select="''"/>

  <!-- Select the first content that the stylesheet places
       after the TOC -->
  <xsl:variable name="first.book.content" 
                select="ancestor::book/*[
                          not(self::title or
                              self::subtitle or
                              self::titleabbrev or
                              self::bookinfo or
                              self::info or
                              self::dedication or
                              self::preface or
                              self::toc or
                              self::lot)][1]"/>
  <xsl:choose>
    <!-- double-sided output -->
    <xsl:when test="$double.sided != 0">
      <xsl:choose>
        <xsl:when test="$element = 'toc'">auto-odd</xsl:when>
        <xsl:when test="$element = 'book'">1</xsl:when>
        <!-- preface typically continues TOC roman numerals -->
        <!-- Change page.number.format if not -->
        <xsl:when test="$element = 'preface'">auto-odd</xsl:when>
        <xsl:when test="($element = 'dedication' or $element = 'article') 
                    and not(preceding::chapter
                            or preceding::preface
                            or preceding::appendix
                            or preceding::article
                            or preceding::dedication
                            or parent::part
                            or parent::reference)">1</xsl:when>
        <xsl:when test="generate-id($first.book.content) =
                        generate-id(.)">1</xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:when>

    <!-- single-sided output -->
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="$element = 'toc'">auto</xsl:when>
        <xsl:when test="$element = 'book'">1</xsl:when>
        <xsl:when test="$element = 'preface'">auto</xsl:when>
       <xsl:when test="($element = 'dedication' or $element = 'article') and
                        not(preceding::chapter
                            or preceding::preface
                            or preceding::appendix
                            or preceding::article
                            or preceding::dedication
                            or parent::part
                            or parent::reference)">1</xsl:when>
        <xsl:when test="generate-id($first.book.content) =
                        generate-id(.)">1</xsl:when>
        <xsl:otherwise>auto</xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:attribute-set name="table.of.contents.titlepage.recto.style" use-attribute-sets="component.title.properties">
</xsl:attribute-set>

<xsl:template name="toc.line">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="label">
    <xsl:apply-templates select="." mode="label.markup"/>
  </xsl:variable>

  <xsl:variable name="title">
    <xsl:apply-templates select="." mode="object.title.markup"/>
  </xsl:variable>

  <xsl:variable name="line">
    <fo:block text-align-last="justify" 
	      end-indent="{$toc.indent.width}pt"
	      last-line-end-indent="-{$toc.indent.width}pt">
      <xsl:attribute name="margin-left">
	<xsl:value-of select="count(ancestor::section)"/>
	<xsl:text>pc</xsl:text>
      </xsl:attribute>
	<fo:inline keep-with-next.within-line="always">
	  <fo:basic-link internal-destination="{$id}">
	    <xsl:apply-templates select="." mode="titleabbrev.markup"/>
	  </fo:basic-link>
	</fo:inline>
	<fo:inline keep-together.within-line="always">
	  <xsl:text> </xsl:text>
	  <xsl:choose>
	    <xsl:when test="self::preface | self::chapter | self::appendix | self::index | self::glossary">
	      <fo:leader/>
	    </xsl:when>
	    <xsl:otherwise>
	      <fo:leader leader-pattern="dots"
			 leader-pattern-width="3pt"
			 leader-alignment="reference-area"
			 keep-with-next.within-line="always"/>
	    </xsl:otherwise>
	  </xsl:choose>
	  <xsl:text> </xsl:text> 
	  <xsl:if test="not(self::glossary or self::index)">
	    <fo:basic-link internal-destination="{$id}">
	      <xsl:apply-templates mode="page-number-prefix" select="."/>
	      <fo:page-number-citation ref-id="{$id}"/>
	    </fo:basic-link>
	  </xsl:if>
	</fo:inline>
    </fo:block>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="self::part">
      <fo:block xsl:use-attribute-sets="toc.line.properties"
		start-indent="0pt" text-align="center" text-align-last="center">
	<xsl:value-of select="$title"/>
      </fo:block>
    </xsl:when>
    <xsl:when test="ancestor-or-self::preface | ancestor-or-self::index | ancestor-or-self::glossary">
      <fo:block xsl:use-attribute-sets="toc.line.properties">
	<xsl:attribute name="start-indent">
	  <xsl:choose>
	    <xsl:when test="self::preface">0pt</xsl:when>
	    <xsl:otherwise>3.5pc</xsl:otherwise>
	  </xsl:choose>
	</xsl:attribute>
	<xsl:copy-of select="$line"/>
      </fo:block>
    </xsl:when>
    <xsl:otherwise>
      <fo:list-block provisional-distance-between-starts="3.5pc" 
		     xsl:use-attribute-sets="toc.line.properties"
		     text-align-last="left">
	<xsl:attribute name="start-indent">
	  <xsl:choose>
	    <xsl:when test="self::chapter | self::appendix | self::index">0pt</xsl:when>
	    <xsl:otherwise>3.5pc</xsl:otherwise>
	  </xsl:choose>
	</xsl:attribute>

	<fo:list-item>
	  <fo:list-item-label end-indent="label-end()">
	    <fo:block>
	      <xsl:value-of select="$label"/>
	      <xsl:if test="self::chapter | self::appendix"> —</xsl:if>
	    </fo:block>
	  </fo:list-item-label>
	  <fo:list-item-body start-indent="body-start()">
	    <xsl:copy-of select="$line"/>
	  </fo:list-item-body>
	</fo:list-item>
      </fo:list-block>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="indexterm" mode="reference">
  <xsl:param name="scope" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="type" select="''"/>
  <xsl:param name="position" select="0"/>
  <xsl:param name="separator" select="''"/>

  <xsl:variable name="term.separator">
    <xsl:call-template name="index.separator">
      <xsl:with-param name="key" select="'index.term.separator'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="range.separator">
    <xsl:call-template name="index.separator">
      <xsl:with-param name="key" select="'index.range.separator'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="number.separator">
    <xsl:call-template name="index.separator">
      <xsl:with-param name="key" select="'index.number.separator'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$separator != ''">
      <xsl:value-of select="$separator"/>
    </xsl:when>
    <xsl:when test="$position = 1">
      <xsl:value-of select="$term.separator"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$number.separator"/>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:choose>
    <xsl:when test="@zone and string(@zone)">
      <xsl:call-template name="reference">
        <xsl:with-param name="zones" select="normalize-space(@zone)"/>
        <xsl:with-param name="scope" select="$scope"/>
        <xsl:with-param name="role" select="$role"/>
        <xsl:with-param name="type" select="$type"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="ancestor::*[contains(local-name(),'info') and not(starts-with(local-name(),'info'))]">
      <xsl:call-template name="info.reference">
        <xsl:with-param name="scope" select="$scope"/>
        <xsl:with-param name="role" select="$role"/>
        <xsl:with-param name="type" select="$type"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="id">
        <xsl:call-template name="object.id"/>
      </xsl:variable>

      <fo:basic-link internal-destination="{$id}">
	<xsl:apply-templates mode="page-number-prefix" select="."/>
        <fo:page-number-citation ref-id="{$id}"/>
      </fo:basic-link>

      <xsl:if test="key('endofrange', $id)[&scope;]">
        <xsl:apply-templates select="key('endofrange', $id)[&scope;][last()]"
                             mode="reference">
          <xsl:with-param name="scope" select="$scope"/>
          <xsl:with-param name="role" select="$role"/>
          <xsl:with-param name="type" select="$type"/>
          <xsl:with-param name="separator" select="$range.separator"/>
        </xsl:apply-templates>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="reference">
  <xsl:param name="scope" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="type" select="''"/>
  <xsl:param name="zones"/>

  <xsl:variable name="number.separator">
    <xsl:call-template name="index.separator">
      <xsl:with-param name="key" select="'index.number.separator'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="contains($zones, ' ')">
      <xsl:variable name="zone" select="substring-before($zones, ' ')"/>
      <xsl:variable name="target" select="key('id', $zone)[&scope;]"/>

      <xsl:variable name="id">
        <xsl:call-template name="object.id">
           <xsl:with-param name="object" select="$target[1]"/>
        </xsl:call-template>
      </xsl:variable>

      <fo:basic-link internal-destination="{$id}">
        <fo:page-number-citation ref-id="{$id}"/>
      </fo:basic-link>

      <xsl:if test="$passivetex.extensions = '0'">
        <xsl:copy-of select="$number.separator"/>
      </xsl:if>
      <xsl:call-template name="reference">
        <xsl:with-param name="zones" select="substring-after($zones, ' ')"/>
        <xsl:with-param name="scope" select="$scope"/>
        <xsl:with-param name="role" select="$role"/>
        <xsl:with-param name="type" select="$type"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="zone" select="$zones"/>
      <xsl:variable name="target" select="key('id', $zone)[&scope;]"/>

      <xsl:variable name="id">
        <xsl:call-template name="object.id">
          <xsl:with-param name="object" select="$target[1]"/>
        </xsl:call-template>
      </xsl:variable>

      <fo:basic-link internal-destination="{$id}">
	<xsl:apply-templates mode="page-number-prefix" select="$target[1]"/>
        <fo:page-number-citation ref-id="{$id}"/>
      </fo:basic-link>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="info.reference">
  <!-- This is not perfect. It doesn't treat indexterm inside info element as a range covering whole parent of info.
       It also not work when there is no ID generated for parent element. But it works in the most common cases. -->
  <xsl:param name="scope" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="type" select="''"/>

  <xsl:variable name="target" select="(ancestor::appendix|ancestor::article|ancestor::bibliography|ancestor::book|
                                       ancestor::chapter|ancestor::glossary|ancestor::part|ancestor::preface|
                                       ancestor::refentry|ancestor::reference|ancestor::refsect1|ancestor::refsect2|
                                       ancestor::refsect3|ancestor::refsection|ancestor::refsynopsisdiv|
                                       ancestor::sect1|ancestor::sect2|ancestor::sect3|ancestor::sect4|ancestor::sect5|
                                       ancestor::section|ancestor::setindex|ancestor::set|ancestor::sidebar)[&scope;]"/>
  
  <xsl:variable name="id">
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="$target[1]"/>
    </xsl:call-template>
  </xsl:variable>
  
  <fo:basic-link internal-destination="{$id}">
    <xsl:apply-templates mode="page-number-prefix" select="$target[1]"/>
    <fo:page-number-citation ref-id="{$id}"/>
  </fo:basic-link>
</xsl:template>

<xsl:param name="xep.index.extensions" select="1"/>

<xsl:template match="indexterm" mode="index-primary">
  <xsl:param name="scope" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="type" select="''"/>

  <xsl:variable name="key" select="&primary;"/>
  <xsl:variable name="refs" select="key('primary', $key)[&scope;]"/>

  <xsl:variable name="term.separator">
    <xsl:call-template name="index.separator">
      <xsl:with-param name="key" select="'index.term.separator'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="range.separator">
    <xsl:call-template name="index.separator">
      <xsl:with-param name="key" select="'index.range.separator'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="number.separator">
    <xsl:call-template name="index.separator">
      <xsl:with-param name="key" select="'index.number.separator'"/>
    </xsl:call-template>
  </xsl:variable>

  <fo:block>
    <xsl:if test="$axf.extensions != 0">
      <xsl:attribute name="axf:suppress-duplicate-page-number">true</xsl:attribute>
    </xsl:if>
    <xsl:value-of select="primary"/>

    <xsl:choose>
      <xsl:when test="$xep.index.extensions != 0">
        <xsl:if test="$refs[not(see) and not(secondary)]">
          <xsl:copy-of select="$term.separator"/>
          <xsl:variable name="primary" select="&primary;"/>
          <xsl:variable name="primary.significant" select="concat(&primary;, $significant.flag)"/>
          <rx:page-index list-separator="{$number.separator}"
                         range-separator="{$range.separator}">
            <xsl:if test="$refs[@significance='preferred'][not(see) and not(secondary)]">
              <rx:index-item xsl:use-attribute-sets="index.preferred.page.properties xep.index.item.properties"
                ref-key="{$primary.significant}"/>
            </xsl:if>
            <xsl:if test="$refs[not(@significance) or @significance!='preferred'][not(see) and not(secondary)]">
              <rx:index-item xsl:use-attribute-sets="xep.index.item.properties"
                ref-key="{$primary}"/>
            </xsl:if>
          </rx:page-index>        
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="page-number-citations">
          <xsl:for-each select="$refs[not(see) 
                                and not(secondary)]">
            <xsl:apply-templates select="." mode="reference">
              <xsl:with-param name="scope" select="$scope"/>
              <xsl:with-param name="role" select="$role"/>
              <xsl:with-param name="type" select="$type"/>
              <xsl:with-param name="position" select="position()"/>
            </xsl:apply-templates>
          </xsl:for-each>
        </xsl:variable>

        <xsl:choose>
          <xsl:when test="$passivetex.extensions != '0'">
            <fotex:sort xmlns:fotex="http://www.tug.org/fotex">
              <xsl:copy-of select="$page-number-citations"/>
            </fotex:sort>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy-of select="$page-number-citations"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:if test="$refs[not(secondary)]/*[self::see]">
      <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see', concat(&primary;, &sep;, &sep;, &sep;, see))[&scope;][1])]"
                           mode="index-see">
         <xsl:with-param name="scope" select="$scope"/>
         <xsl:with-param name="role" select="$role"/>
         <xsl:with-param name="type" select="$type"/>
         <xsl:sort select="translate(see, &lowercase;, &uppercase;)"/>
      </xsl:apply-templates>
    </xsl:if>

  </fo:block>

  <xsl:if test="$refs/secondary or $refs[not(secondary)]/*[self::seealso]">
    <fo:block start-indent="1pc">
      <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see-also', concat(&primary;, &sep;, &sep;, &sep;, seealso))[&scope;][1])]"
                           mode="index-seealso">
         <xsl:with-param name="scope" select="$scope"/>
         <xsl:with-param name="role" select="$role"/>
         <xsl:with-param name="type" select="$type"/>
         <xsl:sort select="translate(seealso, &lowercase;, &uppercase;)"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="$refs[secondary and count(.|key('secondary', concat($key, &sep;, &secondary;))[&scope;][1]) = 1]"
                           mode="index-secondary">
       <xsl:with-param name="scope" select="$scope"/>
       <xsl:with-param name="role" select="$role"/>
       <xsl:with-param name="type" select="$type"/>
       <xsl:sort select="translate(&secondary;, &lowercase;, &uppercase;)"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template match="indexterm" mode="index-secondary">
  <xsl:param name="scope" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="type" select="''"/>

  <xsl:variable name="key" select="concat(&primary;, &sep;, &secondary;)"/>
  <xsl:variable name="refs" select="key('secondary', $key)[&scope;]"/>

  <xsl:variable name="term.separator">
    <xsl:call-template name="index.separator">
      <xsl:with-param name="key" select="'index.term.separator'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="range.separator">
    <xsl:call-template name="index.separator">
      <xsl:with-param name="key" select="'index.range.separator'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="number.separator">
    <xsl:call-template name="index.separator">
      <xsl:with-param name="key" select="'index.number.separator'"/>
    </xsl:call-template>
  </xsl:variable>

  <fo:block>
    <xsl:if test="$axf.extensions != 0">
      <xsl:attribute name="axf:suppress-duplicate-page-number">true</xsl:attribute>
    </xsl:if>
    <xsl:value-of select="secondary"/>

    <xsl:choose>
      <xsl:when test="$xep.index.extensions != 0">
        <xsl:if test="$refs[not(see) and not(tertiary)]">
          <xsl:copy-of select="$term.separator"/>
          <xsl:variable name="primary" select="&primary;"/>
          <xsl:variable name="secondary" select="&secondary;"/>
          <xsl:variable name="primary.significant" select="concat(&primary;, $significant.flag)"/>
          <rx:page-index list-separator="{$number.separator}"
                         range-separator="{$range.separator}">
            <xsl:if test="$refs[@significance='preferred'][not(see) and not(tertiary)]">
              <rx:index-item xsl:use-attribute-sets="index.preferred.page.properties xep.index.item.properties">
                <xsl:attribute name="ref-key">
                  <xsl:value-of select="$primary.significant"/>
                  <xsl:text>, </xsl:text>
                  <xsl:value-of select="$secondary"/>
                </xsl:attribute>
              </rx:index-item>
            </xsl:if>
            <xsl:if test="$refs[not(@significance) or @significance!='preferred'][not(see) and not(tertiary)]">
              <rx:index-item xsl:use-attribute-sets="xep.index.item.properties">
                <xsl:attribute name="ref-key">
                  <xsl:value-of select="$primary"/>
                  <xsl:text>, </xsl:text>
                  <xsl:value-of select="$secondary"/>
                </xsl:attribute>
              </rx:index-item>
            </xsl:if>
          </rx:page-index>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="page-number-citations">
          <xsl:for-each select="$refs[not(see) 
                                and not(tertiary)]">
            <xsl:apply-templates select="." mode="reference">
              <xsl:with-param name="scope" select="$scope"/>
              <xsl:with-param name="role" select="$role"/>
              <xsl:with-param name="type" select="$type"/>
              <xsl:with-param name="position" select="position()"/>
            </xsl:apply-templates>
          </xsl:for-each>
        </xsl:variable>

        <xsl:choose>
          <xsl:when test="$passivetex.extensions != '0'">
            <fotex:sort xmlns:fotex="http://www.tug.org/fotex">
              <xsl:copy-of select="$page-number-citations"/>
            </fotex:sort>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy-of select="$page-number-citations"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:if test="$refs[not(tertiary)]/*[self::see]">
      <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see', concat(&primary;, &sep;, &secondary;, &sep;, &sep;, see))[&scope;][1])]"
                           mode="index-see">
        <xsl:with-param name="scope" select="$scope"/>
        <xsl:with-param name="role" select="$role"/>
        <xsl:with-param name="type" select="$type"/>
        <xsl:sort select="translate(see, &lowercase;, &uppercase;)"/>
      </xsl:apply-templates>
    </xsl:if>

  </fo:block>

  <xsl:if test="$refs/tertiary or $refs[not(tertiary)]/*[self::seealso]">
    <fo:block start-indent="2pc">
      <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see-also', concat(&primary;, &sep;, &secondary;, &sep;, &sep;, seealso))[&scope;][1])]"
                           mode="index-seealso">
          <xsl:with-param name="scope" select="$scope"/>
          <xsl:with-param name="role" select="$role"/>
          <xsl:with-param name="type" select="$type"/>
          <xsl:sort select="translate(seealso, &lowercase;, &uppercase;)"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="$refs[tertiary and count(.|key('tertiary', concat($key, &sep;, &tertiary;))[&scope;][1]) = 1]" 
                           mode="index-tertiary">
          <xsl:with-param name="scope" select="$scope"/>
          <xsl:with-param name="role" select="$role"/>
          <xsl:with-param name="type" select="$type"/>
          <xsl:sort select="translate(&tertiary;, &lowercase;, &uppercase;)"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template match="indexterm" mode="index-tertiary">
  <xsl:param name="scope" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="type" select="''"/>
  <xsl:variable name="key" select="concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;)"/>
  <xsl:variable name="refs" select="key('tertiary', $key)[&scope;]"/>

  <xsl:variable name="term.separator">
    <xsl:call-template name="index.separator">
      <xsl:with-param name="key" select="'index.term.separator'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="range.separator">
    <xsl:call-template name="index.separator">
      <xsl:with-param name="key" select="'index.range.separator'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="number.separator">
    <xsl:call-template name="index.separator">
      <xsl:with-param name="key" select="'index.number.separator'"/>
    </xsl:call-template>
  </xsl:variable>

  <fo:block>
    <xsl:if test="$axf.extensions != 0">
      <xsl:attribute name="axf:suppress-duplicate-page-number">true</xsl:attribute>
    </xsl:if>
    <xsl:value-of select="tertiary"/>

    <xsl:choose>
      <xsl:when test="$xep.index.extensions != 0">
        <xsl:if test="$refs[not(see)]">
          <xsl:copy-of select="$term.separator"/>
          <xsl:variable name="primary" select="&primary;"/>
          <xsl:variable name="secondary" select="&secondary;"/>
          <xsl:variable name="tertiary" select="&tertiary;"/>
          <xsl:variable name="primary.significant" select="concat(&primary;, $significant.flag)"/>
          <rx:page-index list-separator="{$number.separator}"
                         range-separator="{$range.separator}">
            <xsl:if test="$refs[@significance='preferred'][not(see)]">
              <rx:index-item xsl:use-attribute-sets="index.preferred.page.properties xep.index.item.properties">
                <xsl:attribute name="ref-key">
                  <xsl:value-of select="$primary.significant"/>
                  <xsl:text>, </xsl:text>
                  <xsl:value-of select="$secondary"/>
                  <xsl:text>, </xsl:text>
                  <xsl:value-of select="$tertiary"/>
                </xsl:attribute>
              </rx:index-item>
            </xsl:if>
            <xsl:if test="$refs[not(@significance) or @significance!='preferred'][not(see)]">
              <rx:index-item xsl:use-attribute-sets="xep.index.item.properties">
                <xsl:attribute name="ref-key">
                  <xsl:value-of select="$primary"/>
                  <xsl:text>, </xsl:text>
                  <xsl:value-of select="$secondary"/>
                  <xsl:text>, </xsl:text>
                  <xsl:value-of select="$tertiary"/>
                </xsl:attribute>
              </rx:index-item>
            </xsl:if>
          </rx:page-index>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="page-number-citations">
          <xsl:for-each select="$refs[not(see)]">
            <xsl:apply-templates select="." mode="reference">
              <xsl:with-param name="scope" select="$scope"/>
              <xsl:with-param name="role" select="$role"/>
              <xsl:with-param name="type" select="$type"/>
              <xsl:with-param name="position" select="position()"/>
            </xsl:apply-templates>
          </xsl:for-each>
        </xsl:variable>

        <xsl:choose>
          <xsl:when test="$passivetex.extensions != '0'">
            <fotex:sort xmlns:fotex="http://www.tug.org/fotex">
              <xsl:copy-of select="$page-number-citations"/>
            </fotex:sort>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy-of select="$page-number-citations"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:if test="$refs/see">
      <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see', concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;, &sep;, see))[&scope;][1])]"
                           mode="index-see">
        <xsl:with-param name="scope" select="$scope"/>
        <xsl:with-param name="role" select="$role"/>
        <xsl:with-param name="type" select="$type"/>
        <xsl:sort select="translate(see, &lowercase;, &uppercase;)"/>
      </xsl:apply-templates>
    </xsl:if>

  </fo:block>

  <xsl:if test="$refs/seealso">
    <fo:block>
      <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see-also', concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;, &sep;, seealso))[&scope;][1])]"
                           mode="index-seealso">
        <xsl:with-param name="scope" select="$scope"/>
        <xsl:with-param name="role" select="$role"/>
        <xsl:with-param name="type" select="$type"/>
        <xsl:sort select="translate(seealso, &lowercase;, &uppercase;)"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:if>
</xsl:template>

<!-- The following is used in typ. conventions section -->
<xsl:template match="emphasis[@role = 'monospace']">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="emphasis[@role = 'monospace_italic']">
  <xsl:call-template name="inline.italicmonoseq"/>
</xsl:template>

<xsl:template match="processing-instruction('sbr')">
  <xsl:text>&#x200B;</xsl:text>
</xsl:template>

<xsl:template match="processing-instruction('linebreak')" priority="100">
	<fo:block/>
</xsl:template>

<xsl:template match="*[processing-instruction('bjfo') = 'keep-with-previous']">
  <fo:block keep-together.within-column="always"
	    keep-with-previous.within-column="always">
    <xsl:apply-imports/>
  </fo:block>
</xsl:template>

<xsl:template match="*[processing-instruction('bjfo') = 'keep-with-next']">
  <fo:block keep-together.within-column="always"
	    keep-with-next.within-column="always">
    <xsl:apply-imports/>
  </fo:block>
</xsl:template>

<xsl:template match="*[processing-instruction('bjfo') = 'keep-together']">
  <fo:block keep-together.within-column="always">
    <xsl:apply-imports/>
  </fo:block>
</xsl:template>

<xsl:template match="processing-instruction('bjfo')[. = 'page-break']">
  <fo:block break-before="page"/>
</xsl:template>

<xsl:template match="*[processing-instruction('bjfo')[. = 'wide-block-element']]">
  <fo:block start-indent="0pt" end-indent="0pt" margin-left="auto">
    <xsl:apply-imports/>
  </fo:block>
</xsl:template>

  <xsl:template match="phrase[@role = 'keep-together.within-line']">
	<fo:inline keep-together.within-line="always"><xsl:apply-templates/></fo:inline>
  </xsl:template>

  <xsl:template match="text()[ contains(concat(';',ancestor::*/@security,';'),';internal;') ] | xref[ contains(concat(';',ancestor::*/@security,';'),';internal;') ]">
	<fo:wrapper xmlns:fo="http://www.w3.org/1999/XSL/Format" color="blue"><xsl:apply-imports/></fo:wrapper>
  </xsl:template>
  <xsl:template match="text()[ contains(concat(';',ancestor::*/@security,';'),';writeronly;') ] | xref[ contains(concat(';',ancestor::*/@security,';'),';writeronly;') ]" priority="10">
	<fo:wrapper xmlns:fo="http://www.w3.org/1999/XSL/Format" color="red"><xsl:apply-imports/></fo:wrapper>
  </xsl:template>
  <xsl:template match="text()[ contains(concat(';',ancestor::*/@security,';'),';reviewer;') ] | xref[ contains(concat(';',ancestor::*/@security,';'),';reviewer;') ]" priority="10">
	<fo:inline xmlns:fo="http://www.w3.org/1999/XSL/Format" background-color="yellow"><xsl:apply-imports/></fo:inline>
  </xsl:template>
  <xsl:template match="text()[ ancestor::*/@role = 'highlight' ] | xref[ ancestor::*/@role = 'highlight' ]" priority="10">
	<fo:inline xmlns:fo="http://www.w3.org/1999/XSL/Format" background-color="yellow"><xsl:apply-imports/></fo:inline>
  </xsl:template>


  <xsl:template match="processing-instruction('insert-backcover')">
	<fo:page-sequence master-reference="blank">
	  <fo:flow flow-name="blank-body">
		<fo:block>
		  <fo:block-container absolute-position="fixed" left="0pt" top="0pt" z-index="-1">
			<fo:block>
			  <fo:external-graphic src="url({$admon.graphics.path}backcover1.pdf)"/>
			</fo:block>
		  </fo:block-container>
		  <fo:block>&#160;</fo:block>
		  <fo:block break-before="page"/>
		  <fo:block-container absolute-position="fixed" left="0pt" top="0pt" z-index="-1">
			<fo:block>
			  <fo:external-graphic src="url({$admon.graphics.path}backcover2.pdf)"/>
			</fo:block>
		  </fo:block-container>
		  <fo:block-container absolute-position="fixed" left="0pt" top="26cm">	  
			<fo:block text-align="center" font-family="Times,Symbol" font-size="8pt">
			  Copyright <xsl:apply-templates select="//copyright[1]/year"/><xsl:text> </xsl:text>
			  <xsl:choose>
				<xsl:when test="//copyright[1]/holder[not(normalize-space(.) = '')]"><xsl:apply-templates select="//copyright[1]/holder"/></xsl:when>
				<xsl:otherwise>Alcatel-Lucent</xsl:otherwise>
			  </xsl:choose>
			</fo:block>
			<fo:block  text-align="center" font-family="Times,Symbol" font-size="8pt">
			  <xsl:value-of select="//biblioid[1]"/><xsl:text> </xsl:text><xsl:value-of select="//edition[1]"/>
			</fo:block>
		  </fo:block-container>
		</fo:block>
	  </fo:flow>
	</fo:page-sequence>
  </xsl:template>
  
<xsl:template name="xep-document-information">
  <rx:meta-info>
    <xsl:variable name="authors" select="(//author|//editor|//corpauthor|//authorgroup)[1]"/>
<!--  Test not needed. It's always by Alcatel -->
<!--     <xsl:if test="$authors"> -->
      <xsl:variable name="author">
        <xsl:choose>
          <xsl:when test="$authors[self::authorgroup]">
            <xsl:call-template name="person.name.list">
              <xsl:with-param name="person.list" 
                        select="$authors/*[self::author|self::corpauthor|
                               self::othercredit|self::editor]"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$authors[self::corpauthor]">
            <xsl:value-of select="$authors"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="person.name">
              <xsl:with-param name="node" select="$authors"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:element name="rx:meta-field">
        <xsl:attribute name="name">author</xsl:attribute>
        <xsl:attribute name="value">Alcatel-Lucent
<!--           <xsl:value-of select="normalize-space($author)"/> -->
        </xsl:attribute>
      </xsl:element>
<!--     </xsl:if> -->

    <xsl:variable name="title">
      <xsl:apply-templates select="/*[1]" mode="label.markup"/>
      <xsl:apply-templates select="/*[1]" mode="title.markup"/>
    </xsl:variable>

    <xsl:element name="rx:meta-field">
      <xsl:attribute name="name">creator</xsl:attribute>
      <xsl:attribute name="value">
        <xsl:text>DocBook </xsl:text>
        <xsl:value-of select="$DistroTitle"/>
        <xsl:text> V</xsl:text>
        <xsl:value-of select="$VERSION"/>
	<xsl:text> customized by Jirka Kosek &lt;jirka@kosek.cz></xsl:text>
      </xsl:attribute>
    </xsl:element>

    <xsl:element name="rx:meta-field">
      <xsl:attribute name="name">title</xsl:attribute>
      <xsl:attribute name="value">
        <xsl:value-of select="normalize-space($title)"/>
      </xsl:attribute>
    </xsl:element>

   <!-- Per JCBG-223, populate keywords with Vol info, using part number as 1st bibloid, and date as 1st pubdate -->
      <xsl:element name="rx:meta-field">
        <xsl:attribute name="name">keywords</xsl:attribute>
        <xsl:attribute name="value">
Vol 1 of 1 <xsl:value-of select="//biblioid[1]"/>
Issue 1 Date <xsl:value-of select="//pubdate[1]"/>.

<!-- Also, include any keywords that are in the document ... -->
          <xsl:for-each select="//keyword">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="position() != last()">
              <xsl:text>, </xsl:text>
            </xsl:if>
          </xsl:for-each>
        </xsl:attribute>
      </xsl:element>


    <xsl:if test="//subjectterm">
      <xsl:element name="rx:meta-field">
        <xsl:attribute name="name">subject</xsl:attribute>
        <xsl:attribute name="value">
          <xsl:for-each select="//subjectterm">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="position() != last()">
              <xsl:text>, </xsl:text>
            </xsl:if>
          </xsl:for-each>
        </xsl:attribute>
      </xsl:element>
    </xsl:if>
  </rx:meta-info>
</xsl:template>

  <xsl:template match="ulink|uri" name="ulink" xmlns:xlink="http://www.w3.org/1999/xlink" >
  <xsl:param name="url" select="@url|@xlink:href"/>

  <xsl:variable name ="ulink.url">
    <xsl:call-template name="fo-external-image">
      <xsl:with-param name="filename" select="$url"/>
    </xsl:call-template>
  </xsl:variable>

  <fo:basic-link xsl:use-attribute-sets="xref.properties"
                 external-destination="{$ulink.url}">
    <xsl:choose>
      <xsl:when test="count(child::node())=0">
        <xsl:call-template name="hyphenate-url">
          <xsl:with-param name="url" select="$url"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </fo:basic-link>

  <xsl:if test="count(child::node()) != 0
                and string(.) != $url
                and $ulink.show != 0
	            and not(@xrefstyle = 'ulink.hide')">
    <!-- yes, show the URI -->
    <xsl:choose>
      <xsl:when test="$ulink.footnotes != 0 and not(ancestor::footnote)">
        <fo:footnote>
          <xsl:call-template name="ulink.footnote.number"/>
          <fo:footnote-body xsl:use-attribute-sets="footnote.properties">
            <fo:block>
              <xsl:call-template name="ulink.footnote.number"/>
              <xsl:text> </xsl:text>
              <fo:basic-link external-destination="{$ulink.url}">
                <xsl:value-of select="$url"/>
              </fo:basic-link>
            </fo:block>
          </fo:footnote-body>
        </fo:footnote>
      </xsl:when>
      <xsl:otherwise>
        <fo:inline hyphenate="false">
          <xsl:text> (</xsl:text>
          <fo:basic-link external-destination="{$ulink.url}">
            <xsl:call-template name="hyphenate-url">
              <xsl:with-param name="url" select="$url"/>
            </xsl:call-template>
          </fo:basic-link>
          <xsl:text>)</xsl:text>
        </fo:inline>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<xsl:template match="formalpara/para">
  <fo:wrapper>
    <xsl:call-template name="anchor"/>
    <xsl:apply-templates/>
  </fo:wrapper>
</xsl:template>

<xsl:template match="formalpara/para[processing-instruction('bjfo') = 'keep-together']" priority="2">
  <fo:block keep-together.within-column="always">
    <xsl:call-template name="anchor"/>
    <xsl:apply-imports/>
  </fo:block>
</xsl:template>

<xsl:template match="comment|remark">
  <xsl:if test="$show.comments != 0">
	  <xsl:choose>
		<xsl:when test="parent::para or parent::title">
		  <fo:inline 
			font-style="italic"
			font-size="{$body.font.size}"
			background-color="yellow">
			<xsl:call-template name="inline.charseq"/>
		  </fo:inline>
		</xsl:when>
		<xsl:otherwise>
		  <fo:block 
			font-style="italic"
			background-color="yellow">
			<xsl:call-template name="inline.charseq"/>
		  </fo:block>
		</xsl:otherwise>
	  </xsl:choose>
	</xsl:if>
</xsl:template>

	<!-- From table.xsl -->
<xsl:template match="thead">
  <xsl:variable name="tgroup" select="parent::*"/>

  <fo:table-header start-indent="0pt" end-indent="0pt" background-color="rgb(230,230,230)">
    <xsl:apply-templates select="row[1]">
      <xsl:with-param name="spans">
        <xsl:call-template name="blank.spans">
          <xsl:with-param name="cols" select="../@cols"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:apply-templates>
  </fo:table-header>
</xsl:template>

  <!-- From tp-fo.xsl (titlepage templates) -->


  <xsl:template match="copyright" mode="book.titlepage.recto.auto.mode">
	<fo:block-container xmlns:fo="http://www.w3.org/1999/XSL/Format" absolute-position="fixed" text-align="left" font-size="6pt" top="25.8cm" right="10.5cm" left="3cm" font-weight="bold" font-family="Frutiger-BlackCn,Times,Symbol">
	  <fo:block>Alcatel-Lucent Proprietary</fo:block>
	  <fo:block>This document contains proprietary information of Alcatel-Lucent and is not to be disclosed or used except in accordance with applicable agreements.</fo:block>
	  <fo:block>Copyright <xsl:apply-templates select="//copyright[1]/year" /><xsl:text> </xsl:text><xsl:choose>
		  <xsl:when test="//copyright[1]/holder[not(normalize-space(.) = '')]"><xsl:apply-templates select="//copyright[1]/holder"/></xsl:when>
		  <xsl:otherwise>Alcatel-Lucent</xsl:otherwise>
		</xsl:choose>
	  </fo:block>
	</fo:block-container>
  </xsl:template>

  <xsl:template match="year|holder">
	<xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="productname" mode="book.titlepage.recto.auto.mode">
    <!-- this template, along with the next one, makes the PRODNAME | RELEASEINFO block on the cover-->
    <!-- This template makes both the ALCATEL-LUCENT <productnumber> and the prodname | releaseinfo lines on the cover -->


     <fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format" xsl:use-attribute-sets="book.titlepage.recto.style" text-align="left" font-size="24pt" start-indent="0mm" font-weight="bold" font-family="Trebuchet"  margin-top="10.60cm">
      ALCATEL-LUCENT <xsl:apply-templates select="../productnumber"/>
	</fo:block>
 
	<fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format" xsl:use-attribute-sets="book.titlepage.recto.style" text-align="left" font-size="14pt" start-indent="0mm" font-weight="normal" font-family="Trebuchet"  margin-top ="-3pt">

	  <xsl:call-template name="string.upper">
		<xsl:with-param name="string"><xsl:value-of select="."/></xsl:with-param>
	  </xsl:call-template>
	  <xsl:apply-templates select="../releaseinfo"/>
	</fo:block>
  </xsl:template>

<!-- here is where the | gets output -->
  <xsl:template match="releaseinfo"><xsl:text> | </xsl:text>
	<xsl:call-template name="string.upper">
	  <xsl:with-param name="string"><xsl:value-of select="."/></xsl:with-param>
	</xsl:call-template>
  </xsl:template>

  <!-- Put copyright on inside of cover page -->
  <xsl:template match="copyright" mode="book.titlepage.verso.auto.mode">
	<fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format" xsl:use-attribute-sets="book.titlepage.verso.style" font-size="11pt" font-family="Times,Symbol">Copyright <xsl:apply-templates select="year"/><xsl:text> </xsl:text> 
	  <xsl:choose>
		<xsl:when test="holder[not(normalize-space(.) = '')]"><xsl:apply-templates select="holder"/></xsl:when>
		<xsl:otherwise>Alcatel-Lucent</xsl:otherwise>
	  </xsl:choose>
	</fo:block>
  </xsl:template>

<xsl:template match="title" mode="book.titlepage.recto.auto.mode">
<fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format" xsl:use-attribute-sets="book.titlepage.recto.style" text-align="left" font-size="11pt"  start-indent="0mm" font-weight="bold" font-family="{$title.font.family}" space-before="9.5pt">
   <!-- the above had the value letter-spacing=".25em"-->
	  <xsl:variable name="title-content">
	    <xsl:choose>
	      <xsl:when test="string(//processing-instruction('covertitle')) !=''">
	        <!-- if a covertitle PI exists, use that (for JCBG-823) -->
	        <xsl:value-of select="//processing-instruction('covertitle')"/>
	      </xsl:when>
	      <xsl:otherwise>
	        <!-- otherwise, get the title the usual way -->
	        <xsl:call-template name="division.title">
	          <xsl:with-param name="node" select="ancestor-or-self::book[1]"/>
	        </xsl:call-template>
	      </xsl:otherwise>
	    </xsl:choose>
	  </xsl:variable>
	  <xsl:call-template name="string.upper">
		<xsl:with-param name="string" select="$title-content"/>
	  </xsl:call-template>	  
	</fo:block>
</xsl:template>

<xsl:template match="subtitle" mode="book.titlepage.recto.auto.mode">
<fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format" xsl:use-attribute-sets="book.titlepage.recto.style" text-align="left" font-size="10pt"  start-indent="0mm" font-weight="normal" font-family="{$title.font.family}" space-before="3pt">
	  <xsl:call-template name="string.upper">
		<xsl:with-param name="string"><xsl:value-of select="."/></xsl:with-param>
	  </xsl:call-template>
	</fo:block>
</xsl:template>

<xsl:template match="biblioid" mode="book.titlepage.recto.auto.mode">
 <fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format" xsl:use-attribute-sets="book.titlepage.recto.style" text-align="left" font-size="10pt"  start-indent="0mm" font-weight="normal" font-family="{$title.font.family}" space-before="3.5pt">
	<xsl:call-template name="string.upper">
	  <xsl:with-param name="string"><xsl:value-of select="."/></xsl:with-param>
	</xsl:call-template>
 </fo:block>
</xsl:template>

<!-- we're going to output issunum with pubdate, because date is required and issuenum is not, but if issuenum is there, it's on same line -->
<xsl:template match="pubdate" mode="book.titlepage.recto.auto.mode">
<fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format" xsl:use-attribute-sets="book.titlepage.recto.style" text-align="left" font-size="10pt"  start-indent="0mm" font-weight="normal" font-family="{$title.font.family}" space-before="3.5pt">
 <!-- only output issuenum if it has a value -->
 <xsl:if test="../issuenum !=''">ISSUE: <xsl:value-of select="../issuenum"/> | </xsl:if> 
	  <xsl:call-template name="string.upper">
		<xsl:with-param name="string"><xsl:value-of select="."/></xsl:with-param>
	  </xsl:call-template>
	</fo:block>
</xsl:template>



  <!-- End tp-fo.xsl stuff -->


  <xsl:template name="document.status.bar">
	<fo:block-container reference-orientation="90" absolute-position="fixed" height="3in" width="11in" z-index="1"> 
	  <fo:block padding-before=".45in" font-size="1.5em" color="gray" font-weight="bold">
		<fo:leader leader-pattern="use-content" leader-length="15in" letter-spacing=".1em"><xsl:text> </xsl:text><xsl:value-of select="$alcatel.footer.text"/><xsl:text> </xsl:text></fo:leader>
	  </fo:block>
	</fo:block-container>
  </xsl:template>

<xsl:template match="*" mode="running.head.mode">
  <xsl:param name="master-reference" select="'unknown'"/>
  <xsl:param name="gentext-key" select="local-name(.)"/>

  <!-- remove -draft from reference -->
  <xsl:variable name="pageclass">
    <xsl:choose>
      <xsl:when test="contains($master-reference, '-draft')">
        <xsl:value-of select="substring-before($master-reference, '-draft')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$master-reference"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <fo:static-content flow-name="xsl-region-before-first">
			  <xsl:call-template name="document.status.bar"/>

    <fo:block xsl:use-attribute-sets="header.content.properties">
      <xsl:call-template name="header.table">
        <xsl:with-param name="pageclass" select="$pageclass"/>
        <xsl:with-param name="sequence" select="'first'"/>
        <xsl:with-param name="gentext-key" select="$gentext-key"/>
      </xsl:call-template>
    </fo:block>
  </fo:static-content>

  <fo:static-content flow-name="xsl-region-before-odd">
			  <xsl:call-template name="document.status.bar"/>

    <fo:block xsl:use-attribute-sets="header.content.properties">
      <xsl:call-template name="header.table">
        <xsl:with-param name="pageclass" select="$pageclass"/>
        <xsl:with-param name="sequence" select="'odd'"/>
        <xsl:with-param name="gentext-key" select="$gentext-key"/>
      </xsl:call-template>
    </fo:block>
  </fo:static-content>

  <fo:static-content flow-name="xsl-region-before-even">
			  <xsl:call-template name="document.status.bar"/>

    <fo:block xsl:use-attribute-sets="header.content.properties">
      <xsl:call-template name="header.table">
        <xsl:with-param name="pageclass" select="$pageclass"/>
        <xsl:with-param name="sequence" select="'even'"/>
        <xsl:with-param name="gentext-key" select="$gentext-key"/>
      </xsl:call-template>
    </fo:block>
  </fo:static-content>

  <fo:static-content flow-name="xsl-region-before-blank">
			  <xsl:call-template name="document.status.bar"/>

    <fo:block xsl:use-attribute-sets="header.content.properties">
      <xsl:call-template name="header.table">
        <xsl:with-param name="pageclass" select="$pageclass"/>
        <xsl:with-param name="sequence" select="'blank'"/>
        <xsl:with-param name="gentext-key" select="$gentext-key"/>
      </xsl:call-template>
    </fo:block>
  </fo:static-content>

  <xsl:call-template name="footnote-separator"/>

  <xsl:if test="$fop.extensions = 0 and $fop1.extensions = 0">
    <xsl:call-template name="blank.page.content"/>
  </xsl:if>
</xsl:template>

<!--xsl:param name="procedure.step.numeration.formats" select="'1iAI'"/>

<xsl:template name="procedure.step.numeration">
  <xsl:param name="context" select="."/>
  <xsl:variable name="format.length"
                select="string-length($procedure.step.numeration.formats)"/>
  <xsl:choose>
    <xsl:when test="local-name($context) = 'substeps'">
      <xsl:variable name="ssdepth"
                    select="count($context/ancestor::substeps)"/>
      <xsl:variable name="sstype" select="($ssdepth mod $format.length)+2"/>
      <xsl:choose>
		<xsl:when test="ancestor-or-self::substeps[@performance='optional']">a</xsl:when>
        <xsl:when test="$sstype &gt; $format.length">
          <xsl:value-of select="substring($procedure.step.numeration.formats,1,1)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="substring($procedure.step.numeration.formats,$sstype,1)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="local-name($context) = 'step'">
      <xsl:variable name="sdepth"
                    select="count($context/ancestor::substeps)"/>
      <xsl:variable name="stype" select="($sdepth mod $format.length)+1"/>
      <xsl:value-of select="substring($procedure.step.numeration.formats,$stype,1)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
        <xsl:text>Unexpected context in procedure.step.numeration: </xsl:text>
        <xsl:value-of select="local-name($context)"/>
      </xsl:message>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template-->

<xsl:template match="replaceable">
  <xsl:call-template name="inline.italicseq"/>
</xsl:template>


<!-- This is a fix for a bug where there's an extra space after xref where xrefstyle has nopage. Remove this template when you upgrade the base xsls past 1.72 -->
<xsl:template name="make.gentext.template">
  <xsl:param name="xrefstyle" select="''"/>
  <xsl:param name="purpose"/>
  <xsl:param name="referrer"/>
  <xsl:param name="lang">
    <xsl:call-template name="l10n.language"/>
  </xsl:param>
  <xsl:param name="target.elem" select="local-name(.)"/>

  <!-- parse xrefstyle to get parts -->
  <xsl:variable name="parts"
      select="substring-after(normalize-space($xrefstyle), 'select:')"/>

  <xsl:variable name="labeltype">
    <xsl:choose>
      <xsl:when test="contains($parts, 'labelnumber')">
         <xsl:text>labelnumber</xsl:text>
      </xsl:when>
      <xsl:when test="contains($parts, 'labelname')">
         <xsl:text>labelname</xsl:text>
      </xsl:when>
      <xsl:when test="contains($parts, 'label')">
         <xsl:text>label</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="titletype">
    <xsl:choose>
      <xsl:when test="contains($parts, 'quotedtitle')">
         <xsl:text>quotedtitle</xsl:text>
      </xsl:when>
      <xsl:when test="contains($parts, 'title')">
         <xsl:text>title</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="pagetype">
    <xsl:choose>
      <xsl:when test="$insert.olink.page.number = 'no' and
                      local-name($referrer) = 'olink'">
        <!-- suppress page numbers -->
      </xsl:when>
      <xsl:when test="$insert.xref.page.number = 'no' and
                      local-name($referrer) != 'olink'">
        <!-- suppress page numbers -->
      </xsl:when>
      <xsl:when test="contains($parts, 'nopage')">
         <xsl:text>nopage</xsl:text>
      </xsl:when>
      <xsl:when test="contains($parts, 'pagenumber')">
         <xsl:text>pagenumber</xsl:text>
      </xsl:when>
      <xsl:when test="contains($parts, 'pageabbrev')">
         <xsl:text>pageabbrev</xsl:text>
      </xsl:when>
      <xsl:when test="contains($parts, 'Page')">
         <xsl:text>Page</xsl:text>
      </xsl:when>
      <xsl:when test="contains($parts, 'page')">
         <xsl:text>page</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="docnametype">
    <xsl:choose>
      <xsl:when test="($olink.doctitle = 0 or
                       $olink.doctitle = 'no') and
                      local-name($referrer) = 'olink'">
        <!-- suppress docname -->
      </xsl:when>
      <xsl:when test="contains($parts, 'nodocname')">
         <xsl:text>nodocname</xsl:text>
      </xsl:when>
      <xsl:when test="contains($parts, 'docnamelong')">
         <xsl:text>docnamelong</xsl:text>
      </xsl:when>
      <xsl:when test="contains($parts, 'docname')">
         <xsl:text>docname</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:if test="$labeltype != ''">
    <xsl:choose>
      <xsl:when test="$labeltype = 'labelname'">
        <xsl:call-template name="gentext">
          <xsl:with-param name="key">
            <xsl:choose>
              <xsl:when test="local-name($referrer) = 'olink'">
                <xsl:value-of select="$target.elem"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="local-name(.)"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$labeltype = 'labelnumber'">
        <xsl:text>%n</xsl:text>
      </xsl:when>
      <xsl:when test="$labeltype = 'label'">
        <xsl:call-template name="gentext.template">
          <xsl:with-param name="context" select="'xref-number'"/>
          <xsl:with-param name="name">
            <xsl:choose>
              <xsl:when test="local-name($referrer) = 'olink'">
                <xsl:value-of select="$target.elem"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="xpath.location"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
          <xsl:with-param name="purpose" select="$purpose"/>
          <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
          <xsl:with-param name="referrer" select="$referrer"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>

    <xsl:choose>
      <xsl:when test="$titletype != ''">
        <xsl:value-of select="$xref.label-title.separator"/>
      </xsl:when>
      <xsl:when test="$pagetype != '' and $pagetype != 'nopage'">
        <xsl:value-of select="$xref.label-page.separator"/>
      </xsl:when>
    </xsl:choose>
  </xsl:if>

  <xsl:if test="$titletype != ''">
    <xsl:choose>
      <xsl:when test="$titletype = 'title'">
        <xsl:text>%t</xsl:text>
      </xsl:when>
      <xsl:when test="$titletype = 'quotedtitle'">
        <xsl:call-template name="gentext.dingbat">
          <xsl:with-param name="dingbat" select="'startquote'"/>
        </xsl:call-template>
        <xsl:text>%t</xsl:text>
        <xsl:call-template name="gentext.dingbat">
          <xsl:with-param name="dingbat" select="'endquote'"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>

    <xsl:choose>
      <xsl:when test="$pagetype != '' and $pagetype != 'nopage'">
        <xsl:value-of select="$xref.title-page.separator"/>
      </xsl:when>
    </xsl:choose>
  </xsl:if>
  
  <!-- special case: use regular xref template if just turning off page -->
  <xsl:if test="($pagetype = 'nopage' or $docnametype = 'nodocname')
                  and local-name($referrer) != 'olink'
                  and $labeltype = '' 
                  and $titletype = ''">
    <xsl:apply-templates select="." mode="object.xref.template">
      <xsl:with-param name="purpose" select="$purpose"/>
      <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
      <xsl:with-param name="referrer" select="$referrer"/>
    </xsl:apply-templates>
  </xsl:if>

  <xsl:if test="$pagetype != ''">
    <xsl:choose>
      <xsl:when test="$pagetype = 'page'">
        <xsl:call-template name="gentext.template">
          <xsl:with-param name="context" select="'xref'"/>
          <xsl:with-param name="name" select="'page'"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$pagetype = 'Page'">
        <xsl:call-template name="gentext.template">
          <xsl:with-param name="context" select="'xref'"/>
          <xsl:with-param name="name" select="'Page'"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$pagetype = 'pageabbrev'">
        <xsl:call-template name="gentext.template">
          <xsl:with-param name="context" select="'xref'"/>
          <xsl:with-param name="name" select="'pageabbrev'"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$pagetype = 'pagenumber'">
        <xsl:text>%p</xsl:text>
      </xsl:when>
    </xsl:choose>

  </xsl:if>

  <!-- Add reference to other document title -->
  <xsl:if test="$docnametype != '' and local-name($referrer) = 'olink'">
    <!-- Any separator should be in the gentext template -->
    <xsl:choose>
      <xsl:when test="$docnametype = 'docnamelong'">
        <xsl:call-template name="gentext.template">
          <xsl:with-param name="context" select="'xref'"/>
          <xsl:with-param name="name" select="'docnamelong'"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$docnametype = 'docname'">
        <xsl:call-template name="gentext.template">
          <xsl:with-param name="context" select="'xref'"/>
          <xsl:with-param name="name" select="'docname'"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>

  </xsl:if>
  
</xsl:template>

<!-- DWC: Adding this to remove &#173; from bookmark-labels. Perhaps this should be in the stock xsls -->
<xsl:template match="set|book|part|reference|preface|chapter|appendix|article
                     |glossary|bibliography|index|setindex
                     |refentry|refsynopsisdiv
                     |refsect1|refsect2|refsect3|refsection
                     |sect1|sect2|sect3|sect4|sect5|section"
              mode="xep.outline">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>
  <xsl:variable name="bookmark-label-raw">
    <xsl:apply-templates select="." mode="object.title.markup"/>
  </xsl:variable>
	<xsl:variable name="bookmark-label">
	  <xsl:value-of select="translate($bookmark-label-raw,'&#173;','')"/>
	</xsl:variable>
	
	

  <!-- Put the root element bookmark at the same level as its children -->
  <!-- If the object is a set or book, generate a bookmark for the toc -->

  <xsl:choose>
    <xsl:when test="parent::*">
      <rx:bookmark internal-destination="{$id}">
        <rx:bookmark-label>
          <xsl:value-of select="normalize-space($bookmark-label)"/>
        </rx:bookmark-label>
        <xsl:apply-templates select="*" mode="xep.outline"/>
      </rx:bookmark>
    </xsl:when>
    <xsl:otherwise>
      <xsl:if test="$bookmark-label != ''">
        <rx:bookmark internal-destination="{$id}">
          <rx:bookmark-label>
            <xsl:value-of select="normalize-space($bookmark-label)"/>
          </rx:bookmark-label>
        </rx:bookmark>
      </xsl:if>

      <xsl:variable name="toc.params">
        <xsl:call-template name="find.path.params">
          <xsl:with-param name="table" select="normalize-space($generate.toc)"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="contains($toc.params, 'toc')
                    and set|book|part|reference|section|sect1|refentry
                        |article|bibliography|glossary|chapter
                        |appendix">
        <rx:bookmark internal-destination="toc...{$id}">
          <rx:bookmark-label>
            <xsl:call-template name="gentext">
              <xsl:with-param name="key" select="'TableofContents'"/>
            </xsl:call-template>
          </rx:bookmark-label>
        </rx:bookmark>
      </xsl:if>
      <xsl:apply-templates select="*" mode="xep.outline"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="productname[@role = 'ALU']">
	<fo:inline>
	  <xsl:attribute name="keep-together.within-line">
		<xsl:choose>
		  <xsl:when test="string-length(normalize-space(.)) &gt; 10">auto</xsl:when>
		  <xsl:otherwise>always</xsl:otherwise>
		</xsl:choose>
	  </xsl:attribute>
	  <xsl:apply-templates/>
	</fo:inline>
</xsl:template>

  <!-- From table.xsl: Fix in base xsls? -->
<xsl:template name="calsTable">

  <xsl:variable name="keep.together">
    <xsl:call-template name="dbfo-attribute">
      <xsl:with-param name="pis"
                      select="processing-instruction('dbfo')"/>
      <xsl:with-param name="attribute" select="'keep-together'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:for-each select="tgroup">

    <fo:table xsl:use-attribute-sets="table.table.properties">
      <xsl:if test="$keep.together != ''">
        <xsl:attribute name="keep-together.within-column">
          <xsl:value-of select="$keep.together"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:call-template name="table.frame"/>
      <xsl:if test="following-sibling::tgroup">
        <xsl:attribute name="border-bottom-width">0pt</xsl:attribute>
        <xsl:attribute name="border-bottom-style">none</xsl:attribute>
        <xsl:attribute name="padding-bottom">0pt</xsl:attribute>
        <xsl:attribute name="margin-bottom">0pt</xsl:attribute>
        <xsl:attribute name="space-after">0pt</xsl:attribute>
        <xsl:attribute name="space-after.minimum">0pt</xsl:attribute>
        <xsl:attribute name="space-after.optimum">0pt</xsl:attribute>
        <xsl:attribute name="space-after.maximum">0pt</xsl:attribute>
      </xsl:if>
      <xsl:if test="preceding-sibling::tgroup">
        <xsl:attribute name="border-top-width">0.5pt</xsl:attribute>
        <xsl:attribute name="border-top-style">solid</xsl:attribute>
        <xsl:attribute name="padding-top">0pt</xsl:attribute>
        <xsl:attribute name="margin-top">0pt</xsl:attribute>
        <xsl:attribute name="space-before">0pt</xsl:attribute>
        <xsl:attribute name="space-before.minimum">0pt</xsl:attribute>
        <xsl:attribute name="space-before.optimum">0pt</xsl:attribute>
        <xsl:attribute name="space-before.maximum">0pt</xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="."/>
    </fo:table>
  </xsl:for-each>
</xsl:template>

  <xsl:param name="internal-proprietary">
	<xsl:if test="not($security = 'external') or $nda.footer = 'true'">
	  <fo:block text-align="center" font-size=".75em" font-family="Times" space-before.optimum="0.6em" >
		<fo:block>Alcatel-Lucent &#8212; Internal</fo:block>
		<fo:block>Proprietary &#8212; Use pursuant to Company instruction</fo:block>
	  </fo:block>
	</xsl:if>
  </xsl:param>

<!-- Need to add Alcatel-Lucent proprietary statement below footer table -->
<xsl:template name="footer.table">
  <xsl:param name="pageclass" select="''"/>
  <xsl:param name="sequence" select="''"/>
  <xsl:param name="gentext-key" select="''"/>

  <!-- default is a single table style for all footers -->
  <!-- Customize it for different page classes or sequence location -->

  <xsl:choose>
      <xsl:when test="$pageclass = 'index'">
          <xsl:attribute name="margin-left">0pt</xsl:attribute>
      </xsl:when>
  </xsl:choose>

  <xsl:variable name="column1">
    <xsl:choose>
      <xsl:when test="$double.sided = 0">1</xsl:when>
      <xsl:when test="$sequence = 'first' or $sequence = 'odd'">1</xsl:when>
      <xsl:otherwise>3</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="column3">
    <xsl:choose>
      <xsl:when test="$double.sided = 0">3</xsl:when>
      <xsl:when test="$sequence = 'first' or $sequence = 'odd'">3</xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="candidate">
    <fo:table table-layout="fixed" width="100%">
      <xsl:call-template name="foot.sep.rule">
        <xsl:with-param name="pageclass" select="$pageclass"/>
        <xsl:with-param name="sequence" select="$sequence"/>
        <xsl:with-param name="gentext-key" select="$gentext-key"/>
      </xsl:call-template>
      <fo:table-column column-number="1">
        <xsl:attribute name="column-width">
          <xsl:text>proportional-column-width(</xsl:text>
          <xsl:call-template name="header.footer.width">
            <xsl:with-param name="location">footer</xsl:with-param>
            <xsl:with-param name="position" select="$column1"/>
          </xsl:call-template>
          <xsl:text>)</xsl:text>
        </xsl:attribute>
      </fo:table-column>
      <fo:table-column column-number="2">
        <xsl:attribute name="column-width">
          <xsl:text>proportional-column-width(</xsl:text>
          <xsl:call-template name="header.footer.width">
            <xsl:with-param name="location">footer</xsl:with-param>
            <xsl:with-param name="position" select="2"/>
          </xsl:call-template>
          <xsl:text>)</xsl:text>
        </xsl:attribute>
      </fo:table-column>
      <fo:table-column column-number="3">
        <xsl:attribute name="column-width">
          <xsl:text>proportional-column-width(</xsl:text>
          <xsl:call-template name="header.footer.width">
            <xsl:with-param name="location">footer</xsl:with-param>
            <xsl:with-param name="position" select="$column3"/>
          </xsl:call-template>
          <xsl:text>)</xsl:text>
        </xsl:attribute>
      </fo:table-column>

      <fo:table-body>
        <fo:table-row>
          <xsl:attribute name="block-progression-dimension.minimum">
            <xsl:value-of select="$footer.table.height"/>
          </xsl:attribute>
          <fo:table-cell text-align="left"
                         display-align="after">
            <xsl:if test="$fop.extensions = 0">
              <xsl:attribute name="relative-align">baseline</xsl:attribute>
            </xsl:if>
            <fo:block>
              <xsl:call-template name="footer.content">
                <xsl:with-param name="pageclass" select="$pageclass"/>
                <xsl:with-param name="sequence" select="$sequence"/>
                <xsl:with-param name="position" select="'left'"/>
                <xsl:with-param name="gentext-key" select="$gentext-key"/>
              </xsl:call-template>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell text-align="center"
                         display-align="after">
            <xsl:if test="$fop.extensions = 0">
              <xsl:attribute name="relative-align">baseline</xsl:attribute>
            </xsl:if>
            <fo:block>
              <xsl:call-template name="footer.content">
                <xsl:with-param name="pageclass" select="$pageclass"/>
                <xsl:with-param name="sequence" select="$sequence"/>
                <xsl:with-param name="position" select="'center'"/>
                <xsl:with-param name="gentext-key" select="$gentext-key"/>
              </xsl:call-template>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell text-align="right"
                         display-align="after">
            <xsl:if test="$fop.extensions = 0">
              <xsl:attribute name="relative-align">baseline</xsl:attribute>
            </xsl:if>
            <fo:block>
              <xsl:call-template name="footer.content">
                <xsl:with-param name="pageclass" select="$pageclass"/>
                <xsl:with-param name="sequence" select="$sequence"/>
                <xsl:with-param name="position" select="'right'"/>
                <xsl:with-param name="gentext-key" select="$gentext-key"/>
              </xsl:call-template>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>
  </xsl:variable>

  <!-- Really output a footer? -->
  <xsl:choose>
    <xsl:when test="$pageclass='titlepage' and $gentext-key='book'
                    and $sequence='first'">
      <!-- no, book titlepages have no footers at all -->
    </xsl:when>
    <xsl:when test="$sequence = 'blank' and $footers.on.blank.pages = 0">
      <!-- no output -->
		<xsl:copy-of select="$internal-proprietary"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$candidate"/>
		<xsl:copy-of select="$internal-proprietary"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="glossterm" name="glossterm">
  <xsl:param name="firstterm" select="0"/>

  <xsl:choose>
    <xsl:when test="($firstterm.only.link = 0 or $firstterm = 1) and @linkend">
      <xsl:variable name="targets" select="key('id',@linkend)"/>
      <xsl:variable name="target" select="$targets[1]"/>

      <xsl:choose>
        <xsl:when test="$target">
          <fo:basic-link internal-destination="{@linkend}" ><!-- xsl:use-attribute-sets="xref.properties" DWC: don't make glossterms blue -->
			  <!-- DWC: Don't italicize glossterms -->
            <xsl:call-template name="inline.charseq"/>
          </fo:basic-link>
        </xsl:when>
        <xsl:otherwise>
			  <!-- DWC: Don't italicize glossterms -->
          <xsl:call-template name="inline.charseq"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>

    <xsl:when test="not(@linkend)
                    and ($firstterm.only.link = 0 or $firstterm = 1)
                    and ($glossterm.auto.link != 0)
                    and $glossary.collection != ''">
      <xsl:variable name="term">
        <xsl:choose>
          <xsl:when test="@baseform"><xsl:value-of select="@baseform"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="cterm"
           select="(document($glossary.collection,.)//glossentry[glossterm=$term])[1]"/>

      <xsl:choose>
        <xsl:when test="not($cterm)">
          <xsl:message>
            <xsl:text>There's no entry for </xsl:text>
            <xsl:value-of select="$term"/>
            <xsl:text> in </xsl:text>
            <xsl:value-of select="$glossary.collection"/>
          </xsl:message>
			  <!-- DWC: Don't italicize glossterms -->
          <xsl:call-template name="inline.charseq"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="id">
            <xsl:call-template name="object.id">
              <xsl:with-param name="object" select="$cterm"/>
            </xsl:call-template>
          </xsl:variable>
          <fo:basic-link internal-destination="{$id}"
                         xsl:use-attribute-sets="xref.properties">
			  <!-- DWC: Don't italicize glossterms -->
            <xsl:call-template name="inline.charseq"/>
          </fo:basic-link>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>

    <xsl:when test="not(@linkend)
                    and ($firstterm.only.link = 0 or $firstterm = 1)
                    and $glossterm.auto.link != 0">
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

      <xsl:variable name="targets"
                    select="//glossentry[glossterm=$term or glossterm/@baseform=$term]"/>

      <xsl:variable name="target" select="$targets[1]"/>

      <xsl:choose>
        <xsl:when test="count($targets)=0">
          <xsl:message>
            <xsl:text>Error: no glossentry for glossterm: </xsl:text>
            <xsl:value-of select="."/>
            <xsl:text>.</xsl:text>
          </xsl:message>
          <xsl:call-template name="inline.italicseq"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="termid">
            <xsl:call-template name="object.id">
              <xsl:with-param name="object" select="$target"/>
            </xsl:call-template>
          </xsl:variable>

          <fo:basic-link internal-destination="{$termid}"
                         xsl:use-attribute-sets="xref.properties">
            <xsl:call-template name="inline.charseq"/>
          </fo:basic-link>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="inline.italicseq"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="property">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>


</xsl:stylesheet>
