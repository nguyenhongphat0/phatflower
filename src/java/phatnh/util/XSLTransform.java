/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package phatnh.util;

import java.util.logging.Level;
import java.util.logging.Logger;
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
    private StreamSource xsl;
    private StreamResult res;
    
    public XSLTransform(String xslpath) {
        this.xsl = new StreamSource(xslpath);
    }
    
    public XSLTransform transform(StreamSource src) {
        try {
            this.res = new StreamResult(System.out);
            TransformerFactory tf = TransformerFactory.newInstance();
            Transformer trans = tf.newTransformer(this.xsl);
            trans.transform(src, this.res);
        } catch (TransformerException ex) {
            ErrorHandler.handle(ex);
        }
        return this;
    }
    
    public StreamResult toStreamResult() {
        return this.res;
    }
}
