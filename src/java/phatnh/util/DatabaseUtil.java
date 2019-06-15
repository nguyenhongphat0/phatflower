/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package phatnh.util;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

/**
 *
 * @author nguyenhongphat0
 */
public class DatabaseUtil {
    private Connection connection;
    private PreparedStatement preparedStatement;
    private ResultSet resultSet;
    private boolean success;

    public DatabaseUtil() throws NamingException, SQLException {
        InitialContext context = new InitialContext();
        DataSource ds = (DataSource) context.lookup("java:comp/env/DataSource");
        this.connection = ds.getConnection();
    }
    
    public DatabaseUtil prepare(String statement) throws SQLException {
        this.preparedStatement = connection.prepareStatement(statement);
        return this;
    }
    
    public DatabaseUtil setString(int i, String s) throws SQLException {
        this.preparedStatement.setString(i, s);
        return this;
    }
    
    public DatabaseUtil setBigDecimal(int i, BigDecimal x) throws SQLException {
        this.preparedStatement.setBigDecimal(i, x);
        return this;
    }
    
    public DatabaseUtil executeUpdate() throws SQLException {
        this.success = this.preparedStatement.executeUpdate() > 0;
        return this;
    }
    
    public DatabaseUtil check(StatusCallback callback) throws SQLException {
        callback.check(success);
        return this;
    }
    
    public DatabaseUtil executeQuery() throws SQLException {
        this.resultSet = this.preparedStatement.executeQuery();
        return this;
    }
    
    public DatabaseUtil fetch(ResultSetCallback callback) throws SQLException {
        while (this.resultSet.next()) {
            callback.forEach(this.resultSet);
        }
        return this;
    }
    
    public DatabaseUtil close() throws SQLException {
        if (this.resultSet != null) {
            this.resultSet.close();
        }
        if (this.preparedStatement != null) {
            this.preparedStatement.close();
        }
        if (this.connection != null) {
            this.connection.close();
        }
        return this;
    }
    
    public boolean isSuccess() {
        return this.success;
    }
    
    public ResultSet getResultSet() {
        return this.resultSet;
    }
    
    public static interface ResultSetCallback {
        public void forEach(ResultSet res);
    }
    
    public static interface StatusCallback {
        public void check(boolean success);
    }
}
