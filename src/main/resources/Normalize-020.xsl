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

  <xsl:template mode="Normalize-020" match="/">
    <xsl:if test="$debug-level > 0">
      <xsl:message>Normalize-020: next-step is ?, stop-after is <xsl:value-of select="$stop-after"/></xsl:message>
    </xsl:if>
    <xsl:if test="$debug-level &gt; 1">
      <xsl:message>tranforms ...</xsl:message>
    </xsl:if>

    <xsl:variable name="transformed">
      <xsl:apply-templates mode="Normalize-020"/>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$stop-after='Normalize-020'">
        <xsl:copy-of select="$transformed"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="exsl:node-set($transformed)" mode="Normalize-xxx"/> 
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- END OF BOILERPLATE -->

  <!-- change <choice><choice><a/><b/></choice><c/></choice>       to <choice><a/><b/><c/></choice> -->
  <!-- change <group><group><a/><b/></group><c/></group>           to <group><a/><b/><c/></group> -->

  <!-- <choice><choice><choice>ab</choice>c</choice>d</choice> => <choice><choice>ab</choice>cd</choice> -->
  <xsl:template mode="Normalize-020" match="rng:choice[rng:choice] | rng:group[rng:group]">
    <choice>
      <xsl:call-template name="Normalize-020-flatten">
	<xsl:with-param name="target" select="name()"/>
        <xsl:with-param name="children" select="*"/>
      </xsl:call-template>
    </choice>
  </xsl:template>

  <xsl:template name="Normalize-020-flatten">
    <xsl:param name="target"/>
    <xsl:param name="children"/>
    <xsl:for-each select="$children">
      <xsl:choose>
        <xsl:when test="name() = $target">
          <xsl:call-template name="Normalize-020-flatten">
	    <xsl:with-param name="target" select="$target"/>
            <xsl:with-param name="children" select="*"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="." mode="Normalize-020"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template mode="Normalize-020" match="rng:*|text()">
    <xsl:message>expanding</xsl:message>
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="Normalize-020"/>
    </xsl:copy>
  </xsl:template>

  <!-- change <interleave><a/></interleave>                        to <mixed><a/></mixed> -->

</xsl:stylesheet>
