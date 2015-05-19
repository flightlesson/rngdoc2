package com.strongblackcoffee.rngdoc2;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import org.apache.commons.cli.BasicParser;
import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.CommandLineParser;
import org.apache.commons.cli.HelpFormatter;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.ParseException;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class Rngdoc  extends OutputGenerator {
    static Logger logger = LogManager.getLogger(Rngdoc.class.getName());

    static final Options options = new Options();
    static {
        options.addOption("h","help",false,"show help");
        options.addOption("d","debug",true,"debug verbosity, 2 is more verbose than 1, 0 (the default) means no debug output");
        options.addOption("L","last-step",true,"stop after this step");
    };
    
    static void usage() {
        HelpFormatter formatter = new HelpFormatter();
        formatter.printHelp("{cmd} [{args}] {schema}.rng", 
                            "Generates documentation for a Relax NG schema.",  // Note: will wrap if too long a line.
                            options,
                            "Generated documentation consists of many .html files; "
                            +"the starting point is named index.html."); // Note: will wrap if too long a line.
        System.exit(0);
    }
    
    /**
     * Starts the application.
     */
    public static void main( String[] args ) {
        CommandLineParser parser = new BasicParser();
        try {
            CommandLine cmd = parser.parse(options,args);
            OutputGenerator outputGenerator = new Rngdoc(cmd.getOptionValue("debug","0"),cmd.getOptionValue("last-step"));
            outputGenerator.generateOutputFromRngDocument(cmd.getArgs()[0]);
        } catch (ParseException | ArrayIndexOutOfBoundsException x) {
            usage();
        }
    }
    
    String debugLevel;
    String lastStep;
    
    public Rngdoc(String debugLevel, String lastStep) {
        this.debugLevel = debugLevel;
        this.lastStep = lastStep;
    }

    @Override
    void generateOutputFromRngDocument(String pathToSchema) {
        
        logger.debug("Creating simplifier, wbich is the XSL Transformer that simplifies the schema.");
        
        Transformer simplifier = null;
        try {
            StreamSource simplifierSource = new StreamSource( getClass().getResourceAsStream("/Simplify.xsl") );
            simplifierSource.setPublicId("Simplify.xsl");
            simplifier = transformerFactory.newTransformer(simplifierSource);
            simplifier.setURIResolver(uriResolver);
            if (debugLevel != null && !"".equals(debugLevel)) simplifier.setParameter("debug-level",debugLevel);
            if (lastStep   != null && !"".equals(lastStep))   simplifier.setParameter("stop-after",lastStep);
        } catch (TransformerConfigurationException ex) {
            logger.warn(ex);
            System.exit(1);
        }
        
        logger.debug("Simplifying " + pathToSchema + " ...");
        
        Source schemaSource = null;
        try {
            schemaSource = new StreamSource(new FileInputStream(pathToSchema));
        } catch (FileNotFoundException x) {
            logger.warn(x);
            System.exit(1);
        }
        ByteArrayOutputStream expandedModelBAOS = new ByteArrayOutputStream();
        StreamResult expandedStream = new StreamResult(System.out);
        try {
            simplifier.transform(schemaSource, expandedStream);
        } catch (TransformerException ex) {
            logger.warn(ex);
        }
        byte[] expandedModel = expandedModelBAOS.toByteArray();
        
        System.exit(0);
    }
}
