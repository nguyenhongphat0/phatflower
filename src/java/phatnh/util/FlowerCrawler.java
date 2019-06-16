/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package phatnh.util;

import java.io.StringReader;
import javax.servlet.ServletContext;
import javax.xml.transform.stream.StreamSource;
import phatnh.parser.ProductParser;
import phatnh.builder.RequestBuilder;

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
        String content = new RequestBuilder(CAYVAHOA + subdomain)
                .go()
                .match("<body[\\s\\S]*?>[\\s\\S]*?<\\/body>")
                .clean("data-rsssl=1")
                .clean("<br>")
                .clean("<hr>")
                .clean("<div class=\"footer row-fluid\">.*")
                .append("</body>")
                .declareEntities(context)
                .toString();
        return process("cayvahoa.net.xsl", content);
    }
    
    public int crawlVuonCayViet(String subdomain) {
        String content = new RequestBuilder(VUONCAYVIET + subdomain)
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
        return process("vuoncayviet.com.xsl", content);
    }
    
    public int crawlWebCayCanh(String subdomain) {
        String content = new RequestBuilder(WEBCAYCANH + subdomain)
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
        return process("webcaycanh.com.xsl", content);
    }
    
    public int process(String xsl, String content) {
        String xml = XSLTransform.transform(getXSLPath(xsl), content);
        ProductParser parser = new ProductParser();
        XMLUtil.parseString(xml, parser);
        return parser.getCount();
    }
}
