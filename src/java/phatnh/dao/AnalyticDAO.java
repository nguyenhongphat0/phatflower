/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package phatnh.dao;

import java.io.Serializable;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.NamingException;
import phatnh.builder.QueryBuilder;

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
}
