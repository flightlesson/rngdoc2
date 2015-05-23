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

  <xsl:template mode="Simplify-7.02" match="/">
    <xsl:if test="$debug-level > 0">
      <xsl:message>Simplify-7.02: stop-after is <xsl:value-of select="$stop-after"/></xsl:message>
    </xsl:if>

    <xsl:variable name="transformed">
      <xsl:apply-templates mode="Simplify-7.02"/>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$stop-after='Simplify-7.02'">
        <xsl:copy-of select="$transformed"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="exsl:node-set($transformed)" mode="Simplify-7.03"/> 
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- END OF BOILERPLATE -->

  <xsl:template mode="Simplify-7.02" match="rng:grammar|rng:start|rng:define|rng:element|rng:attribute|rng:ref">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="Simplify-7.02"/>
      <xsl:copy-of select="a:documentation|xhtml:div"/>
      <xsl:apply-templates mode="Simplify-7.02"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template mode="Simplify-7.02" match="rng:*|text()|@*[namespace-uri()='']|@a:defaultValue">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="Simplify-7.02"/>
      <xsl:apply-templates mode="Simplify-7.02"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template mode="Simplify-7.02" match="*|@*"/>
</xsl:stylesheet>
