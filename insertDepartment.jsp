<%-- 
    Document   : insertDepartment
    Created on : 4 Sept 2026, 5:42:53 pm
    Author     : risha
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%
    if (session.getAttribute("users") == null || !"Admin".equalsIgnoreCase((String)session.getAttribute("empRole"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    String deptId = request.getParameter("dept_id");
    String deptName = request.getParameter("dept_name");

    if (deptId == null || deptName == null || deptId.trim().isEmpty() || deptName.trim().isEmpty()) {
        response.sendRedirect("addDepartment.jsp?error=1");
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
        
            pstmt = conn.prepareStatement("INSERT INTO department (dept_id, dept_name) VALUES (?, ?)");
            pstmt.setString(1, deptId.trim().toUpperCase());
            pstmt.setString(2, deptName.trim());
            
            int rowsInserted = pstmt.executeUpdate();
            
            if (rowsInserted > 0) {
                 response.sendRedirect("department.jsp");
                } else {
                    response.sendRedirect("addDepartment.jsp?error=1");
                }
               } catch (Exception e) {
                   
                   e.printStackTrace();
                   response.sendRedirect("addDepartment.jsp?error=1");
                   
               }finally {
                    if (pstmt != null) try { pstmt.close(); } catch(Exception e) {}
                    if (conn != null) try { conn.close(); } catch(Exception e) {}
                }
        %>
    </body>
</html>
