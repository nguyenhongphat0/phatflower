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
import javax.servlet.ServletContext;
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
    
    public HttpRequest replace(String regex, String with) {
        Pattern pattern = Pattern.compile(regex, Pattern.DOTALL | Pattern.CASE_INSENSITIVE);
        this.result = pattern.matcher(this.result).replaceAll(with);
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

    public HttpRequest declareDTD(String dtd) {
        return this.prepend("<!DOCTYPE document SYSTEM '" + dtd + "'>");
    }
    
    public HttpRequest declareEntities(ServletContext context) {
        String realPath = context.getRealPath("/");
        String dtd = realPath + "/WEB-INF/dtd/html-entities.dtd";
        return this.declareDTD(dtd);
    }   
    
    @Override
    public String toString() {
        return this.result;
    }
}
