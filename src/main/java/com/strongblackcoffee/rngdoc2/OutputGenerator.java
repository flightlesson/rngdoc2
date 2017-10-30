package com.strongblackcoffee.rngdoc2;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
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
                if (href.endsWith(".xsl")) {
                    StreamSource stream= new StreamSource(this.getClass().getResourceAsStream("/"+href));
                    stream.setPublicId(href);
                    return stream;
                }
                String pathToResource = href;
                if (base == null) {
                    pathToResource = userBaseURI + "/" + href;
                }
                return new StreamSource(new File(pathToResource));
            }
        };
        transformerFactory.setURIResolver(uriResolver);
    }
    
    protected final TransformerFactory transformerFactory;
    protected final URIResolver uriResolver;
    
    protected String userBaseURI = null;
    
    abstract void transform(Source source, Result result) throws OutputGeneratorException;
}
