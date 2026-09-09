<%-- 
    Document   : DeleteDeptController
    Created on : 4 Sept 2026, 7:40:04 pm
    Author     : risha
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%
    if (session.getAttribute("users") == null || !"Admin".equalsIgnoreCase((String)session.getAttribute("empRole"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String targetDeptId = request.getParameter("id");

    if (targetDeptId == null || targetDeptId.trim().isEmpty()) {
        response.sendRedirect("department.jsp?error=missing_id");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%
            Connection conn = null;
            PreparedStatement pstmt = null;
            
            
            try {
                Class.forName("oracle.jdbc.driver.OracleDriver");
                conn = DriverManager.getConnection("jdbc:oracle:thin:@LAPTOP-VK8PMP4T:1521:XE", "system", "password");
       
                pstmt = conn.prepareStatement("DELETE FROM department WHERE dept_id = ?");
                pstmt.setString(1, targetDeptId.trim());
                
                int rowsDeleted = pstmt.executeUpdate();
                
                if (rowsDeleted > 0) {
                     response.sendRedirect("department.jsp");
                 } else {
                     response.sendRedirect("department.jsp?error=not_found");
                }
                
                } catch (Exception e) {      
                        e.printStackTrace();
                        response.sendRedirect("department.jsp?error=delete_failed");
                    } finally {
                        if (pstmt != null) try { pstmt.close(); } catch(Exception e) {}
                        if (conn != null) try { conn.close(); } catch(Exception e) {}
                    }
        %>
    </body>
</html>
