# Simplify-4.07 Unit Test

~~~
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
~~~

