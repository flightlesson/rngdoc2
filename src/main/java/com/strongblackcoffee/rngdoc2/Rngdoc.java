package com.strongblackcoffee.rngdoc2;

import java.io.CharArrayWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.StringReader;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.DefaultParser;
import org.apache.commons.cli.HelpFormatter;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.ParseException;

public class Rngdoc  {

    static final String USAGE = "{cmd} [{args}] {schema}.rng";
    static final String HEADER = "Generates documentation fo a Relax NG schema.\nOptions are:";
    static final Options OPTIONS = new Options();
    static {
        OPTIONS.addOption("h","help",false,"show help");
        OPTIONS.addOption("D","output-dir",true,"specify the directory that HTML files get written to; defaults to './'.");
        OPTIONS.addOption("v","verbose",false,"verbose output");
        OPTIONS.addOption("d","debug",false,"more verbose output");
        OPTIONS.addOption("L","last-step",true,
                "Stop after this step. Stopping after step Simplify prints the simplified schema. "
                + "Stopping after step Normalize prints the simplified and normalized schema. ");
        OPTIONS.addOption("F","first-step",true,"Start at this step. Provided to facilitate testing and debugging.");
    };
    static final String FOOTER = "Generates many .html files; the starting point is named index.html.";
    
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
            int verbosity = cmdline.hasOption("debug") ? 2 : cmdline.hasOption("verbose") ? 1 : 0;
            Rngdoc rngdoc = new Rngdoc(verbosity,cmdline.getOptionValue("first-step"),cmdline.getOptionValue("last-step"));
            rngdoc.generateDocumentation(cmdline.getArgs()[0]);
        } catch (ParseException | ArrayIndexOutOfBoundsException ex) {
            System.out.println(ex.getMessage());
            (new HelpFormatter()).printHelp(USAGE,HEADER,OPTIONS,FOOTER,false);
        } catch (OutputGeneratorException ex) {
            System.out.println(ex.getMessage());
        }
    }
    
    Integer verbosity;
    String firstStep;
    String lastStep;
    
    /**
     * 
     * @param verbosity 0 means no debug messages; 2 is more verbose than 1
     * @param firstStep  null except when debugging
     * @param lastStep   null except when debugging
     */
    public Rngdoc(Integer verbosity, String firstStep, String lastStep) {
        this.verbosity = verbosity;
        this.firstStep = firstStep;
        this.lastStep = lastStep;
    }

    void generateDocumentation(String pathToSchema) throws OutputGeneratorException {
        
        Simplifier simplifier = new Simplifier(verbosity,firstStep,lastStep);
        Normalizer normalizer = new Normalizer(verbosity,firstStep,lastStep);
        
        try {
            StreamSource schema = new StreamSource(new FileInputStream(pathToSchema));
            
            CharArrayWriter simplifiedBuffer = new CharArrayWriter();
            Result simplifiedSchema = new StreamResult(simplifiedBuffer);
            simplifier.transform(schema, simplifiedSchema);
            if (verbosity > 0 || lastStep != null && lastStep.startsWith("Simplify")) {
                System.out.println(simplifiedBuffer.toString());
                if (lastStep != null && lastStep.startsWith("Simplify")) return;
            }

            CharArrayWriter normalizedBuffer = new CharArrayWriter();
            Result normalizedSchema = new StreamResult(normalizedBuffer);
            normalizer.transform(new StreamSource(new StringReader(simplifiedBuffer.toString())), normalizedSchema);
            if (verbosity > 0 || lastStep != null && lastStep.startsWith("Normalize")) {
                System.out.println(normalizedBuffer.toString());
                if (lastStep != null && lastStep.startsWith("Normalize")) return;
            }
        
            System.out.println(normalizedBuffer.toString());  // FIXME: generate documentation            
       
        } catch (FileNotFoundException ex) {
            System.out.println(ex);
            System.exit(1);
        }
    }
}
