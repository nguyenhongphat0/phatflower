/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package phatnh.model;

import java.io.Serializable;

/**
 *
 * @author nguyenhongphat0
 */
public class ProductDTO implements Serializable {
    private String name, link, image;
    private int price;

    public ProductDTO() {
    }

    public ProductDTO(String name, String link, String image, int price) {
        this.name = name;
        this.link = link;
        this.image = image;
        this.price = price;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLink() {
        return link;
    }

    public void setLink(String link) {
        this.link = link;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }
    
    
}
