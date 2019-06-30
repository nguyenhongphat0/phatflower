/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package phatnh.controller;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.StringReader;
import java.io.StringWriter;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.Marshaller;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.sax.SAXResult;
import javax.xml.transform.stream.StreamSource;
import org.apache.fop.apps.FOPException;
import org.apache.fop.apps.FOUserAgent;
import org.apache.fop.apps.Fop;
import org.apache.fop.apps.FopFactory;
import org.apache.fop.apps.MimeConstants;
import org.xml.sax.SAXException;
import phatnh.dao.PlantDAO;
import phatnh.model.Plants;
import phatnh.util.ErrorHandler;
import phatnh.util.XSLTransform;

/**
 *
 * @author nguyenhongphat0
 */
@WebServlet(name = "ExportPDFController", urlPatterns = {"/ExportPDFController"})
public class ExportPDFController extends HttpServlet {

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
        try {
            String ids = request.getParameter("ids");
            PlantDAO dao = new PlantDAO();
            dao.findAll(ids);
            
            JAXBContext jc = JAXBContext.newInstance(Plants.class);
            Marshaller ms = jc.createMarshaller();
            StringWriter sw = new StringWriter();
            ms.marshal(dao.getPlants(), sw);
            
            String fo = XSLTransform.transformWithParams(getResourcePath("/WEB-INF/xsl/fo.xsl"), sw.toString(), new XSLTransform.CustomizeTransformerCallback() {
                @Override
                public void customize(Transformer trans) {
                    trans.setParameter("now", new Date().toString());
                    trans.setParameter("root", getResourcePath(""));
                }
            });
            exportPDF(fo, request, response);
        } catch (Exception e) {
            ErrorHandler.handle(e);
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

    private String getResourcePath(String path) {
        String realPath = getServletContext().getRealPath("/");
        return realPath + path;
    }

    private void exportPDF(String fo, HttpServletRequest request, HttpServletResponse response) throws FOPException, IOException, TransformerException, SAXException {
        response.setContentType("application/pdf;charset=UTF-8");
        OutputStream out = response.getOutputStream();
        FopFactory ff = FopFactory.newInstance();
        ff.setUserConfig(getResourcePath("/WEB-INF/xml/fop-config.xml"));
        FOUserAgent fua = ff.newFOUserAgent();
        Fop fop = ff.newFop(MimeConstants.MIME_PDF, fua, out);
        
        TransformerFactory tff = TransformerFactory.newInstance();
        Transformer trans = tff.newTransformer();
        StringReader reader = new StringReader(fo);
        StreamSource source = new StreamSource(reader);
        SAXResult result = new SAXResult(fop.getDefaultHandler());
        trans.transform(source, result);
    }

}
