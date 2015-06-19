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

  <xsl:template mode="Simplify-4.17" match="/">
    <xsl:if test="$debug-level > 0">
      <xsl:message>Simplify-4.17: stop-after is <xsl:value-of select="$stop-after"/></xsl:message>
    </xsl:if>

    <xsl:variable name="transformed">
      <xsl:apply-templates mode="Simplify-4.17"/>
    </xsl:variable>

    <xsl:if test="$debug-level &gt; 1">
      <redirect:write file="debug-Simplify-4.17.xml">
        <xsl:copy-of select="$transformed"/>
      </redirect:write>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="$stop-after='Simplify-4.17'">
        <xsl:copy-of select="$transformed"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="exsl:node-set($transformed)" mode="Simplify-4.18"/> 
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- END OF BOILERPLATE -->

  <!--
          4.17 combine attribute

          For each grammar element, all define elements with the same name are combined together. For any name,
          there must not be more than one define element with that name that does not have a combine attribute.
          For any name, if there is a define element with that name that has a combine attribute with the value
          choice, then there must not also be a define element with that name that has a combine attribute with
          the value interleave. Thus, for any name, if there is more than one define element with that name,
          then there is a unique value for the combine attribute for that name. After determining this unique
          value, the combine attributes are removed. A pair of definitions

                  <define name="n">
                      p1
                  </define>
                  <define name="n">
                      p2
                  </define>
          is combined into

                  <define name="n">
                      <c>
                          p1
                          p2
                      </c>
                  </define>
          where c is the value of the combine attribute. Pairs of definitions are combined until there is
          exactly one define element for each name.

          Similarly, for each grammar element all start elements are combined together. There must not be more
          than one start element that does not have a combine attribute. If there is a start element that has a
          combine attribute with the value choice, there must not also be a start element that has a combine
          attribute with the value interleave.
  -->

  <xsl:template mode="Simplify-4.17" match="@combine"/>

  <xsl:template mode="Simplify-4.17" match="rng:start[preceding-sibling::rng:start]|rng:define[@name=preceding-sibling::rng:define/@name]"/>

  <xsl:template mode="Simplify-4.17" match="rng:start[not(preceding-sibling::rng:start) and following-sibling::rng:start]">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="Simplify-4.17"/>
      <xsl:copy-of select="a:documentation"/>
      <xsl:copy-of select="xhtml:div"/>
      <xsl:element name="{parent::*/rng:start/@combine}">
        <xsl:call-template name="Simplify-4.17-start"/>
      </xsl:element>
    </xsl:copy>
  </xsl:template>

  <xsl:template name="Simplify-4.17-start">
    <xsl:param name="left" select="following-sibling::rng:start[2]"/>
    <xsl:param name="node-name" select="parent::*/rng:start/@combine"/>
    <xsl:param name="out">
      <xsl:element name="{$node-name}">
        <xsl:apply-templates select="*" mode="Simplify-4.17"/>
        <xsl:apply-templates select="following-sibling::rng:start[1]/*" mode="Simplify-4.17"/>
      </xsl:element>
    </xsl:param>
    <xsl:choose>
      <xsl:when test="$left/*">
        <xsl:variable name="newOut">
          <xsl:element name="{$node-name}">
            <xsl:copy-of select="$out"/>
            <xsl:apply-templates select="$left/*" mode="Simplify-4.17"/>
          </xsl:element>
        </xsl:variable>
        <xsl:call-template name="Simplify-4.17-start">
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

  <xsl:template mode="Simplify-4.17" match="rng:define[not(@name=preceding-sibling::rng:define/@name) and @name=following-sibling::rng:define/@name]">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="Simplify-4.17"/>
      <xsl:copy-of select="a:documentation"/>
      <xsl:copy-of select="xhtml:div"/>
      <xsl:call-template name="Simplify-4.17-define"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template name="Simplify-4.17-define">
    <xsl:param name="left" select="following-sibling::rng:define[@name=current()/@name][2]"/>
    <xsl:param name="node-name" select="parent::*/rng:define[@name=current()/@name]/@combine"/>
    <xsl:param name="out">
      <xsl:element name="{$node-name}">
        <xsl:apply-templates select="*" mode="Simplify-4.17"/>
        <xsl:apply-templates select="following-sibling::rng:define[@name=current()/@name][1]/*" mode="Simplify-4.17"/>
      </xsl:element>
    </xsl:param>
    <xsl:choose>
      <xsl:when test="$left/*">
        <xsl:variable name="newOut">
          <xsl:element name="{$node-name}">
            <xsl:copy-of select="$out"/>
            <xsl:apply-templates select="$left/*" mode="Simplify-4.17"/>
          </xsl:element>
        </xsl:variable>
        <xsl:call-template name="Simplify-4.17-define">
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

  <xsl:template mode="Simplify-4.17" match="*|text()|@*">
    <xsl:copy>
      <xsl:apply-templates select="*|@*|text()" mode="Simplify-4.17"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
