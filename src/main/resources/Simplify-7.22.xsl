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

  <xsl:template mode="Simplify-7.22" match="/">
    <xsl:if test="$debug-level > 0">
      <xsl:message>Simplify-7.22: next-step is ???, stop-after is <xsl:value-of select="$stop-after"/></xsl:message>
    </xsl:if>
    <xsl:if test="$debug-level &gt; 1">
      <xsl:message>tranforms ...</xsl:message>
    </xsl:if>

    <xsl:variable name="transformed">
      <xsl:apply-templates mode="Simplify-7.22"/>
    </xsl:variable>

    <!--
    <xsl:choose>
      <xsl:when test="$stop-after='Simplify-7.22'">
        <xsl:copy-of select="$transformed"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="exsl:node-set($transformed)" mode="???"/> 
      </xsl:otherwise>
    </xsl:choose>
    -->
    <xsl:copy-of select="$transformed"/>
  </xsl:template>

  <!-- END OF BOILERPLATE -->

  <xsl:template mode="Simplify-7.22" match="rng:*|text()|@*">
    <xsl:param name="updated" select="0"/>
    <xsl:copy>
      <xsl:if test="$updated != 0">
        <xsl:attribute name="updated"><xsl:value-of select="$updated"/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates mode="Simplify-7.22" select="@*"/>
      <xsl:copy-of select="a:documentation"/>
      <xsl:copy-of select="xhtml:div"/>
      <xsl:apply-templates mode="Simplify-7.22"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template mode="Simplify-7.22" match="@updated"/>

  <xsl:template mode="Simplify-7.22" match="/rng:grammar">
    <xsl:variable name="thisIteration-rtf">
      <xsl:copy>
        <xsl:apply-templates select="@*" mode="Simplify-7.22"/>
        <xsl:copy-of select="a:documentation"/>
        <xsl:copy-of select="xhtml:div"/>
        <xsl:apply-templates mode="Simplify-7.22"/>
      </xsl:copy>
    </xsl:variable>
    <xsl:variable name="thisIteration" select="exsl:node-set($thisIteration-rtf)"/>
    <xsl:choose>
      <xsl:when test="$thisIteration//@updated">
        <xsl:apply-templates select="$thisIteration/rng:grammar" mode="Simplify-7.22"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$thisIteration-rtf"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template mode="Simplify-7.22" match="rng:choice[*[1][not(self::rng:empty)] and *[2][self::rng:empty]]">
    <xsl:copy>
      <xsl:attribute name="updated">1</xsl:attribute>
      <xsl:copy-of select="a:documentation"/>
      <xsl:copy-of select="xhtml:div"/>
      <xsl:apply-templates select="*[2]" mode="Simplify-7.22"/>
      <xsl:apply-templates select="*[1]" mode="Simplify-7.22"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template mode="Simplify-7.22" match="rng:group[count(rng:empty)=1]|rng:interleave[count(rng:empty)=1]">
    <xsl:apply-templates select="*[not(self::rng:empty)]" mode="Simplify-7.22">
      <xsl:with-param name="updated" select="1"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template mode="Simplify-7.22" match="rng:group[count(rng:empty)=2]|rng:interleave[count(rng:empty)=2]|rng:choice[count(rng:empty)=2]|rng:oneOrMore[rng:empty]">
    <rng:empty updated="1"/>
  </xsl:template>

  <xsl:template mode="Simplify-7.22" match="*"/>
</xsl:stylesheet>
