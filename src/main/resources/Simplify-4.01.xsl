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

  <xsl:template mode="Simplify-4.01" match="/">
    <xsl:param name="stop-after" select="$stop-after"/>
    <xsl:param name="input-uri" select="$input-uri"/>
    <xsl:if test="$debug-level > 0">
      <xsl:message>Simplify-4.01: stop-after is <xsl:value-of select="$stop-after"/>, debug-level=<xsl:value-of select="$debug-level"/>, input-uri is <xsl:value-of select="$input-uri"/></xsl:message>
    </xsl:if>

    <xsl:variable name="transformed">
      <xsl:apply-templates mode="Simplify-4.01"/>
    </xsl:variable>

    <xsl:if test="$debug-level &gt; 1">
      <redirect:write file="debug-Simplify-4.01{$input-uri}.xml">
        <xsl:copy-of select="$transformed"/>
      </redirect:write>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="$stop-after='Simplify-4.01'">
        <xsl:copy-of select="$transformed"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="exsl:node-set($transformed)" mode="Simplify-4.02"> 
          <xsl:with-param name="stop-after" select="$stop-after"/>
          <xsl:with-param name="input-uri" select="$input-uri"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- END OF BOILERPLATE -->

  <!--
          4.1. Annotations

          Foreign attributes and elements are removed.

          rngdoc: keep a:documentation and xhtml:div elements under certain rng elements;
          rngdoc: keep @a:defaultValue attributes.
  -->

  <xsl:template mode="Simplify-4.01" match="rng:grammar|rng:start|rng:define|rng:element|rng:attribute|rng:ref">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="Simplify-4.01"/>
      <xsl:copy-of select="a:documentation|xhtml:div"/>
      <xsl:apply-templates select="*" mode="Simplify-4.01"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template mode="Simplify-4.01" match="rng:*|text()|@*[namespace-uri()='']|@a:defaultValue">
    <xsl:copy>
      <xsl:apply-templates select="@*|*|text()" mode="Simplify-4.01"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template mode="Simplify-4.01" match="*|@*"/>
</xsl:stylesheet>
