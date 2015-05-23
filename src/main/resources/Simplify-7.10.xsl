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

  <xsl:template mode="Simplify-7.10" match="/">
    <xsl:if test="$debug-level > 0">
      <xsl:message>Simplify-7.10: next-step is Simplify-7.11, stop-after is <xsl:value-of select="$stop-after"/></xsl:message>
    </xsl:if>
    <xsl:if test="$debug-level &gt; 1">
      <xsl:message>tranforms ...</xsl:message>
    </xsl:if>

    <xsl:variable name="transformed">
      <xsl:apply-templates mode="Simplify-7.10"/>
    </xsl:variable>

    <xsl:if test="$debug-level &gt; 1">
      <exsl:document href="debug-Simplify-7.10.xml" method="xml" indent="no">
        <xsl:copy-of select="$transformed"/>
      </exsl:document>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="$stop-after='Simplify-7.10'">
        <xsl:copy-of select="$transformed"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="exsl:node-set($transformed)" mode="Simplify-7.11"/> 
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- END OF BOILERPLATE -->

  <xsl:template mode="Simplify-7.10" match="rng:*|text()|@*">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="Simplify-7.10"/>
      <xsl:copy-of select="a:documentation"/>
      <xsl:copy-of select="xhtml:div"/>
      <xsl:apply-templates mode="Simplify-7.10"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template mode="Simplify-7.10" match="@ns"/>

  <xsl:template mode="Simplify-7.10" match="rng:name|rng:nsName|rng:value">
    <xsl:copy>
      <xsl:attribute name="ns">
        <xsl:value-of select="ancestor-or-self::*[@ns][1]/@ns"/>
      </xsl:attribute>
      <xsl:apply-templates select="@*" mode="Simplify-7.10"/>
      <xsl:copy-of select="a:documentation"/>
      <xsl:copy-of select="xhtml:div"/>
      <xsl:apply-templates mode="Simplify-7.10"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template mode="Simplify-7.10" match="*"/>
</xsl:stylesheet>
