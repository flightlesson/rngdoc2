package com.strongblackcoffee.rngdoc2;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FilenameFilter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import static org.junit.Assert.*;
import org.xmlunit.matchers.CompareMatcher;

/**
 *
 */
public class SimplifierTest {
    
    public SimplifierTest() {
    }
    
    @BeforeClass
    public static void setUpClass() {
    }
    
    @AfterClass
    public static void tearDownClass() {
    }
    
    @Before
    public void setUp() {
    }
    
    @After
    public void tearDown() {
    }
    
    // Each test is a directory under src/test/resources
    // Each test consists of up to 4 files:
    //   - a file named "input-data.rng"
    //   - a file named "expected-result.rng"
    //   - (optional) a file named "stop-after-{step}" where {step} names the final step.
    //   - (optional) a file named "start-at-{step}" where {step} names the first step.
    
    public void performTest(String testDirName, boolean verbose) {
        if (verbose) System.out.println("performTest " + testDirName);
        File testDir = new File("src/test/resources/" + testDirName);
        assertTrue(testDir.getPath() + " is not a directory", testDir.isDirectory());
        assertTrue(testDir.getPath() + " is not readable", testDir.canRead());
        
        File[] files = testDir.listFiles(new FilenameFilter() {
            @Override public boolean accept(File d, String name) {
                return "input-data.rng".equals(name);
            }
        });
        assertEquals("didn't find input-data.rng",1,files.length);
        File inputData = files[0];
        
        files = testDir.listFiles(new FilenameFilter() {
            @Override public boolean accept(File d, String name) {
                return "expected-result.rng".equals(name);
            }
        });
        assertEquals("didn't find expected-result.rng",1,files.length);
        File expectedResult = files[0];
        
        String stopAfter = null;
        files = testDir.listFiles(new FilenameFilter() {
            @Override public boolean accept(File d, String name) {
                return name.startsWith("stop-after-");
            }
        });
        if (files.length > 0) {
            assertEquals("more than one file beginning with stop-after-",1,files.length);
            stopAfter = files[0].getName().substring(11);
        }
        
        String startAt = null;
        files = testDir.listFiles(new FilenameFilter() {
            @Override public boolean accept(File d, String name) {
                return name.startsWith("start-at-");
            }
        });
        if (files.length > 0) {
            assertEquals("more than one file beginning with start-at-",1,files.length);
            startAt = files[0].getName().substring(9);
        }
        
        performTest(inputData, expectedResult, startAt, stopAfter, verbose);
    }
    
    public void performTest(File inputData, File expectedResult, String startAt, String stopAfter, boolean verbose) {
        try {
            Simplifier instance = new Simplifier(verbose?2:0,startAt,stopAfter);
            Source source = new StreamSource(inputData);
            ByteArrayOutputStream resultStream = new ByteArrayOutputStream();
            Result result = new StreamResult(resultStream);
            instance.transform(source, result);
            String actual = resultStream.toString();
            String expected = new String(Files.readAllBytes(Paths.get(expectedResult.getPath())));
            if (verbose) System.out.println("actual is " + actual);
            if (verbose) System.out.println("expected is " + expected);
            assertThat(actual,CompareMatcher.isSimilarTo(expected).ignoreWhitespace());    
        } catch (OutputGeneratorException ex) {
            fail("couldn't create Simplifier: " + ex.getMessage());
        } catch (IOException ex) {
            fail("couldn't read " + expectedResult.getPath() + ": " + ex.getMessage());
        }
    }
    
    @Test public void test401() { performTest("Simplifier-test-4.01", false); }
    @Test public void test404() { performTest("Simplifier-test-4.04", false); }
    
}
