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

  <xsl:template mode="Simplify-4.05" match="/">
    <xsl:if test="$debug-level > 0">
      <xsl:message>Simplify-4.05: stop-after is <xsl:value-of select="$stop-after"/></xsl:message>
    </xsl:if>

    <xsl:variable name="transformed">
      <xsl:apply-templates mode="Simplify-4.05"/>
    </xsl:variable>

    <xsl:if test="$debug-level &gt; 1">
      <redirect:write file="debug-Simplify-4.05.xml">
        <xsl:copy-of select="$transformed"/>
      </redirect:write>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="$stop-after='Simplify-4.05'">
        <xsl:copy-of select="$transformed"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="exsl:node-set($transformed)" mode="Simplify-4.05"/> 
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- END OF BOILERPLATE -->

  <!--
          4.5 href attribute

          The value of the href attribute on an externalRef or include element is first transformed by escaping disallowed 
          characters as specified in Section 5.4 of [XLink]. The URI reference is then resolved into an absolute form as 
          described in section 5.2 of [RFC 2396] using the base URI from the context of the element that bears the href attribute.

          The value of the href attribute will be used to construct an element (as specified in Section 2). This must be done
          as follows. The URI reference consists of the URI itself and an optional fragment identifier. The resource identified
          by the URI is retrieved. The result is a MIME entity: a sequence of bytes labeled with a MIME media type. The media
          type determines how an element is constructed from the MIME entity and optional fragment identifier. When the media
          type is application/xml or text/xml, the MIME entity must be parsed as an XML document in accordance with the applicable
          RFC (at the term of writing [RFC 3023]) and an element constructed from the result of the parse as specified in Section 2.
          In particular, the charset parameter must be handled as specified by the RFC. This specification does not define the
          handling of media types other than application/xml and text/xml. The href attribute must not include a fragment
          identifier unless the registration of the media type of the resource identified by the attribute defines the
          interpretation of fragment identifiers for that media type.
  -->
  <xsl:template mode="Simplify-4.05" match="*|text()|@*">
    <xsl:copy>
      <xsl:apply-templates select="*|@*|text()" mode="Simplify-4.05"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
