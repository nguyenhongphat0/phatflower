/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package phatnh.dao;

import java.io.Serializable;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Map;
import javax.naming.NamingException;
import phatnh.builder.QueryBuilder;
import phatnh.model.Categories;
import phatnh.model.Category;

/**
 *
 * @author nguyenhongphat0
 */
public class CategoryDAO implements Serializable {
    Categories categories = new Categories();

    public Categories getCategories() {
        return categories;
    }
    
    public void clearCategories() throws NamingException, SQLException {
        new QueryBuilder()
                .prepare("DELETE FROM categories")
                .executeUpdate()
                .close();
    }
    
    public int insertCategories(Map<String, Integer> token) throws NamingException, SQLException {
        QueryBuilder qb = new QueryBuilder();
        int count = 0;
        for (Map.Entry<String, Integer> entrySet : token.entrySet()) {
            String key = entrySet.getKey();
            Integer value = entrySet.getValue();
            if (value > 1) {
                count++;
                qb.prepare("INSERT INTO categories (name, count) VALUES (?, ?)")
                        .setString(1, key)
                        .setInt(2, value)
                        .executeUpdate();
            }
        }
        qb.close();
        return count;
    }
    
    public void all() throws NamingException, SQLException {
        categories.clear();
        new QueryBuilder()
                .prepare("SELECT id, name, count, enable, onmenu, length(name)*count as priority FROM categories ORDER BY priority DESC")
                .executeQuery()
                .fetch(new QueryBuilder.ResultSetCallback() {
                    @Override
                    public void forEach(ResultSet res) throws SQLException {
                        Category dto = new Category();
                        dto.setId(res.getBigDecimal(1));
                        dto.setName(res.getString(2));
                        dto.setCount(res.getBigDecimal(3));
                        dto.setEnable(res.getBoolean(4));
                        dto.setOnmenu(res.getBoolean(5));
                        categories.getCategory().add(dto);
                    }
                })
                .close();
    }
    
    public void update(String id, String field, String value) throws SQLException, NamingException {
        new QueryBuilder()
                .prepare("UPDATE categories SET " + field + " = " + value + " WHERE id = " + id)
                .executeUpdate()
                .close();
    }
}
