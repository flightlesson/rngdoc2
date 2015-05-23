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

    <xsl:param name="stop-after">Normalize-020</xsl:param>
    <xsl:param name="debug-level">0</xsl:param>

    <xsl:template match="/">

      <xsl:message>debug-level is <xsl:value-of select="$debug-level"/>, stop-after is <xsl:value-of select="$stop-after"/></xsl:message>
      <xsl:if test="$debug-level > 0">
        <xsl:message>Inside expander, stop-after is <xsl:value-of select="$stop-after"/></xsl:message>
      </xsl:if>

      <xsl:apply-templates mode="Normalize-010" select="/"/>

    </xsl:template>

    <!-- Each of these includes should follow the pattern established in Simplify-7.2.xsl -->

    <xsl:include href="Normalize-010.xsl"/>
    <xsl:include href="Normalize-020.xsl"/>
</xsl:stylesheet>
