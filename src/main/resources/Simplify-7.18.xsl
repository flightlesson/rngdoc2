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

  <xsl:template mode="Simplify-7.18" match="/">
    <xsl:if test="$debug-level > 0">
      <xsl:message>Simplify-7.18: next-step is Simplify-7.19, stop-after is <xsl:value-of select="$stop-after"/></xsl:message>
    </xsl:if>
    <xsl:if test="$debug-level &gt; 1">
      <xsl:message>tranforms ...</xsl:message>
    </xsl:if>

    <xsl:variable name="transformed">
      <xsl:apply-templates mode="Simplify-7.18"/>
    </xsl:variable>

    <xsl:if test="$debug-level &gt; 1">
      <redirect:write file="debug-Simplify-7.18.xml">
        <xsl:copy-of select="$transformed"/>
      </redirect:write>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="$stop-after='Simplify-7.18'">
        <xsl:copy-of select="$transformed"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="exsl:node-set($transformed)" mode="Simplify-7.19"/> 
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- END OF BOILERPLATE -->

  <xsl:template mode="Simplify-7.18" match="rng:*|text()|@*">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="Simplify-7.18"/>
      <xsl:copy-of select="a:documentation"/>
      <xsl:copy-of select="xhtml:div"/>
      <xsl:apply-templates mode="Simplify-7.18"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template mode="Simplify-7.18" match="@combine"/>

  <xsl:template mode="Simplify-7.18" match="rng:start[preceding-sibling::rng:start]|rng:define[@name=preceding-sibling::rng:define/@name]"/>

  <xsl:template mode="Simplify-7.18" match="rng:start[not(preceding-sibling::rng:start) and following-sibling::rng:start]">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="Simplify-7.18"/>
      <xsl:copy-of select="a:documentation"/>
      <xsl:copy-of select="xhtml:div"/>
      <xsl:element name="{parent::*/rng:start/@combine}">
        <xsl:call-template name="start7.18"/>
      </xsl:element>
    </xsl:copy>
  </xsl:template>

  <xsl:template name="start7.18">
    <xsl:param name="left" select="following-sibling::rng:start[2]"/>
    <xsl:param name="node-name" select="parent::*/rng:start/@combine"/>
    <xsl:param name="out">
      <xsl:element name="{$node-name}">
        <xsl:apply-templates select="*" mode="Simplify-7.18"/>
        <xsl:apply-templates select="following-sibling::rng:start[1]/*" mode="Simplify-7.18"/>
      </xsl:element>
    </xsl:param>
    <xsl:choose>
      <xsl:when test="$left/*">
        <xsl:variable name="newOut">
          <xsl:element name="{$node-name}">
            <xsl:copy-of select="$out"/>
            <xsl:apply-templates select="$left/*" mode="Simplify-7.18"/>
          </xsl:element>
        </xsl:variable>
        <xsl:call-template name="start7.18">
          <xsl:with-param name="left" select="$left/following-sibling::rng:start[1]"/>
          <xsl:with-param name="node-name" select="$node-name"/>
          <xsl:with-param name="out" select="$newOut"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$out"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template mode="Simplify-7.18" match="rng:define[not(@name=preceding-sibling::rng:define/@name) and @name=following-sibling::rng:define/@name]">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="Simplify-7.18"/>
      <xsl:copy-of select="a:documentation"/>
      <xsl:copy-of select="xhtml:div"/>
      <xsl:call-template name="define7.18"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template name="define7.18">
    <xsl:param name="left" select="following-sibling::rng:define[@name=current()/@name][2]"/>
    <xsl:param name="node-name" select="parent::*/rng:define[@name=current()/@name]/@combine"/>
    <xsl:param name="out">
      <xsl:element name="{$node-name}">
        <xsl:apply-templates select="*" mode="Simplify-7.18"/>
        <xsl:apply-templates select="following-sibling::rng:define[@name=current()/@name][1]/*" mode="Simplify-7.18"/>
      </xsl:element>
    </xsl:param>
    <xsl:choose>
      <xsl:when test="$left/*">
        <xsl:variable name="newOut">
          <xsl:element name="{$node-name}">
            <xsl:copy-of select="$out"/>
            <xsl:apply-templates select="$left/*" mode="Simplify-7.18"/>
          </xsl:element>
        </xsl:variable>
        <xsl:call-template name="define7.18">
          <xsl:with-param name="left" select="$left/following-sibling::rng:define[@name=current()/@name][1]"/>
          <xsl:with-param name="node-name" select="$node-name"/>
          <xsl:with-param name="out" select="$newOut"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$out"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template mode="Simplify-7.18" match="*"/>
</xsl:stylesheet>
