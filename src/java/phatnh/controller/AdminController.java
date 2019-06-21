/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package phatnh.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import javax.naming.NamingException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;
import phatnh.algorithm.Categorize;
import phatnh.dao.CategoryDAO;
import phatnh.model.Categories;
import phatnh.util.ErrorHandler;
import phatnh.util.FlowerCrawler;

/**
 *
 * @author nguyenhongphat0
 */
@WebServlet(name = "AdminController", urlPatterns = {"/AdminController"})
public class AdminController extends HttpServlet {
    PrintWriter out;
    CategoryDAO dao = new CategoryDAO();

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) {
        try {
            response.setContentType("text/xml;charset=UTF-8");
            out = response.getWriter();
            String task = request.getParameter("task");
            switch (task) {
                case "crawl":
                    crawl(request, response);
                    break;
                case "categorize":
                    categorize(request, response);
                    break;
                case "fetchCategories":
                    fetchCategories(request, response);
                    break;
                case "updateCategory":
                    updateCategory(request, response);
                    break;
            }
        } catch (NamingException | SQLException | JAXBException | IOException ex) {
            ErrorHandler.handle(ex);
        }
        
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    private void crawl(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String url = request.getParameter("url") + "/";
        if (url.startsWith("http://")) {
            url = url.replaceFirst("http://", "");
        }
        if (!url.startsWith("https://")) {
            url = "https://" + url;
        }
        try {
            FlowerCrawler fc = new FlowerCrawler(getServletContext(), url);
            int count = fc.crawl();
            out.print(count);
        } catch (Exception e) {
            ErrorHandler.handle(e);
            out.print(-2); // 404, etc,...
        }        
    }

    private void categorize(HttpServletRequest request, HttpServletResponse response) throws NamingException, SQLException, JAXBException {
        int max = Integer.parseInt(request.getParameter("max"));
        int count = Categorize.categorize(max);
        generateXML();
        out.println("Phân loại xong. Đã thêm " + count + " phân loại mới");
    }
    
    private void fetchCategories(HttpServletRequest request, HttpServletResponse response) throws NamingException, SQLException, JAXBException, IOException {
        dao.all();
        JAXBContext jc = JAXBContext.newInstance(Categories.class);
        Marshaller ms = jc.createMarshaller();
        StringWriter writer = new StringWriter();
        ms.marshal(dao.getCategories(), writer);
        String xml = writer.toString();
        out.print(xml);
    }
    
    private void updateCategory(HttpServletRequest request, HttpServletResponse response) throws NamingException, SQLException, JAXBException {
        String id = request.getParameter("id");
        String field = request.getParameter("field");
        String value = request.getParameter("value");
        CategoryDAO dao = new CategoryDAO();
        dao.update(id, field, value);
        generateXML();
        out.print("Lưu thông tin thành công");
    }
    
    private void generateXML() throws NamingException, SQLException, JAXBException {
        dao.all();
        String path = getServletContext().getRealPath("/WEB-INF/xml/categories.xml");
        JAXBContext jc = JAXBContext.newInstance(Categories.class);
        Marshaller ms = jc.createMarshaller();
        ms.marshal(dao.getCategories(), new File(path));
    }
}
