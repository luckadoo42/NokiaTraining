<?xml version ="1.0"?>
<!DOCTYPE stylesheet>

<!-- 
  $Id: dedupids.xsl,v 1.6 2010/01/25 23:01:20 dcramer Exp $
  
  Copyright
  =========
  Copyright (C) 2001-2010 Motive/Alcatel-Lucent. 
  
  Permission is hereby granted, free of charge, to any person
  obtaining a copy of this software and associated documentation
  files (the ``Software''), to deal in the Software without
  restriction, including without limitation the rights to use,
  copy, modify, merge, publish, distribute, sublicense, and/or
  sell copies of the Software, and to permit persons to whom the
  Software is furnished to do so, subject to the following
  conditions:
  
  The above copyright notice and this permission notice shall be
  included in all copies or substantial portions of the Software.
  
  Except as contained in this notice, the names of individuals
  and companies credited with contribution to this software
  shall not be used in advertising or otherwise to promote the
  sale, use or other dealings in this Software without prior
  written authorization from the individuals in question.
  
  Any stylesheet derived from this Software that is publically
  distributed will be identified with a different name and the
  version strings in any derived Software will be changed so that
  no possibility of confusion between the derived package and this
  Software will exist.
  
  Warranty
  ========
  
  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
  NONINFRINGEMENT.  IN NO EVENT SHALL NORMAN WALSH OR ANY OTHER
  CONTRIBUTOR BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
  OTHER DEALINGS IN THE SOFTWARE.
  
  This stylesheet is maintained by James Miller
  <jmiller@broadjump.com> and David Cramer,
  <dcramer@broadjump.com>.
  
  
  Overview
  ========
  
  dedupids.xsl is run over the result of the output of holmanize.xsl to remove
  duplicate id attributes from elements introduced by holmanization.  It depends
  on holmanize.xsl having recursively left ``is_holmanized="true"'' attribute
  values on all shared elements.  It will leave genuinely duplicate id
  attributes appearing in the original, pre-holmanized document as is, but will
  erroneously remove genuinely duplicate ids appearing in shared content.  In
  other words, if the output of dedupids.xsl is validated, duplicate ids which
  appeared in the original input document will still be detected, but those
  appearing in shared content will not.
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:db="http://docbook.org/ns/docbook" xmlns="http://docbook.org/ns/docbook"
  xmlns:xlink="http://www.w3.org/1999/xlink">

  <xsl:key name="id" match="*" use="@xml:id"/>

  <!-- "quiet" != 0 => Quell non-fatal <xsl:message>s. -->
  <xsl:param name="quiet" select="1"/>

  <xsl:output method="xml" indent="no"/>

  <!--
    Match the root.
  -->
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <!--
    Match any element
  -->
  <xsl:template match="*">
    <xsl:copy>
      <xsl:for-each select="@*">
        <xsl:choose>
          <xsl:when test="name(.) = 'is_holmanized'">
            <!-- Don't copy the attribute over. -->
          </xsl:when>
          <xsl:when test="name(.) = 'xml:id'">
            <!--
              Don't copy the attribute over if it came in from holmanizing,
              and it's either preceded by any element with the same id or it's
              followed by a non-holmanized element with the same id.
            -->
            <xsl:if
              test="not(ancestor::*[@is_holmanized='true'] and
              (preceding::*[@xml:id=current()] or
              following::*[@xml:id=current() and
              not(@is_holmanized='true')]))">
              <xsl:apply-templates select="."/>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <!-- Copy the attribute over. -->
            <xsl:apply-templates select="."/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>

  <!--
    Match any non-element node.
  -->
  <xsl:template match="@*|text()|comment()|processing-instruction()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Adding a test to make sure they didn't use a bad file name for the image. -->
  <xsl:template match="@fileref[substring( ., string-length(.) - 13,14 ) = '-converted.png']">
    <xsl:message terminate="yes"> **************************************** ERROR: It is illegal to
      name an image file named *-converted.svg Bad file name: <xsl:value-of select="."/>
      **************************************** </xsl:message>
  </xsl:template>

  <xsl:template match="db:footnoteref">
    <xsl:variable name="targets" select="key('id',@linkend)"/>
    <xsl:variable name="footnote" select="$targets[1]"/>
    <!-- DWC: Die if you try to link from a footnoteref to something other than a footnote. I plan to add this to the core docbook xsls, so perhaps this can be removed later -->
    <xsl:if test="not(local-name($footnote) = 'footnote')">
      <xsl:message terminate="yes"> ERROR: A footnoteref element has a linkend that points to an
        element that is not a footnote. target element: <xsl:value-of select="local-name($footnote)"
        /> linkend/id: <xsl:value-of select="@linkend"/>
      </xsl:message>
    </xsl:if>
    <xsl:copy-of select="."/>
  </xsl:template>

  <!-- Remove any empty indexterms or literals -->
  <xsl:template
    match="
    db:indexterm[(normalize-space(.) = '' and not(./*)) or (./primary[normalize-space(.)	= '' and not(./*)])]|
    db:secondary[normalize-space(.) = '' and not(./*)]|
    db:tertiary[(normalize-space(.) = '' and not(./*)) or ../secondary[normalize-space(.) = '' and not(./*)]]|
    db:literal[normalize-space(.) = '' and not(./*)]|
    db:emphasis[normalize-space(.) = '' and not(./*)]|
    db:filename[normalize-space(.) = '' and not(./*)]|
    db:sgmltag[normalize-space(.) = '' and not(./*)]|
    
    db:guimenuitem[normalize-space(.) = '' and not(./*)]|
    db:guimenu[normalize-space(.) = '' and not(./*)]|
    db:guisubmenu[normalize-space(.) = '' and not(./*)]|
    db:remark[normalize-space(.) = '' and not(./*)]|
    db:replaceable[normalize-space(.) = '' and not(./*)]|
    db:classname[normalize-space(.) = '' and not(./*)]|
    db:interfacename[normalize-space(.) = '' and not(./*)]|
    db:database[normalize-space(.) = '' and not(./*)]|
    db:code[normalize-space(.) = '' and not(./*)]|
    db:superscript[normalize-space(.) = '' and not(./*)]|
    db:subscript[normalize-space(.) = '' and not(./*)]">
    <xsl:message> WARNING: Pruning an empty <xsl:value-of select="local-name(.)"/>. Context:
        <xsl:for-each select="ancestor::*"><xsl:value-of select="local-name(.)"/><xsl:if test="@id"
          >[@id = "<xsl:value-of select="@id"/>"]</xsl:if>/</xsl:for-each><xsl:value-of
        select="local-name(.)"/>
    </xsl:message>
  </xsl:template>


  <xsl:template match="db:link[normalize-space(.) = '']">
    <!-- For an empty link, write out the value of its xlink:href as the contents of teh link -->
    <link>
      <xsl:apply-templates select="@*"/>
      <xsl:value-of select="@xlink:href"/>
    </link>
  </xsl:template>

  <xsl:template match="db:title[not(text()) and not(./*)]">
    <xsl:message terminate="yes"> ------------------------------------------------------------ Fatal
      problem. You have an empty <title/> element in: <xsl:copy-of select="parent::*"/>
      ------------------------------------------------------------ </xsl:message>
  </xsl:template>

  <xsl:template match="db:partintro[parent::db:part]">
    <xsl:message terminate="yes"> Sorry, but the Motive XSLs don't support part/partintro.
    </xsl:message>
  </xsl:template>

  <xsl:template match="db:xref[not(@linkend or @share_linkend)]">
    <xsl:message> ========================= One or more xrefs found that does not have either a
      linkend attribute or a share_linkend attribute. </xsl:message>
    <xsl:for-each select="//db:xref[not(@linkend or @share_linkend)]">
      <xsl:message>========================= <xsl:copy-of select="."/>: -------------------------
          <xsl:copy-of select="parent::*"/> =========================</xsl:message>
    </xsl:for-each>
    <xsl:message terminate="yes"/>
  </xsl:template>

  <xsl:template match="db:title[@xml:id]">
    <xsl:message terminate="yes"> =================================== Uh oh!
      ----------------------------------- I found a title with an xml:id on it. You probably meant
      to put that on the title's parent. Here's the problematic title: <xsl:copy-of select="."/>
      =================================== </xsl:message>
    <!-- 	<anchor xml:id="{@xml:id}" xreflabel="{.}"/> -->
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Catch role attribute on xref, when it =nopage, change it to an xrefstyle -->
  <xsl:template match="db:xref/@role[string(.)='nopage']">
    <xsl:attribute name="xrefstyle">select: nopage</xsl:attribute>
  </xsl:template>

<!-- set up for separate indexes: copy @type to role 
We have to do this because DB5 uses @type not role, but our DB4 xsls expect @role to distinguish indexes 

The tricky part: we need to output 'role', keep all other attributes, but if they already have a role, we want to overwrite.
So, we have a line to copy over all attributes not named role. 

This ... typecasting ... is to fix JCBG-174.

-->
  
  <xsl:template match="db:index[@type]">
    <index>
      <!-- create attribute role with value from type -->
      <xsl:attribute name="role"><xsl:value-of select="@type"/></xsl:attribute>
      <!-- copy all attributes NOT named role -->
      <xsl:copy-of select="@*[generate-id(.) !=generate-id(../@role)]"/>
      <xsl:apply-templates/>
    </index>
    
    
  </xsl:template>


 <!--  Assign default role to indexterms, if they don't have one
   Copy type attribute of indexterm over to role, because DB5 uses type to distinguish different indexes 
   This ... typecasting ... is to fix JCBG-174. -->
  <xsl:template match="db:indexterm">
    <xsl:choose>
      <xsl:when test="not(@type)">
         <!-- if no type, then give role = default 
            Note that this means any existing role value is blown away. But, since role is the WRONG thing to assign to an indexterm, AND we
            have a schematron rule about that, that should be ok. 
         -->
        <indexterm role="default">
          <xsl:copy-of select="@*"/>
          <xsl:apply-templates/>
        </indexterm>
      </xsl:when>
      <xsl:otherwise>
         <!-- otherwise, the indexterm HAS a type value and we need to copy it to the role attrib -->
         <indexterm>
           <!-- create role attrib with value from type -->
           <xsl:attribute name="role"><xsl:value-of select="@type"/></xsl:attribute>
           <!-- Copy all attributes whose name is NOT role -->
           <xsl:copy-of select="@*[generate-id(.) !=generate-id(../@role)]"/>
           <xsl:apply-templates/>
         </indexterm>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="@sharer_doc">
    <xsl:message terminate="yes"> ===============================================================
      ERROR: Unresolved <xsl:value-of select="local-name(..)"/> found, with a sharer ID of
        <xsl:value-of select="../@sharer_id"/> and attempting to share from sharer_doc =
        <xsl:value-of select="."/> - Verify that you set the book's support_holmanization property
      to "true" - Check that the file <xsl:value-of select="."/> is correctly listed in the
      holmanization.includes file ===============================================================
    </xsl:message>
  </xsl:template>

</xsl:stylesheet>
