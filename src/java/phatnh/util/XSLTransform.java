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
        return transformWithParams(xslpath, xmlContent, null);
    }
    
    public static String transformWithParams(String xslpath, String xmlContent, CustomizeTransformerCallback callback) {
        try {
            StringReader reader = new StringReader(xmlContent);
            StringWriter writer = new StringWriter();
            StreamSource src = new StreamSource(reader);
            StreamResult res = new StreamResult(writer);
            StreamSource xsl = new StreamSource(xslpath);
            TransformerFactory tf = TransformerFactory.newInstance();
            Transformer trans = tf.newTransformer(xsl);
            if (callback != null) {
                callback.customize(trans);
            }
            trans.transform(src, res);
            return res.getWriter().toString();
        } catch (TransformerException ex) {
            ErrorHandler.handle(ex);
            return null;
        }
    }
    
    public static interface CustomizeTransformerCallback {
        public void customize(Transformer trans);
    }
}
