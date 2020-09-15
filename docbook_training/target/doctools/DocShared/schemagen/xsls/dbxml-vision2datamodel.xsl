<?xml version ="1.0"?>
<!DOCTYPE stylesheet>

  <xsl:stylesheet version="1.1"
	xmlns:bj="http://www.broadjump.com/datamodel" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output
	  method="xml"
	  indent="yes"/>

	<!--     <xsl:template match="@*|node()"> -->
	<!--       <xsl:copy> -->
	<!--         <xsl:apply-templates select="@*|node()"/> -->
	<!--       </xsl:copy> -->
	<!--     </xsl:template> -->

	<xsl:template match="dbxv_tree|dbxv_query">
	  <bj:subsystem xmlns:bj="http://www.broadjump.com/datamodel" name="Data Mart">
		<bj:title>Datamart schema reference</bj:title>
		<bj:description>
		  <para>FIXME</para>
		</bj:description>
		<xsl:apply-templates select="schema[1]/tables/table"/>
	  </bj:subsystem>
	</xsl:template>
	
	<xsl:template match="table[not(substring(./table_name,1,4) = 'STG_')]">
	  <bj:table>
		<xsl:attribute name="name">
		  <xsl:value-of select="./table_name"/>
		</xsl:attribute>
		<bj:description>
		  <para>FIXME</para>
		</bj:description>
		<xsl:apply-templates select="table_columns/table_column"/>
	  </bj:table>
	</xsl:template>
	
	<xsl:template match="table[substring(./table_name,1,4) = 'STG_']"/>

	<xsl:template match="table_column">
	  <xsl:variable name="COLUMN_NAME" select="COLUMN_NAME"/>
	  <bj:column>
		<xsl:attribute name="name">
		  <xsl:value-of select="$COLUMN_NAME"/>
		</xsl:attribute>
		<bj:description>
		  <xsl:choose>
			<xsl:when test="$COLUMN_NAME = 'DM_CREATED_DATE'">
			  <para>Time stamp indicating when the record was created.</para>
			</xsl:when>
			<xsl:when test="$COLUMN_NAME = 'DM_UPDATED_DATE'">
			  <para>Time stamp indicating when the record was last updated.</para>
			</xsl:when>
			<!-- If it's a foreign key, don't put fixme in
			because we'll autogenerate some text. -->
			<xsl:when 
			  test="$COLUMN_NAME = ../../imported_keys/imported_key/FKCOLUMN_NAME or 
			  $COLUMN_NAME = ../../primary_keys/pk/COLUMN_NAME ">
			  
			  <para><xsl:comment>boilerplate text will be generated. Put any additions to that here</xsl:comment></para></xsl:when>
			<xsl:otherwise><para>FIXME</para></xsl:otherwise>
		  </xsl:choose>
		</bj:description>
		<xsl:choose>
		  <xsl:when test="$COLUMN_NAME = 'DM_CREATED_DATE' or $COLUMN_NAME = 'DM_UPDATED_DATE'"></xsl:when>
		  <xsl:when test="./TYPE_NAME = 'DATE'"><xsl:comment>Date examples are automatically populated as 4/24/2003 4:59:59 PM. If that is not correct as an example, then put in your own bj:example element and its contents will be picked up. </xsl:comment></xsl:when>
		  <xsl:otherwise>
			<bj:example>FIXME</bj:example>
		  </xsl:otherwise>
		</xsl:choose>
<!-- 		<xsl:choose> -->
<!-- 		  <xsl:when test="$COLUMN_NAME = 'DM_CREATED_DATE' or $COLUMN_NAME = 'DM_UPDATED_DATE'"></xsl:when> -->
<!-- 		  <xsl:otherwise> -->
		<bj:format>
		  <xsl:attribute name="type">
			<xsl:value-of select="TYPE_NAME"/>
		  </xsl:attribute>
		  <xsl:if test="not(./TYPE_NAME = 'NUMBER') and 
			not(./TYPE_NAME = 'DATE')">
			<xsl:attribute name="size">
			  <xsl:value-of select="COLUMN_SIZE"/>
			</xsl:attribute>
		  </xsl:if>
		  <xsl:attribute name="nullable">
			<xsl:choose>
			  <xsl:when test="./NULLABLE = '1'">true</xsl:when>
			  <xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		  </xsl:attribute>
		  <xsl:if test="$COLUMN_NAME = ../../primary_keys/pk/COLUMN_NAME">
			<xsl:attribute name="primaryKey">true</xsl:attribute>
		  </xsl:if>
		  <xsl:if test="$COLUMN_NAME = ../../imported_keys/imported_key/FKCOLUMN_NAME">
			<xsl:attribute name="foreignKey">
			  <xsl:value-of select="../../imported_keys/imported_key/PKTABLE_NAME[following-sibling::FKCOLUMN_NAME = $COLUMN_NAME]"/>.<xsl:value-of select="../../imported_keys/imported_key/PKCOLUMN_NAME[following-sibling::FKCOLUMN_NAME = $COLUMN_NAME]"/>
			</xsl:attribute>
		  </xsl:if>
		  <!-- Others? -->
		</bj:format>
<!-- 		  </xsl:otherwise> -->
<!-- 		</xsl:choose> -->
		<xsl:choose>
		  <xsl:when test="$COLUMN_NAME = ../../primary_keys/pk/COLUMN_NAME"><!-- if it's a primary key, noop. --></xsl:when>
		  <xsl:when test="$COLUMN_NAME = 'DM_CREATED_DATE'"></xsl:when>
		  <xsl:when test="$COLUMN_NAME = 'DM_UPDATED_DATE'"></xsl:when>
<!-- 		  <xsl:otherwise> -->
<!-- 			<bj:source> -->
<!-- 			  FIXME -->
<!-- 			</bj:source> -->
<!-- 		  </xsl:otherwise> -->
		</xsl:choose>
	  </bj:column>
	</xsl:template>

  </xsl:stylesheet>
