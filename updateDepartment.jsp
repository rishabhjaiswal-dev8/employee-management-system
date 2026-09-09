<%-- 
    Document   : updateDepartment
    Created on : 4 Sept 2026, 6:43:42 pm
    Author     : risha
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%
    if (session.getAttribute("users") == null || !"Admin".equalsIgnoreCase((String)session.getAttribute("empRole"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    String deptId = request.getParameter("id");
    String deptName = request.getParameter("dept_name");

    if (deptId == null || deptName == null || deptName.trim().isEmpty()) {
        response.sendRedirect("department.jsp");
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

                pstmt = conn.prepareStatement("UPDATE department SET dept_name = ? WHERE dept_id = ?");
                pstmt.setString(1, deptName.trim());
                pstmt.setString(2, deptId.trim());

                int rows = pstmt.executeUpdate();
                
                if(rows > 0) {
                    conn.commit();
                response.sendRedirect("department.jsp");
                 } else {
            response.sendRedirect("department.jsp?error=no_match");
                }
            } catch (Exception e) {
                if(conn != null) try { conn.rollback(); } catch(Exception ex){} // Rollback on failure
        e.printStackTrace();
        response.sendRedirect("department.jsp?error=failed");
            } finally {
                if (pstmt != null) try { pstmt.close(); } catch(Exception e) {}
                if (conn != null) try { conn.close(); } catch(Exception e) {}
            }
        %>
    </body>
</html>
