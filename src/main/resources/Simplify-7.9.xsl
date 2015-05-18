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

  <xsl:template mode="Simplify-7.9" match="/">
    <xsl:if test="$debug-level > 0">
      <xsl:message>Simplify-7.9: next-step is Simplify-7.10, stop-after is <xsl:value-of select="$stop-after"/></xsl:message>
    </xsl:if>
    <xsl:if test="$debug-level &gt; 1">
      <xsl:message>tranforms ...</xsl:message>
    </xsl:if>

    <xsl:variable name="transformed">
      <xsl:apply-templates mode="Simplify-7.9"/>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$stop-after='Simplify-7.9'">
        <xsl:copy-of select="$transformed"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="exsl:node-set($transformed)" mode="Simplify-7.10"/> 
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- END OF BOILERPLATE -->

  <xsl:template mode="Simplify-7.9" match="rng:*|text()|@*">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="Simplify-7.9"/>
      <xsl:copy-of select="a:documentation"/>
      <xsl:copy-of select="xhtml:div"/>
      <xsl:apply-templates mode="Simplify-7.9"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template mode="Simplify-7.9" match="@name[parent::rng:element|parent::rng:attribute]"/>

  <xsl:template mode="Simplify-7.9" match="rng:element[@name]|rng:attribute[@name]">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="Simplify-7.9"/>
      <xsl:copy-of select="a:documentation"/>
      <xsl:copy-of select="xhtml:div"/>
      <xsl:if test="self::rng:attribute and not(@ns)">
        <xsl:attribute name="ns"/>
      </xsl:if>
      <name>
        <xsl:value-of select="@name"/>
      </name>
      <xsl:apply-templates mode="Simplify-7.9"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="*" mode="Simplify-7.9"/>
</xsl:stylesheet>
