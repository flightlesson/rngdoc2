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

  <xsl:template mode="Simplify-4.03" match="/">
    <xsl:if test="$debug-level > 0">
      <xsl:message>Simplify-4.03: stop-after is <xsl:value-of select="$stop-after"/></xsl:message>
    </xsl:if>

    <xsl:variable name="transformed">
      <xsl:apply-templates mode="Simplify-4.03"/>
    </xsl:variable>

    <xsl:if test="$debug-level &gt; 1">
      <redirect:write file="debug-Simplify-4.03.xml">
        <xsl:copy-of select="$transformed"/>
      </redirect:write>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="$stop-after='Simplify-4.03'">
        <xsl:copy-of select="$transformed"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="exsl:node-set($transformed)" mode="Simplify-4.04"/> 
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- END OF BOILERPLATE -->

  <!--
          4.3. datatypeLibrary attribute

          The value of each datatypeLibary attribute is transformed by escaping disallowed characters as specified in 
          Section 5.4 of [XLink].

          For any data or value element that does not have a datatypeLibrary attribute, a datatypeLibrary attribute is
          added. The value of the added datatypeLibrary attribute is the value of the datatypeLibrary attribute of the 
          nearest ancestor element that has a datatypeLibrary attribute, or the empty string if there is no such ancestor. 
          Then, any datatypeLibrary attribute that is on an element other than data or value is removed.
  -->
  <xsl:template mode="Simplify-4.03" match="rng:data|rng:value">
    <xsl:copy>
      <xsl:attribute name="datatypeLibrary">
        <xsl:value-of select="ancestor-or-self::*[@datatypeLibrary][1]/@datatypeLibrary"/>
      </xsl:attribute>
      <xsl:apply-templates select="@*" mode="Simplify-4.03"/>
      <xsl:apply-templates mode="Simplify-4.03"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template mode="Simplify-4.03" match="@datatypeLibrary"/>

  <xsl:template mode="Simplify-4.03" match="*|text()|@*">
    <xsl:copy>
      <xsl:apply-templates select="*|@*|text()" mode="Simplify-4.03"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
