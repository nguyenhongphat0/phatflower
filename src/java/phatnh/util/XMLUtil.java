/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package phatnh.util;

import java.io.IOException;
import java.io.StringReader;
import java.util.HashMap;
import java.util.Map;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;
import org.xml.sax.Attributes;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

/**
 *
 * @author nguyenhongphat0
 */
public class XMLUtil {
    
    public static void parseString(String xml, DefaultHandler handler) {
        try {
            StringReader sr = new StringReader(xml);
            InputSource source = new InputSource(sr);
            SAXParserFactory spf = SAXParserFactory.newInstance();
            SAXParser sax = spf.newSAXParser();
            sax.parse(source, handler);
        } catch (ParserConfigurationException | SAXException | IOException e) {
            ErrorHandler.handle(e);
        }
    }
}
