/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package phatnh.algorithm;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.naming.NamingException;
import phatnh.builder.QueryBuilder;
import phatnh.dao.CategoryDAO;
import phatnh.dao.PlantDAO;
import phatnh.util.ErrorHandler;

/**
 *
 * @author nguyenhongphat0
 */
public class Categorize {
    
    public static int categorize(int max) {
        try {
            List<String> names = new PlantDAO().fetchNames();
            List<String> words = hashName(names, max);
            Map<String, Integer> token = group(names, words);
            CategoryDAO dao = new CategoryDAO();
            dao.clearCategories();
            return dao.insertCategories(token);
        } catch (NamingException | SQLException ex) {
            ErrorHandler.handle(ex);
            return 0;
        }
    }
    
    public static List<String> splitWords(String s, int n) {
        String[] words = s.split(" ");
        List<String> pairs = new ArrayList<>();
        for (int i = 0; i <= words.length - n; i++) {
            String word = words[i];
            for (int j = i + 1; j < i + n; j++) {
                word += " " + words[j];
            }
            pairs.add(word);
        }
        return pairs;
    }
    
    public static List<String> hashName(List<String> names, int maxWord) {
        List<String> list = new ArrayList<>();
        for (int i = 1; i <= maxWord; i++) {
            for (String name : names) {
                List<String> words = splitWords(name, i);
                for (String word : words) {
                    if (!list.contains(word)) {
                        list.add(word);
                    }
                }
            }
        }
        return list;
    }
    
    public static Map<String, Integer> group(List<String> names, List<String> words) {
        Map<String, Integer> token = new HashMap<>();
        for (String word : words) {
            for (String name : names) {
                if (name.contains(word)) {
                    if (token.containsKey(word)) {
                        int count = token.get(word);
                        token.put(word, ++count);
                    } else {
                        token.put(word, 1);
                    }
                }
            }
        }
        return token;
    }
}
