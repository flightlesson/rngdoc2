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

  <xsl:template mode="Simplify-7.04" match="/">
    <xsl:if test="$debug-level > 0">
      <xsl:message>Simplify-7.04: stop-after is <xsl:value-of select="$stop-after"/></xsl:message>
    </xsl:if>

    <xsl:variable name="transformed">
      <xsl:apply-templates mode="Simplify-7.04"/>
    </xsl:variable>

    <xsl:if test="$debug-level &gt; 1">
      <redirect:write file="debug-Simplify-7.04.xml">
        <xsl:copy-of select="$transformed"/>
      </redirect:write>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="$stop-after='Simplify-7.04'">
        <xsl:copy-of select="$transformed"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="exsl:node-set($transformed)" mode="Simplify-7.05"/> 
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- END OF BOILERPLATE -->

  <!-- Make sure every <data> and <value> element has a datatypeLibrary attribute.
       Delete extraneous datatypeLibrary attributes. -->

  <xsl:template mode="Simplify-7.04" match="rng:*|text()|@*">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="Simplify-7.04"/>
      <xsl:copy-of select="a:documentation|xhtml:div"/>
      <xsl:apply-templates mode="Simplify-7.04"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template mode="Simplify-7.04" match="@datatypeLibrary"/>

  <xsl:template mode="Simplify-7.04" match="rng:data|rng:value">
    <xsl:copy>
      <xsl:attribute name="datatypeLibrary">
        <xsl:value-of select="ancestor-or-self::*[@datatypeLibrary][1]/@datatypeLibrary"/>
      </xsl:attribute>
      <xsl:apply-templates select="@*" mode="Simplify-7.04"/>
      <xsl:apply-templates mode="Simplify-7.04"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template mode="Simplify-7.04" match="*|text()|@*">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="Simplify-7.04"/>
      <xsl:copy-of select="a:documentation|xhtml:div"/>
      <xsl:apply-templates mode="Simplify-7.04"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
