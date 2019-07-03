/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package phatnh.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import phatnh.builder.RequestBuilder;
import phatnh.dao.PlantDAO;
import phatnh.model.Plant;
import phatnh.util.ErrorHandler;

/**
 *
 * @author nguyenhongphat0
 */
@WebServlet(name = "ViewDetailController", urlPatterns = {"/ViewDetailController"})
public class ViewDetailController extends HttpServlet {

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
        response.setContentType("text/html;charset=UTF-8");
        String id = request.getParameter("id");
        String quickview = request.getParameter("quickview");
        try {
            PlantDAO dao = new PlantDAO();
            Plant plant = dao.find(id);
            request.setAttribute("plant", plant);
            
            String domain = dao.getDomain(plant);
            request.setAttribute("domain", domain);
            
            if (quickview == null) {
                dao.findSimilar(plant.getName());
            }
            request.setAttribute("dao", dao);
            
            String content = dao.fetchContent(id);
            if (content.equals("")) {
                String html = new RequestBuilder(plant.getLink())
                        .go()
                        .match("<body[\\s\\S]*?>[\\s\\S]*?<\\/body>")
                        .clean("<script[\\s\\S]*?>[\\s\\S]*?<\\/script>")
                        .toString();
                request.setAttribute("html", html);
            } else {
                request.setAttribute("content", content);
            }
        } catch (Exception e) {
            ErrorHandler.handle(e);
        } finally {
            request.getRequestDispatcher("detail.jsp").forward(request, response);
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

}
