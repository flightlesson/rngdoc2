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

  <xsl:template mode="Normalize-010" match="/">
    <xsl:if test="$debug-level > 0">
      <xsl:message>Normalize-020: next-step is Normalize-???, stop-after is <xsl:value-of select="$stop-after"/></xsl:message>
    </xsl:if>
    <xsl:if test="$debug-level &gt; 1">
      <xsl:message>tranforms ...</xsl:message>
    </xsl:if>

    <xsl:variable name="transformed">
      <xsl:apply-templates mode="Normalize-020"/>
    </xsl:variable>

    <xsl:if test="$debug-level &gt; 1">
      <redirect:write file="debug-Normalize-020.xml">
        <xsl:copy-of select="$transformed"/>
      </redirect:write>
    </xsl:if>

    <xsl:if test="$debug-level &gt; 1">
      <exsl:document href="debug-Normalize-020.xml" method="xml" indent="no">
        <xsl:copy-of select="$transformed"/>
      </exsl:document>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="$stop-after='Normalize-020'">
        <xsl:copy-of select="$transformed"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="exsl:node-set($transformed)" mode="Normalize-030"/> 
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- END OF BOILERPLATE -->

  <!-- change <choice><empty/><oneOrMore>{whatever}</oneOrMore></choice> to <zeroOrMore>{whatever}</zeroOrMore> -->
  <xsl:template mode="Normalize-020" match="rng:choice[count(*)=2 and rng:empty and rng:oneOrMore]">
    <zeroOrMore>
      <xsl:apply-templates select="rng:oneOrMore/*" mode="Normalize-020"/>
    </zeroOrMore>
  </xsl:template>

  <!-- change <choice><empty/>{whatever}</choice> to <optional>{whatever}</optional> -->
  <xsl:template mode="Normalize-020" match="rng:choice[count(*)=2 and rng:empty]">
    <optional>
      <xsl:apply-templates select="rng:*[not(rng:empty)]" mode="Normalize-020"/>
    </optional>
  </xsl:template>

  <xsl:template mode="Normalize-020" match="rng:*|text()">
    <xsl:message>expanding</xsl:message>
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="Normalize-020"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
