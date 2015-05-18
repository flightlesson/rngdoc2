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

    <xsl:output method="xml" omit-xml-declaration="yes"/>

<!-- tsingle: Derived from Eric van der Vlist's http://downloads.xmlschemata.org/relax-ng/utilities/simplification.xsl
     which seems based on the steps at https://www.oasis-open.org/committees/relax-ng/spec-20011203.html#simplification.
     Eric's script has been refactored and modified to retain <a:documentation> and <xhtml:div> comments. -->

    <xsl:param name="stop-after">Simplify-7.22</xsl:param>
    <xsl:param name="debug-level">0</xsl:param>

    <xsl:template match="/">

      <xsl:message>debug-level is <xsl:value-of select="$debug-level"/>, stop-after is <xsl:value-of select="$stop-after"/></xsl:message>
      <xsl:if test="$debug-level > 0">
        <xsl:message>Inside expander, stop-after is <xsl:value-of select="$stop-after"/></xsl:message>
      </xsl:if>

        <xsl:apply-templates mode="Simplify-7.2" select="/"/>

    </xsl:template>

    <!-- Each of these includes should follow the pattern established in Simplify-7.2.xsl -->
    
    <xsl:include href="Simplify-7.2.xsl"/>
    <xsl:include href="Simplify-7.3.xsl"/>
    <xsl:include href="Simplify-7.4.xsl"/>
    <xsl:include href="Simplify-7.5.xsl"/>
    <xsl:include href="Simplify-7.7.xsl"/>
    <xsl:include href="Simplify-7.8.xsl"/>
    <xsl:include href="Simplify-7.9.xsl"/>
    <xsl:include href="Simplify-7.10.xsl"/>
    <xsl:include href="Simplify-7.11.xsl"/>
    <xsl:include href="Simplify-7.12.xsl"/>
    <xsl:include href="Simplify-7.13.xsl"/>
    <xsl:include href="Simplify-7.14.xsl"/>
    <xsl:include href="Simplify-7.15.xsl"/>
    <xsl:include href="Simplify-7.16.xsl"/>
    <xsl:include href="Simplify-7.18.xsl"/>
    <xsl:include href="Simplify-7.19.xsl"/>
    <xsl:include href="Simplify-7.20.xsl"/>
    <xsl:include href="Simplify-7.22.xsl"/>
</xsl:stylesheet>
