/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package phatnh.parser;

import java.math.BigDecimal;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;
import phatnh.dao.PlantDAO;
import phatnh.model.Plant;

/**
 *
 * @author nguyenhongphat0
 */
public class ProductParser extends DefaultHandler {
    private String current;
    private Plant dto;
    private PlantDAO dao;
    private int count;
    private int fail;
    public String message;

    public ProductParser() {
        dao = new PlantDAO();
        count = 0;
        fail = 0;
    }

    public String getMessage() {
        return message;
    }

    @Override
    public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
        this.current = qName;
        if (qName.equals("plant")) {
            dto = new Plant();
        }
    }

    @Override
    public void characters(char[] chars, int start, int length) throws SAXException {
        String s = new String(chars, start, length);
        switch (current) {
            case "name":
                dto.setName(s);
                break;
            case "price":
                BigDecimal price = new BigDecimal(s);
                if (s.equals("0")) {
                    fail++;
                }
                dto.setPrice(price);
                break;
            case "link":
                dto.setLink(s);
                break;
            case "image":
                dto.setImage(s);
                break;
        }
    }

    @Override
    public void endElement(String uri, String localName, String qName) throws SAXException {
        if (qName.equals("plant")) {
            boolean success = dao.getPlantList().add(dto);
            if (success) {
                count++;
            }
        }
        this.current = "";
    }

    @Override
    public void endDocument() throws SAXException {
        int inserted = dao.insertAll();
        this.message = "Đã cào được " + count + " sản phẩm.";
        if (inserted < count) {
            this.message += " Trong đó có " + inserted + " sản phẩm mới, " + (count - inserted - fail) + " sản phẩm bị trùng, " + fail + " sản phẩm lỗi đã không được thêm vào database.";
        }
        this.message += "<br/>";
    }

    public int getCount() {
        return count;
    }
}
