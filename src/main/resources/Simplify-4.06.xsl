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

  <xsl:template mode="Simplify-4.06" match="/">
    <xsl:if test="$debug-level > 0">
      <xsl:message>Simplify-4.06: stop-after is <xsl:value-of select="$stop-after"/></xsl:message>
    </xsl:if>

    <xsl:variable name="transformed">
      <xsl:apply-templates mode="Simplify-4.06"/>
    </xsl:variable>

    <xsl:if test="$debug-level &gt; 1">
      <redirect:write file="debug-Simplify-4.06.xml">
        <xsl:copy-of select="$transformed"/>
      </redirect:write>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="$stop-after='Simplify-4.06'">
        <xsl:copy-of select="$transformed"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="exsl:node-set($transformed)" mode="Simplify-4.07"/> 
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- END OF BOILERPLATE -->

  <!--
          4.6 externalRef element

          An externalRef element is transformed as follows. An element is constructed using the URI reference that is the
          value of href attribute as specified in Section 4.5. This element must match the syntax for pattern. The element
          is transformed by recursively applying the rules from this subsection and from previous subsections of this section.
          This must not result in a loop. In other words, the transformation of the referenced element must not require the
          dereferencing of an externalRef attribute with an href attribute with the same value.

          Any ns attribute on the externalRef element is transferred to the referenced element if the referenced element
          does not already have an ns attribute. The externalRef element is then replaced by the referenced element.
  -->

  <xsl:template mode="Simplify-4.06" match="rng:externalRef">
    <xsl:variable name="ref-rtf">
      <xsl:apply-templates select="document(@href)">
        <xsl:with-param name="out" select="0"/>
        <xsl:with-param name="stop-after" select="'Simplify-4.06'"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:variable name="ref" select="exsl:node-set($ref-rtf)"/>
    <xsl:element name="{local-name($ref/*)}" namespace="http://relaxng.org/ns/structure/1.0">
      <xsl:if test="not($ref/*/@ns) and @ns">
        <xsl:attribute name="ns">
          <xsl:value-of select="@ns"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:copy-of select="$ref/*/@*"/>
      <xsl:copy-of select="$ref/*/*|$ref/*/text()"/>
    </xsl:element>
  </xsl:template>


  <xsl:template mode="Simplify-4.06" match="*|text()|@*">
    <xsl:copy>
      <xsl:apply-templates select="*|@*|text()" mode="Simplify-4.06"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
