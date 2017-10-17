package com.strongblackcoffee.rngdoc2;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.util.logging.Level;
import java.util.logging.Logger;
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

/**
 *
 * @author tsingle
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
    
    @Test
    public void testCanReadResources() {
        File file = new File("src/test/resources/found.txt");
        assertTrue("found.txt should exist", file.exists());
        assertTrue("found.txt should be readable", file.canRead());
        assertTrue("found.txt should be a file", file.isFile());
        //try {
        //    System.out.println("path is " + file.getPath() + ", absolute path is " + file.getAbsolutePath() + ", canonical path is " + file.getCanonicalPath());
        //    System.out.println("exists: " + file.exists() + ", canRead: " + file.canRead() + ", isFile: " + file.isFile());
        //} catch (IOException ex) {
        //    fail("IOException " + ex.getMessage());
        //}
        file = new File("src/test/resources/notfound.txt");
        assertFalse("notfound.txt shouldn't exist",file.exists());
        assertFalse("notfound.txt should not be readable", file.canRead());
        assertFalse("notfound.txt should not be a file", file.isFile());
    }

    @Test
    public void test401() {
        System.out.println("test401");
        try {
            Simplifier instance = new Simplifier(0, "Simplify-4.01", "Simplify-4.01");
            File sourceFile = new File("src/test/resources/test401-source.rng");
            Source source = new StreamSource(sourceFile);
            ByteArrayOutputStream resultStream = new ByteArrayOutputStream();
            Result result = new StreamResult(resultStream);
            instance.transform(source, result);
            String actual = resultStream.toString();
            System.out.println("result is " + actual);
        } catch (OutputGeneratorException ex) {
            fail("Caught OutputGeneratorException " + ex.getMessage());
        }
    }
    
}
