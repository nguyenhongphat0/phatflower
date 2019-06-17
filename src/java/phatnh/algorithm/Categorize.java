/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package phatnh.algorithm;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.NamingException;
import phatnh.builder.QueryBuilder;
import phatnh.util.ErrorHandler;

/**
 *
 * @author nguyenhongphat0
 */
public class Categorize {
    
    public static void main(String[] args) {
        try {
            final List<String> names = new ArrayList<>();
            new QueryBuilder()
                    .prepare("SELECT name FROM products")
                    .fetch(new QueryBuilder.ResultSetCallback() {
                        @Override
                        public void forEach(ResultSet res) throws SQLException {
                            names.add(res.getString("name"));
                        }
                    });
            List<String> token = new ArrayList<>();
            for (String name : names) {
                String[] words = name.split(" ");
                token.addAll(Arrays.asList(words));
            }
            System.out.println(token.size());
        } catch (NamingException | SQLException ex) {
            ErrorHandler.handle(ex);
        }
    }
}
