/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package phatnh.util;

import javax.servlet.ServletContext;
import phatnh.parser.ProductParser;
import phatnh.builder.RequestBuilder;

/**
 *
 * @author nguyenhongphat0
 */
public class FlowerCrawler {
    private final ServletContext context;
    private final String url, domain, subdomain;
    
    private static final String CAYVAHOA = "https://cayvahoa.net/";
    private static final String VUONCAYVIET = "https://vuoncayviet.com/";
    private static final String WEBCAYCANH = "https://webcaycanh.com/";

    public FlowerCrawler(ServletContext context, String url) {
        this.context = context;
        this.url = url;
        this.domain = XMLUtil.getDomainFromURL(url);
        this.subdomain = XMLUtil.getSubDomainFromURL(url);
    }
    
    public int crawl() {
        String prefix = "https://" + domain + "/";
        switch (prefix) {
            case CAYVAHOA:
                return crawlCayVaHoa(subdomain);
            case VUONCAYVIET:
                return crawlVuonCayViet(subdomain);
            case WEBCAYCANH:
                return crawlWebCayCanh(subdomain);
            default:
                return -1;
        }
    }
    
    public String getXSLPath(String filename) {
        String realPath = context.getRealPath("/");
        return realPath + "/WEB-INF/xsl/" + filename;
    }
    
    public int crawlCayVaHoa(String subdomain) {
        String content = new RequestBuilder(url)
                .go()
                .match("<body[\\s\\S]*?>[\\s\\S]*?<\\/body>")
                .clean("data-rsssl=1")
                .clean("<br>")
                .clean("<hr>")
                .clean("itemscope")
                .clean("<div class=\"footer row-fluid\">.*")
                .append("</body>")
                .replace("&", "&amp;")
                .toString();
        return process(content);
    }
    
    public int crawlVuonCayViet(String subdomain) {
        String content = new RequestBuilder(url)
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
                .replace("&", "&amp;")
                .toString();
        return process(content);
    }
    
    public int crawlWebCayCanh(String subdomain) {
        String content = new RequestBuilder(url)
                .go()
                .match("<body[\\s\\S]*?>[\\s\\S]*?<\\/body>")
                .clean("<script[\\s\\S]*?>[\\s\\S]*?<\\/script>")
                .clean("<input([\\s\\S]*?)/?>")
                .clean("data-rsssl=1")
                .clean("<br>")
                .clean("<hr>")
                .clean("itemscope")
                .replace("<img([\\s\\S]*?)/?>", "<img$1\\/>")
                .replace("&", "&amp;")
                .toString();
        return process(content);
    }
    
    public int process(String content) {
        String xsl = getXSLPath(domain + ".xsl");
        String xml = XSLTransform.transform(xsl, content);
        if (xml == null) {
            return 0;
        }
        ProductParser parser = new ProductParser();
        XMLUtil.parseString(xml, parser);
        return parser.getCount();
    }
}
