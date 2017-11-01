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

  <xsl:template mode="Simplify-4.12" match="/">
    <xsl:param name="stop-after" select="$stop-after"/>
    <xsl:param name="input-uri" select="$input-uri"/>
    <xsl:if test="$debug-level > 0">
      <xsl:message>Simplify-4.12: stop-after is <xsl:value-of select="$stop-after"/></xsl:message>
    </xsl:if>

    <xsl:variable name="transformed">
      <xsl:apply-templates mode="Simplify-4.12"/>
    </xsl:variable>

    <xsl:if test="$debug-level &gt; 1">
      <redirect:write file="debug-Simplify-4.12{$input-uri}.xml">
        <xsl:copy-of select="$transformed"/>
      </redirect:write>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="$stop-after='Simplify-4.12'">
        <xsl:copy-of select="$transformed"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="exsl:node-set($transformed)" mode="Simplify-4.13"> 
          <xsl:with-param name="stop-after" select="$stop-after"/>
          <xsl:with-param name="input-uri" select="$input-uri"/>
	</xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- END OF BOILERPLATE -->

  <!--
          4.12 Number of child elements

          A define, oneOrMore, zeroOrMore, optional, list or mixed element is transformed so that it has exactly
          one child element. If it has more than one child element, then its child elements are wrapped in a group
          element. Similarly, an element element is transformed so that it has exactly two child elements, the
          first being a name class and the second being a pattern. If it has more than two child elements, then
          the child elements other than the first are wrapped in a group element.

          A except element is transformed so that it has exactly one child element. If it has more than one child
          element, then its child elements are wrapped in a choice element.

          If an attribute element has only one child element (a name class), then a text element is added.

          A choice, group or interleave element is transformed so that it has exactly two child elements. If it has
          one child element, then it is replaced by its child element. If it has more than two child elements, then
          the first two child elements are combined into a new element with the same name as the parent element and
          with the first two child elements as its children. For example,

                  <choice> p1 p2 p3 </choice>

          is transformed to

                  <choice> <choice> p1 p2 </choice> p3 </choice>

          This reduces the number of child elements by one. The transformation is applied repeatedly until there are
          exactly two child elements.
  -->

  <xsl:template mode="Simplify-4.12" match="rng:define[count(rng:*)>1]|rng:oneOrMore[count(rng:*)>1]|rng:zeroOrMore[count(rng:*)>1]|rng:optional[count(rng:*)>1]|rng:list[count(rng:*)>1]|rng:mixed[count(rng:*)>1]">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="Simplify-4.12"/>
      <xsl:call-template name="Simplify-4.12-reduce">
        <xsl:with-param name="node-name" select="'group'"/>
      </xsl:call-template>
    </xsl:copy>
  </xsl:template>

  <xsl:template mode="Simplify-4.12" match="rng:except[count(rng:*)>1]">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="Simplify-7.13"/>
      <xsl:call-template name="Simplify-4.12-reduce">
        <xsl:with-param name="node-name" select="'choice'"/>
      </xsl:call-template>
    </xsl:copy>
  </xsl:template>

  <xsl:template mode="Simplify-4.12" match="rng:attribute[count(rng:*) =1]">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="Simplify-4.12"/>
      <xsl:copy-of select="a:documentation"/>
      <xsl:copy-of select="xhtml:div"/>
      <xsl:apply-templates select="*" mode="Simplify-4.12"/>
      <text/>
    </xsl:copy>
  </xsl:template>

  <xsl:template mode="Simplify-4.12" match="rng:element[count(rng:*)>2]">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="Simplify-4.12"/>
      <xsl:copy-of select="a:documentation"/>
      <xsl:copy-of select="xhtml:div"/>
      <xsl:apply-templates select="rng:*[1]" mode="Simplify-4.12"/>
      <xsl:call-template name="Simplify-4.12-reduce">
        <xsl:with-param name="left" select="rng:*[4]"/>
        <xsl:with-param name="node-name" select="'group'"/>
        <xsl:with-param name="out">
          <group>
            <xsl:apply-templates select="rng:*[2]" mode="Simplify-4.12"/>
            <xsl:apply-templates select="rng:*[3]" mode="Simplify-4.12"/>
          </group>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:copy>
  </xsl:template>

  <xsl:template mode="Simplify-4.12" match="rng:group[count(rng:*)=1]|rng:choice[count(rng:*)=1]|rng:interleave[count(rng:*)=1]">
    <xsl:apply-templates select="*" mode="Simplify-4.12"/>
  </xsl:template>

  <xsl:template mode="Simplify-4.12" match="rng:group[count(rng:*)>2]|rng:choice[count(rng:*)>2]|rng:interleave[count(rng:*)>2]" name="Simplify-4.12-reduce">
    <xsl:param name="left" select="*[3]"/>
    <xsl:param name="node-name" select="name()"/>
    <xsl:param name="out">
      <xsl:element name="{$node-name}">
        <xsl:apply-templates select="*[1]" mode="Simplify-4.12"/>
        <xsl:apply-templates select="*[2]" mode="Simplify-4.12"/>
      </xsl:element>
    </xsl:param>
    <xsl:choose>
      <xsl:when test="$left">
        <xsl:variable name="newOut">
          <xsl:element name="{$node-name}">
            <xsl:copy-of select="$out"/>
            <xsl:apply-templates select="$left" mode="Simplify-4.12"/>
          </xsl:element>
        </xsl:variable>
        <xsl:call-template name="Simplify-4.12-reduce">
          <xsl:with-param name="left" select="$left/following-sibling::*[1]"/>
          <xsl:with-param name="out" select="$newOut"/>
          <xsl:with-param name="node-name" select="$node-name"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$out"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template mode="Simplify-4.12" match="*|text()|@*">
    <xsl:copy>
      <xsl:apply-templates select="*|@*|text()" mode="Simplify-4.12"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
