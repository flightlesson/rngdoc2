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
        <xsl:apply-templates select="exsl:node-set($transformed)" mode="Simplify-4.06"/> 
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

          ==

          Section 5.4 of XLink says that non-ASCII, control, space, '<', '>', '"', '{', '}', '|', '\', '^', and '`' must be replaced 
          with %HH, where HH is the hex representation of the disallowed character.

          ==

          [Section 5.2 of RFC 2396]

              5.2. Resolving Relative References to Absolute Form
              
                 This section describes an example algorithm for resolving URI
                 references that might be relative to a given base URI.

                 The base URI is established according to the rules of Section 5.1 and
                 parsed into the four main components as described in Section 3.  Note
                 that only the scheme component is required to be present in the base
                 URI; the other components may be empty or undefined.  A component is
                 undefined if its preceding separator does not appear in the URI
                 reference; the path component is never undefined, though it may be
                 empty.  The base URI's query component is not used by the resolution
                 algorithm and may be discarded.
              
                 For each URI reference, the following steps are performed in order:
              
                 1) The URI reference is parsed into the potential four components and
                    fragment identifier, as described in Section 4.3.
              
                 2) If the path component is empty and the scheme, authority, and
                    query components are undefined, then it is a reference to the
                    current document and we are done.  Otherwise, the reference URI's
                    query and fragment components are defined as found (or not found)
                    within the URI reference and not inherited from the base URI.
              
                 3) If the scheme component is defined, indicating that the reference
                    starts with a scheme name, then the reference is interpreted as an
                    absolute URI and we are done.  Otherwise, the reference URI's
                    scheme is inherited from the base URI's scheme component.
              
                    Due to a loophole in prior specifications [RFC1630], some parsers
                    allow the scheme name to be present in a relative URI if it is the
                    same as the base URI scheme.  Unfortunately, this can conflict
                    with the correct parsing of non-hierarchical URI.  For backwards
                    compatibility, an implementation may work around such references
                    by removing the scheme if it matches that of the base URI and the
                    scheme is known to always use the <hier_part> syntax.  The parser
                    can then continue with the steps below for the remainder of the
                    reference components.  Validating parsers should mark such a
                    misformed relative reference as an error.
              
                 4) If the authority component is defined, then the reference is a
                    network-path and we skip to step 7.  Otherwise, the reference
                    URI's authority is inherited from the base URI's authority
                    component, which will also be undefined if the URI scheme does not
                    use an authority component.
              
                 5) If the path component begins with a slash character ("/"), then
                    the reference is an absolute-path and we skip to step 7.
              
                 6) If this step is reached, then we are resolving a relative-path
                    reference.  The relative path needs to be merged with the base
                    URI's path.  Although there are many ways to do this, we will
                    describe a simple method using a separate string buffer.
              
                    a) All but the last segment of the base URI's path component is
                       copied to the buffer.  In other words, any characters after the
                       last (right-most) slash character, if any, are excluded.
              
                    b) The reference's path component is appended to the buffer
                       string.
              
                    c) All occurrences of "./", where "." is a complete path segment,
                       are removed from the buffer string.
              
                    d) If the buffer string ends with "." as a complete path segment,
                       that "." is removed.
              
                    e) All occurrences of "<segment>/../", where <segment> is a
                       complete path segment not equal to "..", are removed from the
                       buffer string.  Removal of these path segments is performed
                       iteratively, removing the leftmost matching pattern on each
                       iteration, until no matching pattern remains.
              
                    f) If the buffer string ends with "<segment>/..", where <segment>
                       is a complete path segment not equal to "..", that
                       "<segment>/.." is removed.
              
                    g) If the resulting buffer string still begins with one or more
                       complete path segments of "..", then the reference is
                       considered to be in error.  Implementations may handle this
                       error by retaining these components in the resolved path (i.e.,
                       treating them as part of the final URI), by removing them from
                       the resolved path (i.e., discarding relative levels above the
                       root), or by avoiding traversal of the reference.
              
                    h) The remaining buffer string is the reference URI's new path
                       component.
              
                 7) The resulting URI components, including any inherited from the
                    base URI, are recombined to give the absolute form of the URI
                    reference.  Using pseudocode, this would be
              
                       result = ""
              
                       if scheme is defined then
                           append scheme to result
                           append ":" to result
              
                       if authority is defined then
                           append "//" to result
                           append authority to result
              
                       append path to result
              
                       if query is defined then
                           append "?" to result
                           append query to result
              
                       if fragment is defined then
                           append "#" to result
                           append fragment to result
              
                       return result
              
                    Note that we must be careful to preserve the distinction between a
                    component that is undefined, meaning that its separator was not
                    present in the reference, and a component that is empty, meaning
                    that the separator was present and was immediately followed by the
                    next component separator or the end of the reference.
              
                 The above algorithm is intended to provide an example by which the
                 output of implementations can be tested - implementation of the
                 algorithm itself is not required.  For example, some systems may find
                 it more efficient to implement step 6 as a pair of segment stacks
                 being merged, rather than as a series of string pattern replacements.
              
                    Note: Some WWW client applications will fail to separate the
                    reference's query component from its path component before merging
                    the base and reference paths in step 6 above.  This may result in
                    a loss of information if the query component contains the strings
                    "/../" or "/./".
              
                 Resolution examples are provided in Appendix C.

  -->
  <xsl:template mode="Simplify-4.05" match="*|text()|@*">
    <xsl:copy>
      <xsl:apply-templates select="*|@*|text()" mode="Simplify-4.05"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
