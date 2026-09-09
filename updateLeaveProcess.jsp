<%-- 
    Document   : updateLeaveProcess
    Created on : 6 Sept 2026, 9:56:27 pm
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

    String leaveIdStr = request.getParameter("leave_id");
    String actionParam = request.getParameter("action"); 

    if(leaveIdStr == null || actionParam == null || leaveIdStr.trim().isEmpty() || actionParam.trim().isEmpty()) {
        response.sendRedirect("manageLeaves.jsp");
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
                String targetAction = actionParam.trim();
                String targetLeaveId = leaveIdStr.trim();

            Connection conn = null;
            PreparedStatement pstmt = null;

            try {
                Class.forName("oracle.jdbc.driver.OracleDriver");
                conn = DriverManager.getConnection("jdbc:oracle:thin:@LAPTOP-VK8PMP4T:1521:XE", "system", "password");

                String sql = "UPDATE leave_applications SET status = ? WHERE leave_id = ?";

                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, targetAction);
                pstmt.setInt(2, Integer.parseInt(targetLeaveId));

                int rowsUpdated = pstmt.executeUpdate();

                if(rowsUpdated > 0) {
                    response.sendRedirect("manageLeaves.jsp?msg=processed");
                } else {
                    response.sendRedirect("manageLeaves.jsp?msg=error");
                }

            } catch(Exception e) {
                e.printStackTrace();
                response.sendRedirect("manageLeaves.jsp?msg=error");
            } finally {
                if(pstmt != null) try { pstmt.close(); } catch(Exception e){}
                if(conn != null) try { conn.close(); } catch(Exception e){}
            }
        %>
    </body>
</html>
