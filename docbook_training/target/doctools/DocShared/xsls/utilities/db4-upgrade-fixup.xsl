<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:exsl="http://exslt.org/common"
	xmlns:db = "http://docbook.org/ns/docbook"
	xmlns = "http://docbook.org/ns/docbook"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	exclude-result-prefixes="exsl db"
	version="2.0">
	
	
<!--
	<xsl:param name="this"/>
	

<xsl:template match="/">
		<xsl:variable name="shares_fixed">
			<xsl:apply-templates select="@*|node()" mode="fix-shares"/>
		</xsl:variable>
		<xsl:apply-templates select="$shares_fixed"/>		
	</xsl:template>
	
	<xsl:template match="@*|node()" mode="fix-shares">
		<xsl:choose>
			<xsl:when test="ends-with(local-name(.), '_share') and not($this = '') and @sharer_doc = 'this'">
				<xsl:copy>
					<xsl:apply-templates mode="fix-shares"/>
				</xsl:copy>								
			</xsl:when>
			<xsl:when test="ends-with(local-name(.), '_share') and not($this = '')">
				<xi:include xmlns:xi="http://www.w3.org/2001/XInclude" href="{@sharer_doc}" xpointer="{@sharer_id}"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:apply-templates mode="fix-shares"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
-->	
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="db:interface">
	  <phrase remap="interface"><xsl:apply-templates/></phrase>
	</xsl:template>

	<xsl:template match="db:biblioid">
	  <biblioid class="other" otherclass="invpartnumber"><xsl:apply-templates select="@*[not(local-name(.) = 'class')]|node()"/></biblioid>
	</xsl:template>

	<xsl:template match="@is_shared"/>

	<!-- <xsl:template match="db:para[./db:para or ./db:share_para]"> -->
	<!--   <xsl:copy> -->
	<!--     <xsl:apply-templates select="@*|node()[not(local-name(.) = 'db:para') and not(local-name(.) = 'db:share_para')]"/> -->
	<!--   </xsl:copy> -->
	<!--   <xsl:apply-templates select="*[local-name(.) = 'db:para']|*[local-name(.) = 'db:share_para']"/> -->
	<!-- </xsl:template> -->
	
	<xsl:template match="db:entry">
		<xsl:choose>
			<xsl:when test="./text()[normalize-space(.) != ''] and not(./para)">
				<xsl:message>Fixing entry</xsl:message>
				<entry>
					<xsl:apply-templates select="@*"/>
					<para>
						<xsl:apply-templates select="node()"/>
					</para>
				</entry>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:apply-templates select="@*|node()"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="@rotate"><xsl:attribute name="rotate">1</xsl:attribute></xsl:template>
	
	<xsl:template match="db:xref">
		<xsl:choose>
			<xsl:when test="@share_linkend">
				<xsl:message>Found share_linkend</xsl:message>
				<remark>FIXME: &lt;xref share_linkend="<xsl:value-of select="@share_linkend"/></remark>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:apply-templates select="@*|node()"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="@security[. = 'internal']"><xsl:attribute name="security">internal</xsl:attribute></xsl:template>
	
</xsl:stylesheet>