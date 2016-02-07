package com.strongblackcoffee.rngdoc2;

import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.stream.StreamSource;

/**
 *
 */
public class Simplifier extends OutputGenerator {

    final Transformer simplifier;
    
    public Simplifier(Integer debugLevel, String firstStep, String lastStep) throws OutputGeneratorException {
        try {
            StreamSource simplifierSource = new StreamSource( getClass().getResourceAsStream("/Simplify.xsl") );
            simplifierSource.setPublicId("Simplify.xsl");
            simplifier = transformerFactory.newTransformer(simplifierSource);
            simplifier.setURIResolver(uriResolver);
            if (debugLevel != null && debugLevel > 0) simplifier.setParameter("debug-level",debugLevel);
            if (firstStep  != null && firstStep.startsWith("Simplify"))  simplifier.setParameter("start-at",firstStep);
            if (lastStep   != null && lastStep.startsWith("Simplify"))   simplifier.setParameter("stop-after",lastStep);
        } catch (TransformerConfigurationException ex) {
            throw new OutputGeneratorException("Simplifier constructor: ", ex);
        }
    }

    @Override
    void transform(Source source, Result result) throws OutputGeneratorException {
        try {
            simplifier.transform(source,result);
        } catch (TransformerException ex) {
            throw new OutputGeneratorException("Simplifier transform: ", ex);
        }
    }
}
