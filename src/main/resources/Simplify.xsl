<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns="http://relaxng.org/ns/structure/1.0"
                xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
                xmlns:rng="http://relaxng.org/ns/structure/1.0"
                xmlns:exsl="http://exslt.org/common"
                xmlns:redirect="http://xml.apache.org/xalan/redirect"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                extension-element-prefixes="redirect"
                exclude-result-prefixes = "exsl rng">

    <xsl:output method="xml" omit-xml-declaration="yes"/>

    <xsl:param name="start-at">Simplify-4.01</xsl:param>
    <xsl:param name="stop-after">Simplify-4.06</xsl:param>
    <xsl:param name="debug-level">0</xsl:param>

    <xsl:template match="/">

      <xsl:if test="$debug-level > 0">
        <xsl:message>Simplify: start-at=<xsl:value-of select="$start-at"/>, stop-after=<xsl:value-of select="$stop-after"/></xsl:message>      
      </xsl:if>

      <xsl:choose>
        <xsl:when test="$start-at = 'Simplify-4.02'"><xsl:apply-templates mode="Simplify-4.02" select="/"/></xsl:when>
        <xsl:when test="$start-at = 'Simplify-4.03'"><xsl:apply-templates mode="Simplify-4.03" select="/"/></xsl:when>
        <xsl:when test="$start-at = 'Simplify-4.04'"><xsl:apply-templates mode="Simplify-4.04" select="/"/></xsl:when>
        <xsl:when test="$start-at = 'Simplify-4.05'"><xsl:apply-templates mode="Simplify-4.05" select="/"/></xsl:when>
        <xsl:when test="$start-at = 'Simplify-4.06'"><xsl:apply-templates mode="Simplify-4.06" select="/"/></xsl:when>
        <xsl:otherwise>                              <xsl:apply-templates mode="Simplify-4.01" select="/"/></xsl:otherwise>
      </xsl:choose>

    </xsl:template>
    
    <xsl:include href="Simplify-4.01.xsl"/>
    <xsl:include href="Simplify-4.02.xsl"/>
    <xsl:include href="Simplify-4.03.xsl"/>
    <xsl:include href="Simplify-4.04.xsl"/>
    <xsl:include href="Simplify-4.05.xsl"/>
    <xsl:include href="Simplify-4.06.xsl"/>
</xsl:stylesheet>
