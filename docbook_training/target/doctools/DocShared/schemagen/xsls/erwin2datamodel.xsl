<?xml version ="1.0"?>
<!-- <!DOCTYPE xsl:stylesheet> -->
  <xsl:stylesheet version="1.1"
	xmlns:bj="http://motive.com/techpubs/datamodel" 
	xmlns:ERwin="http://www.ca.com/erwin"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:EMX="http://www.ca.com/erwin/data"
	xmlns:EM2="http://www.ca.com/erwin/EM2data"
    xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns="http://docbook.org/ns/docbook"
	exclude-result-prefixes="ERwin EMX EM2"
	>

	<xsl:output
	  method="xml"
	  indent="yes"

	  />
  	
 
  	

    <!-- Declare a parameter for the title of the schema reference, to be filled by an ant property when this xsl is called
         The value below is thus just a default value.
    -->
  	<xsl:param name="schema.ref.title">XXX Title NOT SET; see schema/build.properties to set a valueXXX</xsl:param>

  	<!-- Declare a parameter for the year in dates, to be filled by an ant property when this 
  		xsl is called. The value below is thus just a default value.
  	-->
  	<xsl:param name="schema.example.year">XXX Year NOT SET XXX</xsl:param>
  	

	<!--     <xsl:template match="@*|node()"> -->
	<!--       <xsl:copy> -->
	<!--         <xsl:apply-templates select="@*|node()"/> -->
	<!--       </xsl:copy> -->
	<!--     </xsl:template> -->

	<xsl:key name="Attributes" match="EMX:Attribute" use="@id"/>

  	<xsl:template match="/" > 	
  		<!-- output a processing instruction to help Oxygen find the datamodel schema for this -->
  		<xsl:processing-instruction name="xml-model">href="../../../target/doctools/DocShared/schemas/broadbook/datamodel.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"</xsl:processing-instruction>
  		<bj:subsystem  xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:bj="http://motive.com/techpubs/datamodel" name="Data Mart">
		<bj:title><xsl:value-of select="$schema.ref.title"/></bj:title>
		<bj:description>
		  <para>FIXME</para>
		</bj:description>
		<xsl:apply-templates select="ERwin:ERwin/EMX:Model/EMX:Entity_Groups/EMX:Entity"/>
	  </bj:subsystem>
	</xsl:template>
	
	<xsl:template match="EMX:Entity[not(substring(@name,1,4) = 'STG_')]">
	  <bj:table>
		<xsl:attribute name="name">
		  <xsl:value-of select="@name"/>
		</xsl:attribute>
		<bj:description>
		  <para>FIXME</para>
		</bj:description>
		<xsl:apply-templates select="EMX:Attribute_Groups/EMX:Attribute"/>
	  </bj:table>
	</xsl:template>
	
	<xsl:template match="EMX:Entity[substring(@name,1,4) = 'STG_']"/>

	<xsl:template match="EMX:Attribute">
	  <xsl:variable name="COLUMN_NAME" select="@name"/>
	  <bj:column>
		<xsl:attribute name="name">
		  <xsl:value-of select="$COLUMN_NAME"/>
		</xsl:attribute>
		<bj:description>
		  <xsl:choose>
		        <!--<xsl:when test="$COLUMN_NAME = 'STATE'">
	  <para>Indicates that there is an allowable exception to a constraint
                            set in this table. For example, a non-unique serial number is allowed
                            if it only appears in a deleted record from the table.</para>
			</xsl:when>-->
		        <xsl:when test="$COLUMN_NAME = 'NULLINDICATOR'">
			  <para>Indicates that there is an allowable exception to a constraint 
                            set in this table. For example, a non-unique serial number is allowed
                            if it only appears in a deleted record from the table.</para>
			</xsl:when>
		        <xsl:when test="$COLUMN_NAME = 'GUID'">
			  <para>The globally unique ID for the object.</para>
			</xsl:when>
		  	<!--xsl:when test="$COLUMN_NAME = 'VERSION'">
			  <para>Indicates the version number of the associated record. The version number 
                          is used by Hibernate managed versioning for optimistic locking.</para>
			</xsl:when-->
			<xsl:when test="$COLUMN_NAME = 'INSERTED'">
			  <para>Time stamp indicating when the record was created.</para>
			</xsl:when>
			<xsl:when test="$COLUMN_NAME = 'UPDATED'">
			  <para>Time stamp indicating when the record was last updated.</para>
			</xsl:when>
			<xsl:when test="$COLUMN_NAME = 'DELETED'">
			  <para>Indicates whether an object has been logically deleted. The data store
            maintains a history of all objects ever created and uses this flag to indicate
            which ones have been logically deleted.</para>
			</xsl:when>
			<!-- If it's a foreign key, don't put fixme in
			because we'll autogenerate some text. -->
			<xsl:when 
			  test="./EMX:AttributeProps/EMX:Parent_Attribute_Ref">			 
			  <para><xsl:comment>boilerplate text will be generated. Put any additions to that here</xsl:comment></para></xsl:when>
			<xsl:when test="./EMX:AttributeProps/EMX:Type = '0'"><para><xsl:comment>boilerplate text will be generated. Text put here will replace that</xsl:comment></para></xsl:when>
			<xsl:otherwise><para>FIXME</para></xsl:otherwise>
		  </xsl:choose>
		</bj:description>
		<xsl:choose>
		<!-- This populates the bj:example element-->
		  <xsl:when test="$COLUMN_NAME = 'INSERTED' or $COLUMN_NAME = 'UPDATED'"><bj:example><xsl:value-of select="$schema.example.year"/>-09-29 17:39:05.052531</bj:example></xsl:when>
                  <xsl:when test="$COLUMN_NAME = 'STARTDATE' or $COLUMN_NAME = 'ENDDATE' or $COLUMN_NAME = 'FIRSTACTIVATED' or $COLUMN_NAME = 'LASTACTIVATED'">
                  	<bj:example><xsl:value-of select="$schema.example.year"/>-09-29</bj:example></xsl:when>
			<xsl:when test="./EMX:AttributeProps/EMX:Datatype = 'TIMESTAMP(6)'"><bj:example><xsl:value-of select="$schema.example.year"/>-09-29 17:39:05.052531</bj:example></xsl:when>
			<xsl:when test="./EMX:AttributeProps/EMX:Datatype = 'DATE'"><bj:example><xsl:value-of select="$schema.example.year"/>-09-29</bj:example></xsl:when>
		  <xsl:otherwise>
			<bj:example>FIXME</bj:example>
		  </xsl:otherwise>
		</xsl:choose>
<!-- 		<xsl:choose> -->
<!-- 		  <xsl:when test="$COLUMN_NAME = 'DM_CREATED_DATE' or $COLUMN_NAME = 'DM_UPDATED_DATE'"></xsl:when> -->
<!-- 		  <xsl:otherwise> -->
		<bj:format>
		  <xsl:attribute name="type">
			<xsl:value-of select="./EMX:AttributeProps/EMX:Datatype"/>
		  </xsl:attribute>
		  <xsl:attribute name="nullable">
			<xsl:choose>
			  <xsl:when test="./EMX:AttributeProps/EMX:Null_Option != '1'">true</xsl:when>
			  <xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		  </xsl:attribute>
		  <xsl:if test="./EMX:AttributeProps/EMX:Type = '0'"><!-- This is a guess -->
			<xsl:attribute name="primaryKey">true</xsl:attribute>
		  </xsl:if>
		  <xsl:if test="./EMX:AttributeProps/EMX:Parent_Attribute_Ref">
			<xsl:attribute name="foreignKey">
			  <xsl:value-of select="key('Attributes',./EMX:AttributeProps/EMX:Parent_Attribute_Ref)/../../@name"/>.<xsl:value-of select="key('Attributes',./EMX:AttributeProps/EMX:Parent_Attribute_Ref)/@name"/>
			</xsl:attribute>
		  </xsl:if>
		  <!-- Others? -->
		</bj:format>
<!-- 		  </xsl:otherwise> -->
<!-- 		</xsl:choose> -->
		<xsl:choose>
		  <xsl:when test="$COLUMN_NAME = ./EMX:AttributeProps/EMX:Type = '0'"><!-- if it's a primary key, noop. --></xsl:when>
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
