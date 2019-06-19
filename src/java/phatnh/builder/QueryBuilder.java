/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package phatnh.builder;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

/**
 * Utilities for communication with the database, using builder pattern
 * @author nguyenhongphat0
 */
public class QueryBuilder {
    private Connection connection;
    private PreparedStatement preparedStatement;
    private ResultSet resultSet;
    private boolean success;

    /**
     * Init a new QueryBuilder object, open a connection to database using DataSource
     * @throws NamingException
     * @throws SQLException 
     */
    public QueryBuilder() throws NamingException, SQLException {
        InitialContext context = new InitialContext();
        DataSource ds = (DataSource) context.lookup("java:comp/env/DataSource");
        this.connection = ds.getConnection();
    }
    
    /**
     * Prepare a SQL statement
     * @param statement
     * @return
     * @throws SQLException 
     */
    public QueryBuilder prepare(String statement) throws SQLException {
        this.preparedStatement = connection.prepareStatement(statement);
        return this;
    }
    
    /**
     * Set string for the statement
     * @param i
     * @param s
     * @return
     * @throws SQLException 
     */
    public QueryBuilder setString(int i, String s) throws SQLException {
        this.preparedStatement.setString(i, s);
        return this;
    }
    
    /**
     * Set big decimal for the statement
     * @param i
     * @param x
     * @return
     * @throws SQLException 
     */
    public QueryBuilder setBigDecimal(int i, BigDecimal x) throws SQLException {
        this.preparedStatement.setBigDecimal(i, x);
        return this;
    }
    
    /**
     * Set number for the statement
     * @param i
     * @param x
     * @return
     * @throws SQLException 
     */
    public QueryBuilder setInt(int i, int x) throws SQLException {
        this.preparedStatement.setInt(i, x);
        return this;
    }
    
    /**
     * Use this to run the INSERT, UPDATE, DELETE statement
     * @return
     * @throws SQLException 
     */
    public QueryBuilder executeUpdate() throws SQLException {
        this.success = this.preparedStatement.executeUpdate() > 0;
        return this;
    }
    
    /**
     * You can pass a callback function here to check the status of the executeUpdate statement
     * A query is success if affected rows > 0
     * @param callback
     * @return
     * @throws SQLException 
     */
    public QueryBuilder check(StatusCallback callback) throws SQLException {
        callback.check(success);
        return this;
    }
    
    /**
     * Use this to run the SELECT statement
     * @return
     * @throws SQLException 
     */
    public QueryBuilder executeQuery() throws SQLException {
        this.resultSet = this.preparedStatement.executeQuery();
        return this;
    }
    
    /**
     * You can pass a callback function here to loop through the result set
     * The callback function will implement the method forEach, which have the ResultSet as the parameter
     * @param callback
     * @return
     * @throws SQLException 
     */
    public QueryBuilder fetch(ResultSetCallback callback) throws SQLException {
        while (this.resultSet.next()) {
            callback.forEach(this.resultSet);
        }
        return this;
    }
    
    /**
     * Remember to call this function after everything is done
     * @return
     * @throws SQLException 
     */
    public QueryBuilder close() throws SQLException {
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
    
    /**
     * Manually get the success status
     * @return 
     */
    public boolean isSuccess() {
        return this.success;
    }
    
    /**
     * Manually get the ResultSet for advanced handling
     * @return 
     */
    public ResultSet getResultSet() {
        return this.resultSet;
    }
    
    public static interface ResultSetCallback {
        public void forEach(ResultSet res) throws SQLException;
    }
    
    public static interface StatusCallback {
        public void check(boolean success);
    }
}
