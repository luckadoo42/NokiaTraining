<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mod="http://motive.com/techpubs/module"
    exclude-result-prefixes="xs mod" version="2.0">

    <xsl:param name="doctools"
        >/home/dcramer/workhead-nextgen/branches/na71/target/doctools</xsl:param>
    <xsl:param name="PLANID">NOTSET</xsl:param>
    <xsl:param name="BUILD_URL">NOTSET</xsl:param>
    <xsl:param name="BUILDNUMBER">0</xsl:param>
    <!-- This parameter should already be set. -->
    <xsl:param name="module.dir"/>
    <xsl:param name="mailhost"/>

    <!-- As of Feb 2017, this script has these passes: 
 * template-pass mode: 
   Handles the <template> elements before the "preprocess" pass.
   Output:  $templates-processed

 * preprocess mode: 
   Removes items that are disabled; removes PDF format if IC format at same security is requested.
   Input:  $templates-processed
   Output: $preprocessed

 * sort mode: Sorts the $documents variable
   Input:  $documents, which is generated from $preprocessed in <xsl:template match="/">
-->

    <xsl:variable name="emails">
        <xsl:for-each select="//mod:email">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="not(position() = last())">
                <xsl:text>,</xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>

    <xsl:output indent="yes"/>

    <!--Preprocess mode section 
        
        Use a mode to preprocess the input, throwing out any items marked disabled='true' or 'yes' 
    
    
    Note re: debugging this script: it is useful to comment-out one mode or the other - for example, to debug
    the preprocess stuff, it's useful to comment out all the main mode stuff 
    
    (but that requires that you add the two templates shown below, to make the script produce any 
    output at all)
    
    
    <xsl:template match="mod:writeronly" 
    mode="preprocess">
    <dummy/>
    </xsl:template> 
    
    <xsl:template match="/">
    <xsl:copy><xsl:apply-templates select="$preprocessed/*"/></xsl:copy>
    </xsl:template>
    <xsl:template match="node() | @*" >
    <xsl:copy>
    <xsl:apply-templates select="node() | @*" mode="preprocess"/>
    </xsl:copy>
    </xsl:template>
    
 -->

    <!-- store everything in a variable named $preprocessed, after preprocessing it -->
    <xsl:variable name="preprocessed">
        <xsl:apply-templates select="$templates-processed/node()|$templates-processed/@*"
            mode="preprocess"/>
    </xsl:variable>
    <!-- noop template throws out elements that have @disabled set ... -->
    <xsl:template match="*[@disabled = 'true' or @disabled = 'yes']" mode="preprocess"/>

    <!-- JCBG-1980: Create a "template" pass to handle the <template> elements before the "preprocess" pass. -->
    <xsl:variable name="templates-processed">
        <xsl:apply-templates select="node()|@*" mode="template-pass"/>
    </xsl:variable>

    <!-- JCBG-1980 (Overview): Simplify module.xml and centralize <format> children in templates. -->
    <!-- JCBG-1980 (Case 1/5): The <document> has <format> children and no template attribute...handled same as before JCBG-1980. -->
    <!-- For each template, handle the <document> elements that use that template. -->
    <xsl:template match="//mod:template" mode="template-pass">
        <xsl:variable name="template-name" select="./@name"/>
        <xsl:comment>### Matched template: <xsl:value-of select="$template-name"/></xsl:comment>
        <xsl:for-each select="//mod:document[@template = $template-name]">
            <xsl:variable name="dir-name">
                <xsl:value-of select="./@dir"/>
            </xsl:variable>
            <xsl:choose>
                <!-- JCBG-1980 (Case 2/5): The <document> has a <format> child and a template, so fail. -->
                <xsl:when test="mod:format">
                    <xsl:comment>### Case 2 (format / template)</xsl:comment>
                    <xsl:message terminate="yes">The document with dir=<xsl:value-of
                            select="$dir-name"/> has both a template attribute and a "format" child
                        element. It can have no more than one of these items.</xsl:message>
                </xsl:when>

                <!-- JCBG-1980 (Case 3/5): The <document> has no <format> child, so write the <document> using the template's <format> children. -->
                <xsl:when test="not(mod:format)">
                    <xsl:comment>### Case 3 (no format / template)</xsl:comment>
                    <xsl:element name="document" namespace="http://motive.com/techpubs/module">
                        <xsl:attribute name="dir" select="$dir-name"/>
                        <xsl:copy-of select="//mod:template[@name = $template-name]/*"/>
                    </xsl:element>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <!-- JCBG-1980 (Case 4/5): A <document> that has no <format> children and no template attribute, so use the "default" template. -->
    <xsl:template match="//mod:document[not(./mod:format)][not(@template)]" mode="template-pass">
        <xsl:comment>### No format / no template</xsl:comment>
        <xsl:variable name="dir-name">
            <xsl:value-of select="./@dir"/>
        </xsl:variable>
        <!-- If the default template exists. -->
        <xsl:if test="exists(//mod:template[@name = 'default'])">
            <xsl:comment>### Case 4-a (default template exists)</xsl:comment>
            <xsl:element name="document" namespace="http://motive.com/techpubs/module">
                <xsl:attribute name="dir">
                    <xsl:value-of select="$dir-name"/>
                </xsl:attribute>
                <xsl:copy-of select="/mod:module/mod:template[@name = 'default']/*"/>
            </xsl:element>
        </xsl:if>
        <!-- If the default template does not exist. -->
        <xsl:if test="not(exists(//mod:template[@name = 'default']))">
            <xsl:comment>### Case 4-b (default template does NOT exist)</xsl:comment>
            <xsl:message terminate="yes">The document with dir=<xsl:value-of select="$dir-name"/>
                has no "format" child elements and no template attribute. With those items missing,
                a template element with the name "default" is used. However, no such template was
                found. Choose one of the following options: * Define a "default" template. * Specify
                a template attribute and value for the "document" element. * Specify one or more
                "format" child elements for the "document" element.</xsl:message>
        </xsl:if>
    </xsl:template>

    <!-- JCBG-1980 (Case 5/5): Check for any <document> elements that specify a template attribute that does NOT match a defined template. -->
    <xsl:template match="mod:document[@template][not(//mod:template[@name = current()/@template])]"
        mode="template-pass">
        <xsl:variable name="named-template" select="./@template"/>
        <xsl:value-of select="$named-template"/>
        <xsl:comment>### Case 5 (document specifies a template that does NOT exist)</xsl:comment>
        <xsl:message terminate="yes">One or more documents has a template attribute of
                "<xsl:value-of select="./@template"/>." There is no template with that name. Check
            for typos in the "template" element name attributes and in the "document" element
            template attributes.</xsl:message>
    </xsl:template>

    <!-- JCBG-1980: Need to throw out <document> elements with a template attribute and 
        no <format> children because they're getting into the intermediate file. -->
    <xsl:template
        match="//mod:document[not(./mod:format)][@template][//mod:template[@name = ./@template]]"
        mode="template-pass"/>

    <!-- here's the copy template required to make the preprocess mode work -->
    <xsl:template match="node() | @*" mode="preprocess">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*" mode="preprocess"/>
        </xsl:copy>
    </xsl:template>

    <!-- JCBG-1980: here's the copy template required to make the template-pass mode work -->
    <xsl:template match="node() | @*" mode="template-pass">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*" mode="template-pass"/>
        </xsl:copy>
    </xsl:template>



    <!-- hack to fix JCBG-108: noop to throw out pdf when building infocenter of same security 
    
    This is a hack because this xsl produces an error (JCBG-108): if you include a PDF and an infocenter output of
    the same security level, the derived ant code does NOT specify the PDF. But if you don't include PDF
    of same security as the infocenter output, then the script correctly adds it in. We want PDF in either case.
    
    Since specifying the PDF is not needed AND causes an error, this hack simply filter it out during this preprocess
    stage.
     
    Match on: PDF (format[@name = 'pdf']
    with sibling format infocenter (@name=eclipse-infocenter)
    and both have the same element names...
    compare the current() node name to the context (.) node name in the expression...


This would probably cause a problem if you 
tried to build multiple pdfs of same security but with different properties
(since I plan to add the ability to assign properties in module.xml)
but that could be fixed by additional stuff in the match below ... -Aaron DaMommio


    -->
    <!--  with new predicate
    <xsl:template match="mod:format[@name = 'pdf']/*[../../mod:format[@name='eclipse-infocenter'][@disabled !='true']/*[local-name(.)=local-name(current())]]"
        mode="preprocess"/>
    -->

    <xsl:template
        match="mod:format[@name = 'pdf']/*[../../mod:format[@name='eclipse-infocenter']/*[local-name(.)=local-name(current())]]"
        mode="preprocess"/>





    <!-- end of preprocess mode stuff -->

    <!-- main mode stuff will now operate on the variable $preprocessed -->




    <xsl:template match="/">

        <!-- JCBG-1980: Save $templates-processed for debugging -->
        <xsl:message terminate="no">Generating copy of $templates-processed in
            temp-templates-processed.xml</xsl:message>
        <xsl:result-document href="temp-templates-processed.xml">
            <xsl:copy-of select="$templates-processed/*"/>
        </xsl:result-document>

        <!-- JCBG-1980: Save $preprocessed for debugging -->
        <xsl:message terminate="no">Generating copy of $preprocessed in
            temp-preprocessed.xml</xsl:message>
        <xsl:result-document href="temp-preprocessed.xml">
            <xsl:copy-of select="$preprocessed/*"/>
        </xsl:result-document>

        <project basedir="../..">
            <taskdef resource="net/sf/antcontrib/antlib.xml">
                <classpath>
                    <pathelement location="{$doctools}/lib/ant-contrib-1.0b3.jar"/>
                </classpath>
            </taskdef>
            <xsl:if test="not($preprocessed/mod:module/mod:document/mod:format/*)">
                <xsl:message terminate="yes"> ERROR: No documents to build in module.xml file.
                </xsl:message>
            </xsl:if>

            <!-- JCBG-2090: Exit if an eclipse format has multiple children with publish="true" attributes. -->
            <xsl:for-each
                select="$preprocessed/mod:module/mod:document/mod:format[contains(@name,'eclipse')]">
                <xsl:if test="count(./*[@publish='true']) > 1">
                    <xsl:message terminate="yes"> ERROR: An eclipse format has more than one
                        security with a publish="true" attribute. Update your module.xml so that no
                        eclipse format has more than one such security. </xsl:message>
                </xsl:if>
            </xsl:for-each>

	    <!-- write out the notification list for use by Jenkinsfile, to a file
		 this is later picked up by Jenkinsfile to use to send notifications
	   
	    <echo>Now writing notification list from module file to a file 'target/notificationList.txt' for use by Jenkinsfile later: using this list: <xsl:value-of select="$emails"/></echo>
	    <echo file="target/notificationList.txt"><xsl:value-of select="$emails"/></echo>

	     for debug, writing out the notification list file to the console 
	    <concat><filelist dir="target" files="notificationList.txt"/></concat>
	    -->

            <xsl:variable name="documents">
                <xsl:apply-templates select="$preprocessed/mod:module/mod:document"/>
            </xsl:variable>

            <!-- JCBG-1980: Save $documents for debugging -->
            <xsl:message terminate="no">Generating copy of $documents in
                temp-documents.xml</xsl:message>
            <xsl:result-document href="temp-documents.xml">
                <xsl:copy-of select="$documents/*"/>
            </xsl:result-document>

            <xsl:apply-templates select="$documents/*" mode="sort">
                <xsl:sort select="local-name()" order="descending"/>
            </xsl:apply-templates>

            <!-- JCBG-1646, adding code to generate external war files based on an attribute on the module element 
            this to go at END of the generated ant file
            -->
            <xsl:if test="/mod:module/@war">
                <!-- if there exists an @war -->
                <xsl:message> External war: In module2build.xsl, I detected an @war with value
                        <xsl:value-of select="/mod:module/@war"/> and am therefore outputting code
                    to build an external-war. </xsl:message>
                <ant antfile="build.xml" dir="{/mod:module/@war}" inheritall="false">
                    <target name="external-war"/>
                    <property name="security" value="external"/>
                    
                    <!-- for jcbg-2099, passing down these additional properties -->
                    <property name="jira.uname" value="${jira.uname}"/>
                        <property name="jira.password" value="${jira.password}"/>

                    <xsl:if test="boolean($emails)">
                        <!-- for jcbg-1250, pass down a notification property -->
                        <property name="notification-list" value="{$emails}"/>
                    </xsl:if>

                </ant>
            </xsl:if>

            <!-- JCBG-2091, process war elements to make war outputs -->
            <xsl:for-each select="/mod:module/mod:war">
                <xsl:if test="/mod:module/@war">
                    <!-- if there exists an @war, throw an error because you can't have both @war and war elements -->
                    <xsl:message terminate="yes">ERROR: You have a war attribute on your module
                        element, AND one or more war elements; you can't have both.</xsl:message>
                </xsl:if>

                <xsl:message> WAR FILE: In module2build.xsl, I detected a war element pointing at
                    folder [<xsl:value-of select="./mod:folder"/>] and am therefore outputting code to
                    build a war from that folder. </xsl:message>
                
                <ant antfile="build.xml" dir="{./mod:folder}" inheritall="false">
                    <target name="external-war"/>
                    <property name="security" value="external"/>

                    <xsl:if test="boolean($emails)">
                        <!-- for jcbg-1250, pass down a notification property -->
                        <property name="notification-list" value="{$emails}"/>
                    </xsl:if>

                </ant>
            </xsl:for-each>

            <!-- JCBG-1371 (check-urls.xsl). Check whether the file found.invalid.urls.flag exists. Send email if that file exists. -->
            <!-- JCBG-2028 (not getting email). Moved code here so that it is inserted in the build.xml file regardless of failonerror settings. -->
            <echo>JCBG-2028 test: About to check whether found.invalid.urls.flag exists.</echo>
            <if>
                <available file="{$module.dir}/target/found.invalid.urls.flag"/>
                <then>
                    <!-- Delete file in preparation for next build. Send email about the invalid URLs. -->
                    <echo>JCBG-2028 test: found.invalid.urls.flag exists.</echo>
                    <delete file="{$module.dir}/target/found.invalid.urls.flag"/>

                    <!-- JCBG-2024: Use filterchain to grep | sort | uniq the log file to get only the lines to include in a temp file. -->
                    <copy file="{$module.dir}/target/check-urls.log"
                        tofile="{$module.dir}/target/check-urls.log-tmp">
                        <filterchain>
                            <linecontains>
                                <contains value="[check-urls WARNING]"/>
                            </linecontains>
                            <sortfilter/>
                            <tokenfilter>
                                <uniqfilter/>
                            </tokenfilter>
                        </filterchain>
                    </copy>
                    <!-- JCBG-2024: Move the temp file back to the original file to send in mail message. -->
                    <move file="{$module.dir}/target/check-urls.log-tmp"
                        tofile="{$module.dir}/target/check-urls.log"/>

                    <echo>Sending email about invalid URLs to: <xsl:value-of select="$emails"
                        /></echo>
                    <!-- JCBG-2024: Tweaked the text in this echo. -->
                    <!-- JCBG-2037: Set the hostname value to use in the email. -->
                    <property environment="env"/>
                    <exec executable="hostname" osfamily="unix" failifexecutionfails="false"
                        outputproperty="env.COMPUTERNAME"/>
                    <property name="hostname" value="${{env.COMPUTERNAME}}"/>

                    <mail from="noeply@nokia.com" tolist="{$emails}"
                        subject="Build: Found invalid URLs or the URL checking failed"
                        mailhost="{$mailhost}"
                        files="{$module.dir}/target/check-urls.log" failonerror="false">
                        <!-- JCBG-2024: Added the files attribute on previous line. Updated the message text below. -->
                        <message> You are receiving this message because a build found invalid URLs.
                            The detection of invalid URLs does not fail the build. --- The build was
                            run by the following user on the indicated host. User: ${user.name}
                            Host: ${hostname} --- For information about the invalid URLs, see one of
                            the following items: * The WARNINGS section below that lists only the
                            invalid URLs and if the URL checker failed. NOTE: Each invalid
                            URL--regardless of how many times it appears in your docs--is listed
                            only once. Check your files carefully for multiple occurrences of each
                            invalid URL. * The full build log at:

			    <xsl:value-of select="$BUILD_URL"/>consoleFull

                            To find problems in the build log,
                            search for the following text: [check-urls WARNING] For more
                            information, see
                            http://pubs.motive.com/info/topic/toolsguide/invalidURLs.html. = = =
                            WARNINGS = = = </message>
                    </mail>
                    <!-- JCBG-2024: Delete log; otherwise, local builds will add to existing log. -->
                    <delete file="{$module.dir}/target/check-urls.log"/>

                </then>
                <else>
                    <echo>JCBG-2028 test: found.invalid.urls.flag not found.</echo>
                </else>
            </if>
        </project>

    </xsl:template>


    <xsl:template match="*" mode="sort">
        <xsl:copy-of select="."/>
    </xsl:template>

    <xsl:template match="mod:notification"/>

    <xsl:template match="mod:document">

        <!-- setting this up top now, as a variable
        <xsl:param name="emails">
          <xsl:for-each select="ancestor-or-self::*[./mod:notification][1]/mod:notification/mod:email"><xsl:value-of select="normalize-space(.)"/><xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>
        </xsl:param>    -->


        <!-- Note that the delimiter above must be a comma, not a semicolon; making it a comma fixes JCBG-265 -->


        <xsl:for-each-group select="./mod:format/mod:*[ancestor-or-self::*/@failonerror = 'false']"
            group-by="local-name()">
            <xsl:variable name="security" select="current-grouping-key()"/>
            <xsl:variable name="targets">
                <xsl:if
                    test="current-group()[parent::mod:format/@name = 'eclipse-infocenter'] and not(current-group()[parent::mod:format/@name = 'pdf'])">
                    <target name="pdf"/>
                </xsl:if>
                <xsl:for-each select="current-group()">
                    <xsl:choose>
                        <xsl:when
                            test="parent::mod:format/@name = 'eclipse-infocenter' and @publish = 'true'">
                            <target name="publish-eclipse-infocenter"/>
                        </xsl:when>
                        <xsl:when
                            test="parent::mod:format/@name = 'eclipse-help' and @publish = 'true'">
                            <target name="publish-eclipse-help"/>
                            <!-- Added this for JCBG-780 -->
                        </xsl:when>
                        <xsl:otherwise>
                            <target name="{parent::mod:format/@name}"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="targets-text">
                <xsl:for-each select="$targets/*">
                    <xsl:value-of select="@name"/>
                    <xsl:if test="position() != last()">, </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <trycatch>
                <try>
                    <ant antfile="build.xml" dir="{ancestor::mod:document/@dir}" inheritall="false">
                        <xsl:copy-of select="$targets"/>
                        <property name="security" value="{$security}"/>
                        <!-- for jcbg-2099, passing down these additional properties -->
                        <property name="jira.uname" value="${jira.uname}"/>
                        <property name="jira.password" value="${jira.password}"/>
                        <xsl:if test="boolean($emails)">
                            <!-- for jcbg-1250, pass down a notification property -->
                            <property name="notification-list" value="{$emails}"/>
                        </xsl:if>
                        <xsl:if test="ancestor-or-self::*[@infocenter][1]">
                            <property name="infocenter"
                                value="{ancestor-or-self::*[@infocenter][1]/@infocenter}"/>
                        </xsl:if>
                    </ant>
                </try>
                <catch>
                    <!-- JCBG-148 Send email in local build, too. -->
                    <property environment="env"/>
                    <exec executable="hostname" osfamily="unix" failifexecutionfails="false"
                        outputproperty="env.COMPUTERNAME"/>
                    <property name="hostname" value="${{env.COMPUTERNAME}}"/>

                    <!-- jcbg-1398, changed sender name from mpd-techpubsall to donotreply@motive.com,
	special address for the purpose of senders like this -->

                    <echo>Sending email re: failure to: <xsl:value-of select="$emails"/></echo>
                    <mail from="noreply@nokia.com" tolist="{$emails}"
                        subject="{ancestor::mod:document/@dir} build failed: ({$targets-text}) [{$security} security]...could not create formats."
                        mailhost="{$mailhost}" failonerror="false">
                        <message>Build failed: Could not create formats (<xsl:value-of
                                select="$targets-text"/> [<xsl:value-of select="$security"/>
                            security for <xsl:value-of
                                select="concat(ancestor::mod:document/@dir,'/',ancestor::mod:document/@file)"
                            />] The build failed to create certain specific output formats in a
                            specific security setting, as described above. <xsl:value-of
                                select="current-dateTime()"/>
                            <!-- JCBG-148 Send email in local build, too. Add info to help one see that it's a local build. -->
                            --- The build was run by the following user on the indicated host. User:
                            ${user.name} Host: ${hostname} --- TO LOCATE THE ISSUE Search for
                            "failed:" (no quotes) in the build log:

			    <xsl:value-of select="$BUILD_URL"/>consoleFull

			    
                            For more information, see the following
                            Tools Guide topic: Email: "Build failed: Could not create formats
                            (format_list)" at
                            http://pubs.motive.com/info/topic/toolsguide/FormatsFailed.html</message>
                    </mail>
                </catch>
            </trycatch>
        </xsl:for-each-group>

        <xsl:for-each-group
            select="./mod:format/mod:*[ancestor-or-self::*/@failonerror = 'true' or not(ancestor-or-self::*[@failonerror])]"
            group-by="local-name()">
            <xsl:variable name="security" select="current-grouping-key()"/>
            <xsl:variable name="targets">
                <xsl:if
                    test="
                    current-group()[parent::mod:format/@name = 'eclipse-infocenter'] and 
                    not(ancestor::mod:document/mod:format/*[local-name() = $security and parent::mod:format/@name = 'pdf'])">
                    <target name="pdf"/>
                </xsl:if>
                <xsl:for-each select="current-group()">
                    <xsl:choose>
                        <xsl:when
                            test="parent::mod:format/@name = 'pdf' and ancestor::mod:document/mod:format/*[local-name() = $security and parent::mod:format/@name = 'eclipse-infocenter']"/>
                        <xsl:when
                            test="parent::mod:format/@name = 'eclipse-infocenter' and @publish = 'true'">
                            <target name="publish-eclipse-infocenter"/>
                        </xsl:when>
                        <xsl:when
                            test="parent::mod:format/@name = 'eclipse-help' and @publish = 'true'">
                            <target name="publish-eclipse-help"/>
                            <!-- added for JCBG-780-->
                        </xsl:when>
                        <xsl:otherwise>
                            <target name="{parent::mod:format/@name}"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="targets-text">
                <xsl:for-each select="$targets/*">
                    <xsl:value-of select="@name"/>
                    <xsl:if test="position() != last()">, </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <xsl:if test="$targets//target">
                <ant antfile="build.xml" dir="{ancestor::mod:document/@dir}" inheritall="false">
                    <xsl:copy-of select="$targets"/>
                    <property name="security" value="{$security}"/>
                    <!-- for jcbg-2099, passing down these additional properties -->
                    <property name="jira.uname" value="${jira.uname}"/>
                       <property name="jira.password" value="${jira.password}"/>
                    <xsl:if test="ancestor-or-self::*[@infocenter][1]">
                        <property name="infocenter"
                            value="{ancestor-or-self::*[@infocenter][1]/@infocenter}"/>
                    </xsl:if>
                    <xsl:if test="boolean($emails)">
                        <!-- for jcbg-1250, pass down a notification property -->
                        <property name="notification-list" value="{$emails}"/>
                    </xsl:if>

                </ant>
            </xsl:if>
        </xsl:for-each-group>



    </xsl:template>

</xsl:stylesheet>
