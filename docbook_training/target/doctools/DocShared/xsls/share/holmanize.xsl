<?xml version ="1.0"?>
<!DOCTYPE stylesheet>

<!-- 
$Id: holmanize.xsl,v 1.23 2009/03/12 21:58:31 aarond Exp $

Copyright
=========
Copyright (C) 2001, 2002 BroadJump Inc. 

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


NOTE:
Much of the documentation below is out-of-date. I have modified this to work
in a RelaxNG world where we can't use NDATA and unparsed-entity-uri()s. 

Overview
========

holmanize.xsl implements what David Cramer and I have come to call the "Holman
Method" for content sharing across (or even within) XML documents.  This
method uses the XSLT document() (and, less importantly, unparsed-entity-uri())
functions in favor of the more traditional general external entity mechanism.
We named it for G. Ken Holman (gkholman@cranesoftwrights.com), who suggested
the method to David during a seminar in Ottawa in Autumn, 2001.

We can identify three advantages of the Holman Method for content sharing over
the general external entity mechanism:

  1 The shared, or source, element (or, "fragment") being re-used does not
    need to appear in its own file, but may appear "in-line" in a containing
    document.

  2 The shared (source) elements are insulated from presumably unpredictable
    changes in what can be called the general internal entity "environment" of
    the sharing (target) documents in which they're re-used.  This makes this
    scheme more robust than sharing through external entity references.

  3 Some currently available, WYSIWYG XML editors which poorly handle (to the
    point of crashing) general external entity references are unfazed by the
    placeholder elements which identify shared uses of the source elements.

On the down side, the DTD used for both the source and target documents must
be changed (v.i.).  Also, the author of the target document will not be able
to see the re-used content in the context of the target document until after
this XSLT has been used to "assemble" that target into something closer to its
final form; whether this is a disadvantage is debatable.

PROBLEMS
========

Redundant ID Attributes

holmanize.xsl can produce invalid documents when the same element is re-used
more than once if that element has an "ID" type attribute.  Actually, if the
element being re-used already appears in the source document, then re-using it
just once can cause this problem.  The problem is also recursive in nature:
it can occur if an element is re-used once and then a child of that element is
also re-used once.

We solve this problem by recursively giving ``is_holmanized="true"''
attributes to the output elements corresponding to the <share_foo> placeholder
elements from the input; then a dedupids.xsl stylesheet is run on the output
to strip all duplicate id attributes, but the first, resulting from
holmanizing.

Detailed Description and Usage
==============================

First the DTD used by source and target elements needs to modified.  For each
element, <foo>, which is to be shared, a new <share_foo> element must be
declared and all element content models which contain a <foo> element must
also contain a <share_foo> element in the same places.  We also added an
``is_shared'' attribute to each <foo> to at least give some indication to the
author of the source document that her <foo> is being re-used elsewhere:

  <!ATTLIST foo is_shared (true | false) "false">

This XSLT stylesheet will issue warnings when the target <foo> of a
<share_foo> element does not have ``is_shared="true"''.

The location of re-use of the <foo> element in a target document is marked by
a <share_foo> element.  (The name of this placeholder element *must* be
``share_'' prepended to the name of the source element in order for this XSLT
stylesheet to function successfully.  Following this naming convention for the
placeholder elements precludes the necessity for any changes to this XSLT
stylesheet in the face of any new placeholder elements being added in the
DTD.)  The original <foo> is assumed to have had an ``id'' attribute (declared
of type ID in the ATTLIST declaration which defines it in the external subset
of the formal DTD) which is unique for that <foo> in its containing source
document, and thus which can be used to uniquely identify that <foo> in that
document.  The <share_foo> then has a ``sharer_id'' attribute with the same
value as the shared <foo>'s ``id'' attribute.  To identify the source document
which contains the shared <foo>, the <share_foo> also has a ``sharer_doc''
attribute.  This ``sharer_doc'' could directly contain a relative path to the
source document containing the shared <foo>, but instead it contains the name
of an unparsed general external entity whose declaration itself contains that
relative path.  By adding this level of indirection, and by following a
convention that all such unparsed general external entity declarations are
contained in a single .ent file (for at least one group of related documents),
we're able to manage changes in the names and file tree locations of shared
documents more easily.

One other bit of patching up we do involves the ``linkend'' attributes used in
<xref>, <glossterm>, etc., elements.  These attributes are declared in the
docbook XML DTD to be of type IDREF, so for a document containing an element
with a ``linkend'' attribute to be valid, the value of that attribute must
appear elsewhere in the document, only once, as the value of an attribute
declared to be of ID type.  If the input (i.e., pre-assembled) document to
this XSLT stylesheet has, for example, an <xref> element which references
through its ``linkend'' attribute another element which is not present in the
document, but will be after assembly, the input document will be invalid.
Xerces-C, for example, will complain:  "ID attribute 'foo' was referenced but
never declared."

Of course, the assembled output document will be valid, but to preserve
validity of the input documents as well we add a new ``share_linkend''
attribute in the DTD for elements such as <xref> and use it instead of
``linkend'' when the element is referring to another element only available
after this XSLT stylesheet has been applied.  Hence this XSLT stylesheet
'patches up' these elements, replacing all ``share_linkend'' attributes with
``linkend'' attributes containing the same values.


Example
=======

Let's recapitulate the required DTD changes with a simple example.  If we had
a DTD which originally contained:

  <!ELEMENT one           (title,two+)>

  <!ELEMENT title         (#PCDATA)>

  <!ELEMENT two           ((xrefthing|three)+)>
  <!ATTLIST two           id              ID             #REQUIRED>

  <!ELEMENT three         (#PCDATA)>

  <!ELEMENT xrefthing     (#PCDATA)>
  <!ATTLIST xrefthing     linkend         IDREF          #REQUIRED>

and we wanted to enable sharing of <two> elements, and allow <xrefthing>
elements to reference the shared <two> elements while preserving validity of
the input document, we would change these portions of the DTD to:

  <!ELEMENT one           (title,(two|share_two)+)>

  <!ELEMENT title         (#PCDATA)>

  <!ELEMENT two           ((xrefthing|three)+)>
  <!ATTLIST two           id              ID             #REQUIRED>
  <!ATTLIST two           is_shared       (true | false) "false">

  <!ELEMENT share_two     EMPTY>
  <!ATTLIST share_two     sharer_doc      ENTITY         #REQUIRED>
  <!ATTLIST share_two     sharer_id       NMTOKEN        #REQUIRED>

  <!ELEMENT three         (#PCDATA)>

  <!ELEMENT xrefthing     (#PCDATA)>
  <!ATTLIST xrefthing     linkend         IDREF          #REQUIRED>
  <!ATTLIST xrefthing     share_linkend   NMTOKEN        #REQUIRED>

If we then wanted to allow <two> elements contained in the files foo.xml and
bar.xml to be shared, our .ent file would contain:

  <!NOTATION SHARED_XML SYSTEM "can anything useful be put here?">
  <!ENTITY foo.xml SYSTEM "../xml-docs/foo.xml" NDATA SHARED_XML>
  <!ENTITY bar.xml SYSTEM "../xml-docs/bar.xml" NDATA SHARED_XML>


informal change history
=======================

  xshare1.xsl - Taking initial cut at "Holman method" for sharing content
    using XSLT unparsed-entity-uri() and document() functions.  Successful,
    but runs wild when given recursive shared element references.

  xshare2-norecurse.xsl - Taking initial cut at solving the recursive shared
    element reference problem.  Not successful.

  xshare3-norecurse.xsl - Successfully detecting recursive shared elements
    through use of <xsl:with-param> inside of <xsl:apply-templates> to keep a
    global "stack" of element references.

  xshare4-norecurse.xsl - Partially parameterizing the names of the shared
    elements using the saxon:evaluate() extension function.  Successful.

  xshare5-norecurse.xsl - Fully parameterizing the names of the shared
    elements using the saxon:evaluate() extension function.  Adding "shared
    element expanded here" comments in the output.  Detecting empty shared
    elements caused by bad ID attribute or bad pathname to document containing
    the shared element.  Whining in greater detail when recursive share is
    detected.  Whining (subject to the setting of a ``quiet'' global
    parameter) when the source of a share_MUMBLE doesn't have it's
    ``is_shared'' attribute set to "true".

  holmanize.xsl - Change ``share_linkend'' element attributes to ``linkend''
    attributes for all incoming elements.

-->

  <xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:saxon="http://icl.com/saxon"
	  xmlns:exslt="http://exslt.org/common" 
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:db="http://docbook.org/ns/docbook"
	exslt:dummy="dummy" 
	extension-element-prefixes="exslt" 
	exclude-result-prefixes="exslt">

    <!--xsl:output
      method="xml"
      indent="yes"
      doctype-public="-//BroadJump//DTD DocBook XML V4.1.2-Based Subset v1.0//EN"
      doctype-system="../../../../../../xmldocs/export/DocShared/1.0/dtds/broadbook/broadbook.dtd"/-->

    <!--xsl:output
      method="xml"
      doctype-public="-//OASIS//DTD DocBook XML V4.1.2//EN"
      doctype-system="../../../../doctools/1.0/DocBookDTD/4.1/docbookx.dtd"/-->

    <!--
    Match the root.

    This is the starting point.  We check that our saxon:evaluate() XSLT
    extension function is available and initialize the "share_stack" parameter
    that allows detection of recursively shared elements.
    -->
    <xsl:template match="/">
	<xsl:message>
============================================================
	  <xsl:value-of select="system-property('xsl:vendor')"/>
============================================================
	</xsl:message>
      <xsl:if test="not(function-available('saxon:evaluate'))">
        <xsl:message terminate="yes">
          <xsl:text>ERROR: saxon:evaluate() XSLT extension function </xsl:text>
          <xsl:text>is needed but not available.</xsl:text>
        </xsl:message>
      </xsl:if>
      <xsl:apply-templates>
        <!-- Note that the empty stack has a single '\'.  -->
        <xsl:with-param name="share_stack"
          select="'\'"/>
      </xsl:apply-templates>
    </xsl:template>

    <!--
    Match any element.

    We set this at a higher priority than the ``match="@*|node()'' template
    below so that that template will not catch elements, just everything else.
    We can't use XPath axis specifiers like ``text()'' and
    ``processing-instruction()'' in template match attribute values, just
    ``node()'', which catches elements; hence the use of the priority
    attributes to resolve the dispute between this and that template.
    -->

    <xsl:template match="*" priority="1">

      <xsl:param name="share_stack"/>
      <xsl:param name="is_holmanized" select="'false'"/>
      <xsl:param name="sharer_doc"/>
	  <xsl:param name="local_id"/>
	  <xsl:param name="local_author_condition_1"/>
	  <xsl:param name="local_author_condition_2"/>
	  <xsl:param name="local_security"/>
	  <xsl:param name="local_condition"/>

      <xsl:choose>
        <!-- We found a shared element placeholder element. -->
        <xsl:when test="substring(name(.), 1, 6) = 'share_'">

          <xsl:variable name="replac_elt_name"
            select="concat('db:',substring-after(name(.), 'share_'))"/>
          
          <xsl:variable name="new_share"
            select="concat($replac_elt_name,
                           '\',
                           @sharer_id,
                           '\',
                           @sharer_doc,
                           '\')"/>

          <xsl:variable name="new_share_stack"
            select="concat($share_stack, $new_share)"/>
          
          <!-- Puke n' die if we're about to recurse. -->
          <xsl:if test="contains($share_stack, concat('\', $new_share))">
            <xsl:message terminate="yes">
              <xsl:text>HOLMANIZE ERROR: recursive sharing </xsl:text>
			  <xsl:text>detected while expanding </xsl:text>
			  <xsl:text disable-output-escaping="yes">&amp;lt;</xsl:text>
			  <xsl:value-of select="name(.)"/>
			  <xsl:text> sharer_id="</xsl:text>
			  <xsl:value-of select="@sharer_id"/>
			  <xsl:text>" sharer_doc="</xsl:text>
			  <xsl:value-of select="@sharer_doc"/>
			  <xsl:text disable-output-escaping="yes">"&amp;gt; (</xsl:text>
			  <xsl:text>where sharer_doc denotes file "</xsl:text>
			  <xsl:value-of select="@sharer_doc"/>
			  <xsl:text>") with share_stack: </xsl:text>
              <xsl:value-of select="$share_stack"/>
            </xsl:message>
          </xsl:if>

          <xsl:variable name="document-prefix">document('</xsl:variable>
          <xsl:variable name="document-suffix">',.)//</xsl:variable>
          <xsl:variable name="squot">'</xsl:variable>
          <xsl:variable name="replac_elt_str"
            select="concat($document-prefix,@sharer_doc,$document-suffix,
            $replac_elt_name,'[@xml:id = ',$squot,@sharer_id,$squot,']')"/>

		  <xsl:variable name="replac_elt_nodes"
			select="exslt:node-set(saxon:evaluate($replac_elt_str))"/>


          <!-- Insert an "element expanded here" comment into the output. -->
          <xsl:comment>
            <xsl:text> HOLMANIZE: Expanded </xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;</xsl:text>
            <xsl:value-of select="name(.)"/>
            <xsl:text> sharer_doc="</xsl:text>
            <xsl:value-of select="@sharer_doc"/>
            <xsl:text>" sharer_id="</xsl:text>
            <xsl:value-of select="@sharer_id"/>
            <xsl:text disable-output-escaping="yes">"&gt; (from </xsl:text>
            <xsl:text>file "</xsl:text>
            <xsl:value-of select="@sharer_doc"/>
            <xsl:text>").</xsl:text>
          </xsl:comment>

          <!-- Puke n' die if we can't find the shared element. -->
          <xsl:if test="not($replac_elt_nodes)">
            <xsl:message terminate="yes">
              <xsl:text>HOLMANIZE ERROR: could not locate </xsl:text>
              <xsl:text disable-output-escaping="yes">&amp;lt;</xsl:text>
              <xsl:value-of select="$replac_elt_name"/>
              <xsl:text> xml:id="</xsl:text>
              <xsl:value-of select="@sharer_id"/>
              <xsl:text disable-output-escaping="yes">"&amp;gt; </xsl:text>
              <xsl:text>in file "</xsl:text>
              <xsl:value-of select="@sharer_doc"/>
              <xsl:text>" while expanding </xsl:text>
              <xsl:text disable-output-escaping="yes">&amp;lt;</xsl:text>
              <xsl:value-of select="name(.)"/>
              <xsl:text> sharer_id="</xsl:text>
              <xsl:value-of select="@sharer_id"/>
              <xsl:text>" sharer_doc="</xsl:text>
              <xsl:value-of select="@sharer_doc"/>
              <xsl:text disable-output-escaping="yes">"&amp;gt;; </xsl:text>
              <xsl:text>  $share_stack="</xsl:text>
              <xsl:value-of select="$share_stack"/>
              <xsl:text>".</xsl:text>
            </xsl:message>
          </xsl:if>

		  <!--
		  Whine if the source element's is_shared attribute value isn't
		  "true," and if we're not quelling such whining.
		  -->
			<xsl:variable name="source_filename"
			  select="@sharer_doc"/>
			<xsl:for-each select="$replac_elt_nodes[not(@is_shared = 'true')]">
				<xsl:message>
				  <xsl:text>HOLMANIZE WARNING: source element </xsl:text>
				  <xsl:text disable-output-escaping="yes">&lt;</xsl:text>
				  <xsl:value-of select="$replac_elt_name"/>
				  <xsl:text> xml:id="</xsl:text>
				  <xsl:value-of select="@xml:id"/>
				  <xsl:text>" is_shared="</xsl:text>
				  <xsl:value-of select="@is_shared"/>
				  <xsl:text disable-output-escaping="yes">"&gt; </xsl:text>
				  <xsl:text>in file "</xsl:text>
				  <xsl:value-of select="$source_filename"/>
				  <xsl:text>" does not have is_shared="true".</xsl:text>
				</xsl:message>
			</xsl:for-each>

          <!-- Recurse on the element shared from elsewhere. -->
          <xsl:apply-templates
            select="$replac_elt_nodes">
            <xsl:with-param name="share_stack" select="$new_share_stack"/>
            <xsl:with-param name="is_holmanized" select="'true'"/>
            <xsl:with-param name="sharer_doc" select="@sharer_doc"/>
			<xsl:with-param name="local_id" select="@xml:id"/>
			<xsl:with-param name="local_author_condition_1" select="@author_condition_1"/>
			<xsl:with-param name="local_author_condition_2" select="@author_condition_2"/>
			<xsl:with-param name="local_security" select="@security"/>
			<xsl:with-param name="local_condition" select="@condition"/>
          </xsl:apply-templates>
        </xsl:when>

        <!-- We found a regular (non-placeholder) element. -->
        <xsl:otherwise>
          <xsl:copy>
			<!--
			Explicitly handle the element's attributes first so that we can
			intercept and change any ``share_linkend'' to a ``linkend''.
			-->
			<xsl:for-each select="@*">
			  <xsl:choose>
				<xsl:when test="name(.)='share_linkend'">
				  <xsl:attribute name="linkend">
					<xsl:value-of select="."/>
				  </xsl:attribute>
				</xsl:when>

				<xsl:otherwise>
				  <xsl:attribute name="{name(.)}">
					<xsl:value-of select="."/>
				  </xsl:attribute>
				</xsl:otherwise>
			  </xsl:choose>
			</xsl:for-each>

      <xsl:if test="not($sharer_doc = '')">
        <xsl:attribute name="xml:base"><xsl:value-of select="$sharer_doc"/></xsl:attribute>
      </xsl:if>
            
            <!-- if the share_* element has an id, author_condition_*, security, or 
			condition, apply it (whether or not the source elt has the attrib) -->
			<xsl:if test="not(normalize-space($local_id) = '')">
			  <xsl:attribute name="xml:id">
				<xsl:value-of select="$local_id"/>
			  </xsl:attribute>
			</xsl:if>
			<xsl:if test="not(normalize-space($local_author_condition_1) = '')">
			  <xsl:attribute name="author_condition_1">
				<xsl:value-of select="$local_author_condition_1"/>
			  </xsl:attribute>
			</xsl:if>
			<xsl:if test="not(normalize-space($local_author_condition_2) = '')">
			  <xsl:attribute name="author_condition_2">
				<xsl:value-of select="$local_author_condition_2"/>
			  </xsl:attribute>
			</xsl:if>
			<xsl:if test="not(normalize-space($local_security) = '')">
			  <xsl:attribute name="security">
				<xsl:value-of select="$local_security"/>
			  </xsl:attribute>
			</xsl:if>
			<xsl:if test="not(normalize-space($local_condition) = '')">
			  <xsl:attribute name="condition">
				<xsl:value-of select="$local_condition"/>
			  </xsl:attribute>
			</xsl:if>

            <!--
            If we were called to traverse a shared elt, mark it with an
            "is_holmanized" attribute for later removal of duplicate "xml:id"
            attributes.
            -->
            <xsl:if test="$is_holmanized = 'true'">
              <xsl:attribute name="is_holmanized">true</xsl:attribute>
            </xsl:if>

            <xsl:apply-templates select="node()">
              <xsl:with-param name="share_stack"
                select="$share_stack"/>
              <!--
              Pass the 'is_holmanized' param value on down, so that all shared elts
              will be recursively marked with the ``is_holmanized="true"'' attr.
              -->
              <xsl:with-param name="is_holmanized"
                select="$is_holmanized"/>
              <xsl:with-param name="sharer_doc"
                select="$sharer_doc"/>
            </xsl:apply-templates>
          </xsl:copy>
        </xsl:otherwise>
      </xsl:choose>

    </xsl:template>

    <!--
    Match any non-element node.

    See discussion of priority attributes at the top of the previous
    template.
    -->
    <xsl:template match="@*|node()" priority="0">
      <xsl:param name="share_stack"/>
      <xsl:copy>
        <xsl:apply-templates select="@*|node()">
          <xsl:with-param name="share_stack"
            select="$share_stack"/>
        </xsl:apply-templates>
      </xsl:copy>
    </xsl:template>

  </xsl:stylesheet>
