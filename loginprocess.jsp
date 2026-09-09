<%-- 
    Document   : loginprocess.jsp
    Created on : 1 Sept 2026, 6:43:18 pm
    Author     : risha
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>      
    </head>
    <body>
        <%
        String user = request.getParameter("username");
        String pass = request.getParameter("password");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@LAPTOP-VK8PMP4T:1521:XE", "system", "password");
        
        pstmt = conn.prepareStatement("SELECT emp_id, emp_name, role FROM employees WHERE username = ? AND password = ?");
        pstmt.setString(1, user);
        pstmt.setString(2, pass);
        
        rs = pstmt.executeQuery();
        
        if (rs.next()) {
            session.setAttribute("users", user);
            session.setAttribute("empId", rs.getString("emp_id"));
            session.setAttribute("empName", rs.getString("emp_name"));
            session.setAttribute("empRole", rs.getString("role"));
            
            response.sendRedirect("dashboard.jsp");
        } else {
            request.setAttribute("errorMessage", "Invalid Username or Password.");
            RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
            rd.forward(request, response);
        }
    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("errorMessage", "Database Connection Error: " + e.getMessage());
        RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
        rd.forward(request, response);
    } finally {
        // Enforce cleanup routines on resources explicitly to prevent server connection leaks
        if (rs != null) try { rs.close(); } catch(SQLException e){}
        if (pstmt != null) try { pstmt.close(); } catch(SQLException e){}
        if (conn != null) try { conn.close(); } catch(SQLException e){}
    }
        %>
    </body>
</html>
