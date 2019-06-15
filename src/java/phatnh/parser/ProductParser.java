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
import phatnh.model.Plants;

/**
 *
 * @author nguyenhongphat0
 */
public class ProductParser extends DefaultHandler {
    private String current;
    private Plants.Plant dto;
    private PlantDAO dao;
    private int count;

    public ProductParser() {
        dao = new PlantDAO();
        count = 0;
    }

    @Override
    public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
        this.current = qName;
        if (qName.equals("plant")) {
            dto = new Plants.Plant();
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
            boolean success = dao.insert(dto);
            if (success) {
                count++;
            }
        }
        this.current = "";
    }

    public int getCount() {
        return count;
    }
}
