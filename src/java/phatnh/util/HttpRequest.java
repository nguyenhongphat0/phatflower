/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package phatnh.util;

import java.io.IOException;
import java.io.InputStream;
import java.io.StringReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Scanner;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

/**
 *
 * @author nguyenhongphat0
 */
public class HttpRequest {
    private String path;
    private InputStream is;
    private String result;

    public HttpRequest(String path) {
        this.path = path;
    }
    
    public HttpRequest go() {
        try {
            URL url = new URL(this.path);
            this.is = url.openStream();
            String s = "";
            Scanner sc = new Scanner(is, "UTF-8");
            while (sc.hasNext()) {
                s += sc.nextLine() + "\n";
            }
            this.result = s;
        } catch (MalformedURLException ex) {
            ErrorHandler.handle(ex);
        } catch (IOException ex) {
            ErrorHandler.handle(ex);
        }
        return this;
    }
    
    public HttpRequest sout() {
        System.out.println(this.result);
        return this;
    }
    
    public HttpRequest match(String regex) {
        Pattern pattern = Pattern.compile(regex, Pattern.DOTALL | Pattern.CASE_INSENSITIVE);
        Matcher matcher = pattern.matcher(this.result);
        this.result = "";
        while (matcher.find()) {
            this.result += matcher.group();
        }
        return this;
    }
    
    public HttpRequest clean(String regex) {
        Pattern pattern = Pattern.compile(regex, Pattern.DOTALL | Pattern.CASE_INSENSITIVE);
        this.result = pattern.matcher(this.result).replaceAll("");
        return this;
    }
    
    public HttpRequest prepend(String s) {
        this.result = s + this.result;
        return this;
    }
    
    public HttpRequest append(String s) {
        this.result += s;
        return this;
    }

    public HttpRequest declareEntity() {
        return this.prepend("<!DOCTYPE document ["
                + "<!ENTITY nbsp ' '>"
                + "<!ENTITY ndash '–'>"
                + "<!ENTITY hellip '…'>"
                + "<!ENTITY rarr '→'>"
                + "<!ENTITY larr '←'>"
                + "]>");
    }
    
    @Override
    public String toString() {
        return this.result;
    }
    
    public static void main(String[] args) throws Exception {
        String content = new HttpRequest("https://cayvahoa.net/cay-canh/page/2/")
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
        StreamResult res = new XSLTransform("src/java/phatnh/xsl/cayvahoa.net.xsl")
                .transform(src)
                .toStreamResult();
        
    }
}
