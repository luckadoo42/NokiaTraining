<?xml version='1.0'?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version='1.0' xmlns="http://www.w3.org/1999/xhtml">




  <!-- Determine the issue number to use 
    the idea here is that you can use this var both to decide whether to output an Issue value, and to be the value; if it is null, then you don't output anything
  -->
  <xsl:variable name="ISSUE">
    <xsl:choose>
      <!-- first, use issuenum, when not null -->
      <xsl:when test="//issuenum[1] !=''"><xsl:value-of select="//issuenum[1]"/></xsl:when>
      <!-- next, use edition, when not null -->
      <xsl:when test="//edition[1] !=''"><xsl:value-of select="//edition[1]"/></xsl:when>
      <xsl:otherwise/> <!-- otherwise null-->
    </xsl:choose>
  </xsl:variable>
  
  <!-- how to handle titles, and cover page; overrides template in xhtml/titlepage.xsl 
  this way of doing branding introduced with nokia1 branding. this file to be imported by chunk/nokia1.xsl AND eclipse/nokia1.xsl
  -->
  
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
    


        <xsl:choose>
          <xsl:when test="local-name(..) ='book' or local-name(..) ='bookinfo'">
            <!-- if the title's parent is book or bookinfo, it's the main cover title, and we add cover art-->
            <br/>
            <img style="border-width: 0in; margin-left: 3.75cm;" alt="Logo"
              src="./images/_common/NOKIA_LOGO_RGB.png"/>
            <br/><br/><br/><br/><br/><br/>
            <h2 style="margin-left: 6cm; color: grey;">
              <!-- removed this to allow diff color <xsl:apply-templates select="." mode="class.attribute"/> -->
              <xsl:value-of select="//productnumber[1]"/>
              
            <!-- notice how using //productnumber[1] takes the first productnumber in doc, wherever it is -->

                  <xsl:text> </xsl:text><xsl:value-of select="//productname[1]"/> <br/>
            <xsl:value-of select="//releaseinfo[1]"/> </h2>
            <!-- now figure out the content of the title, and put in $covertitle for later use
            - use covertitle PI's value, if exists, otherwise apply templates
            - and uppercase it
            -->
            <xsl:variable name="covertitle">
                   <xsl:choose>
                    <xsl:when test="string(//processing-instruction('covertitle')) !=''">
                      <!-- if a covertitle PI exists, use that (for JCBG-823) -->
                      <xsl:value-of select="//processing-instruction('covertitle')"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <!-- get the title the usual way -->
                      <xsl:apply-templates mode="titlepage.mode"/>
                    </xsl:otherwise>
                  </xsl:choose>
            </xsl:variable>
            
            <!-- and now here comes the title -->
            <h2 style="margin-left: 6cm;">
            <!--  <xsl:apply-templates select="." mode="class.attribute"/> -->
              <a id="{$id}"/>
              <xsl:choose>
                <!-- if has @revisionflag, use that -->
                <xsl:when test="$show.revisionflag != 0 and @revisionflag">
                  <span class="{@revisionflag}">
                    <xsl:value-of select="$covertitle"/>
                  </span>
                </xsl:when>
                <xsl:otherwise>
                  <!-- otherwise, just output title -->
                  <xsl:value-of select="$covertitle"/>
                </xsl:otherwise>
              </xsl:choose>
            </h2>
            <br/><br/><br/>
            <div style="margin-left: 6cm; font-weight: bold">
              <p><xsl:value-of select="/book/bookinfo/biblioid"/></p>
              <xsl:if test="$ISSUE !=''">
              <p>Issue <xsl:value-of select="$ISSUE"/></p> </xsl:if>
              <p><xsl:value-of select="/book/bookinfo/pubdate"/></p></div>
            <br/><br/>
          </xsl:when>
          <xsl:otherwise>
            <!-- otherwise, output the normal title -->
            <h1><xsl:apply-templates select="."
              mode="class.attribute"/>
              <a id="{$id}"/>
              <xsl:choose>
                <xsl:when test="$show.revisionflag != 0 and @revisionflag">
                  <span class="{@revisionflag}">
                    <xsl:apply-templates mode="titlepage.mode"/>
                  </span>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:apply-templates mode="titlepage.mode"/>
                </xsl:otherwise>
              </xsl:choose></h1>
            
            
          </xsl:otherwise>
        </xsl:choose>
 
 
  </xsl:template>
  
  
</xsl:stylesheet>
