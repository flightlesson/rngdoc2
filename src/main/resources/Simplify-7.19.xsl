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

  <xsl:template mode="Simplify-7.19" match="/">
    <xsl:if test="$debug-level > 0">
      <xsl:message>Simplify-7.19: next-step is Simplify-7.20, stop-after is <xsl:value-of select="$stop-after"/></xsl:message>
    </xsl:if>
    <xsl:if test="$debug-level &gt; 1">
      <xsl:message>tranforms ...</xsl:message>
    </xsl:if>

    <xsl:variable name="transformed">
      <xsl:apply-templates mode="Simplify-7.19"/>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$stop-after='Simplify-7.19'">
        <xsl:copy-of select="$transformed"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="exsl:node-set($transformed)" mode="Simplify-7.20"/> 
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- END OF BOILERPLATE -->

  <xsl:template mode="Simplify-7.19" match="/rng:grammar">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="Simplify-7.19"/>
      <xsl:copy-of select="a:documentation"/>
      <xsl:apply-templates select="rng:*" mode="Simplify-7.19"/>
      <xsl:apply-templates select="//rng:element[not(parent::rng:define)]" mode="step7.19-define"/>
    </xsl:copy>
  </xsl:template>

  <!-- takes care of <element> whose parent was not <define> -->
  <xsl:template mode="step7.19-define" match="rng:element">
    <define name="__{rng:name}-elt-{generate-id()}">
      <xsl:copy>
        <xsl:apply-templates select="@*" mode="Simplify-7.19"/>
        <xsl:copy-of select="a:documentation"/>
        <xsl:copy-of select="xhtml:div"/>
        <xsl:apply-templates select="rng:*|text()" mode="Simplify-7.19"/>
      </xsl:copy>
    </define>
  </xsl:template>

  <!-- remove <define>s without an <element> child -->
  <xsl:template mode="Simplify-7.19" match="rng:define[not(rng:element)]"/>

  <xsl:template mode="Simplify-7.19" match="rng:define">
    <!-- fixme: add test to ensure this define is reachable -->
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="Simplify-7.19"/>
      <xsl:copy-of select="a:documentation"/>
      <xsl:copy-of select="xhtml:div"/>
      <xsl:apply-templates mode="Simplify-7.19"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template mode="Simplify-7.19" match="*"/>

  <!-- expand attribute <ref>s -->
  <xsl:template mode="Simplify-7.19" match="rng:ref[@name=/*/rng:define[not(rng:element)]/@name][rng:attribute]">
    <xsl:apply-templates select="/*/rng:define[@name=current()/@name]/rng:attribute" mode="step7.19-attribute"/>
  </xsl:template>
  
  <xsl:template mode="Simplify-7.19" match="rng:ref[@name=/*/rng:define[not(rng:element)]/@name]">
    <xsl:apply-templates select="/*/rng:define[@name=current()/@name]/*" mode="Simplify-7.19"/>
  </xsl:template>
  
  <xsl:template mode="step7.19-attribute" match="rng:attribute">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:copy-of select="parent::rng:define/a:documentation"/>
      <xsl:copy-of select="a:documentation"/>
      <xsl:copy-of select="parent::rng:define/xhtml:div"/>
      <xsl:copy-of select="xhtml:div"/>
      <xsl:apply-templates select="*" mode="Simplify-7.19"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template mode="Simplify-7.19" match="rng:*|text()|@*">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="Simplify-7.19"/>
      <xsl:copy-of select="a:documentation"/>
      <xsl:copy-of select="xhtml:div"/>
      <xsl:apply-templates mode="Simplify-7.19"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
