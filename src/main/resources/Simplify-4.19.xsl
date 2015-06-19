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

  <xsl:template mode="Simplify-4.19" match="/">
    <xsl:if test="$debug-level > 0">
      <xsl:message>Simplify-4.19: stop-after is <xsl:value-of select="$stop-after"/></xsl:message>
    </xsl:if>

    <xsl:variable name="transformed">
      <xsl:apply-templates mode="Simplify-4.19"/>
    </xsl:variable>

    <xsl:if test="$debug-level &gt; 1">
      <redirect:write file="debug-Simplify-4.19.xml">
        <xsl:copy-of select="$transformed"/>
      </redirect:write>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="$stop-after='Simplify-4.19'">
        <xsl:copy-of select="$transformed"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="exsl:node-set($transformed)" mode="Simplify-4.20"/> 
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- END OF BOILERPLATE -->

  <!--
          4.19 define and ref elements

          In this rule, the grammar is transformed so that every element element is the child of a define element, and the child of
          every define element is an element element.

          First, remove any define element that is not reachable. A define element is reachable if there is reachable ref element
          referring to it. A ref element is reachable if it is the descendant of the start element or of a reachable define element.
          Now, for each element element that is not the child of a define element, add a define element to the grammar element, and
          replace the element element by a ref element referring to the added define element. The value of the name attribute of the
          added define element must be different from value of the name attribute of all other define elements. The child of the
          added define element is the element element.

          Define a ref element to be expandable if it refers to a define element whose child is not an element element. For each
          ref element that is expandable and is a descendant of a start element or an element element, expand it by replacing the
          ref element by the child of the define element to which it refers and then recursively expanding any expandable ref
          elements in this replacement. This must not result in a loop. In other words expanding the replacement of a ref element
          having a name with value n must not require the expansion of ref element also having a name with value n. Finally, remove
          any define element whose child is not an element element.
  -->
  <xsl:template mode="Simplify-4.19" match="/rng:grammar">
    <xsl:copy>
      <xsl:apply-templates select="*|@*|text" mode="Simplify-4.19"/>
      <xsl:apply-templates select="//rng:element[not(parent::rng:define]" mode="Simplify-4.19-define"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template mode="Simplify-4.19-define" match="rng:element">
    <define name="__{rng:name}-elt-{generate-id()}">
      <xsl:copy>
        <xsl:apply-templates select="*|@*|text()" mode="Simplify-7.19"/>
      </xsl:copy>
    </define>
  </xsl:template>

  <xsl:template mode="Simplify-4.19" match="rng:element">
    <xsl:variable name="refname">
    </xsl:variable>
    <rng:ref name="{$refname}"/>
  </xsl:template>

  <xsl:template mode="Simplify-4.19" match="*|text()|@*">
    <xsl:copy>
      <xsl:apply-templates select="*|@*|text()" mode="Simplify-4.19"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
