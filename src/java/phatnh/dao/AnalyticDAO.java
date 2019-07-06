/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package phatnh.dao;

import java.io.PrintWriter;
import java.io.Serializable;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.NamingException;
import javax.xml.stream.XMLOutputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamWriter;
import phatnh.builder.QueryBuilder;
import phatnh.util.ErrorHandler;

/**
 *
 * @author nguyenhongphat0
 */
public class AnalyticDAO implements Serializable {
    
    public void record(String product, String userAgent, String pageUrl) throws NamingException, SQLException {
        String sql = "INSERT INTO analytics(product, user_agent, page_url) VALUES (" + product + ", ?, ?)";
        new QueryBuilder()
                .prepare(sql)
                .setString(1, userAgent)
                .setString(2, pageUrl)
                .executeUpdate()
                .close();
    }
    
    public void analizeUserAgent(PrintWriter writer) {
        String sql = "SELECT user_agent as value, count(id) as count FROM analytics "
                + "GROUP BY user_agent "
                + "ORDER BY count DESC";
        writeResult(sql, writer);
    }
    
    public void analizePageUrls(PrintWriter writer) {
        String sql = "SELECT page_url as value, count(id) as count FROM analytics "
                + "WHERE page_url IS NOT NULL "
                + "GROUP BY page_url "
                + "ORDER BY count DESC";
        writeResult(sql, writer);
    }
    
    public void analizeDailyViews(PrintWriter writer) {
        String sql = "SELECT date(moment) AS value, count(id) AS count FROM analytics "
                + "GROUP BY date(moment) "
                + "LIMIT 30";
        writeResult(sql, writer);
    }
    
    public void analizeRealTimeViews(PrintWriter writer) {
        String sql = "SELECT time(moment) AS value, count(id) as count FROM analytics "
                + "WHERE moment >= now() - INTERVAL 1 HOUR "
                + "GROUP BY minute(moment) "
                + "ORDER BY value ASC";
        writeResult(sql, writer);
    }
    
    private void writeResult(String sql, PrintWriter writer) {
        try {
            QueryBuilder qb = new QueryBuilder()
                    .prepare(sql)
                    .executeQuery();
            ResultSet res = qb.getResultSet();
            XMLOutputFactory xof = XMLOutputFactory.newInstance();
            XMLStreamWriter xsw = xof.createXMLStreamWriter(writer);
            xsw.writeStartDocument();
            xsw.writeStartElement("analytics");
            while (res.next()) {
                xsw.writeStartElement("analytic");
                xsw.writeStartElement("value");
                xsw.writeCharacters(res.getString("value"));
                xsw.writeEndElement();
                xsw.writeStartElement("count");
                xsw.writeCharacters(res.getString("count"));
                xsw.writeEndElement();
                xsw.writeEndElement();
            }
            xsw.writeEndElement();
            xsw.writeEndDocument();
            xsw.flush();
            xsw.close();
            qb.close();
        } catch (NamingException | SQLException | XMLStreamException ex) {
            ErrorHandler.handle(ex);
        }
    }
}
