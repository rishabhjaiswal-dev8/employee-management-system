<%-- 
    Document   : insertEmployee
    Created on : 3 Sept 2026, 5:37:34 pm
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
            String empId = request.getParameter("emp_id");
            String empName = request.getParameter("emp_name");
            String uname = request.getParameter("username");
            String pass = request.getParameter("password");
            String role = request.getParameter("role");
            String assignedDeptId = request.getParameter("employeeDept");
           
             Connection conn = null;
             PreparedStatement pstmt = null;
             
          try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection("jdbc:oracle:thin:@LAPTOP-VK8PMP4T:1521:XE", "system", "password");
        
            pstmt = conn.prepareStatement("INSERT INTO employees (emp_id, emp_name, username, password, role, dept_id) VALUES (?, ?, ?, ?, ?,?)");
            pstmt.setString(1, empId);
            pstmt.setString(2, empName);
            pstmt.setString(3, uname);
            pstmt.setString(4, pass);
            pstmt.setString(5, role);
            pstmt.setString(6, assignedDeptId);
        
            int rows = pstmt.executeUpdate();
        
           if(rows > 0) { 
                response.sendRedirect("viewEmployees.jsp");
        } else {
            response.sendRedirect("addEmployee.jsp?error=1");
        }
    } catch(Exception e) {
        e.printStackTrace();
        response.sendRedirect("addEmployee.jsp?error=1");
    } finally {
        if(pstmt != null) try { pstmt.close(); } catch(Exception e){}
        if(conn != null) try { conn.close(); } catch(Exception e){}
          }
        %>
    </body>
</html>
