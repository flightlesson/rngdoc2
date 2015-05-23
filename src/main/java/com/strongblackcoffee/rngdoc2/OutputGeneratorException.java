package com.strongblackcoffee.rngdoc2;

/**
 *
 */
public class OutputGeneratorException extends Exception {
    
    public OutputGeneratorException(String s, Exception x) {
        super(s + x.toString());
    }
    
    public OutputGeneratorException(String s) {
        super(s);
    }
}
