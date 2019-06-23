/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package phatnh.dao;

import java.io.Serializable;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;
import javax.naming.NamingException;
import phatnh.model.Plant;
import phatnh.builder.QueryBuilder;
import phatnh.model.Plants;
import phatnh.util.ErrorHandler;
import phatnh.util.XMLUtil;

/**
 *
 * @author nguyenhongphat0
 */
public class PlantDAO implements Serializable {
    private Plants plants = new Plants();

    public Plants getPlants() {
        return plants;
    }
    
    public List<Plant> getPlantList() {
        return plants.getPlant();
    }
    
    public String getReadablePrice(Plant plant) {
        DecimalFormat f = new DecimalFormat();
        f.setGroupingUsed(true);
        f.setGroupingSize(3);
        return f.format(plant.getPrice());
    }
    
    public String getDomain(Plant plant) {
        return XMLUtil.getDomainFromURL(plant.getLink());
    }
    
    public void all() {
        try {
            new QueryBuilder()
                    .prepare("SELECT id, name, link, image, price FROM products")
                    .executeQuery()
                    .fetch(new QueryBuilder.ResultSetCallback() {
                        @Override
                        public void forEach(ResultSet res) throws SQLException {
                            Plant plant = new Plant();
                            plant.setId(res.getBigDecimal("id"));
                            plant.setName(res.getString("name"));
                            plant.setLink(res.getString("link"));
                            plant.setImage(res.getString("image"));
                            plant.setPrice(res.getBigDecimal("price"));
                            getPlantList().add(plant);
                        }
                    })
                    .close();
        } catch (NamingException | SQLException ex) {
            ErrorHandler.handle(ex);
        }
    }
    
    public Plant find(String id) {
        final Plant plant = new Plant();
        try {
            new QueryBuilder()
                    .prepare("SELECT id, name, link, image, price FROM products WHERE id = " + id)
                    .executeQuery()
                    .fetch(new QueryBuilder.ResultSetCallback() {
                        @Override
                        public void forEach(ResultSet res) throws SQLException {
                            plant.setId(res.getBigDecimal("id"));
                            plant.setName(res.getString("name"));
                            plant.setLink(res.getString("link"));
                            plant.setImage(res.getString("image"));
                            plant.setPrice(res.getBigDecimal("price"));
                        }
                    })
                    .close();
        } catch (NamingException | SQLException ex) {
            ErrorHandler.handle(ex);
        }
        return plant;
    }
    
    public boolean insert(Plant dto) {
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
    
    public boolean insertContent(String id, String content) {
        try {
            int idValue = Integer.parseInt(id);
            return new QueryBuilder()
                    .prepare("INSERT INTO product_contents(id, content) VALUES (?, ?)")
                    .setInt(1, idValue)
                    .setString(2, content)
                    .executeUpdate()
                    .close()
                    .isSuccess();
        } catch (NumberFormatException | NamingException | SQLException e) {
            ErrorHandler.handle(e);
            return false;
        }
    }
    
    public String fetchContent(String id) {
        final StringBuilder sb = new StringBuilder();
        try {
            int idValue = Integer.parseInt(id);
            new QueryBuilder()
                    .prepare("SELECT content FROM product_contents WHERE id = ?")
                    .setInt(1, idValue)
                    .executeQuery()
                    .fetch(new QueryBuilder.ResultSetCallback() {
                        @Override
                        public void forEach(ResultSet res) throws SQLException {
                            sb.append(res.getString(1));
                        }
                    })
                    .close();
        } catch (NumberFormatException | NamingException | SQLException e) {
            ErrorHandler.handle(e);
        }
        return sb.toString();
    }
    
    public List<String> fetchNames() throws NamingException, SQLException {
        final List<String> names = new ArrayList<>();
        new QueryBuilder()
                .prepare("SELECT name FROM products")
                .executeQuery()
                .fetch(new QueryBuilder.ResultSetCallback() {
                    @Override
                    public void forEach(ResultSet res) throws SQLException {
                        names.add(res.getString("name").toLowerCase());
                    }
                });
        return names;
    }
    
    public void findSimilar(String name) {
        try {
            String sql = "SELECT id, name, link, image, price FROM products "
                    + "WHERE POSITION("
                        + "(SELECT name FROM categories "
                        + "WHERE COUNT <= 10 AND POSITION(name IN ?) > 0 "
                        + "ORDER BY COUNT DESC LIMIT 1) "
                        + "IN "
                        + "name"
                    + ") > 0";
            new QueryBuilder()
                    .prepare(sql)
                    .setString(1, name)
                    .executeQuery()
                    .fetch(new QueryBuilder.ResultSetCallback() {
                        @Override
                        public void forEach(ResultSet res) throws SQLException {
                            Plant plant = new Plant();
                            plant.setId(res.getBigDecimal("id"));
                            plant.setName(res.getString("name"));
                            plant.setLink(res.getString("link"));
                            plant.setImage(res.getString("image"));
                            plant.setPrice(res.getBigDecimal("price"));
                            getPlantList().add(plant);
                        }
                    })
                    .close();
        } catch (NamingException | SQLException ex) {
            ErrorHandler.handle(ex);
        }
    }
}
