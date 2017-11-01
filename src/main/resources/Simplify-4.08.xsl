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

  <xsl:template mode="Simplify-4.08" match="/">
    <xsl:param name="stop-after" select="$stop-after"/>
    <xsl:param name="input-uri" select="$input-uri"/>
    <xsl:if test="$debug-level > 0">
      <xsl:message>Simplify-4.08: stop-after is <xsl:value-of select="$stop-after"/>, debug-level=<xsl:value-of select="$debug-level"/>, input-uri is <xsl:value-of select="$input-uri"/></xsl:message>
    </xsl:if>

    <xsl:variable name="transformed">
      <xsl:apply-templates mode="Simplify-4.08"/>
    </xsl:variable>

    <xsl:if test="$debug-level &gt; 1">
      <redirect:write file="debug-Simplify-4.08{$input-uri}.xml">
        <xsl:copy-of select="$transformed"/>
      </redirect:write>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="$stop-after='Simplify-4.08'">
        <xsl:copy-of select="$transformed"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="exsl:node-set($transformed)" mode="Simplify-4.09"> 
          <xsl:with-param name="stop-after" select="$stop-after"/>
          <xsl:with-param name="input-uri" select="$input-uri"/>
	</xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- END OF BOILERPLATE -->

  <!--
          4.8 name attribute of element and attribute elements

          The name attribute on an element or attribute element is transformed into a name child element.

          If an attribute element has a name attribute but no ns attribute, then an ns="" attribute is added to the
          name child element.
  -->

  <xsl:template mode="Simplify-4.08" match="@name[parent::rng:element|parent::rng:attribute]"/>

  <xsl:template mode="Simplify-4.08" match="rng:element[@name]|rng:attribute[@name]">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="Simplify-4.08"/>
      <xsl:if test="self::rng:attribute and not(@ns)">
        <xsl:attribute name="ns"/>
      </xsl:if>
      <name>
        <xsl:value-of select="@name"/>
      </name>
      <xsl:apply-templates select="*|text()" mode="Simplify-4.08"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template mode="Simplify-4.08" match="*|text()|@*">
    <xsl:copy>
      <xsl:apply-templates select="*|@*|text()" mode="Simplify-4.08"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
