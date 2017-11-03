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

  <xsl:template mode="Simplify-4.07" match="/">
    <xsl:param name="stop-after" select="$stop-after"/>
    <xsl:param name="input-uri" select="$input-uri"/>
    <xsl:if test="$debug-level > 0">
      <xsl:message>Simplify-4.07: stop-after is <xsl:value-of select="$stop-after"/>, debug-level=<xsl:value-of select="$debug-level"/>, input-uri is <xsl:value-of select="$input-uri"/></xsl:message>
    </xsl:if>

    <xsl:variable name="transformed">
      <xsl:apply-templates mode="Simplify-4.07"/>
    </xsl:variable>

    <xsl:if test="$debug-level &gt; 1">
      <redirect:write file="debug-Simplify-4.07{$input-uri}.xml">
        <xsl:copy-of select="$transformed"/>
      </redirect:write>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="$stop-after='Simplify-4.07'">
        <xsl:copy-of select="$transformed"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="exsl:node-set($transformed)" mode="Simplify-4.08"> 
          <xsl:with-param name="stop-after" select="$stop-after"/>
          <xsl:with-param name="input-uri" select="$input-uri"/>
	</xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- END OF BOILERPLATE -->

  <!--
          4.7 include element

          An include element is transformed as follows. An element is constructed using the URI reference that is the
          value of href attribute as specified in Section 4.5. This element must be a grammar element, matching the
          syntax for grammar.

          This grammar element is transformed by recursively applying the rules from this subsection and from previous
          subsections of this section. This must not result in a loop. In other words, the transformation of the grammar
          element must not require the dereferencing of an include attribute with an href attribute with the same value.

          Define the components of an element to be the children of the element together with the components of any div
          child elements. If the include element has a start component, then the grammar element must have a start
          component. If the include element has a start component, then all start components are removed from the grammar
          element. If the include element has a define component, then the grammar element must have a define component
          with the same name. For every define component of the include element, all define components with the same name
          are removed from the grammar element.

          The include element is transformed into a div element. The attributes of the div element are the attributes of
          the include element other than the href attribute. The children of the div element are the grammar element
          (after the removal of the start and define components described by the preceding paragraph) followed by the
          children of the include element. The grammar element is then renamed to div.
  -->
  <xsl:template mode="Simplify-4.07" match="rng:include">
    <xsl:message>Including <xsl:value-of select="@href"/></xsl:message>
    <xsl:variable name="ref-rtf">
      <xsl:apply-templates  mode="Simplify-4.01" select="document(@href)">
        <xsl:with-param name="stop-after" select="'Simplify-4.07'"/>
        <xsl:with-param name="input-uri" select="@href"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:variable name="ref" select="exsl:node-set($ref-rtf)"/>
    <div>
      <div>
	<xsl:copy-of select="@*[name() != 'href']"/>
	<xsl:copy-of select="$ref/rng:grammar/rng:start[not(current()/rng:start)]"/>
	<xsl:copy-of select="$ref/rng:grammar/rng:define[not(@name = current()/rng:define/@name)]"/>
      </div>
      <xsl:copy-of select="*"/>
    </div>
  </xsl:template>

  <xsl:template mode="Simplify-4.07" match="*|text()|@*">
    <xsl:copy>
      <xsl:apply-templates select="*|@*|text()" mode="Simplify-4.07"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
