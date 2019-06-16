/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package phatnh.dao;

import java.io.Serializable;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import javax.naming.NamingException;
import phatnh.model.Plants;
import phatnh.builder.QueryBuilder;
import phatnh.util.ErrorHandler;

/**
 *
 * @author nguyenhongphat0
 */
public class PlantDAO implements Serializable {
    
    public List<Plants.Plant> all() {
        final List<Plants.Plant> list = new ArrayList<>();
        try {
            new QueryBuilder()
                    .prepare("SELECT name, link, image, price FROM products")
                    .executeQuery()
                    .fetch(new QueryBuilder.ResultSetCallback() {
                        @Override
                        public void forEach(ResultSet res) throws SQLException {
                            Plants.Plant plant = new Plants.Plant();
                            plant.setName(res.getString(1));
                            plant.setLink(res.getString(2));
                            plant.setImage(res.getString(3));
                            plant.setPrice(res.getBigDecimal(4));
                            list.add(plant);
                        }
                    })
                    .close();
        } catch (NamingException | SQLException ex) {
            ErrorHandler.handle(ex);
        }
        return list;
    }
    
    public boolean insert(Plants.Plant dto) {
        try {
            return new QueryBuilder()
                    .prepare("INSERT INTO products(name, link, image, price) VALUES (?, ?, ?, ?)")
                    .setString(1, dto.getName())
                    .setString(2, dto.getLink())
                    .setString(3, dto.getImage())
                    .setBigDecimal(4, dto.getPrice())
                    .executeUpdate()
                    .close()
                    .isSuccess();
        } catch (NamingException | SQLException e) {
            ErrorHandler.handle(e);
            return false;
        }
    }
}
