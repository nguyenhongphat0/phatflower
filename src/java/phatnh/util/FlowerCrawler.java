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
    private static final String VUONCAYVIET = "https://vuoncayviet.com/";
    private static final String WEBCAYCANH = "https://webcaycanh.com/";

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
                .declareEntities(context)
                .toString();
        StreamSource src = new StreamSource(new StringReader(content));
        String xml = new XSLTransform(getXSLPath("cayvahoa.net.xsl"))
                .transform(src)
                .toString();
        ProductParser parser = new ProductParser();
        XMLUtil.parseString(xml, parser);
        return parser.getCount();
    }
    
    public int crawlVuonCayViet(String subdomain) {
        String content = new HttpRequest(VUONCAYVIET + subdomain)
                .go()
                .match("<body[\\s\\S]*?>[\\s\\S]*?<\\/body>")
                .clean("<section id=\"navbar\"[\\s\\S]*?>[\\s\\S]*?<\\/section>")
                .clean("<script[\\s\\S]*?>[\\s\\S]*?<\\/script>")
                .clean("<iframe[\\s\\S]*?>[\\s\\S]*?<\\/iframe>")
                .clean("type=\"image\"")
                .clean("&#")
                .clean("&p=")
                .replace("<img([\\s\\S]*?)/?>", "<img$1\\/>")
                .replace("<div class='pic-news'<a", "<div class='pic-news'><a")
                .replace("<ul[\\s\\S]*?>", "<ul/>")
                .replace("</ul>", "<ul/>")
                .declareEntities(context)
                .toString();
        StreamSource src = new StreamSource(new StringReader(content));
        String xml = new XSLTransform(getXSLPath("vuoncayviet.com.xsl"))
                .transform(src)
                .toString();
        ProductParser parser = new ProductParser();
        XMLUtil.parseString(xml, parser);
        return parser.getCount();
    }
    
    public int crawlWebCayCanh(String subdomain) {
        String content = new HttpRequest(WEBCAYCANH + subdomain)
                .go()
                .match("<body[\\s\\S]*?>[\\s\\S]*?<\\/body>")
                .clean("<script[\\s\\S]*?>[\\s\\S]*?<\\/script>")
                .clean("<input([\\s\\S]*?)/?>")
                .clean("data-rsssl=1")
                .clean("<br>")
                .clean("<hr>")
                .clean("itemscope")
                .replace("<img([\\s\\S]*?)/?>", "<img$1\\/>")
                .declareEntities(context)
                .toString();
        StreamSource src = new StreamSource(new StringReader(content));
        String xml = new XSLTransform(getXSLPath("webcaycanh.com.xsl"))
                .transform(src)
                .toString();
        ProductParser parser = new ProductParser();
        XMLUtil.parseString(xml, parser);
        return parser.getCount();
    }
}
