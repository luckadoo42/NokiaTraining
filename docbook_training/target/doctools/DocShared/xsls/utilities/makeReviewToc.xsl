 <xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:output method="xml" indent="no"/>

 <!-- How this works:
 	This xsl IGNORES ITS INPUT FILE, and instead uses http requests to get two files from an infocenter, 
 	one of search results and one of toc.xml.
 	
 	It then processes the toc.xml to make an html toc (of indented bullets) for output; but for each item,
 	if it showed up in the search results, then it gets highlighted and made into a link.
 	-->
 	
 	
 <!-- params with default values for test purposes -->
  <xsl:param name="infocenter">na</xsl:param>
  <xsl:param name="searchWord">NA70</xsl:param>
  <xsl:param name="eclipse.plugin.id">com.alcatel.NAUG70</xsl:param>
  <!-- ======================================== -->
  <xsl:param name="infocenterURL">http://pubs.motive.com/<xsl:choose>
	  <xsl:when test="$infocenter = 'pubs'">info</xsl:when>
	  <xsl:otherwise><xsl:value-of select="$infocenter"/></xsl:otherwise>
  </xsl:choose></xsl:param>
 	
 	<!-- jcbg-1317 fix the search URL to work with new infocenters, which need /search?phrase instead of /search?searchWord -->
  <xsl:param name="searchURL"><xsl:value-of select="concat($infocenterURL,'/search?phrase=',$searchWord)"/></xsl:param>

 	<!-- Generate the searchXML results by getting the searchURL into a param that we can inspect later -->
 	<xsl:param name="searchXML"><xsl:copy-of select="document($searchURL)/*"/></xsl:param>
 	
 	<!-- Generate a toc of the book specified by the eclipse plugin id, and put that in a param we can use later -->
    <xsl:param name="tocXML"><xsl:copy-of select="document(concat($infocenterURL,'/topic/',$eclipse.plugin.id,'/toc.xml') )"/></xsl:param>


<!-- now apply templates to the toc of the book, to build our output -->
  <xsl:template match="/">
	<html>
	  <body>
		<xsl:apply-templates select="$tocXML/*"/>
	  </body>
	</html>
  </xsl:template>
  
  <xsl:template match="toc">
	<h1><xsl:value-of select="@label"/></h1>
	<ul>
	  <xsl:apply-templates/>
	</ul>
  </xsl:template>
  
  <xsl:template match="topic">
	<xsl:choose>
	  <xsl:when test="./topic"> <!-- if the current topic CONTAINS topics, then we need to handle the contents... -->
		  <li>
			<xsl:choose>
				<!-- if the current topic occurred in the searchXML, with the right plugin id, then highlight and link it -->
				
				<!-- previous test exp, before JCBG-1317 was: 
					<xsl:when test="$searchXML//topic[current()/@href = substring-before(substring-after(@href,concat($eclipse.plugin.id,'/')),'?') ]">
					...that one takes the substring-after the ecl id (which is NULL if wrong ecl id), and then takes the part before the ?
					 but now we don't have ? in the search results.
				
				Two changes for JCBG-1317: change 'topic' to 'hit' (because new search results use 'hit' as the search result element) and remove the substring-before part
				of the expression above
				
				FURTHER REFACTORING... we're repeating the TEST and OUTPUT expressions below twice. Find a way to only use them once.
				-->
				
			  <xsl:when test="$searchXML//hit[current()/@href = substring-after(@href,concat($eclipse.plugin.id,'/'))]">
				<b style="background: yellow;"><a target="_blank" href="{$infocenterURL}/topic{$searchXML//hit[current()/@href = substring-after(@href,concat($eclipse.plugin.id,'/'))]/@href}"><xsl:value-of select="@label"/></a></b>
			  </xsl:when>
			  <xsl:otherwise>
				<xsl:value-of select="@label"/>
			  </xsl:otherwise>
			</xsl:choose>
			<ul>
			  <xsl:apply-templates/>
			</ul>
		  </li>
	  </xsl:when>
	  <xsl:otherwise> <!-- here we handle the case where the current topic is a leaf, contains no other topics -->
		<li> 
		  <xsl:choose>
		  	<!-- if the current topic occurred in the searchXML, with the right plugin id, then highlight and link it -->
		  	<xsl:when test="$searchXML//hit[current()/@href = substring-after(@href,concat($eclipse.plugin.id,'/'))]">
		  		<b style="background: yellow;"><a target="_blank" href="{$infocenterURL}/topic{$searchXML//hit[current()/@href = substring-after(@href,concat($eclipse.plugin.id,'/'))]/@href}"><xsl:value-of select="@label"/></a></b>
		  	</xsl:when>
			<xsl:otherwise>
			  <xsl:value-of select="@label"/>
			</xsl:otherwise>
		  </xsl:choose>
		</li>
	  </xsl:otherwise>
	</xsl:choose>
  </xsl:template>
  
  </xsl:stylesheet>
