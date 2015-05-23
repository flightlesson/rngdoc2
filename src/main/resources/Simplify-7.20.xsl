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

  <xsl:template mode="Simplify-7.20" match="/">
    <xsl:if test="$debug-level > 0">
      <xsl:message>Simplify-7.20: next-step is Simplify-7.22, stop-after is <xsl:value-of select="$stop-after"/></xsl:message>
    </xsl:if>
    <xsl:if test="$debug-level &gt; 1">
      <xsl:message>tranforms ...</xsl:message>
    </xsl:if>

    <xsl:variable name="transformed">
      <xsl:apply-templates mode="Simplify-7.20"/>
    </xsl:variable>

    <xsl:if test="$debug-level &gt; 1">
      <redirect:write file="debug-Simplify-7.20.xml">
        <xsl:copy-of select="$transformed"/>
      </redirect:write>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="$stop-after='Simplify-7.20'">
        <xsl:copy-of select="$transformed"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="exsl:node-set($transformed)" mode="Simplify-7.22"/> 
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- END OF BOILERPLATE -->

  <xsl:template mode="Simplify-7.20" match="rng:*|text()|@*">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="Simplify-7.20"/>
      <xsl:copy-of select="a:documentation"/>
      <xsl:copy-of select="xhtml:div"/>
      <xsl:apply-templates mode="Simplify-7.20"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template mode="Simplify-7.20" match="/rng:grammar">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="Simplify-7.20"/>
      <xsl:copy-of select="a:documentation"/>
      <xsl:copy-of select="xhtml:div"/>
      <xsl:apply-templates mode="Simplify-7.20"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template mode="Simplify-7.20" match="rng:element[not(parent::rng:define)]">
    <ref name="__{rng:name}-elt-{generate-id()}"/>
  </xsl:template>

  <xsl:template mode="Simplify-7.20" match="rng:define[not(rng:element)]"/>

  <xsl:template mode="Simplify-7.20" match="rng:ref[@name=/*/rng:define[not(rng:element)]/@name]">
    <xsl:apply-templates select="/*/rng:define[@name=current()/@name]/*" mode="Simplify-7.20"/>
  </xsl:template>

  <xsl:template mode="Simplify-7.20" match="*"/>
</xsl:stylesheet>
