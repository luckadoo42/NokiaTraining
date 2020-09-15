<?xml version ="1.0"?>
<!DOCTYPE stylesheet>

  <xsl:stylesheet version="1.1"
		  xmlns:db="http://docbook.org/ns/docbook"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output
	  method="xml"
	  indent="yes"/>

	<xsl:param name="failonerror">false</xsl:param>


<!-- For JCBG-465, adding statement about where to find report. Using a variable here so I can reuse this text easily in 2 places. -->
    <xsl:variable name="seereport"><xsl:text>


</xsl:text>See the HTML report file at /target/report.html for a clearer indication of problems.<xsl:text>


</xsl:text></xsl:variable>

	<xsl:template match="/">
	  <html>
		<head>
		  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		  <style>

			a:active  { color: #FF0000}
			a:hover   {color: #F27C00;}
			a:link    { color: #003399}
			a:visited { color: #BDBA03}
			a.copyright { color: #C0C0C0}
			a.copyright:visited { color: #C0C0C0}
			a.copyright:hover { color: #C0C0C0}
			a.hotterm:hover   {color: #F27C00;}
			span.bjinternal a:visited { color: #F27C00}

			
			BODY
			{
			font-family: Arial, Verdana, Helvetica, sans-serif;
			font : x-small;
			}

			DIV
			{
			font-family: Arial, Verdana, Helvetica, sans-serif;
			text-indent : 0em;
			}

			DFN
			{
			color: #F27C00;
			text-decoration: none;
			font-style:normal;
			}

			div.toc
			{
			margin : 0em 0em 0em 0em;
			}

			div.Tocfirst
			{
			margin : 5em 0em 0em 0em;
			font-weight:normal;
			}

			ol.substeps
			{
			list-style-type : lower-alpha;
			}

			/* Contents entries */

			DT, dt, .term 
			{
			margin : 0em 0em 0em 1em;
			font-weight: bold;
			}

			/* Contents entry text (after number) */

			dt a
			{
			margin : 0em 0em 0em 0em;
			font-weight: normal
			}

			EM, i
			{
			font-style: italic;
			}

			.blue
			{
			font-weight: bold;
			color:  #003399;
			}

			FONT
			{
			font-family: Arial, Verdana, Helvetica, sans-serif;
			}

			H1, H2, H3, H4, H5
			{
			color: #003399;
			font-family: Arial, Verdana, Helvetica, sans-serif;
			font : small;
			}
			
			
			H1
			{
			margin : 1em 0em .5em 0em;
			font-weight: bold;
			}

			H2
			{
			margin : 2em 0em -.25em 0em;
			font-weight: bold;
			}	 

			H3
			{
			margin : 1.5em 0em -.25em 0em;
			font-weight: bold;
			font: medium bold
			}	  

			H4
			{
			margin : 1em 0em -.25em 0em;
			}	

			H4.headerTitle
			{
			font-size:11px;
			color:black;
			font-weight: normal;
			}

			H5
			{
			font-style: italic;
			margin : .5em 0em -.25em 0em;
			font-weight: bold;
			}	  



			.border
			{
			font-family: Arial, Verdana, Helvetica, sans-serif;
			font-weight: bold;
			border-style : outset;
			border-width : thin thin thin thin;
			margin: 3em 0em 1em 0em;
			}


			.HEADER1
			{
			font-family: Arial, Verdana, Helvetica, sans-serif;
			font-size: 20px;
			line-height: 20px;
			font-weight: bold;
			}


			.HEADER2
			{
			font-family: Arial, Verdana, Helvetica, sans-serif;
			FONT-WEIGHT: bold;
			font-size: 16px;
			font-weight: bold;
			color: #000000;
			}

			P
			{
			font-family: Arial, Verdana, Helvetica, sans-serif;
			}

			P.emphasis
			{
			font-weight: bold;
			color : #003399;
			}

			div.bjinternal
			{
			color : #F27C00;
			}

			span.bjinternal
			{
			color : #F27C00;
			}

			a.copyright
			{
			color : #C0C0C0;
			}


			P.copyright
			{
			color : #C0C0C0;
			text-align:center;
			font: 11px
			}

			LI
			{
			font-family: Arial, Verdana, Helvetica, sans-serif;
			margin: .5em;
			}

			LI P
			{ 
			margin: .5em;
			}

			Table, Table.body
			{
			margin-top:.5em;
			margin-bottom : .5em;
			}

			tr.body th
			{
			background-color : #003399;
			font : x-small;
			font-weight: bold;
			}

			th p
			{
			font-weight: bold;
			}

			TD
			{
	border: solid 1px;
			font-family: Arial, Verdana, Helvetica, sans-serif;
			padding-top: 5px;
			padding-bottom: 5 px;
			padding-right : 10px;
			padding-left : 5px;
			font : x-small;
			vertical-align : top;
			}

			TD.navheader
			{
			font-family: Arial, Verdana, Helvetica, sans-serif;
			color: #C0C0C0;
			vertical-align : top;
			border: none;
			padding-top: 0px;
			padding-bottom: 5 px;
			padding-right : 0px;
			padding-left : 0px;
			}

			TH
			{
			font-family: Arial, Verdana, Helvetica, sans-serif;
			font-weight: bold;
			color: white;
			text-align : left;
			background:  #003399;
			border: none;
			padding-top: 5px;
			padding-bottom: 5 px;
			padding-right : 10px;
			padding-left : 5px;
			}

			TH.admonition
			{
			font-family: Arial, Verdana, Helvetica, sans-serif;
			font-weight: bold;
			color: black;
			background:  white;
			text-align : left;
			border: none;
			padding-top: 5px;
			padding-bottom: 5 px;
			padding-right : 5px;
			padding-left : 5px;
			}

			p.admonition
			{
			font-family: Arial, Verdana, Helvetica, sans-serif;
			Font-weight: bold;
			color: black;
			text-align: left;
			}

			tt
			{
			font: x-small;
			}


			.header
			{
			color: #F27C00;
			font-weight: bold;
			}

			em.orange
			{
			color: #F27C00;
			font-family: Arial, Verdana, Helvetica, sans-serif;
			font-weight: bold;
			font-size: 13px
			}


			UL
			{
			font-family: Arial, Verdana, Helvetica, sans-serif;
			margin-top: 1em;
			}

			OL
			{
			font-family: Arial, Verdana, Helvetica, sans-serif;
			margin-top: 1em;
			}

			.line
			{
			margin: 0pt 6pt
			}

			B
			{
			font-weight: bold
			}


			.sidebar
			{
			color: white;
			font-family: Arial, Verdana, Helvetica, sans-serif;
			}

			.date
			{
			color: #999999;
			font-family: Arial, Verdana, Helvetica, sans-serif;
			margin: 0pt 6pt 6pt
			}

			.footer
			{
			color: #999999;
			font-family: Arial, Verdana, Helvetica, sans-serif;	
			text-decoration: none
			}

			A
			{
			font-family: Arial, Verdana, Helvetica, sans-serif;
			}


			.tablehead
			{
			background: #ffffeb;
			color: black;
			font-family: Arial, Verdana, Helvetica, sans-serif;
			font-weight: bold;
			line-height: 14px
			}


		  </style>
		</head>
		<body>
		  <h1>Glossary Report</h1>
		  <p>This report shows potential problems in the
		  glossary by showing places where an external term
		  links to an internal term or a deprecated term. It also checks for invalid id attributes.
		  </p>
		  <table style="border: black 2px solid" cellpadding="5" cellspacing="0" width="100%">
			<thead class="tablehead">
			  <tr>
				<th width="10%" style="border: black 1px solid">The glossary entry</th>
				<th style="border: black 1px solid" >with the ID</th>
				<th style="border: black 1px solid">contains a</th>
				<th width="10%" style="border: black 1px solid">that links to</th>
				<th style="border: black 1px solid">&#160;</th>
				<th style="border: black 1px solid" >which is</th>
			  </tr>
			</thead>
			<tbody>
			  <xsl:variable name="rows">
				<xsl:apply-templates/>
			  </xsl:variable>
			  <xsl:choose>
				<xsl:when test="not(normalize-space($rows) = '')">				  
				  <xsl:copy-of select="$rows"/>
				  <xsl:if test="$failonerror = 'true'">
				    <xsl:message terminate="yes">
				      <xsl:copy-of select="$rows"/>
                      <xsl:value-of select="$seereport"/> <!-- added for JCBG-465-->
				    </xsl:message>
				  </xsl:if>
				</xsl:when>
				<xsl:otherwise>
				  <tr>
					<td colspan="6" align="center">
					  <b>No crosslinking problems found!</b>
					</td>
				  </tr>
				</xsl:otherwise>
			  </xsl:choose>
			</tbody>
		  </table>
		  
		  <xsl:choose>
			<xsl:when test="//glossentry[not(substring(@xml:id,string-length(@xml:id) - 7, 8) = 'glossary') and not(substring(@xml:id,string-length(@xml:id) - 8, 9) = 'glossterm') and not(contains(';adoption;help.desk.server;audio.device.profile;subscriber.environment.manager;video.device.profile;virus;worm;electronic.channel.glossary.wimbledon;voice.workflow;managed_settings.glossary.wimbledon;optimal_value.glossary.wimbledon;serviceview.console;model;model_builder;overlay_builder;overlay;',concat(';',@xml:id,';'))) ]">
			<p>glossentry elements with illegal id values. All glossentry elements MUST have id attributes and the id attribute should always end in ".glossary".  </p>
			<ul>
			  <xsl:variable name="items">
			  <xsl:for-each select="//glossentry[not(substring(@xml:id,string-length(@xml:id) - 7, 8) = 'glossary') and not(substring(@xml:id,string-length(@xml:id) - 8, 9) = 'glossterm') and not(contains(';adoption;help.desk.server;audio.device.profile;subscriber.environment.manager;video.device.profile;virus;worm;electronic.channel.glossary.wimbledon;voice.workflow;managed_settings.glossary.wimbledon;optimal_value.glossary.wimbledon;serviceview.console;model;model_builder;overlay_builder;overlay;',concat(';',@xml:id,';'))) ]">
				<li><xsl:value-of select="glossterm"/>: <xsl:value-of select="@xml:id"/>
				  <xsl:if test="not(@xml:id)"><b>WARNING: no id attribute!</b></xsl:if>
				</li>
			  </xsl:for-each>
			  </xsl:variable>
			  <xsl:copy-of select="$items"/>
			  <xsl:if test="$failonerror = 'true'">
			    <xsl:message terminate="yes">
			      <xsl:copy-of select="$items"/>
                  <xsl:value-of select="$seereport"/> <!-- added for JCBG-465-->
			    </xsl:message>		
			  </xsl:if>		    
			</ul>
			</xsl:when>
			<xsl:otherwise>
			  <b>No (new) id-related problems found</b>
			</xsl:otherwise>
		  </xsl:choose>		  
		</body>
	  </html>
	</xsl:template>

	<xsl:template match="db:glossterm[not(parent::db:glossentry)
	  and (not(@linkend) or normalize-space(@linkend) = '')]" priority="100">
	  <tr style="color: red">
		<td><xsl:value-of select="ancestor::db:glossentry/db:glossterm"/></td>
		<td><xsl:value-of select="ancestor::db:glossentry/@xml:id"/></td> 
		<td>glossterm (<xsl:value-of select="."/>)</td>
		<td>&#160;</td>
		<td>&#160;</td>
		<td>Missing a linkend</td>
	  </tr>
	</xsl:template>

	<xsl:template match="db:glossterm[not(parent::db:glossentry)
	  and not(@linkend = //*/@xml:id)]" priority="10">
	  <tr style="color: red">
		<td><xsl:value-of select="ancestor::db:glossentry/db:glossterm"/></td>
		<td><xsl:value-of select="ancestor::db:glossentry/@xml:id"/></td> 
		<td>glossterm (<xsl:value-of select="."/>)</td>
		<td><xsl:value-of select="./@linkend"/>&#160;</td>
		<td>&#160;</td>
		<td>nonexistent</td>
	  </tr>
	</xsl:template>

	<xsl:template match="db:glossseealso[not(@otherterm) or not(@otherterm = //db:glossentry/@xml:id)]">
	  <tr style="color: red">
		<td><xsl:value-of select="ancestor::db:glossentry/glossterm"/></td>
		<td><xsl:value-of select="ancestor::db:glossentry/@xml:id"/></td> 
		<td>glossseealso (<xsl:value-of select="."/>)</td>
		<td><xsl:value-of select="./@otherterm"/>&#160;</td>
		<td>&#160;</td>
		<td>nonexistent</td>
	  </tr>
	</xsl:template>

	<xsl:template match="//db:glossterm[@linkend and
	  ancestor::db:glossentry[not(@security)] and 
	  @linkend = //db:glossentry[@security]/@xml:id and 
	  not(ancestor::*[ancestor::db:glossentry]/@security)] |

	  //db:glosssee[not(@security) and 
	  parent::db:glossentry[not(@security)] and 
	  @otherterm = //db:glossentry[@security]/@xml:id] |

	  //db:glossseealso[not(@security) and 
	  ancestor::db:glossentry[not(@security)] and 
	  @otherterm = //db:glossentry[@security]/@xml:id] |

	  //db:glossterm[@linkend and
	  ancestor::db:glossentry[not(@role = 'deprecated') and not(@security)] and
	  @linkend = //db:glossentry[@role = 'deprecated']/@xml:id and 
	  not(ancestor::*[ancestor::db:glossentry]/@security)] |

	  //glosssee[parent::db:glossentry[not(@role = 'deprecated') and not(@security)] and
	  not(@security) and 
	  @otherterm = //db:glossentry[@role = 'deprecated']/@xml:id] |

	  //db:glossseealso[ancestor::db:glossentry[not(@role = 'deprecated') and not(@security)] and
	  not(@security) and 
	  @otherterm = //db:glossentry[@role = 'deprecated']/@xml:id]	  ">
	  
	  <tr>
		<td><xsl:value-of select="ancestor::db:glossentry/db:glossterm"/>&#160;</td>
		<td><xsl:value-of select="ancestor::db:glossentry/@xml:id"/>&#160;</td>
		<td><xsl:value-of select="name(.)"/>&#160;</td>
		<td><xsl:value-of select="."/>&#160;</td>
		<td><xsl:value-of select="@linkend"/><xsl:value-of select="@otherterm"/>&#160;</td>
		<td>
		  <xsl:value-of select="//db:glossentry[@xml:id = current()/@linkend or @xml:id = current()/@otherterm]/@role"/>&#160;
		  <xsl:value-of select="//db:glossentry[@xml:id = current()/@linkend or @xml:id = current()/@otherterm]/@security"/>
		</td>
	  </tr>
<!-- 	  <xsl:message> -->
<!-- 		================================================== -->
<!-- 		Warning: glossterm security or deprecation problem. -->
<!-- 		In: <xsl:value-of select="ancestor::glossentry/@xml:id"/> -->
<!-- 		Term: <xsl:value-of select="."/>   -->
<!-- 		linkend/otherterm = <xsl:value-of select="@linkend"/><xsl:value-of select="@otherterm"/> -->

<!-- 		This means that either an external term links to -->
<!-- 		(via glossterm, glosssee, or glossseealso) a -->
<!-- 		bjinternal, reviewer, or writeronly term, or a -->
<!-- 		non-deprecated external term links to a deprecated -->
<!-- 		term. -->
<!-- 		================================================== -->
<!-- 	  </xsl:message> -->
	</xsl:template>

	<xsl:template match="text()"/>
  </xsl:stylesheet>
