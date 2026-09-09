<%-- 
    Document   : updateDeleteHandler
    Created on : 3 Sept 2026, 6:18:33 pm
    Author     : risha
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%
    String empRole = (String) session.getAttribute("empRole");
    if(session.getAttribute("users") == null || !"Admin".equalsIgnoreCase(empRole)) {
        response.sendRedirect("login.jsp");
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
              String action = request.getParameter("action");
              String empId = request.getParameter("emp_id");
        
              Connection conn = null;
             PreparedStatement pstmt = null;
             
              try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@LAPTOP-VK8PMP4T:1521:XE", "system", "password");

        if("delete".equalsIgnoreCase(action)) {
            // SQL Delete Operation
            pstmt = conn.prepareStatement("DELETE FROM employees WHERE emp_id = ?");
            pstmt.setString(1, empId);
            pstmt.executeUpdate();
            
        } else if("update".equalsIgnoreCase(action)) {
            // Capture Form Input Strings
            String empName = request.getParameter("emp_name");
            String uname = request.getParameter("username");
            String pass = request.getParameter("password");
            String role = request.getParameter("role");

            // SQL Update Operation
            pstmt = conn.prepareStatement("UPDATE employees SET emp_name = ?, username = ?, password = ?, role = ? WHERE emp_id = ?");
            pstmt.setString(1, empName);
            pstmt.setString(2, uname);
            pstmt.setString(3, pass);
            pstmt.setString(4, role);
            pstmt.setString(5, empId);
            pstmt.executeUpdate();
        }
        
        // Return cleanly to directory panel upon execution success
        response.sendRedirect("viewEmployees.jsp");

    } catch(Exception e) {
        e.printStackTrace();
        response.sendRedirect("viewEmployees.jsp?error=database");
    } finally {
        if(pstmt != null) try { pstmt.close(); } catch(Exception e){}
        if(conn != null) try { conn.close(); } catch(Exception e){}
    }
%>
    </body>
</html>
