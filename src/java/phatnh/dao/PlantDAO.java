/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package phatnh.dao;

import java.io.Serializable;
import java.sql.SQLException;
import javax.naming.NamingException;
import phatnh.model.Plants;
import phatnh.util.DatabaseUtil;
import phatnh.util.ErrorHandler;

/**
 *
 * @author nguyenhongphat0
 */
public class PlantDAO implements Serializable {
    
    public boolean insert(Plants.Plant dto) {
        try {
            return new DatabaseUtil()
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
