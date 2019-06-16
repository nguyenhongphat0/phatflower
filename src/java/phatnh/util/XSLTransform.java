/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package phatnh.util;

import java.io.StringReader;
import java.io.StringWriter;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

/**
 *
 * @author nguyenhongphat0
 */
public class XSLTransform {
    public static String transform(String xslpath, String xmlContent) {
        try {
            StringReader reader = new StringReader(xmlContent);
            StringWriter writer = new StringWriter();
            StreamSource src = new StreamSource(reader);
            StreamResult res = new StreamResult(writer);
            StreamSource xsl = new StreamSource(xslpath);
            TransformerFactory tf = TransformerFactory.newInstance();
            Transformer trans = tf.newTransformer(xsl);
            trans.transform(src, res);
            return res.getWriter().toString();
        } catch (TransformerException ex) {
            ErrorHandler.handle(ex);
            return null;
        }
    }
}
