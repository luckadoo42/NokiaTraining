<?xml version ="1.0"?>

<!--
  This stylesheet pulls in all <glossentry>s which are referenced, directly or
  indirectly, from <glossterm>s outside of their ancestor <glossary>.
  (Indirectly referenced <glossentry>s are those which are referenced by a chain
  of other <glossentry>s (via their <glossterm>, <glosssee>, or <glossseealso>
  children), the head of which is directly referenced.)  Those <glossentry>s
  which are not referenced from without the <glossary> are not written to the
  output.
  
  This transformation was previously accomplished with three separate
  transformations, called "weed," "sort" and "unique."  This one reduces the
  aggregate time needed to run those three by about 36%.
  
  Notice that any output to STDOUT may be interpreted by Powderkeg Perl scripts
  as a failure of the transformation; hence the 'DEBUG' <xsl:message>s below
  have been commented out.
  
  Informal Change History
  =======================
  
  Wed Jan  9 11:29:16  2002
  
  Added non-fatal whining  (subject to ``quiet'' global parameter setting) when
  a glossentry with a ``role="deprecated"'' attribute is written.
  
-->

<xsl:stylesheet exclude-result-prefixes="db" version="2.0" xmlns:db="http://docbook.org/ns/docbook"
  xmlns="http://docbook.org/ns/docbook" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:key name="outsideGlossaryGlossterms" match="//db:glossterm[not(ancestor::db:glossary)]"
    use="@linkend"/>

  <xsl:param name="quiet" select="0"/>

  <!-- adding for nokia branding, JCBG-1780 -->
  <xsl:param name="branding"/>

  <!-- adding these for JCBG-1587 to control whether detected bad olinks cause fails -->
  <xsl:param name="fail.on.bad.olink"/>
  <xsl:param name="olink.debug"/>
  <xsl:param name="current.docid"/>

  <xsl:param name="trademark.symbols">every</xsl:param>
  <!-- added for JCBG-852-->
  <!-- blockelements var added for JCBG-852; 
  note that this var needs to list every element that should be treated as a boundary for first-in-topic
  
  Bug JCBG-1482: since we're searching through BLOCKELEMENTS using contains(), you get a false positive on any element whose name
  is a perfect substring of some other element. It so happens that such a case exists, with 'refentry' and 'entry';
  the result is, a table's 'entry' elements become boundaries... any entry element restarts the 'first in topic' counting.
  
  kludge fix for that: i'm changing 'refentry' below to refextry, temporarily. That means refentry elements won't be boundaries. But,I don't 
  think we use those much/ever. I'll fix it for reals later. 
  
  A real fix should change the expressions that look inside BLOCKELEMENTS so that they look for not just contains-a-string, but add delimters 
  around the string. For ex, could change the content below to /section/chapter/preface... and then look for /section/, to prevent this.
  Or any method that doesn't allow a perfect substring to sneak through. 
  
  -Aaron DaMommio, 6/4/14
  
  -->
  <xsl:variable name="BLOCKELEMENTS">section chapter preface glossary appendix part division
    reference refextry bibliography sect1 sect2 sect3 sect4 sect 5 glossdiv bibliodiv
    indexdiv</xsl:variable>
  <xsl:param name="module.dir"/>
  <xsl:param name="staging.doc.dir"/>



  <xsl:param name="language"/>

  <!-- If recurse.on.glossary != 0 => put glossterms that
    occur in glossdefs in glossary -->
  <xsl:param name="recurse.on.glossary" select="'1'"/>

  <!--
    This is a list of all <glossentry>s directly referenced from without the
    glossary, with all duplicates eliminated.  It has a trailing space but no
    leading space, which is useful for recursive list-walking.  The space
    character is a good ``list'' delimiter because we're guaranteed that it
    will not appear in an attribute value.
  -->
  <xsl:variable name="allDirectlyReferencedGlossentries">
    <!--
      Apply the "Muench Method" (after Oracle XML guy Steve Muench; see pp
      144-145 of Doug Tidwell's _XSLT_ ((c) 2001 O'Reilly).
      
      Okay, let's restate what is said there about this arcanum.  We are
      selecting the set of <glossterm>s which do not descend from a <glossary>
      and for which the *unique id* of each <glossterm> is the same as the
      *unique id* of the first (in input document order) <glossterm> of that
      other set (returned by key()) of <glossterm>s that all have the same
      value for their linkend attributes.
      
      Notice that when given a node set, the generate-id() function returns
      the unique id for the first node in that set, making the ``[1]''
      predicate applied to the result of the key() function on p 144 of
      Tidwell redundant.
      
      DWC: Replacing Muench stuff with the XSLT 2.0 version.
    -->
    <xsl:text> </xsl:text>
    <xsl:for-each-group select="//db:glossterm[not(ancestor::db:glossary)]" group-by="@linkend">
      <xsl:sort select="current-grouping-key()"/>
      <xsl:value-of select="current-grouping-key()"/>
      <xsl:text> </xsl:text>
    </xsl:for-each-group>
    <xsl:text> </xsl:text>
  </xsl:variable>

  <!--
    This is a list of all <glossentry>s which are only indirectly referenced
    from without the glossary.  It has *both* a leading and a trailing space,
    making it useful for comparisons using the contains() function.
    Generation of this list probably eats most of the time required for this
    transformation.
  -->
  <xsl:variable name="allIndirectlyReferencedGlossentries">
    <xsl:call-template name="genAllIndirectlyReferencedGlossentries">
      <xsl:with-param name="sources" select="$allDirectlyReferencedGlossentries"/>
      <xsl:with-param name="targets" select="''"/>
    </xsl:call-template>
  </xsl:variable>


  <xsl:template match="db:book">

    <xsl:message> ================================= Directly referenced glossterms: "<xsl:copy-of
        select="$allDirectlyReferencedGlossentries"/>" ================================= <xsl:if
        test="not($recurse.on.glossary = '0')"> Indirectly referenced glossterms: "<xsl:copy-of
          select="$allIndirectlyReferencedGlossentries"/>" =================================
      </xsl:if>
    </xsl:message>

    <xsl:if test="not($recurse.on.glossary = '0')">
      <xsl:result-document href="file:///{$staging.doc.dir}/_indirectly-referenced-glossentries.xml">
        <xsl:element name="property" namespace="">
          <xsl:attribute name="name">glossary.exclusions</xsl:attribute>
          <xsl:attribute name="value">
            <xsl:value-of select="normalize-space($allIndirectlyReferencedGlossentries)"/>
          </xsl:attribute>
        </xsl:element>
      </xsl:result-document>
    </xsl:if>

    <!-- Ensure that there's only one glossary in the document. -->
    <xsl:if test="count(//db:glossary) > 1">
      <xsl:message terminate="yes"> This XSLT stylesheet supports only one glossary element.
      </xsl:message>
    </xsl:if>

    <!-- previous apply ...can delete once jcbg-852 chgs are done and working
  <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>  -->

    <!-- Adding modes: two passes, for JCBG-852 re: trademark automation here -->

    <xsl:variable name="pass1">
      <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
    </xsl:variable>

    <xsl:apply-templates select="$pass1" mode="pass2"/>

  </xsl:template>


  <xsl:template match="db:glossary">
    <xsl:variable name="lang">
      <xsl:choose>
        <xsl:when test="ancestor-or-self::*[@xml:lang]">
          <xsl:value-of select="ancestor-or-self::*[@xml:lang][1]/@xml:lang"/>
        </xsl:when>
        <xsl:when test="not($language = '')">
          <xsl:value-of select="$language"/>
        </xsl:when>
        <xsl:otherwise>en</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:for-each select=".//db:glossentry">
        <!--
          Do not be confused by the fact that each <glossentry> begins with a
          <glossterm> which does not have a linkend attribute, and that we're
          sorting on this <glossterm>.  Any <glossterm> in a <glossentry> that
          links the latter to a another <glossentry> appears after the
          initial, linkend-less <glossterm>.
          
          We could eliminate "bad" sort orders caused by spurious whitespace
          by wrapping glossterm in a normalize-space() in the select=, below.
          
          {translate(ancestor::*/@lang,'_','')}
        -->
        <xsl:sort lang="{$language}"
          select="normalize-space(concat(@sortas, self::*[not(@sortas)]/db:glossterm))"/>
        <!--
          We wrap the @id attribute value in whitespaces to prevent false
          matches (e.g. "bar.glossary" incorrectly matching
          "foobar.glossary").  This is why the
          allIndirectlyReferencedGlossentries has to have a leading and a
          trailing space char.
        -->
        <xsl:if
          test="key('outsideGlossaryGlossterms', @xml:id) or
          contains($allIndirectlyReferencedGlossentries,
          concat(' ', @xml:id, ' '))">
          <!--
            Whine if the glossentry we're about to write out has
            role="deprecated" and if we're not quelling such whining.
          -->
          <xsl:if test="($quiet = 0) and @role = 'deprecated'">
            <xsl:message>
              <xsl:text>GLOSSIFY WARNING: glossary entry </xsl:text>
              <xsl:text disable-output-escaping="yes">&lt;</xsl:text>
              <xsl:text>glossentry xml:id="</xsl:text>
              <xsl:value-of select="@xml:id"/>
              <xsl:text>" role="deprecated"</xsl:text>
              <xsl:text disable-output-escaping="yes">&gt; </xsl:text>
              <xsl:text>is deprecated yet referenced by this </xsl:text>
              <xsl:text>document.</xsl:text>
            </xsl:message>
          </xsl:if>
          <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
          </xsl:copy>
        </xsl:if>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="db:glossterm[not(parent::db:glossentry)]|db:glossseealso">
    <xsl:choose>
      <xsl:when
        test="
        (self::db:glossterm and @linkend and not(@linkend ='') and contains($allDirectlyReferencedGlossentries,concat(' ',@linkend,' '))) or 
        (self::db:glossterm and @linkend and not(@linkend ='') and contains($allIndirectlyReferencedGlossentries,concat(' ',@linkend,' ')) and not($recurse.on.glossary = '0')) or   
        (self::db:glossseealso and @otherterm and not(@otherterm = '') and contains($allDirectlyReferencedGlossentries,concat(' ',@otherterm,' '))) or 
        (self::db:glossseealso and @otherterm and not(@otherterm = '') and not($recurse.on.glossary = '0'))
        ">
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </xsl:when>
      <xsl:when test="self::db:glossseealso"/>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="genAllIndirectlyReferencedGlossentries">
    <xsl:param name="sources"/>
    <xsl:param name="targets"/>

    <xsl:choose>
      <xsl:when test="$sources=''">
        <xsl:value-of select="$targets"/>
      </xsl:when>
      <xsl:otherwise>
        <!--
          I don't know why we're getting a leading space out of this, but the
          code below (viz., the recursive call) now depends on it.  Exercise
          caution wrt to these leading and trailing space chars should you
          mess with this code.
          
          UPDATE (Thu Apr 18 18:57:58  2002)
          Hmm, now it seems that we're intermittently getting the leading
          whitespace.  Looks like it's time to just hammer it with a
          conditional and normalize_space() (i.e., "cleanSourceReferents").
        -->
        <xsl:variable name="sourceReferents">
          <xsl:for-each select="//db:glossentry[@xml:id=substring-before($sources, ' ')]">
            <xsl:for-each select=".//db:glossterm | .//db:glosssee | .//db:glossseealso">
              <xsl:choose>
                <xsl:when test="name(.)='glossterm'">
                  <xsl:if
                    test="
                    $recurse.on.glossary != '0'
                    and
                    not(key('outsideGlossaryGlossterms', @linkend))
                    and
                    not(contains($targets, concat(' ', @linkend, ' ')))">
                    <xsl:value-of select="@linkend"/>
                    <xsl:text> </xsl:text>
                  </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:if
                    test="not(key('outsideGlossaryGlossterms', @otherterm))
                    and
                    not(contains($targets, concat(' ', @otherterm, ' ')))">
                    <xsl:value-of select="@otherterm"/>
                    <xsl:text> </xsl:text>
                  </xsl:if>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
          </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="cleanSourceReferents">
          <xsl:if test="normalize-space($sourceReferents)">
            <xsl:value-of select="concat(' ', normalize-space($sourceReferents), ' ')"/>
          </xsl:if>
        </xsl:variable>
        <!-- DEBUG -->
        <!--        <xsl:message>genAllIndirectlyReferencedGlossentries: $sources="<xsl:value-of select="$sources"/>", $targets="<xsl:value-of select="$targets"/>".</xsl:message> -->
        <!--            <xsl:message>                                        $sourceReferents="<xsl:value-of select="$sourceReferents"/>".</xsl:message> -->
        <!--            <xsl:message>                                        $cleanSourceReferents="<xsl:value-of select="$cleanSourceReferents"/>".</xsl:message> -->
        <!-- GUBED -->
        <xsl:call-template name="genAllIndirectlyReferencedGlossentries">
          <xsl:with-param name="sources"
            select="concat(substring-after($cleanSourceReferents, ' '),
            substring-after($sources, ' '))"/>
          <xsl:with-param name="targets"
            select="concat(' ', normalize-space(concat($sourceReferents,
            $targets)), ' ')"
          />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- =================================================================================
  pass2 templates: these templates are all used only in the second pass of this xsl 

this pass added for JCBG-852, to implement trademark automation, so that the templates can apply to post-glossified content.

==========
-->

  <!-- basic copy-everything for pass 2 -->
  <xsl:template match="@*|node()" mode="pass2">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="pass2"/>
    </xsl:copy>
  </xsl:template>

  <!-- JCBG-1587, catch olinks that have security mismatch problems -->

  <xsl:template match="db:olink" mode="pass2">
    <!-- define some vars = security values of the link and its target -->
    <xsl:variable name="LINKSEC" select="ancestor-or-self::*[@security][1]/@security"/>
    <!-- security of this link-->
    <xsl:variable name="TARGETSEC"
      select="document('../../../../olink.db')//*[@targetdoc = current()/@targetdoc]//*[@targetptr=current()/@targetptr]/@data-security"/>
    <!-- security of the target; because the value we put in
		the olink.db already reflects looking back up the ancestor access, we don't have to do that here -->

    <xsl:if test="$olink.debug = '1'">
      <!-- emit debug info for every olink, but only if olink.debug=1 -->
      <xsl:message>OLINK:td=<xsl:value-of select="@targetdoc"/>, tp=<xsl:value-of
          select="@targetptr"/>, LS=<xsl:value-of select="$LINKSEC"/>, TS=<xsl:value-of
          select="$TARGETSEC"/></xsl:message>
    </xsl:if>

    <!-- here's where we verify that the olink can reach its target b/c of security-->
    <xsl:choose>
      <!-- First we must eliminate cases where the target doesn't exist, because those return weird TARGETSEC values of null that don't match a LINKSEC of "" -->

      <!-- first check the targetdoc -->
      <xsl:when test="not(document('../../../../olink.db')//*[@targetdoc = current()/@targetdoc])">
        <xsl:copy-of select="."/>
        <!-- the value of $fail.on.bad.olink is yes or no, so we can use it as the value of @terminate to control whether bad links fail the build -->
        <xsl:message terminate="{$fail.on.bad.olink}">***ERROR: BAD OLINK: targetdoc value
            '<xsl:value-of select="@targetdoc"/>' does not exist in
          olink.db.<xsl:text>
</xsl:text>Olink is in document <xsl:value-of select="$current.docid"
          />, source file <xsl:value-of select="ancestor-or-self::*[@xml:base][1]/@xml:base"/>,
          topic "<xsl:value-of select="ancestor-or-self::*[db:title][1]/db:title"/>"; it links to
            <xsl:value-of select="@targetdoc"/>/ targetptr=<xsl:value-of select="@targetptr"
          />.<xsl:text>
</xsl:text></xsl:message>
      </xsl:when>

      <!-- next check targetptr -->
      <xsl:when
        test="not(document('../../../../olink.db')//*[@targetdoc = current()/@targetdoc]//*[@targetptr=current()/@targetptr])">
        <xsl:copy-of select="."/>
        <!-- the value of $fail.on.bad.olink is yes or no, so we can use it as the value of @terminate to control whether bad links fail the build -->
        <xsl:message terminate="{$fail.on.bad.olink}">***ERROR: BAD OLINK: targetptr value
            '<xsl:value-of select="@targetptr"/>' does not exist in the document <xsl:value-of
            select="@targetdoc"/>.<xsl:text>
</xsl:text>Olink is in document <xsl:value-of
            select="$current.docid"/>, source file <xsl:value-of
            select="ancestor-or-self::*[@xml:base][1]/@xml:base"/>, topic "<xsl:value-of
            select="ancestor-or-self::*[db:title][1]/db:title"/>"; it links to <xsl:value-of
            select="@targetdoc"/>/ targetptr=<xsl:value-of select="@targetptr"
          />.<xsl:text>
</xsl:text></xsl:message>
      </xsl:when>

      <!-- then check all the success cases and in each case, copy the node out -->
      <!--   <xsl:when test="$LINKSEC = 'writeronly'"><xsl:copy-of select="."/></xsl:when>
         ... I THOUGHT writeronly builds included internal, external, and reviewer output but they DO NOT -->
      <xsl:when test="$LINKSEC = normalize-space($TARGETSEC)">
        <xsl:copy-of select="."/>
      </xsl:when>
      <!-- same security always works -->
      <xsl:when test="normalize-space($TARGETSEC) = ''">
        <xsl:copy-of select="."/>
      </xsl:when>
      <!-- if target has no security, it will definitely be there, so it'll def work no matter what the link's security -->
      <!-- now 2 special cases for reviewer, which includes internal, external text... -->
      <xsl:when test="$LINKSEC = 'reviewer' and $TARGETSEC = 'internal'">
        <xsl:copy-of select="."/>
      </xsl:when>
      <xsl:when test="$LINKSEC = 'reviewer' and $TARGETSEC = 'external'">
        <xsl:copy-of select="."/>
      </xsl:when>

      <!-- anything that didn't match above cases gets a fail for security reasons-->
      <xsl:otherwise>
        <xsl:copy-of select="."/> [??? error bad link] <!-- go ahead and write out the olink so we can see it if we are letting the document build via fail.on.bad.olink=no; 
          but also include the ??? for user info and searchability-->
        <!-- the value of $fail.on.bad.olink is yes or no, so we can use it as the value of @terminate to control whether bad links fail the build -->
        <xsl:message terminate="{$fail.on.bad.olink}"><xsl:text>
</xsl:text>***ERROR: BAD OLINK
          found: Olink will not work in one of the security outputs because
          of<xsl:text>
</xsl:text>incompatible security levels (link is in security='<xsl:value-of
            select="$LINKSEC"/>' and target is in '<xsl:value-of select="$TARGETSEC"/>'
          text).<xsl:text>
</xsl:text>Olink is in document <xsl:value-of select="$current.docid"/>,
          source file <xsl:value-of select="ancestor-or-self::*[@xml:base][1]/@xml:base"/>, topic
            "<xsl:value-of select="ancestor-or-self::*[db:title][1]/db:title"/>"; it links to
            <xsl:value-of select="@targetdoc"/>/ targetptr=<xsl:value-of select="@targetptr"
          />.<xsl:text>
</xsl:text> TO FIX: change the security of either the element containing the
          olink, or the target, so that there is no case where an output could have a link but no
          target. <xsl:text>
</xsl:text><xsl:if test="$fail.on.bad.olink = 'yes'"> To locate
            multiple bad links of this nature in one build, set the build property fail.on.bad.olink
            to 'no' and search the build log for BAD OLINK. After fixing the bad olinks, change
            fail.on.bad.olink to 'yes' so that future errors fail the build.
          </xsl:if><xsl:text>
  
</xsl:text>
        </xsl:message></xsl:otherwise>
    </xsl:choose>

  </xsl:template>

<!-- JCBG-1924, display add'l info for glossterms -->
  <xsl:template match="db:glossentry/db:glossterm" mode="pass2">
    <db:glossterm><xsl:copy-of select="child::node()"/><xsl:text> </xsl:text><db:remark>[<xsl:value-of select="../@xml:base"/>#<xsl:value-of select="../@xml:id"/>]</db:remark>
    </db:glossterm>

  </xsl:template>

  <!-- JCBG-852, trademark automation -->

  <xsl:template match="db:trademark[not(@class)]" mode="pass2">
    <!-- the not @class means we don't change any class you already applied; this
         allows you to manually mark something -->
    <xsl:variable name="term">
      <xsl:value-of select="normalize-space(.)"/>
    </xsl:variable>
    <xsl:variable name="symbol">
      <xsl:copy-of
        select="document('../../../SharedContent/en_US/legal/trademarks.xml')//db:formalpara[normalize-space(db:title) = $term]/db:para[1]"
      />
    </xsl:variable>

    <!-- If term does not exist, output a warning. If no term, $symbol="" -->
    <xsl:if test="$symbol=''">
      <xsl:message> WARNING: No data found in
        target/doctools/SharedContent/en_US/legal/trademarks.xml file for term _<xsl:value-of
          select="$term"/>_. </xsl:message>
    </xsl:if>

    <!-- If term DOES exist, output some logging text -->
    <xsl:if test="not($symbol='')">
      <xsl:message>Found trademark phrase = _<xsl:value-of select="."/>_ and symbol <xsl:value-of
          select="$symbol"/></xsl:message>
      <xsl:message>....matching legal text entry in trademarks list, = _<xsl:value-of
          select="document('../../../SharedContent/en_US/legal/trademarks.xml')//db:formalpara[normalize-space(db:title) = $term]/db:para[2]"
        />_</xsl:message>
      <xsl:message> </xsl:message>
    </xsl:if>
    <!-- <message>
      ... value-of select="document('../../../SharedContent/en_US/legal/trademarks.xml')//db:formalpara[db:title = .]/db:para[2]" is <xsl:value-of select="document('../../../SharedContent/en_US/legal/trademarks.xml')//db:formalpara[db:title = .]/db:para[2]"/>
      *** works***	... value-of select="document('../../../SharedContent/en_US/legal/trademarks.xml')//db:formalpara[db:title = $term]/db:para[2]" is <xsl:value-of select="document('../../../SharedContent/en_US/legal/trademarks.xml')//db:formalpara[db:title = $term]/db:para[2]"/>
      ... value-of select="document('../../../SharedContent/en_US/legal/trademarks.xml')//db:formalpara[. =db:title]/db:para[2]" is <xsl:value-of select="document('../../../SharedContent/en_US/legal/trademarks.xml')//db:formalpara[. = db:title]/db:para[2]"/>
      ... value-of select="document('../../../SharedContent/en_US/legal/trademarks.xml')//db:formalpara[string(db:title) = $term]/db:para[2]" is <xsl:value-of select="document('../../../SharedContent/en_US/legal/trademarks.xml')//db:formalpara[string(db:title) = $term]/db:para[2]"/>
      
      </xsl:message> -->



    <!-- code for outputting appropriate trademark symbols, for trademark.symbols options none, every, first, topic -->


    <xsl:choose>
      <xsl:when test="($trademark.symbols = 'none') or (trademark.symbols ='') or ($symbol = '')">
        <!-- when property is none, or if there IS NO symbol defined for this term, we want to strip off the trademark
        but, in case it had attributes we want to preserve, we convert it to a phrase: -->
        <phrase>
          <xsl:apply-templates select="@*|node()" mode="pass2"/>
        </phrase>
      </xsl:when>
      <xsl:when test="$trademark.symbols = 'every'">
        <xsl:copy>
          <xsl:attribute name="class">
            <xsl:value-of select="$symbol"/>
          </xsl:attribute>
          <xsl:attribute name="revisionflag">added</xsl:attribute>
          <xsl:apply-templates select="@*|node()" mode="pass2"/>
        </xsl:copy>


      </xsl:when>
      <xsl:when test="$trademark.symbols = 'first'">
        <!-- show symbol only on FIRST occurrence in the book -->

        <!-- 
          we know that this works as test for 1st: 
        -->
        <!-- Two cases here: if current element IS first occurrence, then we want to output tm; if not, we want to WRAP IT IN A
          PHRASE... -->
        <xsl:choose>
          <xsl:when
            test="count(preceding::*[local-name(.)='trademark'][normalize-space(.) = $term]) = 0">
            <xsl:copy>
              <xsl:attribute name="class">
                <xsl:value-of select="$symbol"/>
              </xsl:attribute>
              <xsl:attribute name="revisionflag">added</xsl:attribute>
              <xsl:apply-templates select="@*|node()" mode="pass2"/>
            </xsl:copy>
          </xsl:when>
          <xsl:otherwise>
            <!-- if it's not first, then make a phrase and copy down @ and text nodes -->
            <phrase>
              <xsl:apply-templates select="@*|node()" mode="pass2"/>
            </phrase>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$trademark.symbols = 'topic'">
        <!-- show symbol only on FIRST occurrence in the TOPIC 
        For JCBG-1290, removed some xsl:text elements inside here that were holdovers from testing, that were causing 
        extra line space, which was only visible when text was directly adjacent to the trademark element.
        -->
        <xsl:choose>
          <!-- when not true that the immediately preceding trademark is a child of the same block ancestor...-->
          <xsl:when
            test="not((preceding::*[self::db:trademark and normalize-space(.) = $term][1])[(ancestor::*[contains($BLOCKELEMENTS, local-name(.))][1]) = (current()/ancestor::*[contains($BLOCKELEMENTS, local-name(.))][1])])">
            <xsl:copy>
              <xsl:attribute name="class">
                <xsl:value-of select="$symbol"/>
              </xsl:attribute>
              <xsl:attribute name="role">first-in-topic</xsl:attribute>
              <xsl:apply-templates select="@*|node()" mode="pass2"/>
            </xsl:copy>
          </xsl:when>
          <xsl:otherwise>
            <!-- if it's not first in topic, then make a phrase and copy down @ and text nodes -->
            <phrase>
              <xsl:apply-templates select="@*|node()" mode="pass2"/>
            </phrase>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>



  </xsl:template>


  <!-- Legalnotice PI that auto generates all the legal text,  <?auto-legalnotice?> -->


  <!-- Handling 2 cases with one template: 
  1. <?auto-legalnotice?> in the info element, all by itself
  2. <legalnotice><?auto-legalnotice?> And some text </legalnotice>
  
  In the first case, the current element has no content, so in both cases we write out the current content.
  It's just that in the first case, that's nothing, so in the first case, you get all text generated by the script, but in the 
  second you get any text in your legalnotice merged inside the rest. 
  
  -->

  <!-- additional complication 12/14/15: nokia branding to use its own legal statement-->




  <xsl:template
    match="db:info/processing-instruction('auto-legalnotice') | db:legalnotice[processing-instruction('auto-legalnotice')]"
    mode="pass2">
    <legalnotice>
      <xsl:choose>
        <!-- added for nokia branding  ...now this template has 2 paths, one for nokia, one for all others, and they use different legal notice source files-->
        <xsl:when test="substring($branding,1,5) = 'nokia'">

          <!-- first output the legalnotice title -->
          <xsl:copy-of
            select="document('../../../SharedContent/en_US/legal/nokia_notice.xml')/db:legalnotice/db:para[1]"/>

          <para>
            <!-- then the first phrase-->
            <xsl:copy-of
              select="document('../../../SharedContent/en_US/legal/nokia_notice.xml')/db:legalnotice//db:phrase[1]"/>

            <xsl:text> </xsl:text>
            <!-- inserts a space -->

            <!-- now write out any custom text inside the original legalnotice element,which could be inside any number of paras. 
      note that if we are reacting to our first match pattern, the bare PI inside an info element, then the below expression produces no output,
which in that case, is what we want.      -->
            <phrase role="custom-legal-text">
              <xsl:apply-templates select="./db:para/node()" mode="pass2"/>
            </phrase>
            <xsl:text> </xsl:text>
            <!-- inserts a space -->

<!-- Sep 2019: Karen Young email says trademarks list is not needed given the blanket statement in the new legal text.
            <phrase role="generated-legal-text">
              <xsl:apply-templates select="//db:trademark" mode="pass3"/>
            </phrase>
-->
          </para>

          <para><xsl:copy-of select="document('../../../SharedContent/en_US/legal/nokia_notice.xml')/db:legalnotice//db:phrase[2]"/></para>
	  <para><xsl:copy-of select="document('../../../SharedContent/en_US/legal/nokia_notice.xml')/db:legalnotice//db:phrase[3]"/></para>
          <para><xsl:copy-of select="document('../../../SharedContent/en_US/legal/nokia_notice.xml')/db:legalnotice//db:phrase[4]"/></para>
          <para><xsl:copy-of select="document('../../../SharedContent/en_US/legal/nokia_notice.xml')/db:legalnotice//db:phrase[5]"/></para>
	  <para><xsl:copy-of select="document('../../../SharedContent/en_US/legal/nokia_notice.xml')/db:legalnotice//db:phrase[6]"/></para>
          <para><xsl:copy-of select="document('../../../SharedContent/en_US/legal/nokia_notice.xml')/db:legalnotice//db:phrase[7]"/></para>
	  <para><xsl:copy-of select="document('../../../SharedContent/en_US/legal/nokia_notice.xml')/db:legalnotice//db:phrase[8]"/></para>
	  <important><title><xsl:copy-of select="document('../../../SharedContent/en_US/legal/nokia_notice.xml')/db:legalnotice//db:phrase[9]"/></title>
                  <para><xsl:copy-of select="document('../../../SharedContent/en_US/legal/nokia_notice.xml')/db:legalnotice//db:phrase[10]"/></para>
	          <para><xsl:copy-of select="document('../../../SharedContent/en_US/legal/nokia_notice.xml')/db:legalnotice//db:phrase[11]"/></para>
	  	  <para><xsl:copy-of select="document('../../../SharedContent/en_US/legal/nokia_notice.xml')/db:legalnotice//db:phrase[12]"/></para>
	  </important>
	  <para><xsl:copy-of select="document('../../../SharedContent/en_US/legal/nokia_notice.xml')/db:legalnotice//db:phrase[13]"/></para>
	  <para><xsl:copy-of select="document('../../../SharedContent/en_US/legal/nokia_notice.xml')/db:legalnotice//db:phrase[14]"/></para>


        </xsl:when>
        <xsl:otherwise>
          <!-- otherwise just use the normal notice file -->

          <!-- first output the legalnotice title -->
          <xsl:copy-of
            select="document('../../../SharedContent/en_US/legal/important_notice.xml')/db:legalnotice/db:para[1]"/>

          <para>
            <!-- then the first phrase-->
            <xsl:copy-of
              select="document('../../../SharedContent/en_US/legal/important_notice.xml')/db:legalnotice//db:phrase[1]"/>

            <xsl:text> </xsl:text>
            <!-- inserts a space -->

            <!-- now write out any custom text inside the original legalnotice element, 
          which could be inside any number of paras. 
      note that if we are reacting to our first match pattern, the bare PI inside an info element, then the below expression produces no output,
which in that case, is what we want      
      -->
            <phrase role="custom-legal-text">
              <xsl:apply-templates select="./db:para/node()" mode="pass2"/>
            </phrase>
            <xsl:text> </xsl:text>
            <!-- inserts a space -->


<!-- Sep 2019: Karen Young email says trademarks list is not needed given the blanket statement in the new legal text.
            <phrase role="generated-legal-text">
              <xsl:apply-templates select="//db:trademark" mode="pass3"/>
            </phrase>
-->

            <xsl:text> </xsl:text>
            <!-- inserts a space -->
            <!-- then the second phrase-->
            <xsl:copy-of
              select="document('../../../SharedContent/en_US/legal/important_notice.xml')/db:legalnotice//db:phrase[2]"/>

          </para>
        </xsl:otherwise>
      </xsl:choose>

      <!-- JCBG-1832: Add timestamp to HTML / PDF output-->
      <para><xsl:value-of select="current-dateTime()" /></para>


    </legalnotice>

  </xsl:template>

  <xsl:template match="db:trademark" mode="pass3">
    <!-- I'm not using the [not(@class)] here because by this time we've added @class to all trademarks -->
    <!-- this template finds the legal text for each trademark -->
    <xsl:variable name="term">
      <xsl:value-of select="normalize-space(.)"/>
    </xsl:variable>
    <xsl:variable name="symbol">
      <!-- here we're just using this as a quick way to check if the term exists in the db -->
      <xsl:copy-of
        select="document('../../../SharedContent/en_US/legal/trademarks.xml')//db:formalpara[normalize-space(db:title) = $term]/db:para[1]"
      />
    </xsl:variable>

    <!-- If term does not exist, output a warning. If no term, $symbol="" -->
    <xsl:if test="$symbol=''">
      <xsl:message> WARNING: No data found in
        target/doctools/SharedContent/en_US/legal/trademarks.xml file for term _<xsl:value-of
          select="$term"/>_ when generating legal text. </xsl:message>
    </xsl:if>

    <!-- If term DOES exist, AND it's the first case in the book, output the legal text for this trademark term -->
    <xsl:if
      test="not($symbol='') and (count(preceding::*[local-name(.)='trademark'][normalize-space(.) = $term]) = 0)">
      <xsl:copy-of
        select="document('../../../SharedContent/en_US/legal/trademarks.xml')//db:formalpara[normalize-space(db:title) = $term]/db:para[2]/node()"/>
      <xsl:text> </xsl:text>
      <!-- adding a space after each item -->
    </xsl:if>


  </xsl:template>


</xsl:stylesheet>
