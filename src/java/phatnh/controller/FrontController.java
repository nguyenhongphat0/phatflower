/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package phatnh.controller;

import java.io.IOException;
import java.sql.SQLException;
import javax.naming.NamingException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import phatnh.dao.AnalyticDAO;
import phatnh.util.ErrorHandler;

/**
 *
 * @author nguyenhongphat0
 */
@WebServlet(name = "FrontController", urlPatterns = {"/FrontController"})
public class FrontController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String url = "/";
        try {
            String action = request.getParameter("action");
            switch (action) {
                case "admin":
                    url = "AdminController";
                    break;
                case "list":
                    url = "ViewListController";
                    break;
                case "detail":
                    url = "ViewDetailController";
                    break;
                case "search":
                    url = "SearchController";
                    break;
                case "exportPDF":
                    url = "ExportPDFController";
                    break;
            }
            recordAnalytic(request, response);
        } catch (Exception e) {
            ErrorHandler.handle(e);
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
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

    private void recordAnalytic(HttpServletRequest request, HttpServletResponse response) throws NamingException, SQLException {
        String action = request.getParameter("action");
        String product = "null";
        if (action.equals("detail")) {
            product = request.getParameter("id");
        }
        String userAgent = request.getHeader("User-Agent");
        String pageUrl = request.getQueryString();
        new AnalyticDAO().record(product, userAgent, pageUrl);
    }

}
