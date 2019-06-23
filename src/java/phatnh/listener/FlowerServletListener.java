/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package phatnh.listener;

import java.util.Date;
import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import phatnh.util.ErrorHandler;

/**
 * Web application lifecycle listener.
 *
 * @author nguyenhongphat0
 */
public class FlowerServletListener implements ServletContextListener {
    public static ServletContext context;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        context = sce.getServletContext();
        ErrorHandler.log("Hệ thống khởi chạy vào lúc " + new Date());
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        ErrorHandler.log("Hệ thống tắt vào lúc " + new Date());
    }
}
