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
public class Normalizer extends OutputGenerator {
    
    final Transformer normalizer;

    public Normalizer(Integer debugLevel, String firstStep, String lastStep) throws OutputGeneratorException { 
        try {
            StreamSource normalizerSource = new StreamSource( getClass().getResourceAsStream("/Normalize.xsl") );
            normalizerSource.setPublicId("Normalize.xsl");
            normalizer = transformerFactory.newTransformer(normalizerSource);
            normalizer.setURIResolver(uriResolver);
            if (debugLevel != null && debugLevel.intValue() > 0) normalizer.setParameter("debug-level",debugLevel);
            if (firstStep  != null && firstStep.startsWith("Normalize"))  normalizer.setParameter("start-at",firstStep);
            if (lastStep   != null && lastStep.startsWith("Normalize"))   normalizer.setParameter("stop-after",lastStep);
        } catch (TransformerConfigurationException ex) {
            throw new OutputGeneratorException("Normalize constructor: ",ex);
        }
    }

    @Override
    void transform(Source source, Result result) throws OutputGeneratorException {
        try {
            normalizer.transform(source,result);
        } catch (TransformerException x) {
            throw new OutputGeneratorException("normalizer.transform: ",x);
        }
    }
    
}
