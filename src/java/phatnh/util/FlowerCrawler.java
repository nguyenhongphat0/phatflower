/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package phatnh.util;

import java.io.File;
import java.io.StringReader;
import java.util.Map;
import javax.servlet.ServletContext;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import phatnh.parser.ProductParser;
import phatnh.util.HttpRequest;

/**
 *
 * @author nguyenhongphat0
 */
public class FlowerCrawler {
    private ServletContext context;
    private static final String CAYVAHOA = "https://cayvahoa.net/";

    public FlowerCrawler(ServletContext context) {
        this.context = context;
    }
    
    public String getXSLPath(String filename) {
        String realPath = context.getRealPath("/");
        return realPath + "/WEB-INF/xsl/" + filename;
    }
    
    public int crawlCayVaHoa(String subdomain) {
        String content = new HttpRequest(CAYVAHOA + subdomain)
                .go()
                .match("<body[\\s\\S]*?>[\\s\\S]*?<\\/body>")
                .clean("data-rsssl=1")
                .clean("<br>")
                .clean("<hr>")
                .clean("<div class=\"footer row-fluid\">.*")
                .append("</body>")
                .declareEntity()
                .toString();
        StreamSource src = new StreamSource(new StringReader(content));
        String xml = new XSLTransform(getXSLPath("cayvahoa.net.xsl"))
                .transform(src)
                .toString();
        ProductParser parser = new ProductParser();
        XMLUtil.parseString(xml, parser);
        return parser.getCount();
    }
}
