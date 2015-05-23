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

<!-- tsingle: Derived from Eric van der Vlist's http://downloads.xmlschemata.org/relax-ng/utilities/simplification.xsl
     which seems based on the steps at https://www.oasis-open.org/committees/relax-ng/spec-20011203.html#simplification.
     Eric's script has been refactored and modified to retain <a:documentation> and <xhtml:div> comments. -->

    <xsl:param name="start-at">Simplify-7.2</xsl:param>
    <xsl:param name="stop-after">Simplify-7.22</xsl:param>
    <xsl:param name="debug-level">0</xsl:param>

    <xsl:template match="/">

      <xsl:if test="$debug-level > 0">
        <xsl:message>Simplify: start-at=<xsl:value-of select="$start-at"
                     />, stop-after=<xsl:value-of select="$stop-after"/></xsl:message>
      </xsl:if>

      <xsl:choose>
        <xsl:when test="$start-at = 'Simplify-7.03'"><xsl:apply-templates mode="Simplify-7.03" select="/"/></xsl:when>
        <xsl:when test="$start-at = 'Simplify-7.04'"><xsl:apply-templates mode="Simplify-7.04" select="/"/></xsl:when>
        <xsl:when test="$start-at = 'Simplify-7.05'"><xsl:apply-templates mode="Simplify-7.05" select="/"/></xsl:when>
        <xsl:when test="$start-at = 'Simplify-7.07'"><xsl:apply-templates mode="Simplify-7.07" select="/"/></xsl:when>
        <xsl:when test="$start-at = 'Simplify-7.08'"><xsl:apply-templates mode="Simplify-7.08" select="/"/></xsl:when>
        <xsl:when test="$start-at = 'Simplify-7.09'"><xsl:apply-templates mode="Simplify-7.09" select="/"/></xsl:when>
        <xsl:when test="$start-at = 'Simplify-7.10'"><xsl:apply-templates mode="Simplify-7.10" select="/"/></xsl:when>
        <xsl:when test="$start-at = 'Simplify-7.11'"><xsl:apply-templates mode="Simplify-7.11" select="/"/></xsl:when>
        <xsl:when test="$start-at = 'Simplify-7.12'"><xsl:apply-templates mode="Simplify-7.12" select="/"/></xsl:when>
        <xsl:when test="$start-at = 'Simplify-7.13'"><xsl:apply-templates mode="Simplify-7.13" select="/"/></xsl:when>
        <xsl:when test="$start-at = 'Simplify-7.14'"><xsl:apply-templates mode="Simplify-7.14" select="/"/></xsl:when>
        <xsl:when test="$start-at = 'Simplify-7.15'"><xsl:apply-templates mode="Simplify-7.15" select="/"/></xsl:when>
        <xsl:when test="$start-at = 'Simplify-7.16'"><xsl:apply-templates mode="Simplify-7.16" select="/"/></xsl:when>
        <xsl:when test="$start-at = 'Simplify-7.18'"><xsl:apply-templates mode="Simplify-7.18" select="/"/></xsl:when>
        <xsl:when test="$start-at = 'Simplify-7.19'"><xsl:apply-templates mode="Simplify-7.19" select="/"/></xsl:when>
        <xsl:when test="$start-at = 'Simplify-7.20'"><xsl:apply-templates mode="Simplify-7.20" select="/"/></xsl:when>
        <xsl:when test="$start-at = 'Simplify-7.22'"><xsl:apply-templates mode="Simplify-7.22" select="/"/></xsl:when>
        <xsl:otherwise>                              <xsl:apply-templates mode="Simplify-7.02" select="/"/></xsl:otherwise>
      </xsl:choose>

    </xsl:template>

    <!-- Each of these includes should follow the pattern established in Simplify-7.02.xsl -->
    
    <xsl:include href="Simplify-7.02.xsl"/>
    <xsl:include href="Simplify-7.03.xsl"/>
    <xsl:include href="Simplify-7.04.xsl"/>
    <xsl:include href="Simplify-7.05.xsl"/>
    <xsl:include href="Simplify-7.07.xsl"/>
    <xsl:include href="Simplify-7.08.xsl"/>
    <xsl:include href="Simplify-7.09.xsl"/>
    <xsl:include href="Simplify-7.10.xsl"/>
    <xsl:include href="Simplify-7.11.xsl"/>
    <xsl:include href="Simplify-7.12.xsl"/>
    <xsl:include href="Simplify-7.13.xsl"/>
    <xsl:include href="Simplify-7.14.xsl"/>
    <xsl:include href="Simplify-7.15.xsl"/>
    <xsl:include href="Simplify-7.16.xsl"/>
    <xsl:include href="Simplify-7.18.xsl"/>
    <xsl:include href="Simplify-7.19.xsl"/>
    <xsl:include href="Simplify-7.20.xsl"/>
    <xsl:include href="Simplify-7.22.xsl"/>
</xsl:stylesheet>
