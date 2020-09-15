<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:db="http://docbook.org/ns/docbook"
    xmlns="http://docbook.org/ns/docbook"
    xmlns:file="java.io.File"
    exclude-result-prefixes="#all"
    version="2.0">
    
    <!-- 
        This xslt does several things:
        1. Checks to make sure that all of the images used by the file are available. 
           If any are missing, it prints a list of all that are missing and then 
           terminates (if the param terminate-on-missing-image is set to "yes").
        2. If the format param is set to pdf, the xslt munges all fileref attribute 
           values so that they contain the absolute path to the image so that the fo 
           renderer doesn't have to worry about that. 
        3. If the format param is not set to pdf (i.e. is an html format), 
           two things happen:
           a. The xslt generates and ant script that:
              i.    Converts an .svg images to .png since not all browsers 
                    support svg. 
              ii.   Copies all images to our html staging location and convert any 
                    .svg images to .png. Images that come from xincluded content 
                    are copied into _stage/imagees and have a generated id prepended. 
                    As a result, the directory/file name _stage/stage is reserved.
                    Images that come from content that is NOT xincluded in, 
                    is just copied into the html staging area.
               iii. Copies over certain comman images such as callout graphics (it 
                    calculates the highest callout that would be needed and copies
                    all from 1.png to that number). We don't use admonition 
                    graphics, but if we did, it would check for each kind
                    of admon and copy the image over if it found it.                    
           b. This xslt munges the filref attributes to change svg to png AND 
              munge the paths to images in xincluded content. The details are 
              explained below.
        
        Note: The file/dir names _stage, images/_common, and _xincluded are reserved. 
              TODO: Have the main build check the source dir for these patterns and fail
              if they're found. That is now JCBG-779.
    -->

    <!-- ============================================================================= -->
    <!-- These params must all be passed in by the build (defaults here are for testing only) -->
    <xsl:param name="format">pdf</xsl:param>
    <xsl:param name="staging.top.dir">/home/dcramer/docmodules-stage</xsl:param>
    <xsl:param name="staging.doc.dir">/home/dcramer/docmodules-stage/na71/enus/naug</xsl:param>
    <xsl:param name="doctools">/home/dcramer/doctools20</xsl:param>
    <xsl:param name="branding">motive</xsl:param><!-- If the branding is motive, then copy over the RSA image -->
      <xsl:param name="source-files-up-to-date"/>
    <xsl:param name="security">external</xsl:param><!-- Need this for the file name of the html build file -->
    <xsl:param name="htmlstage" select="concat($staging.doc.dir,'/_stage')"/>
    <!-- ============================================================================= -->

    <!-- Calculate the location of the staging directory for html ouptut -->
    <xsl:param name="htmlstage-images" select="concat($htmlstage,'/images-temp/')"/>
    
    <!-- Generally we want to fail on a missing image. For testing sometimes it's convenient not to. -->
    <xsl:param name="terminate-on-missing-image">yes</xsl:param>
    
    <!-- ============================================================================= -->


    <xsl:include href="../../../docbook-xsl/1.72.0/common/stripns.xsl"/>

    <xsl:variable name="missing-images">
        <xsl:apply-templates select="//db:imagedata" mode="check-file"/>
    </xsl:variable>
    
    <xsl:template match="db:imagedata" mode="check-file">
        <xsl:if test="not(ends-with(@fileref,'doctools/DocShared/content/images/checkbox.png')) and not(@fileref = 'images/_common/checkbox.png')">
            <xsl:if test="not(file:exists(file:new(resolve-uri(@fileref, base-uri(.)))))">
                <imagedata fileref="{resolve-uri(@fileref, base-uri(.))}"/>             
            </xsl:if> 
        </xsl:if> 
    </xsl:template>
    
    <xsl:template match="/">        
        <xsl:if test="count($missing-images/*) &gt; 0">            
            <xsl:message>
                <xsl:value-of select="count($missing-images/*)"/> image<xsl:if test="count($missing-images/*) &gt; 1">s</xsl:if> missing: <xsl:text>
                </xsl:text>
                <xsl:for-each select="$missing-images/*">
                    <xsl:value-of select="@fileref"/><xsl:choose><xsl:when test="following-sibling::*">, <xsl:text>       
                    </xsl:text></xsl:when><xsl:otherwise>. </xsl:otherwise></xsl:choose> 
                </xsl:for-each>
            </xsl:message>
            <xsl:if test="$terminate-on-missing-image = 'yes'">
                <xsl:message terminate="yes"/>
            </xsl:if>
        </xsl:if>

        <xsl:variable name="filerefs-adjusted">
            <xsl:apply-templates/>
        </xsl:variable>
        
        <xsl:if test="not($format = 'pdf')">
            <xsl:call-template name="make-ant"/>
        </xsl:if>
        
        <xsl:apply-templates select="$filerefs-adjusted" mode="stripNS"/>
        
    </xsl:template>
    
    <xsl:template name="make-ant">
        <xsl:result-document indent="yes" href="file:///{concat($staging.top.dir,'/copy-images-build-',$security ,'.xml')}" xmlns=""><!-- TODO: Figure out where this should go. -->
            <project default="main">
                
                <!-- Make a batik classpath property equal to list of jars in the lib folder -->
            
                
                <pathconvert property="batik-classpath">
                    <fileset>
                        <xsl:attribute name="dir"><xsl:value-of select="$doctools"/>/lib</xsl:attribute>
                        <include name="*.jar"/>
                    </fileset>
                </pathconvert>
                

                    
                <target name="main">
<!-- Tried very hard to get the rasterize task to work; always failed. David Cramer had apparently tried 
    the same thing, because the commented out code below was his. -Aaron D
    <taskdef name="rasterize" 
    classname="org.apache.tools.ant.taskdefs.optional.RasterizerTask" classpath="{$batik-classpath}"/> -->
                    <xsl:apply-templates select="//db:imagedata" mode="copy-images"/>
                    <xsl:variable name="calloutcounts">
                        <!-- 
                            Calculate longest calloutlist: 
                            Store list of co counts in a variable, then sort the list, then take the last one
                            Copy all callouts from 1 to the highest callout to the staging dir, ./images/_common 
                        -->
                        <xsl:apply-templates select="//*[./db:co]" mode="count-callouts">
                            <xsl:sort select="count(.//db:co)" data-type="number"/>
                        </xsl:apply-templates>
                    </xsl:variable> 
                    <xsl:if test="count(//db:co[1]) &gt; 0">
                        <xsl:message>
                            Highest callout #: <xsl:value-of select="$calloutcounts//db:item[last()]/@count"/>                           
                        </xsl:message>
                        <copy todir="{$htmlstage-images}/images/_common">
                            <fileset dir="{$doctools}/DocShared/content/images/callouts">
                                    <xsl:attribute name="includes">
                                        <xsl:call-template name="copy-callout">
                                            <xsl:with-param name="count" select="$calloutcounts//db:item[last()]/@count"/>
                                        </xsl:call-template>                                               
                                    </xsl:attribute>
                            </fileset>
                        </copy>
                    </xsl:if>                    
                    <!-- If the doc contains db:itemizedlist[@role = 'checklist'] -->
                    <xsl:if test="//db:variablelist[@role = 'checklist']">
                        <echo>Copying checkbox image to images/_common.</echo>
                        <copy todir="{$htmlstage-images}images/_common">
                            <fileset dir="{$doctools}/DocShared/content/images">
                                <include name="checkbox.png"/>
                            </fileset>
                        </copy>
                    </xsl:if>
                   <!-- If the branding is motive, motive2 or alcatel2, then copy over the RSA image (JCBG-133)-->
                    <xsl:if test="$branding = 'motive' or $branding = 'alcatel2' or $branding = 'motive2' or substring($branding,1,5) = 'nokia'">
                        <echo>Copying RSA logo file to images/_common</echo>
                        <copy todir="{$htmlstage-images}images/_common">
                            <fileset dir="{$doctools}/DocShared/content/images">
                                <include name="RSA_Secured_logo.gif"/>
                            </fileset>
                        </copy>
                    </xsl:if>
                    <!-- If the branding is alcatel2 or motive2, then copy over the cover image (JCBG-133) -->
                    <xsl:if test="$branding = 'alcatel2' or $branding = 'motive2'">
                        <echo>Copying cover image file to images/_common</echo>
                        <copy todir="{$htmlstage-images}images/_common/">
                            <fileset dir="{$doctools}/DocShared/content/images/alcatel2">
                                <include name="cityimage.png"/>
                            </fileset>
                        </copy>
                      </xsl:if>
                    
                    <!-- If the branding starts with nokia, then copy over the logo -->
                    <xsl:if test="substring($branding,1,5) = 'nokia'">
                        <echo>Copying cover image file to images/_common</echo>
                        <copy todir="{$htmlstage-images}images/_common/">
                            <fileset dir="{$doctools}/DocShared/content/images/nokia1/">
                                <include name="NOKIA_LOGO_RGB.png"/>
                            </fileset>
                        </copy>
                    </xsl:if>
                    <!-- 
                        NOTE: If you use admon graphics, you would want to add a test
                               here to check for each and copy over the graphic if uses. 
                               e.g. <if test="//important">...
                    -->
                    
                    
                </target>
            </project>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="*" mode="count-callouts">
        <item count="{count(.//db:co)}"/>
    </xsl:template>
    
    <!-- A for-loop to list the callout image names we need to copy to the staging area -->
    <xsl:template name="copy-callout">
        <xsl:param name="count" select="1"/>
        <xsl:if test="$count &gt; 0">
            <xsl:value-of select="$count"/><xsl:text>.png</xsl:text><xsl:if test="$count &gt; 1"><xsl:text>,</xsl:text></xsl:if>
            <xsl:call-template name="copy-callout">
                <xsl:with-param name="count" select="$count - 1"/>
            </xsl:call-template>        
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="db:imagedata" mode="copy-images">
        <!-- 
            If format != pdf, then we need to do some munging: 
            If ends-with svg, then change to png:
            
            <xsl:variable name="fileref">
              <xsl:value-of select="replace(@fileref,'(.*)(\.[sS][vV][gG])','$1')"/><xsl:if test="matches(@fileref,'(.*)(\.[sS][vV][gG])')">.png</xsl:if>
            </xsl:variable>                         
            
            Case 1: If dirname of base-uri(.) = dirname of base-uri(/) AND not(contains(@fileref,'..')) then just copy whole dir structure of @fileref to output basedir dir.
                    Just copy the images to the html staging area with no changes. 
            Case 2: If not(dirname of base-uri(.) = dirname of base-uri(/)) or contains(@fileref,'..') then copy image file to _xincluded/{generate-id(.)}-{replace(@fileref,'.*/(.*)','$1')}
                    Copy the image file to images/_xincluded and prepend a generated id to avoid name collisions. 
                        
            We use this same algorithm to munge fileref values (above).
            
            TODO: In Holmanization xsl, add an xml:base attribute to the borrowed content. 
            Need to figure out how to find the current file's name. I think there's 
            a way to do that in xslt 2.0. OR just use the value of sharer_doc as a proxy?
            If you do this, it should take care of images in holmanized content and 
            xincludes in holmanized content. 
        -->    
        <xsl:variable name="fqfileref">
            <xsl:choose>
                <xsl:when test="substring(@fileref,2,1) = ':'"><xsl:value-of select="@fileref"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="substring-after(resolve-uri(@fileref, base-uri(.)),'file:')"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable> 
        <xsl:variable name="fileref">
            <xsl:value-of select="normalize-space(replace(@fileref,'(.*)(\.[sS][vV][gG])','$1'))"/><xsl:if test="matches(@fileref,'(.*)(\.[sS][vV][gG])')">.png</xsl:if>
        </xsl:variable> 
        
        <xsl:if test="matches(@fileref,'(.*)(\.[sS][vV][gG])') and (not($source-files-up-to-date = 'true') or not(file:exists(file:new(concat(replace($fqfileref,'(.*)(\.[sS][vV][gG])','$1'),'.png')))))">
            <!-- 
                Rasterize it and copy it to correct destination. Only rasterize if the file name ends in .svg and either the source files are not up-to-date or the target file doesn't exist.
                The target file might not exist if, e.g. we did an external spin before and now are doing an internal one. 
            -->
      
            <echo xmlns="">Rasterizing <xsl:value-of select="$fqfileref"/></echo>
            <exec xmlns="" executable="java" failonerror="true">
                <arg line="-cp '${{batik-classpath}}' org.apache.batik.apps.rasterizer.Main"/>
                <arg value="-scriptSecurityOff"/>
                <xsl:choose>
                    <xsl:when test="substring($fileref,3,1) = ':'">
                        <arg value="{substring-after(replace($fqfileref,'%20',' '), '/')}"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <arg value="{replace($fqfileref,'%20',' ')}"/>
                    </xsl:otherwise>
                </xsl:choose>
                
            </exec>
            
        </xsl:if>
        <!-- Use algorithm where you compare base-uri of imagedata with baseuri of root and do the copy based on that. --> 
        <xsl:choose>
            <xsl:when test="replace(base-uri(/),'(.*/).*','$1') = replace(base-uri(.),'(.*/).*','$1') and not(contains($fileref,'..'))">
                <copy xmlns=""  todir="{$htmlstage-images}">
                    <fileset dir="{replace(substring-after(replace(base-uri(.),'(.*/).*','$1'),'file:'),'%20',' ')}" includes="{$fileref}"/>
                </copy>
            </xsl:when>
	  <xsl:when test="@fileref = 'images/_common/checkbox.png' or substring(@fileref,2,1) = ':'">
		<!-- Ignore, checkbox.png is copied elsewhere -->
	  </xsl:when>
            <xsl:otherwise>
                <copy xmlns=""  file="{replace(substring-after(resolve-uri($fileref, base-uri(.)), 'file:'),'%20',' ')}" 
                    tofile="{$htmlstage-images}/images/_xincluded/{generate-id(.)}-{replace(resolve-uri($fileref, base-uri(.)),'(.*/)(.*)','$2')}"/>         
            </xsl:otherwise>
        </xsl:choose>           
    </xsl:template>

    <xsl:template match="db:imagedata">
       <!-- Break the build if the doc contains an imagedata with an empty fileref -->
	    <xsl:if test="normalize-space(@fileref)=''">
           <xsl:message terminate="yes">

<xsl:text>
BUILD FAILURE: EMPTY FILREF. You have an imagedata element with an empty fileref attribute. 
</xsl:text>
<xsl:text> 
</xsl:text>

		   </xsl:message>
        </xsl:if>
        <imagedata>
            <xsl:apply-templates select="@*"/>
            <xsl:choose>
                <xsl:when test="@fileref = 'images/_common/checkbox.png' or ends-with(@fileref,'doctools/DocShared/content/images/checkbox.png')"/>
                <xsl:when test="$format = 'pdf'">
                    <!-- If format = pdf, then just convert filerefs to absolute path: -->
                    <xsl:attribute name="fileref" select="resolve-uri(@fileref, base-uri(.))"/>
                </xsl:when>
                <xsl:otherwise>                                                        
                    <xsl:variable name="fileref">
                        <xsl:value-of select="replace(@fileref,'(.*)(\.[sS][vV][gG])','$1')"/><xsl:if test="matches(@fileref,'(.*)(\.[sS][vV][gG])')">.png</xsl:if>
                    </xsl:variable>                     
		  <xsl:choose>
                        <xsl:when test="replace(base-uri(/),'(.*/).*','$1') = replace(base-uri(.),'(.*/).*','$1') and not(contains(@fileref,'..'))">
                            <xsl:attribute name="fileref" select="$fileref"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute 
                                name="fileref" 
                                select="concat('images/_xincluded/',generate-id(.),'-',replace(resolve-uri($fileref, base-uri(.)),'(.*/)(.*)','$2'))"/>
                        </xsl:otherwise>
                    </xsl:choose>                    
                </xsl:otherwise>
            </xsl:choose>

            <!--xsl:message>
                Some experiments:                
                =============================================
                @fileref: <xsl:value-of select="@fileref"/>
                base-uri(.): <xsl:value-of select="base-uri(.)"/>
                base-uri(/): <xsl:value-of select="base-uri(/)"/>
                resolve-uri(@fileref, base-uri(.)): <xsl:value-of select="resolve-uri(@fileref, base-uri(.))"/>
                regexp1: <xsl:value-of select="replace(resolve-uri(@fileref, base-uri(.)),'(.*/)(.*)','$1')"/>
                regexp2: <xsl:value-of select="replace(base-uri(/),'(.*/).*','$1')"/>
                regexp3: <xsl:value-of select="replace(base-uri(.),'(.*/).*','$1')"/>
                regepx4: <xsl:value-of select="replace(@fileref,'(.*)(\.[sS][vV][gG])','$1')"/><xsl:if test="matches(@fileref,'(.*)(\.[sS][vV][gG])')">.png</xsl:if>
                =============================================        
            </xsl:message-->
        </imagedata>
    </xsl:template>
    
    <xsl:template match="@*|node()">
                <xsl:copy>
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:copy>               
    </xsl:template> 

</xsl:stylesheet>
