<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:db="http://docbook.org/ns/docbook" 
  xmlns:xi="http://www.w3.org/2001/XInclude"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  exclude-result-prefixes="db" version="2.0">
  <!-- xsl 2.0 required to allow use of replace() function -->

  <!--Convert jira RSS to a docbook table or list -->

  <xsl:output method="xml" encoding="utf-8" indent="no" omit-xml-declaration="no"/>


  <!-- global params -->
  <xsl:param name="JIRAROOTID">default-id</xsl:param>
  <xsl:param name="TYPE">known</xsl:param>
  <xsl:param name="STYLE">table</xsl:param>
  <xsl:param name="JIRATITLE">DefaultTitle</xsl:param>
  <xsl:param name="ulink.show"/>
  <xsl:param name="ROOTELEMENT">section</xsl:param> <!-- added for JCBG-1556-->
  <xsl:param name="INTROPARA">NONE</xsl:param>  <!-- added for JCBG-1556--> 
  <xsl:param name="RHKEYWORD">NONE</xsl:param>  <!-- added for JCBG-1758-->
  <xsl:param name="STOPCHUNKING">yes</xsl:param>  <!-- added for JCBG-2044-->

  <xsl:variable name="cols">
    <!-- # of columns, only used for tables -->
    <xsl:if test="$TYPE = 'resolved'">2</xsl:if>
    <xsl:if test="$TYPE = 'general'">2</xsl:if>
    <xsl:if test="$TYPE = 'known'">3</xsl:if>
  </xsl:variable>

<!-- set widths for cols -->
  <xsl:variable name="COL1WIDTH">1*</xsl:variable>
  <xsl:variable name="COL2WIDTH">2*</xsl:variable>
  <xsl:variable name="COL3WIDTH">2*</xsl:variable>

  <!-- We need a variable with a NODE in it to use in our group-by expressions;
    this variable DEFAULTCATEGORY determines the name of the default category;
    am using ZZZZ so that it sorts to the bottom, and then later we test for that and output
    a different name -->
  <xsl:variable name="DEFAULTCATEGORY">
    <category>ZZZZ</category>
  </xsl:variable>

  <!-- param USECAT says whether we are going to output category headers/divisions
    We set the value at the root here so that we do the logic on this just once.
    it can be set by the user as a param to the get-jira macro
    
    if set by the user, that wins (b/c usecat passed in as $USECAT and overrides this code here)
    if not, then we decide based on this: 
        if general, then we use cats if ANY items have category info  
           ((( HOWEVER, this doesn't currently help b/c general later ignores categories.
           To support categories, we'd need code in the Table and List sections to handle that. All the expressions re: categories also filter at the same time.
           We could REFACTOR the xsl to do something like a 2-pass approach...do the filtering first IF NEEDED, THEN do the categories stuff. 
           This script could use a refactor anyway.
           )))
        otherwise, use cats if any Release Noted For items have category info
    
      
    this expression catches any items with Release Noted For..
    (//customfields/customfield[string(customfieldname)= 'Release Noted For'])

this one starts from item, catches ones with both Release Noted For and a category
customfields[customfield/string(customfieldname) = 'Release Noted For']/customfield[string(customfieldname)= 'Release Note Category']/customfieldvalues/customfieldvalue

  -->

  <xsl:param name="USECAT">
    <xsl:choose>
      <!-- if general, then use categories if any items have Release Note Category -->
      <xsl:when
        test="($TYPE = 'general') and //customfield[string(customfieldname)='Release Note Category']"
        >yes</xsl:when>
      <!-- if not general, use categories only if at least one item has both Release Noted For and a category -->
      <xsl:when
        test="not($TYPE = 'general') and (//customfields[customfield/string(customfieldname) = 'Release Noted For']/customfield[string(customfieldname)= 'Release Note Category']/customfieldvalues/customfieldvalue)"
        >yes</xsl:when>
      <xsl:otherwise>no</xsl:otherwise>
    </xsl:choose>
  </xsl:param>

  <!-- variable CATEGORIES = assigns categories, so that all get one -->

 

  <!-- title of the whole table or section-->

  <!-- templates -->

  <xsl:template match="/">
    <xsl:apply-templates select="//channel"/>
  </xsl:template>

  <xsl:template match="channel">
    <xsl:text>
</xsl:text>
    <xsl:comment>
      <xsl:text>

WARNING, GENERATED FILE. DO NOT EDIT BY HAND.

Converted by jira2docbook.xsl. 

This file made from the JIRA data available via the link</xsl:text>
      <xsl:value-of select="link"/>
      <xsl:text>
  
  
</xsl:text>
    </xsl:comment>



    <xsl:comment> Some debugging values: <xsl:text>
 </xsl:text>$TYPE= <xsl:value-of select="$TYPE"/>
      <xsl:text>
 </xsl:text>$STYLE= <xsl:value-of select="$STYLE"/>
      <xsl:text>
 </xsl:text>$USECAT= <xsl:value-of select="$USECAT"/>
      <xsl:text>
 </xsl:text>$DEFAULTCATEGORY= <xsl:value-of select="$DEFAULTCATEGORY"/>
      <xsl:text>
 </xsl:text>$STOPCHUNKING= <xsl:value-of select="$STOPCHUNKING"/>
    </xsl:comment>
    <xsl:text>

</xsl:text>



    <xsl:choose>  
      <!-- This is the main choice in the root template: style = table or list?-->
      <xsl:when test="$STYLE = 'table'">


        <!--- table wrapper: start stuff -->
        <db:informaltable>
          <xsl:attribute name="version">5.0-extension BroadBook-2.0</xsl:attribute>
          <xsl:attribute name="xml:id">
            <xsl:value-of select="$JIRAROOTID"/>
          </xsl:attribute>
          
          <!-- Output the RH keyword string, per JCBG-1758 and JCBG-1894 -->
          
          <xsl:if test="not($RHKEYWORD = 'NONE')">  
            <db:info>
            <db:keywordset>
              <db:keyword role="rh"><xsl:value-of select="$RHKEYWORD"/></db:keyword>
            </db:keywordset>
            </db:info>
          </xsl:if> 
          
          
          <xsl:text>
</xsl:text>

          <db:tgroup>
            <!-- set # of columns -->
            <xsl:attribute name="cols">
              <xsl:value-of select="$cols"/>
            </xsl:attribute>

            <!-- now colspecs ... with no colwidth for now -->
            <db:colspec colnum="1" colname="col1">
              <!-- kludge for JCBG-1168, titles linked accidentally; by making 
                  the ID col wider for resolved issues, makes it unlikely they'll 
                  break to a new line; we don't do it when ulinks are not shown, though, 
               because then it is not needed. 
              <xsl:if test="($TYPE = 'resolved') and not($ulink.show = '0')">
                <xsl:attribute name="colwidth">3in</xsl:attribute>
                </xsl:if> -->
              <xsl:attribute name="colwidth"><xsl:value-of select="$COL1WIDTH"/></xsl:attribute>
            </db:colspec>

              <!-- these colwidths from variables only work if you do the value as an xsl:attribute with a value-of -->
            <db:colspec colnum="2" colname="col2">
              <xsl:attribute name="colwidth"><xsl:value-of select="$COL2WIDTH"/></xsl:attribute>
            </db:colspec>
            <!-- output a 3rd column only if type=Known -->
            <xsl:if test="$TYPE = 'known'">
              <db:colspec colnum="3" colname="col3" >
                <xsl:attribute name="colwidth"><xsl:value-of select="$COL3WIDTH"/></xsl:attribute>
              </db:colspec>
            </xsl:if>

            <!-- table headers -->
            <db:thead>
              <db:row>
                <db:entry colname="col1">
                  <db:para>ID</db:para>
                </db:entry>
                <db:entry colname="col2">
                  <db:para>Title</db:para>
                </db:entry>
                <!-- output a 3rd entry only if type=Known -->
                <xsl:if test="$TYPE = 'known'">
                  <db:entry colname="col3">
                    <db:para>Description</db:para>
                  </db:entry>
                </xsl:if>
              </db:row>
            </db:thead>
            <xsl:text>

</xsl:text>
            <db:tbody>
              <xsl:text>

</xsl:text>


              <!-- Handle cases where there are no matching items-->
              <xsl:choose>
                 <!-- when general, then emit row with message, if there are no items in the query -->
                <xsl:when test="not(//item) and ($TYPE = 'general')">
                  <xsl:call-template name="no-items-table"/>
                </xsl:when>
                 <!-- when not general, then emit row if no items that have 'release noted for' -->
                <xsl:when
                  test="not(//item/customfields/customfield[string(customfieldname)= 'Release Noted For']) and not($TYPE = 'general')">
                  <xsl:call-template name="no-items-table"/>
                </xsl:when>

              </xsl:choose>

              <!-- Handle cases where all matching items = internal -->

              <xsl:if
                test="not($TYPE='general') and not(//item/customfields/customfield[string(customfieldname)= 'Release Noted For']/customfieldvalues/customfieldvalue[ string(.) ='External']) and //item/customfields/customfield[string(customfieldname)= 'Release Noted For']/customfieldvalues/customfieldvalue[ string(.) ='Internal']">
                <!-- if it's a known or resolved table, and no external items, then we need to output a special row 
                      with security=external, to show up in external-only builds -->
                <db:row security="external">
                  <!-- for JCBG-1174, added 'external' here, so we get the special row only on external builds -->
                  <db:entry namest="col1" nameend="col{$cols}">
                    <xsl:copy-of select="$NOEXTERNALITEMSMESSAGE"/>
                  </db:entry>
                </db:row>
              </xsl:if>



              <xsl:choose>
                <xsl:when test="$TYPE='general'">
                  <!-- for general, we're just going to apply templates to all items, no categories or Release Noted For filtering-->
                  <xsl:apply-templates select="item" mode="table">
                    <xsl:sort select="number(substring-after(key, '-'))"/>
                  </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                  <!-- for non-general, we're going to do some complicated category stuff, and filter on Release Noted For along the way-->


                  <!-- group by category  -->
                  <!--  the group-by below filters on Release Noted For, then selects category;
                       the filtering on Release Noted For means that items with no release note don't get grouped, so theyb                       
                       
             I tried several different approaches here. In these notes, (category) stands for 'an expression that
             returns the item's category name, or nothing if it doesn't have one.
             
             I tried using string(category); this works, returning '' if the item has no category, but then you have to sort on that, and the only option is to put '' first.
             
             Now I'm using the group-by to force items with no category to go in the $DEFAULTCATEGORY.
             
             Initially I tried to do that by using "(category), $DEFAULTCATEGORY" but using , turned out to be bad because that
             returns 2 categories when the item has one, so every item is in DEFAULTCATEGORY and some are in others too.

             I needed an expression that only returned 1 value in a nodeset. I did that basically by chaining up
             (category) and $DEFAULTCATEGORY and taking the [1] of that set, because when the item has no category, then
             $DEFAULTCATEGORY will be the only thing, but otherwise you get the item's category.
           
             expression that returns a category if it exists: customfields[customfield/string(customfieldname) = 'Release Noted For']/customfield[string(customfieldname)= 'Release Note Category']/customfieldvalues/customfieldvalue
             
             This means, though, that even if there are NO items that lack a category, we'll process a group for $DEFAULTCATEGORY. So I added an <xsl:if>
             below to skip writing out the category header if there are no $DEFAULTCATEGORY items.
             
              -->


                  <xsl:for-each-group
                    select="item[customfields/customfield/string(customfieldname) = 'Release Noted For']"
                    group-by="normalize-space(((customfields/customfield[string(customfieldname)= 'Release Note Category']/customfieldvalues/customfieldvalue) | $DEFAULTCATEGORY)[1])">
                        <!-- for JCBG-1999, added normalize-space to the group-by expression above, so that category names get leading/trailing spaces trimmed. -->
                    <xsl:sort select="current-grouping-key()"/>

                    <!-- Category Header Row -->
                    <xsl:if test="$USECAT = 'yes'">
                      <!-- skip this row if not using categories -->
                      <xsl:if test="count(current-group()) &gt; 0">
                        <!-- ie, if current group has ANY members at all; otherwise skip this row
                     we need this test because if the $DEFAULTCATEGORY has no members, it still gets processed here due to how we concatenated
                      it to the list in the group-by above
                      -->

                        <xsl:comment>Category Header Row for category <xsl:value-of
                            select="current-grouping-key()"/> which has <xsl:value-of
                            select="count(current-group())"/> members.</xsl:comment>
                        <xsl:text>
 </xsl:text>
                        <db:row>
                          <!-- if we don't find any External items in this group, make the row internal-->
                          <xsl:if
                            test="not(current-group()//customfieldvalue[string(.) = 'External'][string(../../customfieldname) = 'Release Noted For'])">
                            <xsl:attribute name="security">internal</xsl:attribute>
                            <xsl:comment>Internal, because all the category's items are internal;
                              making it internal makes it disappear on external builds, when it
                              would have no content.</xsl:comment>
                            <xsl:text>
</xsl:text>
                          </xsl:if>
                          <db:entry namest="col1" nameend="col{$cols}">
                            <db:para>
                              <db:emphasis role="bold">
                                <!-- if the category is ZZZZ, use label Miscellaneous; otherwise use actual category name 
                        this allows Misc items to sort to the bottom -->
                                <xsl:text>
</xsl:text>
                                <xsl:choose>
                                  <xsl:when test="current-grouping-key() = 'ZZZZ'"
                                    >Miscellaneous</xsl:when>
                                  <xsl:otherwise>
                                    <xsl:value-of select="current-grouping-key()"/>
                                  </xsl:otherwise>
                                </xsl:choose>


                              </db:emphasis>
                            </db:para>
                          </db:entry>
                        </db:row>
                        <xsl:text>

</xsl:text>
                      </xsl:if>
                    </xsl:if>

                    <xsl:for-each select="current-group()">
                      <!-- need to put the sort on the for-each, NOT on the apply below-->
                      <xsl:sort select="number(substring-after(key, '-'))"/>
                      <!-- debug comment
                  <xsl:comment>In xsl for each current group, I am a <xsl:value-of
                      select="local-name()"/>. My sort value is... <xsl:value-of
                      select="number(substring-after(key,'-'))"/></xsl:comment>
                  <xsl:text>
                    
                  </xsl:text> -->
                      <xsl:apply-templates select="." mode="table"/>

                    </xsl:for-each>

                  </xsl:for-each-group>
                </xsl:otherwise>

              </xsl:choose>
              <!-- table wrapper: end stuff -->
            </db:tbody>
          </db:tgroup>
        </db:informaltable>

      </xsl:when>


      <xsl:when test="$STYLE = 'list'">
	<!-- for jcbg-1556, made the wrapper element's name be based on new ROOTELEMENT param -->
        <xsl:element name="db:{$ROOTELEMENT}">
	  
          <xsl:attribute name="version">5.0-extension BroadBook-2.0</xsl:attribute>
          <xsl:attribute name="xml:id">
            <xsl:value-of select="$JIRAROOTID"/>
          </xsl:attribute>
          <xsl:text>
          </xsl:text>

	  <!-- Add a stop-chunking PI, per JCBG-2044 -->
	  <xsl:if test="$STOPCHUNKING = 'yes'">
	    <xsl:processing-instruction name="dbhtml">stop-chunking</xsl:processing-instruction>
	  </xsl:if>

          <db:info>

            <!-- Output the title -->
          <db:title>
            <xsl:choose>
              <xsl:when test="$JIRATITLE">
                <xsl:value-of select="$JIRATITLE"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test="$TYPE = 'known'">Known Issues</xsl:when>
                  <xsl:when test="$TYPE = 'resolved'">Resolved Issues</xsl:when>
                  <xsl:otherwise> XXX No title supplied for JIRA section; set the 'jiratitle'
                    parameter xxx </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </db:title>

           <!-- Output the RH keyword string, per JCBG-1758 -->
       <xsl:if test="not($RHKEYWORD = 'NONE')">  
          <db:keywordset>
            <db:keyword role="rh"><xsl:value-of select="$RHKEYWORD"/></db:keyword>
          </db:keywordset>
       </xsl:if> 
          </db:info>
          <!-- output an xinclude pointing at the intro para, if there is one -->
      <xsl:text>
        
      </xsl:text>
          <xsl:if test="not($INTROPARA = 'NONE')">
            <xsl:element name="xi:include">
              <xsl:attribute name="href"><xsl:value-of select="$INTROPARA"/></xsl:attribute>
            </xsl:element>
            
          </xsl:if>

          <!-- Handle cases where there are no matching items for query: output a message -->
          <xsl:choose>
             <!-- if general, then must have no items at all to get the message -->
            <xsl:when test="not(//item) and ($TYPE = 'general')">
              <xsl:call-template name="no-items-list"/>
            </xsl:when>
             <!-- if not general, then must lack items with release noted for, to get the message -->
            <xsl:when
              test="not(//item/customfields/customfield[string(customfieldname)= 'Release Noted For']) and not($TYPE='general')">
              <xsl:call-template name="no-items-list"/>
            </xsl:when>
          </xsl:choose>


          <!-- Handle cases where all matching items = internal -->

          <xsl:if
            test="not($TYPE='general') and not(//item/customfields/customfield[string(customfieldname)= 'Release Noted For']/customfieldvalues/customfieldvalue[ string(.) ='External']) and //item/customfields/customfield[string(customfieldname)= 'Release Noted For']/customfieldvalues/customfieldvalue[ string(.) ='Internal']">

            <!-- if it's a known list, and no external items, then we need to output a special para
              with security=external, to show up in external-only builds -->
            <xsl:copy-of select="$NOEXTERNALITEMSMESSAGE"/>

          </xsl:if>

          <!-- Now emit the items, but we need to do it differently for general and other cases 
            -->

          <xsl:choose>
            <xsl:when test="$TYPE='general'">
              <!-- do a stop-chunking so that the items in the list appear on one html page -->
              <xsl:processing-instruction name="dbhtml">stop-chunking</xsl:processing-instruction>
            
              <!-- for general, we're just going to apply templates to all items, no categories or Release Noted For filtering-->
              
              <xsl:apply-templates select="item" mode="list">
                <xsl:sort select="number(substring-after(key, '-'))"/>
              </xsl:apply-templates>
            </xsl:when>
            <xsl:when test="$USECAT='no'">
              
               <!-- This when case is 'not general, but no categories either', and so we are going to emit the filtered list of items-->
              
              <xsl:apply-templates select="item[customfields/customfield/string(customfieldname) = 'Release Noted For']" mode="list">
                <xsl:sort select="number(substring-after(key, '-'))"/>
              </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
              <!-- otherwise, we're using cateogories AND filtering ...-->

              <!-- what we had BEFORE adding category support, in this otherwise...
              <xsl:apply-templates
                select="item[customfields/customfield/string(customfieldname) = 'Release Noted For']"
                mode="list">
                   <xsl:sort select="number(substring-after(key, '-'))"/>
              </xsl:apply-templates> -->

              <!-- emit the categorized items... -->

              <xsl:for-each-group
                select="item[customfields/customfield/string(customfieldname) = 'Release Noted For']"
                group-by="normalize-space(((customfields/customfield[string(customfieldname)= 'Release Note Category']/customfieldvalues/customfieldvalue) | $DEFAULTCATEGORY)[1])">
                <!-- for JCBG-1999, added normalize-space to the group-by expression above, so that category names get leading/trailing spaces trimmed. -->
                <xsl:sort select="current-grouping-key()"/>

                <!-- Category Header Section Wrapper -->
          
                  <xsl:if test="count(current-group()) &gt; 0">
                    <!-- ie, if current group has ANY members at all; otherwise skip this section entirely
                      we need this test because if the $DEFAULTCATEGORY has no members, it still gets processed here due to how we concatenated
                      it to the list in the group-by above
                    -->

                    <xsl:comment>Category Header Section for category "<xsl:value-of
                        select="current-grouping-key()"/>" which has <xsl:value-of
                        select="count(current-group())"/> members.</xsl:comment>
                    <xsl:text>
 </xsl:text>
                    <db:section>
                      <!-- Make a security attribute, maybe:
                        if we don't find any External items in this group, make the section internal-->
                      <xsl:if
                        test="not(current-group()//customfieldvalue[string(.) = 'External'][string(../../customfieldname) = 'Release Noted For'])">
                        <xsl:attribute name="security">internal</xsl:attribute>
                        <xsl:comment>Internal, because all the category's items are internal; making
                          it internal makes it disappear on external builds, when it would have no
                          content.</xsl:comment>
                        <xsl:text>
</xsl:text>
                      </xsl:if>
                                          

                      <!-- Make the section title:
                        if the category is ZZZZ, use title Miscellaneous; otherwise use actual category name 
                              this allows Misc items to sort to the bottom -->
                      <xsl:text>
                            </xsl:text>
                      <db:title>
                        <xsl:choose>
                          <xsl:when test="current-grouping-key() = 'ZZZZ'">Miscellaneous</xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="current-grouping-key()"/>
                          </xsl:otherwise>
                        </xsl:choose>
                      </db:title>


                      <xsl:text>

</xsl:text>
                      <!-- do a processing instruction to stop chunking
                      this puts all the category's items in one page in html
                      -->  
                      <xsl:processing-instruction name="dbhtml">stop-chunking</xsl:processing-instruction>
                      


                      <xsl:for-each select="current-group()">
                        <!-- need to put the sort on the for-each, NOT on the apply below-->
                        <xsl:sort select="number(substring-after(key, '-'))"/>

                        <xsl:apply-templates select="." mode="list"/>

                      </xsl:for-each>
                    </db:section>
                  </xsl:if>
              </xsl:for-each-group> 
            </xsl:otherwise>
       
          </xsl:choose>
          <!-- table wrapper: end stuff -->


        </xsl:element>
        
      </xsl:when>
      <!-- end of list handler -->
    </xsl:choose>
  </xsl:template>

  <!-- 
    ================
    ERROR CATCHING TEMPLATES
    
    catch errors of elements that are output as table or list and should not be;
    output a comment about them, rather than their content-->

  <xsl:template match="*" mode="table">
    <xsl:comment>TABLE mode Unmatched <xsl:value-of select="local-name()"/>.</xsl:comment>
    <xsl:apply-templates mode="table"/>
    <xsl:text>
</xsl:text>

  </xsl:template>

  <xsl:template match="*" mode="list">
    <xsl:comment>LIST mode Unmatched <xsl:value-of select="local-name()"/>.</xsl:comment>
    <xsl:text>
</xsl:text>
    <xsl:apply-templates mode="list"/>
  </xsl:template>



  <!-- =========================================================
    TABLE style's item handler
    (also, RESOLVED, whether you put list OR table) -->

  <!-- this template processes all items, because we're only emitting ones with Release 
        Noted For in known/resolved types; for general, we emit all -->
  <xsl:template match="item" mode="table">

    <xsl:text>
</xsl:text>
    <db:row>
      <!-- row needs a security=internal attribute IFF the item is release noted for =internal-->
      <xsl:if
        test="customfields/customfield[customfieldname[string(.)='Release Noted For']]/customfieldvalues/customfieldvalue[ string(.) ='Internal']">
        <xsl:attribute name="security">internal</xsl:attribute>
      </xsl:if>
      <xsl:text>
   </xsl:text>

      <db:entry colname="1">
        <xsl:text>
      </xsl:text>

        <!-- item descr or link -->
        <!-- ok,  let's think about this. We want to output the following cases:
          1. if internal build, we output internal link.
          2. if external build, we output ID, no link. 
          To do that, we'll output both, each with a different security attrib, so only one gets used.      
          -->
        <db:para security="external">
          <xsl:value-of select="key"/>
        </db:para>
        <xsl:text>
      </xsl:text>

        <db:para security="internal">
          <db:link>
            <xsl:attribute name="xlink:href">
              <xsl:value-of select="link"/>
            </xsl:attribute>
            <xsl:value-of select="key"/>
          </db:link>
        </db:para>
        <xsl:text>
      </xsl:text>
      </db:entry>
      <xsl:text>
      </xsl:text>

      <db:entry colname="2">
        <!-- Here we want the title, but we want to prune off the preceding issue info in [ ], 
          which is different from what we're using in the section template.
        We can do that with substring-after, but only if we can put the value in an expression;
       
        so, we'll populate a variable with the title, using called template
        and then later reference the variable and prune off the item part -->
        <xsl:variable name="TABLEITEMTITLE">
          <xsl:call-template name="itemtitle"/>
        </xsl:variable>
        <db:para>
          <xsl:value-of select="substring-after($TABLEITEMTITLE,'] ')"/>
        </db:para>
      </db:entry>
      <xsl:text>
      </xsl:text>
      <xsl:if test="$TYPE = 'known'">
        <!-- We skip outputting col 3 if this is a resolved issues table -->
        <db:entry colname="3">
          <!-- Now we want to apply templates to all the release note custom field values that match workaround
            or known issues. Verify can put a formalpara in an entry.-->

          <xsl:apply-templates
            select="customfields/customfield[(string(customfieldname) = 'Known Issue') or (string(customfieldname) = 'Workaround')]"/>

        </db:entry>
        <xsl:text>        
        </xsl:text>
      </xsl:if>




    </db:row>
    <xsl:text>

</xsl:text>

  </xsl:template>

  <!-- ====================
       LIST style's item handler
       ===================   -->

  <!-- here's the item handler for a list-based output... -->
  <xsl:template match="item" mode="list">
    <xsl:text>
     </xsl:text>
    <db:section>
      <xsl:attribute name="xml:id">
        <xsl:value-of select="concat($JIRAROOTID,'_', key)"/>
      </xsl:attribute>
      <xsl:if
        test="customfields/customfield[string(customfieldname)= 'Release Noted For']/customfieldvalues/* = 'Internal'">
        <xsl:attribute name="security">internal</xsl:attribute>
      </xsl:if>
      <xsl:text>
      </xsl:text>
      <!-- use called template to get item title, so can check if we need to use Release Note Title field -->
      <db:title>
        <xsl:call-template name="itemtitle"/>
      </db:title>
      <xsl:text>
        </xsl:text>


      <db:formalpara security="internal">
        <db:title>JIRA link</db:title>
        <db:para>
          <db:link>
            <xsl:attribute name="xlink:href">
              <xsl:value-of select="link"/>
            </xsl:attribute>
            <xsl:value-of select="key"/>
          </db:link>
        </db:para>
      </db:formalpara>
      <xsl:text>
      </xsl:text>


      <!-- Now we need to do something different based on whether TYPE='general' -->

      <xsl:choose>
        <xsl:when test="$TYPE='general' or $TYPE='resolved'">
          <db:para>
            <db:remark>Empty paragraph appears here to make the output valid, because this is a
              'general' list.</db:remark>
          </db:para>
        </xsl:when>
        <xsl:otherwise>
          <!-- otherwise, we process Known Issue, Workaround ... -->


          <!-- Known Issues and Workaround sections: push out the appropriate stuff, to
        be handled by other templates -->

          <xsl:apply-templates
            select="customfields/customfield[(string(customfieldname) = 'Known Issue') or (string(customfieldname) = 'Workaround')]"/>
          <!-- I had to specify Known Issues and Workaruond in separate string comparisons to make this work-->

          <!-- if there's no Known Issue/Workaround field, we'll output a blank para here, b/c otherwise our external output will
          have an empty section here, making it invalid. -->
          <xsl:if test="not(customfields/customfield[(string(customfieldname) = 'Known Issue') or (string(customfieldname) = 'Workaround')])">
            <db:para>
              <db:remark>Empty paragraph appears here to make the output valid, because this item has no Known Issue or Workaround yet.</db:remark>
            </db:para>
          </xsl:if>

          <!-- reviewer-only formalpara, for debug information -->

          <db:formalpara security="reviewer">
            <db:title>Test data</db:title>
            <xsl:text>
               </xsl:text>

            <db:para>
              <db:emphasis>Release Noted For:</db:emphasis>
              <xsl:value-of
                select="customfields/customfield[string(customfieldname)= 'Release Noted For']/customfieldvalues/*"
              />
            </db:para>
            <xsl:text>
      </xsl:text>
            <db:para>
              <db:emphasis>Release Note Category:</db:emphasis>
              <xsl:value-of
                select="customfields/customfield[string(customfieldname)= 'Release Note Category']/customfieldvalues/*"
              />
            </db:para>
          </db:formalpara>
          <xsl:text>
               </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </db:section>
    <xsl:text>

</xsl:text>
  </xsl:template>


  <!-- ===================================================
       templates for contents of customfieldvalue elements 
       ===================================================  -->

  <!-- these templates make the sbr and hbr PIs get passed through -->

  <!--
  <xsl:template match="processing-instruction('sbr')">
    <xsl:processing-instruction name="sbr"/> (SBR added here by jira2docbook.xsl) </xsl:template>

  <xsl:template match="processing-instruction('hbr')">
    <xsl:processing-instruction name="hbr"/> (HBR added here by jira2docbook.xsl) </xsl:template>
-->
  <!-- special linebreak PI, because hbr doesn't do anything in chunk
I'm adding 'linebreak' in place of <p> in the ant code in main-build.xml, and then, here, I change it to some docbook 
that will produce a line break.

Note the preceding-sibling predicate below: that makes it match ONLY on linebreaks that have a text node preceding them.
This is to SKIP any line break that is the VERY FIRST THING in the parent element. We don't want to have a line break 
because of a <p> that started off the description.

delete this linebreak thing if we don't end up using it


  <xsl:template match="processing-instruction('linebreak')[preceding-sibling::text()]">
<db:literallayout><xsl:text>
</xsl:text></db:literallayout> ((linebreak converted to literallayout by jira2docbook.xsl)) </xsl:template>
  -->

  <!-- customfield template -->
  <xsl:template match="customfield">
    <db:formalpara>
      <db:title>
        <xsl:value-of select="customfieldname"/>
      </db:title>
      <xsl:apply-templates select="customfieldvalues/customfieldvalue"/>
    </db:formalpara>

  </xsl:template>

  <!-- handling escaped & in the customfield text ... 

now i'm doing this in jiraUnescape.xsl, so can toss this when that works right

-->
  <!-- ok, we want to catch ESCAPED ampersands & unescape them. let's think about this.
     
     I can't search on the exact string &amp; and find that, becaue it is escaped...???
     
     however, .... I can fix that in my OUTPUT file, because... by then, I've only got escaped stuff? 
     ... html??
     ... well, what if i have links that contains escaped & in them, hun? we need to NOT do it to those. 
     but those would not be text nodes? -->

  <!-- to do a replace on all amp, here, we'd need to have that mapping function -->
  <!-- this works but can only repl & with some other char...
  
  <xsl:value-of select="translate(., '&amp;','~')"/>((TEXT NODE THAT HAD an amper)) -->
  <!-- ok, how could i replace & with &? It's already escaped, i want to unescape it.
    Ok, so.. I don't want to replace &amp; with & ... maybe it's more like I want a regex, 
    like replace &amp;.*; with &.*; ... .... i could maybe do that in ant easier. 
    ... or we could use xsl 2.0 and that regex thing on text
    ... or  repl & with some OTHER char and inspect the output anyways ... 
    
    test how this CATCH even works, 
  OK... this match is working and it does replace, and apparently in ONLY the right places.
  The cases that it found were &amp;amp;, &amp;gt;
  ... ok, so... 
  
  <xsl:value-of select="."/>
  ((replace is 
  <xsl:value-of select="function-available('replace')"/> ))
 
  
  -->
  <!-- commenting this out because we should not now need this 
<xsl:template match="text()[contains(.,'&amp;')]">
   <xsl:value-of select="replace(string(.),'&amp;','@ampersand@')"/> 
</xsl:template>  -->


  <!-- convert br to hbr (works in pdf, but hbr has no effect on chunk-->
  <!--
  <xsl:template match="br">
    <xsl:processing-instruction name="hbr"/>((HBR))
    </xsl:template> -->

  <!-- convert br to literallayout one-line; this produces 2 line breaks. -->
  <xsl:template match="br">
    <db:literallayout/>
  </xsl:template>
  <!-- insert ((literallayout)) in above template to track the transformations-->

  <!-- Trim off extra trailing <br/> elements
  
  convert <br/> that is at end of customfieldvalue, to nothing, to trim trailing brs -->



  <!-- this one catches too many brs  <xsl:template match="br[following-sibling::* = '']">(last trailing br)</xsl:template> -->

  <!-- this one catches too many brs
  <xsl:template match="br[../][last()]">(trimmed off trailing br)</xsl:template> -->
  <xsl:template match="br[last() - 1][following-sibling::* = br]">(2nd to last trailing
    br)</xsl:template>
  <xsl:template match="br[last() - 2][following-sibling::* = br]">(3rd to last trailing
    br)</xsl:template>
  <!-- cases to consider:
 
  one br at end ... no following siblings
  two br at end: 
  three or more br at end
  
  i guess we want to catch any br with either no following siblings, or all following siblings are also br?
  but how do we test for that, eh? 
  what if we test for up to 4 br in a row, and leave it at that? That ought to be good enough.
  Catch each of those positions with its own template?
  
  what if we count back from the end? a br which is last?
  
  'a br which is followed by exactly 1 br'
  'a br followed by exactly two br'
  
  but, these expressions have NOT match when there are text nodes btw the brs
  
  -->



  <!-- if the customfieldvalue has any p, then don't wrap in a para... -->
  <xsl:template match="customfieldvalue[p]">
    <xsl:apply-templates select="* | node()"/>
  </xsl:template>

  <!-- if the customfieldvalue has no p in it, it will fall through to this template, which adds para wrapper -->
  <xsl:template match="customfieldvalue">
    <db:para>
      <xsl:apply-templates select="* | node()"/>
    </db:para>
  </xsl:template>

  <xsl:template match="p">
    <db:para>
      <xsl:apply-templates select="* | node()"/>
    </db:para>
  </xsl:template>

  <!-- convert most a elements to links -->
  <xsl:template match="a">
    <db:link>
      <xsl:attribute name="xlink:href">
        <xsl:value-of select="@href"/>
      </xsl:attribute>
      <xsl:apply-templates select="* | node()"/>
    </db:link>
  </xsl:template>

  <!-- JCBG-214: Special case: if it's a link to jira, make it into an internal link plus an external 
  phrase that is not linked... -->
  <xsl:template
    match="a[starts-with(@href,'https://jira.motive.com/')] | a[starts-with(@href,'http://jira-1.be.alcatel-lucent.com')] | a[starts-with(@href,'https://portal.motive.com/')]">
         <!-- JCBG-1504, support portal.motive.com -->
    <db:link security="internal">
      <xsl:attribute name="xlink:href">
        <xsl:value-of select="@href"/>
      </xsl:attribute>
      <xsl:apply-templates select="* | node()"/>
    </db:link>
    <db:phrase security="external">
      <xsl:apply-templates select="* | node()"/>
    </db:phrase>
  </xsl:template>






  <!-- convert html ul tags to itemizedlist in para -->
  <xsl:template match="ul">
    <db:para>
      <db:itemizedlist>
        <xsl:apply-templates select="* | node()"/>
      </db:itemizedlist>
    </db:para>
  </xsl:template>

  <!-- convert html li tags to listitem with para -->
  <xsl:template match="li">
    <db:listitem>
      <db:para>
        <xsl:apply-templates select="* | node()"/>
      </db:para>
    </db:listitem>
  </xsl:template>

  <!-- convert html tt tags to literals -->
  <xsl:template match="tt">
    <db:literal>
      <xsl:apply-templates select="* | node()"/>
    </db:literal>
  </xsl:template>

  <!-- convert html b emphasis bold -->
  <xsl:template match="b">
    <db:emphasis role="bold">
      <xsl:apply-templates select="* | node()"/>
    </db:emphasis>
  </xsl:template>

  <!-- convert html em to db emphasis -->
  <xsl:template match="em">
    <db:emphasis>
      <xsl:apply-templates select="* | node()"/>
    </db:emphasis>
  </xsl:template>

  <!-- convert html span class='error' to plain text -->
  <xsl:template match="span[@class='error']">
    <xsl:apply-templates select="* | node()"/>
  </xsl:template>

  <!-- catch any unhandled html tags and log a message -->
  <xsl:template match="*">
    <!-- to output the key name for what could be any element embedded in a customfieldvalue, need expression for 'my issue's key' 
      that is valid no matter how deep in the nodes we might be; use ancestor ? or preceding sibling ... preceding::key[]1? -->
    <xsl:message terminate="no"> ======== WARNING, unhandled html tag encountered in issue
        <xsl:value-of select="preceding::key[1]"/>, in the '<xsl:value-of
        select="preceding::customfieldname[1]"/>' field, with tag name '<xsl:value-of
        select="local-name(.)"/>' ========= </xsl:message>
    <xsl:apply-templates select="* | node()"/>
  </xsl:template>




  <!-- =========================
       named or called templates 
       =========================   -->

  <xsl:template name="itemtitle">
    <!-- this is a called template whose purpose is return the title of a jira issue - or its release note title, if that exists-->
    <!-- this is designed to be called when the context is an item -->
    <xsl:choose>
      <!-- use release note title, if it exists, and prefix it with the key in brackets 
		 so that it matches a regular title -->
      <xsl:when test="customfields/customfield[string(customfieldname)= 'Release Note Title']">
          [<xsl:value-of select="key"/>] <xsl:value-of
          select="customfields/customfield[string(customfieldname)= 'Release Note Title']/customfieldvalues/customfieldvalue"
        />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="title"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>


  <!-- ============================
       handlers for when there are ONLY internal items 
       ==================================-->

  <!-- this variable set at the top level, but put here to be closer to relevant code-->
  <xsl:variable name="NOEXTERNALITEMSMESSAGE">
    <db:para security="external">None. <db:remark>This paragraph is here because the JIRA query
        produced only internal issues. It is marked "security='external'", so it will show up ONLY
        IN EXTERNAL output. This prevents you from getting an EMPTY TABLE in your external output.
        Since all of the issues listed for this query are set to 'Release Noted For' = 'Internal',
        they will show up only for internal output. </db:remark></db:para>
  </xsl:variable>


<!-- this variable set at the top level, so available to both templates below -->
  <xsl:variable name="NOITEMSMESSAGE">
    No issues found. <db:remark>XXX NO ITEMS FOUND FOR THIS QUERY. Check your query in JIRA;
    make sure it produces results, and if you are using type='known' or 'resolved', make sure there
    are issues that have 'Release Noted For' set to Internal or External.</db:remark></xsl:variable>

  <!-- handlers for when there are no matching items; 
    since I needed to put calls to these in table and list, it was just as easy to have 2 separate templates-->
  
  

  <xsl:template name="no-items-table">
    <db:row>
      <db:entry namest="col1" nameend="col{$cols}">
        <xsl:copy-of select="$NOITEMSMESSAGE"/>
      </db:entry>
    </db:row>
    <xsl:message terminate="no"> ======================================== <xsl:value-of
        select="$NOITEMSMESSAGE"/> ======================================== </xsl:message>

  </xsl:template>


  <xsl:template name="no-items-list">
    <db:para>
      <xsl:copy-of select="$NOITEMSMESSAGE"/>
    </db:para>
    <xsl:message terminate="no"> ======================================== <xsl:value-of
        select="$NOITEMSMESSAGE"/> ======================================== </xsl:message>

  </xsl:template>

</xsl:stylesheet>
