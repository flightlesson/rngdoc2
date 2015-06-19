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

  <xsl:template mode="Simplify-4.21" match="/">
    <xsl:if test="$debug-level > 0">
      <xsl:message>Simplify-4.21: stop-after is <xsl:value-of select="$stop-after"/></xsl:message>
    </xsl:if>

    <xsl:variable name="transformed">
      <xsl:apply-templates mode="Simplify-4.21"/>
    </xsl:variable>

    <xsl:if test="$debug-level &gt; 1">
      <redirect:write file="debug-Simplify-4.21.xml">
        <xsl:copy-of select="$transformed"/>
      </redirect:write>
    </xsl:if>

    <!-- (Simplify-4.21 is the last step)
    <xsl:choose>
      <xsl:when test="$stop-after='Simplify-4.21'">
        <xsl:copy-of select="$transformed"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="exsl:node-set($transformed)" mode="???"/> 
      </xsl:otherwise>
    </xsl:choose>
    -->
    <xsl:copy-of select="$transformed"/>
  </xsl:template>

  <!-- END OF BOILERPLATE -->

  <!--
          4.21 empty element

          In this rule, the grammar is transformed so that an empty element does not occur as a child of a group, interleave, or
          oneOrMore element or as the second child of a choice element. A group, interleave or choice element that has two empty
          child elements is transformed into an empty element. A group or interleave element that has one empty child element is
          transformed into its other child element. A choice element whose second child element is an empty element is transformed
          by interchanging its two child elements. A oneOrMore element that has an empty child element is transformed into an empty
          element. The preceding transformations are applied repeatedly until none of them is applicable any more.
  -->
  <xsl:template mode="Simplify-4.21" match="*|text()|@*">
    <xsl:copy>
      <xsl:apply-templates select="*|@*|text()" mode="Simplify-4.21"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
