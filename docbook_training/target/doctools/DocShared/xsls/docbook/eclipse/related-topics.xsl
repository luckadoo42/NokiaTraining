<?xml version='1.0'?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet 
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:exslt="http://exslt.org/common" 
  exslt:dummy="dummy" 
  extension-element-prefixes="exslt" 
  exclude-result-prefixes="exslt"
  version='1.0'>

  <xsl:param name="infocenter">Unknown</xsl:param>
  <xsl:param name="bugzilla.component">Unknown</xsl:param>
  <xsl:param name="bugzilla.product.version"></xsl:param>
  <xsl:param name="google.code"/>
  <xsl:param name="security"/> <!-- added for JCBG-2133, prevent google.code from showing up in external outputs -->
  

  <!-- disqus parameters -->
  <xsl:param name="disqus.enable"/>
  <xsl:param name="disqus.shortname">motivepubs</xsl:param>
  
  <xsl:param name="format"/>
  <xsl:param name="related.topics.type">list</xsl:param><!-- list, activex, otherwise -->
  <xsl:param name="output_file_name"></xsl:param>
  <xsl:param name="security.filename.flag"></xsl:param>
  <xsl:param name="motive.include.infocenter.footer">
  	<xsl:choose>
  		<xsl:when test="$format = 'eclipse-infocenter'">1</xsl:when>
  		<xsl:otherwise>0</xsl:otherwise>
  	</xsl:choose>
  </xsl:param>

	<xsl:variable name="quote.char">'</xsl:variable>
	<xsl:variable name="dbl.quote.char">"</xsl:variable>




<xsl:template name="user.footer.content">

	<xsl:variable name="title"><xsl:copy-of select="./title"/></xsl:variable>

	<xsl:variable name="PID"><xsl:if
		test="/book/bookinfo/biblioid[@class='pubnumber']"><xsl:value-of
		  select="translate(normalize-space(/book/bookinfo/biblioid[@class='pubnumber']),' ','+')"/><xsl:text>+</xsl:text></xsl:if></xsl:variable>

	<xsl:variable name="filename"><xsl:apply-templates mode="chunk-filename" select="."/></xsl:variable>

	
	<xsl:if test="$related.topics.type = 'list' or $related.topics.type = 'activex'">

	<xsl:variable name="params">
		<!-- TODO: Think about sorting these? Document order? -->
	  <xsl:for-each select="./*/keywordset/keyword">
		<xsl:apply-templates select="/*//keywordset/keyword[ 
		  . = current() and 
			  not(./@role = 'notarget') and 
		  generate-id(.) != generate-id(current())]" mode="relatedtopics"/>
	  </xsl:for-each>
	</xsl:variable>

	<xsl:variable name="unique-params">
	  <xsl:for-each select="exslt:node-set($params)/p[not(preceding-sibling::p/a/@href = ./a/@href) and not(normalize-space(preceding-sibling::p/a) = normalize-space(./a)) and not(normalize-space(./a) = normalize-space($title))]">
			<xsl:copy-of select="."/>
	  </xsl:for-each>
	</xsl:variable>
	  
	  <xsl:choose>
		<xsl:when test="exslt:node-set($unique-params)/p and
		  not(./*[(self::title|self::chapterinfo|self::sectioninfo)[following-sibling::*[1][self::section]]])">
		  <ul class="rt-outer">
			<li>
			  <span class="button">
				<a onmouseover="ReverseContentDisplay('rt-div',event); return true;" onclick="ReverseContentDisplay('rt-div',event); return true;">
				  <xsl:call-template name="gentext">
					<xsl:with-param name="key">RelatedTopics</xsl:with-param>
				  </xsl:call-template>
				</a>
			  </span>
			  <div
				id="rt-div"
				style="display:none; 
				position:absolute;
				margin-top: 10px;
				margin-left: 70px;"><!--  70px works well for IE, 110px for Firefox -->
				<ul class="rt-inner" id="related-topics-inner">
				  <xsl:for-each select="exslt:node-set($unique-params)/p">
					<li><xsl:copy-of select="./node()"/></li></xsl:for-each>
				</ul>				
			  </div>			 
			</li>
		  </ul>
		</xsl:when>
		<xsl:otherwise>
		  <xsl:comment>No related topics</xsl:comment>
		</xsl:otherwise>
	  </xsl:choose>

	</xsl:if>


  </xsl:template>
  
  <xsl:template match="keyword" mode="relatedtopics">
	  <xsl:if test="$related.topics.type = 'list' or $related.topics.type = 'activex'">

		<p>
		  <!-- TODO: Get the title with the label? e.g. Chapter
		  1. Blah de blah. Or not? -->
		  <a>
			<xsl:attribute name="href">
			  <xsl:apply-templates
				mode="chunk-filename"
				select="../../.."/>
			</xsl:attribute>
			<xsl:value-of select="../../../title"/>
		  </a>
		</p>
	</xsl:if>
													   
  </xsl:template>

  <xsl:template name="user.footer.navigation">
  	
  	<xsl:variable name="filename"><xsl:apply-templates mode="chunk-filename" select="."/></xsl:variable>
  	
	<xsl:if test="$motive.include.infocenter.footer != '' and $infocenter != 'wimbledon'">
        <!-- insert duplicate feedback link at bottom of page, per JCBG-1545 
        Note that I tried to wrap this feedback link in a p with style="text-align:right", but that didn't work. I ended up going to the named template
        "feedback" and adding text-align:right to the div that it creates.
        -->
	<xsl:call-template name="feedback"/> 
		

	  <xsl:if test="($output_file_name != '') and ($format !='eclipse-help')">  <!-- for JCBG-780, added test whether the format is eclipse-help, skipping the link if it IS -->
               <div class="pdflink"> <!-- for JCBG-672 and JCBG-780, wrapped this chunk of content in a div with a classname so that we can address it as a chunk in the css -->
		<p> 
		  <b>
			This document is also available in <a target="_blank" href="{normalize-space($output_file_name)}{normalize-space($security.filename.flag)}.pdf" onmouseover="return overlib('{$motive.footer.popup.text}',DELAY,250,BGCLASS, 'bgClass',FGCLASS,'fgClass',CENTER);" onmouseout="return nd();"><img style="border-style: none;" src="pdficon_small.gif"/> PDF</a> format.
		  </b>
		</p></div>
	  </xsl:if>
	</xsl:if>

<!-- Put javascript-for-every-page chunks here -->
 
 <xsl:apply-templates mode="titlepage.footer.mode" select="/book/bookinfo/copyright"/>
    
        <!-- google analytics javascript code -->
  	    <!-- the test below used to check for $format='eclipse-infocenter'; changed 10/12/16 to only check that the format CONTAINS 'eclipse', so it will work for eclipse-help also
  	    and then  updated 4/16/18 for JCBG-2133, prevent google.code from showing up in external outputs: added "and not($security='external')"  	    -->

<!-- Turning off google analytics code for ALL OUTPUTS as of 5/8/18; am doing this by simply commenting out the code below.
  		This is for JCBG-2136.
  	
  	<xsl:if test="not($google.code = '')
		and not($security='external')
		and (contains($format,'eclipse')) 
		and $motive.include.infocenter.footer != ''"><xsl:text>
				
	</xsl:text>
	   <script type="text/javascript">
             var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
             document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
           </script>
           <script type="text/javascript">
             try {
             var pageTracker = _gat._getTracker("UA-6581175-<xsl:value-of select="$google.code"/>");
             pageTracker._setDomainName("none");
             pageTracker._trackPageview();
             } catch(err) {}</script>
        </xsl:if> 
        -->

       <!-- disqus javascript code 
       note that, when writing out disqus_title, it must not have line breaks in it. I added normalize-space() to the expressions for
       it, to fix that (JCBG-975). However, if we see problems again with displaying the disqus form, verify that the disqus_title (or any other
       var values) doesn't have any line breaks.
       
       -->

	<xsl:if test="$disqus.enable = 'true' and $format='eclipse-infocenter' and $motive.include.infocenter.footer != ''"><xsl:text>
	</xsl:text>

<div id="disqus_thread"></div>
<script type="text/javascript">
    var disqus_shortname = '<xsl:value-of select="$disqus.shortname"/>'; // forum shortname value
    var disqus_developer = 1; // developer mode is on
    var disqus_title = '<xsl:value-of select="normalize-space(./title)"/> - <xsl:value-of select="translate(translate(normalize-space(//title[1]), $quote.char,''),$dbl.quote.char,'')"/>';
 
    // The following are highly recommended additional parameters. Remove the slashes in front to use.
    // var disqus_identifier = 'unique_dynamic_id_1234';
    <!-- added disqus_url for JCBG-1150 -->
    var disqus_url = 'http://pubs.motive.com/<xsl:value-of select="$infocenter"/>/topic/<xsl:value-of select="$eclipse.plugin.id"/>/<xsl:value-of select="$filename"/>';
    

    /* * * DON'T EDIT BELOW THIS LINE * * */
    (function() {
        var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
        dsq.src = 'http://' + disqus_shortname + '.disqus.com/embed.js';
        (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
    })();
</script>
<noscript>Please enable JavaScript to view the <a href="http://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
<a href="http://disqus.com" class="dsq-brlink">blog comments powered by <span class="logo-disqus">Disqus</span></a>


        </xsl:if>



  </xsl:template>


</xsl:stylesheet>
