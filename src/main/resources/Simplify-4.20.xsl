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

  <xsl:template mode="Simplify-4.20" match="/">
    <xsl:param name="stop-after" select="$stop-after"/>
    <xsl:param name="input-uri" select="$input-uri"/>
    <xsl:if test="$debug-level > 0">
      <xsl:message>Simplify-4.20: stop-after is <xsl:value-of select="$stop-after"/></xsl:message>
    </xsl:if>

    <xsl:variable name="transformed">
      <xsl:apply-templates mode="Simplify-4.20"/>
    </xsl:variable>

    <xsl:if test="$debug-level &gt; 1">
      <redirect:write file="debug-Simplify-4.20{$input-uri}.xml">
        <xsl:copy-of select="$transformed"/>
      </redirect:write>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="$stop-after='Simplify-4.20'">
        <xsl:copy-of select="$transformed"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="exsl:node-set($transformed)" mode="Simplify-4.21"> 
          <xsl:with-param name="stop-after" select="$stop-after"/>
          <xsl:with-param name="input-uri" select="$input-uri"/>
	</xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- END OF BOILERPLATE -->

  <!--
          4.20 notAllowed element

          In this rule, the grammar is transformed so that a notAllowed element occurs only as the child of a start or element
          element. An attribute, list, group, interleave, or oneOrMore element that has a notAllowed child element is transformed
          into a notAllowed element. A choice element that has two notAllowed child elements is transformed into a notAllowed
          element. A choice element that has one notAllowed child element is transformed into its other child element. An except
          element that has a notAllowed child element is removed. The preceding transformations are applied repeatedly until none
          of them is applicable any more. Any define element that is no longer reachable is removed.
  -->
  <xsl:template mode="Simplify-4.20" match="*|text()|@*">
    <xsl:copy>
      <xsl:apply-templates select="*|@*|text()" mode="Simplify-4.20"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
