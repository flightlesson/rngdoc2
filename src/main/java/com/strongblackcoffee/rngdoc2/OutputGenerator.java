package com.strongblackcoffee.rngdoc2;

import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.URIResolver;
import javax.xml.transform.stream.StreamSource;

/**
 *
 */
abstract public class OutputGenerator {
    
    OutputGenerator() {
        transformerFactory = TransformerFactory.newInstance("org.apache.xalan.processor.TransformerFactoryImpl",null);
        uriResolver = new URIResolver() {
            @Override
            public Source resolve(String href, String base) throws TransformerException {
                System.out.println("resolve(\""+href+"\",\""+base+"\")");
                StreamSource stream= new StreamSource(this.getClass().getResourceAsStream("/"+href));
                stream.setPublicId(href);
                return stream;
            }
        };
        transformerFactory.setURIResolver(uriResolver);
    }
    
    protected TransformerFactory transformerFactory;
    protected URIResolver uriResolver;
    
    abstract void transform(Source source, Result result) throws OutputGeneratorException;
}
