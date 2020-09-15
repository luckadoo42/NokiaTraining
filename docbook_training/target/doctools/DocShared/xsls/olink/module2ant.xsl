<?xml version ="1.0"?>
<!-- 
  
  This xslt processes the module.xml file and generates an ant script that in turn 
  generates all the necessary target olink database files. 
  
  For each document we generate a target database file in html/reviewer format. 
  
  For now, I'll write the ant script beside the module.xml but someday it should go in target. 
  
-->
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:mod="http://motive.com/techpubs/module">
  
  <xsl:output
    method="xml"
    indent="yes"/>
  
  <xsl:param name="module.dir"/>

    <xsl:variable name="emails">
        <xsl:for-each select="//mod:email">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="not(position() = last())">
                <xsl:text>,</xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>

  
  
  <xsl:template match="/">
    <xsl:comment>
        Generated from the module.xml file using module2ant.xsl.
        This file generates olink db files for each document
        in the module, then compiles them into one big olink.db
        file.
    </xsl:comment>
    <project basedir="work">

      	    <!-- write out the notification list for use by Jenkinsfile, to a file
		 this is later picked up by Jenkinsfile to use to send notifications
	    -->
	    <echo>Now writing notification list from module file to a file 'target/notificationList.txt' for use by Jenkinsfile later: using this list: <xsl:value-of select="$emails"/></echo>
	    <echo file="notificationList.txt"><xsl:value-of select="$emails"/></echo>

	    <!-- for debug, writing out the notification list file to the console -->
	      <concat><filelist dir="." files="notificationList.txt"/></concat>


      
      <xsl:apply-templates/>
      
      <replace dir="{$module.dir}/target">
        <include name="target-*.db"/>
        <replacefilter token="&lt;!DOCTYPE div" value=""/>
        <replacefilter token='PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">' value=""/>
      </replace>
      <!-- Now combine the result of the two previous runs: olinkdb.xsl parses module.xml and constructs and olink.db from all the generated target db files. -->
      <ant dir="{concat($module.dir,'/',//mod:document[not(disabled = 'true') and not(disabled = 'yes')][1]/@dir)}" antfile="build.xml" target="compile-olinkdb"/>
      
    </project>
  </xsl:template>
  
  <xsl:template match="mod:document[not(@disabled = 'true') and not(@disabled = 'yes')]">
    <xsl:variable name="current.docid" select="document(concat( @dir, '/build.xml'),. )//property[@name = 'current.docid']/@value"/>
    <xsl:if test="normalize-space($current.docid) = ''">
      <xsl:message>
        !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

        Error: I can't find a value for the current.docid property for the 
		document in folder <xsl:value-of select="@dir"/>, in the build.xml
        there. 

        Possible causes:
        1. The build.xml in that folder does not have a current.docid 
	   property.
        2. The build.xml is invalid, so I can't read it to get a value 
	   (validate the file and fix any problems). 
        3. The folder <xsl:value-of select="@dir"/> does not exist, or the
           name is wrong in the module.xml file. 
           NB: With Linux build servers, case-sensitivity matters!

        !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
      </xsl:message>     
      <xsl:message  terminate="yes"/>
    </xsl:if>
    <!-- Build target db off of partially generated file:  -->
    <ant dir="{concat($module.dir, '/',@dir)}" antfile="build.xml" target="targetdb" inheritall="false">
      <property name="security" value="reviewer"/>      
      <property name="current.docid" value="{$current.docid}"/>
      <property name="input.file.path.trimmed" value="{@dir}"/>
      <property name="staging.doc.dir" value="{concat($module.dir,'/target/work/',@dir)}"/>
    </ant>    
  </xsl:template> 
  
  <xsl:template match="text()"/>
  
</xsl:stylesheet>
