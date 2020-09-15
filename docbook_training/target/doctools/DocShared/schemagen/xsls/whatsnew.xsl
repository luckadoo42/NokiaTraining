<?xml version="1.0" ?>
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:bj="http://motive.com/techpubs/datamodel" 
	xmlns:lookup="http://www.broadjump.com/lookup"
	xmlns:wn="http://motive.com/techpubs/whatsnew"
	xmlns:db="http://docbook.org/ns/docbook"
	xmlns="http://docbook.org/ns/docbook" 
	exclude-result-prefixes="lookup bj db wn">

	<xsl:output indent="yes"/>

	<!--
  This stylesheet sifts through a datamodel file to get info on updated/added/changed components
  and from them generates a DocBook section file that can be xincluded into a book. -->


	<xsl:param name="schema.whatsnew.id">my.default.id</xsl:param>
	<xsl:param name="schema.whatsnew.version">my.default.version</xsl:param>
	<xsl:param name="schema.whatsnew.title">New in <xsl:value-of select="$schema.whatsnew.version"/></xsl:param>
	
	<!-- copy of input doc for reference later -->
	<xsl:variable name="current.doc">
		<xsl:copy-of select="/"/>
	</xsl:variable>

	
	<xsl:template match="/">
		
		<db:section xml:id="{$schema.whatsnew.id}" version="5.0-extension BroadBook-2.0" >
			<db:title><xsl:value-of select="$schema.whatsnew.title"/></db:title>
			<xsl:comment>schema.whatsnew.version = <xsl:value-of select="$schema.whatsnew.version"/></xsl:comment>

			<!-- generate a list of new stuff, with categories, in a variable; we'll walk the whole tree of table names and find all the ones that count as new for us,
			because their @added matches $schema.whatsnew.version -->
			<xsl:variable name="changes">
              <wn:changes 
              	xmlns:bj="http://motive.com/techpubs/datamodel" 
              	xmlns:lookup="http://www.broadjump.com/lookup"
              	xmlns:wn="http://motive.com/techpubs/whatsnew"
              	xmlns:db="http://docbook.org/ns/docbook"
              	xmlns="http://docbook.org/ns/docbook" > <!-- namespaces to prevent namespaces on child elements-->
              	
              	
				<xsl:for-each select="document('categories.xsl')//lookup:subject-area">
					<xsl:variable name="catname"><xsl:value-of select="normalize-space(@name)"/></xsl:variable>
					<xsl:for-each select="tokenize(., ',')">
						<xsl:variable name="myversion" select="$current.doc//bj:table[@name=normalize-space(current())]/@added"/>
						<xsl:choose>
							<!-- New tables: when the current table has @added=$schema.whatsnew.version, then write out a newtable element -->
							<xsl:when test="normalize-space($myversion)=normalize-space($schema.whatsnew.version)">
								<wn:newtable>
									<xsl:attribute name="cat"><xsl:value-of select="$catname"/></xsl:attribute>
									<xsl:attribute name="name"><xsl:value-of select="normalize-space(.)"/></xsl:attribute>
								</wn:newtable>
							</xsl:when>
							<!-- New columns: otherwise, check it for new columns
							thus we only walk the columns of tables that are NOT new
							-->
							<xsl:otherwise>
								<xsl:for-each select="$current.doc//bj:table[@name=normalize-space(current())]/bj:column[@added=$schema.whatsnew.version]">
									<wn:newcolumn>
										<xsl:attribute name="cat"><xsl:value-of select="$catname"/></xsl:attribute>
										<xsl:attribute name="table"><xsl:value-of select="normalize-space(../@name)"/></xsl:attribute>
										<xsl:attribute name="name"><xsl:value-of select="normalize-space(./@name)"/></xsl:attribute>
									</wn:newcolumn>
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>										
					</xsl:for-each>
				</xsl:for-each>
              	
              	<!-- add new formats to the list   updated for JCBG-2132
              	walk the categories.xsl,and write out, for each table, any format elements that contain an @last and have @added= current whatsnew.version
              	-->
              	
              	<xsl:for-each
              		select="document('categories.xsl')//lookup:subject-area/tokenize(., ',')">
              		
              		
<!-- create wn:formatchange for each format that has changed values AND are in the correct added version-->
              		<xsl:for-each select="$current.doc//bj:table[@name=normalize-space(current())]/bj:column/bj:format[@last][@added=$schema.whatsnew.version]">
              			<wn:formatchange>
              				<xsl:attribute name="table"><xsl:value-of select="normalize-space(../../@name)"/></xsl:attribute>
              				<xsl:attribute name="column"><xsl:value-of select="normalize-space(../@name)"/></xsl:attribute>
              				<xsl:attribute name="last"><xsl:value-of select="normalize-space(./@last)"/></xsl:attribute>
              				<xsl:attribute name="type"><xsl:value-of select="normalize-space(./@type)"/></xsl:attribute>
              			</wn:formatchange>
              		</xsl:for-each>
              	</xsl:for-each>
              	
              	<!-- deleted stuff   updated for JCBG-2132
              	originally, we just copied over every bj:deleted-table and bj:deleted-column in the source file
              	however, that's wrong if the deleted tables were NOT INCLUDED in the output by virtue of not being included in the categories.xsl
              	therefore, now what we'll do is:
              	     add a predicate to deleted-table to exclude tables whose @cat='', b/c those were ones not included in categories.xsl
              	     
              	     and then for columns??? we shouldn't be listing a col if the parent table is deleted or didn't 
              	
              	
              	-->
              	<xsl:for-each select="//bj:deleted-table[not(@cat='')]"><xsl:copy-of select="."/></xsl:for-each>
              	
              	<xsl:for-each select="//bj:deleted-column"><xsl:copy-of select="."/></xsl:for-each>
              </wn:changes>
			</xsl:variable>
			<!-- for debugging, to look at values of $newtables, see the temp file -->
			<xsl:result-document href="temp-changes.xml">
			<xsl:copy-of select="$changes"/>
			</xsl:result-document>
			
			<!-- new tables -->
			<xsl:if test="$changes//wn:newtable"> <!-- include this section only if there's at least 1 table -->
			
			<db:section>
				<db:title>New tables in <xsl:value-of select="$schema.whatsnew.version"/></db:title>
				<db:informaltable>
				<db:tgroup cols="2">
					<db:colspec colname="c1" colnum="1" colwidth="2in"/>
					<db:colspec colname="c2" colnum="2" colwidth="2in"/>
					
					<db:thead>
						<db:row>
							<db:entry>Category</db:entry>
							<db:entry>Table name</db:entry>
						</db:row>
					</db:thead>
					<db:tbody>

              <!-- now process $changes to create docbook ROWS-->
											
						<xsl:for-each-group select="$changes//wn:newtable" group-by="@cat">	
							<xsl:sort order="ascending" select="@cat"/> 
							<xsl:for-each select="current-group()">
								<xsl:sort order="ascending" select="normalize-space(@name)"/> 
							<db:row>
								<xsl:if test="position()=1"> <!-- only do the 1st entry in row if this is the 1st row for this category -->
									<db:entry morerows="{count(current-group())-1}"><xsl:value-of select="@cat"/></db:entry>
								</xsl:if>
								<db:entry><db:database class="table"><xsl:value-of select="./@name"/></db:database></db:entry>
							</db:row>
							</xsl:for-each>
						</xsl:for-each-group>

					</db:tbody>
				</db:tgroup></db:informaltable>
			</db:section>
			</xsl:if>
			
			<!-- new columns -->
			
			<xsl:if test="$changes//wn:newcolumn">
			<db:section>
				<db:title>New columns in <xsl:value-of select="$schema.whatsnew.version"/></db:title>
				<db:informaltable>
					<db:tgroup cols="3">
						<db:colspec colname="c1" colnum="1" colwidth="2in"/>
						<db:colspec colname="c2" colnum="2" colwidth="2in"/>
						<db:colspec colname="c3" colnum="3" colwidth="2in"/>
						
						<db:thead>
							<db:row>
								<db:entry>Category</db:entry>
								<db:entry>Table</db:entry>
								<db:entry>Column</db:entry>
							</db:row>
						</db:thead>
						<db:tbody>
							
							<!-- now process $changes to create docbook ROWS-->
							
							<xsl:for-each-group select="$changes//wn:newcolumn" group-by="@cat">	
								<xsl:sort order="ascending" select="@cat"/> 
								
								  <xsl:for-each select="current-group()">
								  	<xsl:sort order="ascending" select="normalize-space(@table)"/>
								  	<xsl:variable name="num-in-cat"><xsl:value-of select="count(current-group())-1"/></xsl:variable>
								  	
								  	<db:row>
									  <xsl:if test="position()=1"> <!-- only do the 1st entry in row if this is the 1st row for this category -->
										<db:entry morerows="{$num-in-cat}"><xsl:value-of select="@cat"/></db:entry>
									  </xsl:if>
								  		
								  		<xsl:if test="not(@table = preceding-sibling::wn:newcolumn[1]/@table)">
								  	      <db:entry morerows="{count($changes//wn:newcolumn[@table=current()/@table])-1}"><db:phrase security="writeronly">[<xsl:value-of select="position()"/>]</db:phrase><db:database class="table"><xsl:value-of select="normalize-space(./@table)"/></db:database></db:entry>
								  		</xsl:if>
								  		<db:entry><db:phrase security="writeronly">[<xsl:value-of select="position()"/>][]<xsl:value-of select="normalize-space(./@table)"/>]</db:phrase><xsl:value-of select="normalize-space(./@name)"/></db:entry>
								
								  	</db:row>
							     </xsl:for-each>
							   
							</xsl:for-each-group>
						</db:tbody>
					</db:tgroup></db:informaltable>
			</db:section></xsl:if>
			
			<!-- format changes go here -->
			
			<xsl:if test="//bj:format[@last][@added=$schema.whatsnew.version]">
				<db:section>
					<db:title>Format changes for columns in <xsl:value-of select="$schema.whatsnew.version"/></db:title>
					<db:informaltable>
						<db:tgroup cols="3">
							<db:colspec colname="c1" colnum="1" colwidth="2in"/>
							<db:colspec colname="c2" colnum="2" colwidth="2in"/>
							<db:colspec colname="c3" colnum="3" colwidth="2in"/>
							
							<db:thead>
								<db:row>
									<db:entry>Table</db:entry>
									<db:entry>Column</db:entry>
									<db:entry>Format</db:entry>
								</db:row>
							</db:thead>
							<db:tbody>
								
								
								
								<xsl:for-each-group select="$changes//wn:formatchange" group-by="@table">	 <!-- group by table name-->
									<xsl:sort order="ascending" select="@table"/> <!-- sort by table name-->
									
									<xsl:for-each select="current-group()">
										<xsl:sort order="ascending" select="normalize-space(@table)"/>
										<xsl:variable name="num-in-cat"><xsl:value-of select="count(current-group())-1"/></xsl:variable>
										
										<db:row>
											<!-- table name-->
											<xsl:if test="position()=1"> <!-- only do the 1st entry in row if this is the 1st row for this category -->
												<db:entry morerows="{$num-in-cat}"><db:database><xsl:value-of select="@table"/></db:database></db:entry> 
											</xsl:if>
											
												<!-- col name-->
												<!-- note that I used a literal and NOT a database to wrap these names to avoid accidental links when a colname happens to match a table name -->
											<db:entry><db:literal><xsl:value-of select="@column"/></db:literal></db:entry>
											
											<!-- format and old format -->
											<db:entry><db:phrase security="writeronly">[<xsl:value-of select="position()"/>][<xsl:value-of select="@table"/>][<xsl:value-of select="@column"/>]</db:phrase><xsl:value-of select="@type"/> was <xsl:value-of select="@last"/></db:entry>
											
										</db:row>
									</xsl:for-each>
									
								</xsl:for-each-group>
							</db:tbody>
						</db:tgroup></db:informaltable>
				</db:section></xsl:if>
			
			
			
			<!-- Deleted tables -->
			
			<xsl:if test="$changes//bj:deleted-table[@removed=$schema.whatsnew.version]">
				<db:section>
					<db:title>Tables removed in <xsl:value-of select="$schema.whatsnew.version"/></db:title>
					<db:informaltable>
						<db:tgroup cols="2">
							<db:colspec colname="c1" colnum="1" colwidth="2in"/>
							<db:colspec colname="c2" colnum="2" colwidth="2in"/>
							
							<db:thead>
								<db:row>
									<db:entry>Category</db:entry>
									<db:entry>Removed Tables</db:entry>
								</db:row>
							</db:thead>
							<db:tbody>
								
								
								<xsl:for-each-group select="$changes//bj:deleted-table[@removed=$schema.whatsnew.version]" group-by="@cat">	
									<xsl:sort order="ascending" select="@cat"/> 
									<xsl:for-each select="current-group()">
										<xsl:sort order="ascending" select="normalize-space(@name)"/> 
									    <db:row>	
										<!-- category -->
										  <xsl:if test="position()=1">
										    <db:entry morerows="{count(current-group())-1}"><xsl:value-of select="@cat"/></db:entry>
										   </xsl:if>
										<!-- table name -->
									    	<db:entry><db:phrase security="writeronly">[<xsl:value-of select="position()"/>][<xsl:value-of select="@cat"/>][<xsl:value-of select="@removed"/>]</db:phrase><db:database class="table"><xsl:value-of select="normalize-space(@name)"/></db:database></db:entry>
																		
									    </db:row>
									
								</xsl:for-each></xsl:for-each-group>
								
							</db:tbody>
						</db:tgroup></db:informaltable>
				</db:section></xsl:if>
			
			<!-- Deleted columns -->
			
			<xsl:if test="$changes//bj:deleted-column[@removed=$schema.whatsnew.version]">
				<db:section>
					<db:title>Tables with columns removed in <xsl:value-of select="$schema.whatsnew.version"/></db:title>
					<db:informaltable>
						<db:tgroup cols="3">
							<db:colspec colname="c1" colnum="1" colwidth="2in"/>
							<db:colspec colname="c2" colnum="2" colwidth="2in"/>
							<db:colspec colname="c3" colnum="3" colwidth="2in"/>
							
							<db:thead>
								<db:row>
									<db:entry>Category</db:entry>
									<db:entry>Table with removed columns</db:entry>
									<db:entry>Removed columns</db:entry>
								</db:row>
							</db:thead>
							<db:tbody>
								
																
								
							
								
								<xsl:for-each-group select="$changes//bj:deleted-column[@removed=$schema.whatsnew.version]" group-by="@cat">	
									<xsl:sort order="ascending" select="@cat"/> 
									
									<xsl:for-each select="current-group()">
										<xsl:sort order="ascending" select="normalize-space(@table)"/>
										<xsl:variable name="num-in-cat"><xsl:value-of select="count(current-group())-1"/></xsl:variable>
										
										<db:row>
											<xsl:if test="position()=1"> <!-- only do the 1st entry in row if this is the 1st row for this category -->
												<db:entry morerows="{$num-in-cat}"><xsl:value-of select="@cat"/></db:entry>
											</xsl:if>
											
											<xsl:if test="not(@table = preceding-sibling::bj:deletedcolumn[1]/@table)">
												<db:entry morerows="{count(//bj:deletedcolumn[@table=current()/@table])-1}"><db:phrase security="writeronly">[<xsl:value-of select="position()"/>]</db:phrase><db:database class="table"><xsl:value-of select="normalize-space(./@table)"/></db:database></db:entry>
											</xsl:if>
											<db:entry><db:phrase security="writeronly">[<xsl:value-of select="position()"/>][]<xsl:value-of select="normalize-space(./@table)"/>]</db:phrase><xsl:value-of select="normalize-space(./@name)"/></db:entry>
											
										</db:row>
									</xsl:for-each>
									
								</xsl:for-each-group>
								
								
							</db:tbody>
						</db:tgroup></db:informaltable>
				</db:section></xsl:if>
			

		</db:section>
	</xsl:template>
	
	
		
	
	

	



	
	


	




</xsl:stylesheet>
