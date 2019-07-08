/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package phatnh.util;

import java.io.IOException;
import java.io.StringReader;
import java.nio.charset.StandardCharsets;
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
    
    public static String getDomainFromURL(String url) {
        String domain = url;
        try {
            domain = domain.substring(domain.indexOf("//") + 2);
            domain = domain.substring(0, domain.indexOf("/"));
        } catch (Exception e) {
            ErrorHandler.handle(e);
        }
        return domain;
    }
    
    public static String getSubDomainFromURL(String url) {
        String domain = url;
        domain = domain.substring(domain.indexOf("//") + 2);
        domain = domain.substring(domain.indexOf("/"));
        return domain;
    }
    
    public static String getVietnameseString(String s) {
        byte[] bytes = s.getBytes(StandardCharsets.ISO_8859_1);
        return new String(bytes, StandardCharsets.UTF_8);
    }
}
