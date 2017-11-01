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

  <xsl:template mode="Simplify-4.18" match="/">
    <xsl:param name="stop-after" select="$stop-after"/>
    <xsl:param name="input-uri" select="$input-uri"/>
    <xsl:if test="$debug-level > 0">
      <xsl:message>Simplify-4.18: stop-after is <xsl:value-of select="$stop-after"/></xsl:message>
    </xsl:if>

    <xsl:variable name="transformed">
      <xsl:apply-templates mode="Simplify-4.18"/>
    </xsl:variable>

    <xsl:if test="$debug-level &gt; 1">
      <redirect:write file="debug-Simplify-4.18{$input-uri}.xml">
        <xsl:copy-of select="$transformed"/>
      </redirect:write>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="$stop-after='Simplify-4.18'">
        <xsl:copy-of select="$transformed"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="exsl:node-set($transformed)" mode="Simplify-4.19"> 
          <xsl:with-param name="stop-after" select="$stop-after"/>
          <xsl:with-param name="input-uri" select="$input-uri"/>
	</xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- END OF BOILERPLATE -->

  <!--
          4.18 grammar element

          In this rule, the schema is transformed so that its top-level element is grammar and so that it has no other
          grammar elements.

          Define the in-scope grammar for an element to be the nearest ancestor grammar element. A ref element refers
          to a define element if the value of their name attributes is the same and their in-scope grammars are the same.
          A parentRef element refers to a define element if the value of their name attributes is the same and the in-scope
          grammar of the in-scope grammar of the parentRef element is the same as the in-scope grammar of the define element.
          Every ref or parentRef element must refer to a define element. A grammar must have a start child element.

          First, transform the top-level pattern p into <grammar><start>p</start></grammar>. Next, rename define elements
          so that no two define elements anywhere in the schema have the same name. To rename a define element, change the 
          value of its name attribute and change the value of the name attribute of all ref and parentRef elements that refer 
          to that define element. Next, move all define elements to be children of the top-level grammar element, replace
          each nested grammar element by the child of its start element and rename each parentRef element to ref.
  -->

  <xsl:template mode="Simplify-4.18" match="/rng:*">
    <xsl:choose>
      <xsl:when test="rng:grammar">
        <rng:grammar>
          <xsl:apply-templates select="*|@*|text()" mode="Simplify-4.18"/>
          <xsl:apply-templates select="//rng:define" mode="Simplify-4.18-define"/>
        </rng:grammar>
      </xsl:when>
      <xsl:otherwise>
        <rng:grammar>
          <rng:start>
            <xsl:copy>
              <xsl:apply-templates select="@*|*|text()" mode="Simplify-4.18"/>
            </xsl:copy>
          </rng:start>
          <xsl:apply-templates select="//rng:define" mode="Simplify-4.18-define"/>
        </rng:grammar>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template mode="Simplify-4.18-define" match="rng:define">
    <xsl:copy>
      <xsl:apply-templates select="@*|*|text()" mode="Simplify-4.18"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template mode="Simplify-4.18" match="rng:define"/>

  <xsl:template mode="Simplify-4.18" match="*|text()|@*">
    <xsl:copy>
      <xsl:apply-templates select="*|@*|text()" mode="Simplify-4.18"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
