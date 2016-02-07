package com.strongblackcoffee.rngdoc2;

import java.io.CharArrayWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.StringReader;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.DefaultParser;
import org.apache.commons.cli.HelpFormatter;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.ParseException;
import org.apache.log4j.BasicConfigurator;
import org.apache.log4j.Logger;
import org.apache.log4j.PropertyConfigurator;
import org.apache.log4j.xml.DOMConfigurator;

public class Rngdoc  {
    static Logger LOGGER = Logger.getLogger(Rngdoc.class.getName());

    static final String USAGE = "{cmd} [{args}] {schema}.rng";
    static final String HEADER = "Generates documentation fo a Relax NG schema.\nOptions are:";
    static final Options OPTIONS = new Options();
    static {
        OPTIONS.addOption("h","help",false,"show help");
        OPTIONS.addOption("d","debug",true,"debug verbosity, 2 is more verbose than 1, 0 (the default) means no debug output.");
        OPTIONS.addOption("L","last-step",true,
                "Stop after this step. Stopping after step Simplify prints the simplified schema. "
                + "Stopping after step Normalize prints the simplified and normalized schema. ");
        OPTIONS.addOption("F","first-step",true,"Start at this step. Provided to facilitate testing and debugging.");
    };
    static final String FOOTER = "Generates many .html files; the starting point is named index.html";
    
    /**
     * Starts the application.
     */
    public static void main( String[] args ) {
        try {
            CommandLine cmdline = (new DefaultParser()).parse(OPTIONS,args);
            if (cmdline.hasOption("help")) {
                (new HelpFormatter()).printHelp(USAGE,HEADER,OPTIONS,FOOTER,false);
                System.exit(1);
            }
            configureLogger(cmdline.getOptionValue("l4jconfig","l4j.lcf"));
            Integer debugLevel = null;
            try {
                debugLevel = new Integer(cmdline.getOptionValue("debug","0"));
            } catch (NumberFormatException x) {
                System.out.println("Huh? debug's value is '"+cmdline.getOptionValue("debug")+"'");
                (new HelpFormatter()).printHelp(USAGE,HEADER,OPTIONS,FOOTER,false);
                System.exit(1);
            }
            Rngdoc rngdoc = new Rngdoc(debugLevel,cmdline.getOptionValue("first-step"),cmdline.getOptionValue("last-step"));
            rngdoc.generateDocumentation(cmdline.getArgs()[0]);
        } catch (ParseException | ArrayIndexOutOfBoundsException ex) {
            System.err.println(ex.getMessage());
            (new HelpFormatter()).printHelp(USAGE,HEADER,OPTIONS,FOOTER,false);
        } catch (OutputGeneratorException ex) {
              LOGGER.fatal(ex.getMessage());
        }
    }
    
    static void configureLogger(String l4jconfig) {
        if ((new File(l4jconfig)).canRead()) {
            if (l4jconfig.matches(".*\\.xml$")) {
                DOMConfigurator.configureAndWatch(l4jconfig);
            } else {
                PropertyConfigurator.configureAndWatch(l4jconfig);
            }
        } else {
            BasicConfigurator.configure();
        }
    }
    
    Integer debugLevel;
    String firstStep;
    String lastStep;
    
    /**
     * 
     * @param debugLevel 0 means no debug messages; 2 is more verbose than 1
     * @param firstStep  null except when debugging
     * @param lastStep   null except when debugging
     */
    public Rngdoc(Integer debugLevel, String firstStep, String lastStep) {
        this.debugLevel = debugLevel;
        this.firstStep = firstStep;
        this.lastStep = lastStep;
    }

    void generateDocumentation(String pathToSchema) throws OutputGeneratorException {
        
        Simplifier simplifier = new Simplifier(debugLevel,firstStep,lastStep);
        Normalizer normalizer = new Normalizer(debugLevel,firstStep,lastStep);
        
        Source schema = null;
        try {
            schema = new StreamSource(new FileInputStream(pathToSchema));
        } catch (FileNotFoundException x) {
            LOGGER.warn(x);
            System.exit(1);
        }
        
        CharArrayWriter simplifiedBuffer = new CharArrayWriter();
        Result simplifiedSchema = new StreamResult(simplifiedBuffer);
        simplifier.transform(schema, simplifiedSchema);
        if (debugLevel > 0 || lastStep != null && lastStep.startsWith("Simplify")) {
            System.out.println(simplifiedBuffer.toString());
            if (lastStep != null && lastStep.startsWith("Simplify")) return;
        }

        CharArrayWriter normalizedBuffer = new CharArrayWriter();
        Result normalizedSchema = new StreamResult(normalizedBuffer);
        normalizer.transform(new StreamSource(new StringReader(simplifiedBuffer.toString())), normalizedSchema);
        if (debugLevel > 0 || lastStep != null && lastStep.startsWith("Normalize")) {
            System.out.println(normalizedBuffer.toString());
            if (lastStep != null && lastStep.startsWith("Normalize")) return;
        }
        
        System.out.println(normalizedBuffer.toString());  // FIXME: generate documentation
    }
}
