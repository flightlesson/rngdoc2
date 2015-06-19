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

  <xsl:template mode="Simplify-4.09" match="/">
    <xsl:if test="$debug-level > 0">
      <xsl:message>Simplify-4.09: stop-after is <xsl:value-of select="$stop-after"/></xsl:message>
    </xsl:if>

    <xsl:variable name="transformed">
      <xsl:apply-templates mode="Simplify-4.09"/>
    </xsl:variable>

    <xsl:if test="$debug-level &gt; 1">
      <redirect:write file="debug-Simplify-4.09.xml">
        <xsl:copy-of select="$transformed"/>
      </redirect:write>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="$stop-after='Simplify-4.09'">
        <xsl:copy-of select="$transformed"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="exsl:node-set($transformed)" mode="Simplify-4.10"/> 
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- END OF BOILERPLATE -->

  <!--
          4.9 ns attribute

          For any name, nsName or value element that does not have an ns attribute, an ns attribute is added.
          The value of the added ns attribute is the value of the ns attribute of the nearest ancestor element
          that has an ns attribute, or the empty string if there is no such ancestor. Then, any ns attribute
          that is on an element other than name, nsName or value is removed.
  -->

  <xsl:template mode="Simplify-4.09" match="@ns"/>

  <xsl:template mode="Simplify-4.09" match="rng:name|rng:nsName|rng:value">
    <xsl:copy>
      <xsl:attribute name="ns">
        <xsl:value-of select="ancestor-or-self::*[@ns][1]/@ns"/>
      </xsl:attribute>
      <xsl:apply-templates select="@*" mode="Simplify-4.09"/>
      <xsl:apply-templates select="*|text()" mode="Simplify-4.09"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template mode="Simplify-4.09" match="*|text()|@*">
    <xsl:copy>
      <xsl:apply-templates select="*|@*|text()" mode="Simplify-4.09"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
