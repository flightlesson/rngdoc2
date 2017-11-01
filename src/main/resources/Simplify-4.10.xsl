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

  <xsl:template mode="Simplify-4.10" match="/">
    <xsl:param name="stop-after" select="$stop-after"/>
    <xsl:param name="input-uri" select="$input-uri"/>
    <xsl:if test="$debug-level > 0">
      <xsl:message>Simplify-4.10: stop-after is <xsl:value-of select="$stop-after"/></xsl:message>
    </xsl:if>

    <xsl:variable name="transformed">
      <xsl:apply-templates mode="Simplify-4.10"/>
    </xsl:variable>

    <xsl:if test="$debug-level &gt; 1">
      <redirect:write file="debug-Simplify-4.10{$input-uri}.xml">
        <xsl:copy-of select="$transformed"/>
      </redirect:write>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="$stop-after='Simplify-4.10'">
        <xsl:copy-of select="$transformed"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="exsl:node-set($transformed)" mode="Simplify-4.11"> 
          <xsl:with-param name="stop-after" select="$stop-after"/>
          <xsl:with-param name="input-uri" select="$input-uri"/>
	</xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- END OF BOILERPLATE -->

  <!--
          4.10 QNames

          For any name element containing a prefix, the prefix is removed and an ns attribute is added
          replacing any existing ns attribute. The value of the added ns attribute is the value to which
          the namespace map of the context of the name element maps the prefix. The context must have a
          mapping for the prefix.
  -->

  <xsl:template mode="Simplify-4.10" match="rng:name[contains(., ':')]">
    <xsl:variable name="prefix" select="substring-before(., ':')"/>
    <name>
      <xsl:attribute name="ns">
        <xsl:for-each select="namespace::*">
          <xsl:if test="name()=$prefix">
            <xsl:value-of select="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:attribute>
      <xsl:value-of select="substring-after(., ':')"/>
    </name>
  </xsl:template>

  <xsl:template mode="Simplify-4.10" match="*|text()|@*">
    <xsl:copy>
      <xsl:apply-templates select="*|@*|text()" mode="Simplify-4.10"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
