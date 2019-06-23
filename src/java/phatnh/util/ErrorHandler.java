/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package phatnh.util;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.nio.charset.StandardCharsets;
import java.util.Date;
import java.util.Scanner;
import phatnh.listener.FlowerServletListener;

/**
 *
 * @author nguyenhongphat0
 */
public class ErrorHandler {
    
    public static String getLogPath() {
        return FlowerServletListener.context.getRealPath("/WEB-INF/logs");
    }
    
    public static void log(String s) {
        try {
            FileOutputStream fos = new FileOutputStream(getLogPath(), true);
            OutputStreamWriter osw = new OutputStreamWriter(fos, StandardCharsets.UTF_8);
            osw.write(s + "\r\n");
            osw.close();
            fos.close();
        } catch (Exception e) {
            System.out.println("Không thể ghi vào file log. Vui lòng kiểm tra lại quyền của thư mục chứa logs");
        }
    }
    
    public static void clear() {
        try {
            FileOutputStream fos = new FileOutputStream(getLogPath());
            fos.close();
        } catch (Exception e) {
            System.out.println("Không thể dọn dẹp logs. Vui lòng kiểm tra lại quyền của thư mục chứa logs");
        }
    }
    
    public static String fetch() {
        try {
            String s = "";
            File logs = new File(getLogPath());
            try (Scanner sc = new Scanner(logs, "UTF-8")) {
                while (sc.hasNext()) {
                    s += sc.nextLine() + "\r\n";
                }
            }
            return s;
        } catch (Exception e) {
            log("File logs không tồn tại. File sẽ được tạo mới");
            return "";
        }
    }
    
    public static void handle(Exception e) {
        StackTraceElement ste = null;
        for (StackTraceElement el : e.getStackTrace()) {
            if (el.getClassName().startsWith("phatnh")) {
                ste = el;
                break;
            }
        }
        String message = "[" + new Date() + "]" + " Lỗi tại lớp " + ste.getClassName() + ", dòng thứ " + ste.getLineNumber()+ " của file " + ste.getFileName()+ ", phương thức: " + ste.getMethodName() + ". ";
        if (e.getMessage() != null) {
            message += "Thông tin thêm: " + e.getMessage();
        }
        log(message);
    }
}
