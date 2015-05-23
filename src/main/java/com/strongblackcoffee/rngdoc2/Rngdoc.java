package com.strongblackcoffee.rngdoc2;

import java.io.CharArrayWriter;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.StringReader;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
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

public class Rngdoc  {
    static Logger logger = LogManager.getLogger(Rngdoc.class.getName());

    static final Options options = new Options();
    static {
        options.addOption("h","help",false,
                "show help");
        options.addOption("d","debug",true,
                "debug verbosity, 2 is more verbose than 1, 0 (the default) means no debug output.");
        options.addOption("L","last-step",true,
                "Stop after this step. Stopping after step Simplify prints the simplified schema. "
                + "Stopping after step Normalize prints the simplified and normalized schema. ");
        options.addOption("F","first-step",true,
                "Start at this step. Provided to facilitate testing and debugging.");
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
            Integer debugLevel = null;
            try {
                debugLevel = new Integer(cmd.getOptionValue("debug","0"));
            } catch (NumberFormatException x) {
                System.out.println("Huh? debug's value is '"+cmd.getOptionValue("debug")+"'");
                usage();
            }
            Rngdoc rngdoc = new Rngdoc(debugLevel,cmd.getOptionValue("first-step"),cmd.getOptionValue("last-step"));
            rngdoc.generateDocumentation(cmd.getArgs()[0]);
        } catch (ParseException | ArrayIndexOutOfBoundsException x) {
            usage();
        } catch (OutputGeneratorException ex) {
            logger.error(ex);
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
            logger.warn(x);
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
