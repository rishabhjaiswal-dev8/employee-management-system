<%-- 
    Document   : updateSalaryProcess
    Created on : 6 Sept 2026, 8:32:10 pm
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

    String empId = request.getParameter("emp_id");
    String basicStr = request.getParameter("basic_salary");
    String allowanceStr = request.getParameter("allowance");
    String deductionsStr = request.getParameter("deductions");

    if(empId != null) {
        empId = empId.trim();
    } else {
        response.sendRedirect("manageSalary.jsp?msg=error");
        return;
    }

    double basicSalary = 0.00;
    double allowance = 0.00;
    double deductions = 0.00;

    try {
        if(basicStr != null) basicSalary = Double.parseDouble(basicStr);
        if(allowanceStr != null) allowance = Double.parseDouble(allowanceStr);
        if(deductionsStr != null) deductions = Double.parseDouble(deductionsStr);
    } catch(NumberFormatException e) {
        e.printStackTrace();
        response.sendRedirect("manageSalary.jsp?msg=error");
        return;
    }
    

    double netSalary = basicSalary + allowance - deductions;

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@LAPTOP-VK8PMP4T:1521:XE", "system", "password");
        
        String mergeSql = "MERGE INTO salary_ledger target " +
                          "USING (SELECT ? as emp_id FROM dual) src " +
                          "ON (target.emp_id = src.emp_id) " +
                          "WHEN MATCHED THEN " +
                          "  UPDATE SET target.basic_salary = ?, target.allowance = ?, target.deductions = ?, target.net_salary = ? " +
                          "WHEN NOT MATCHED THEN " +
                          "  INSERT (emp_id, basic_salary, allowance, deductions, net_salary) VALUES (?, ?, ?, ?, ?)";

        pstmt = conn.prepareStatement(mergeSql);
        
        pstmt.setString(1, empId);
        
        pstmt.setDouble(2, basicSalary);
        pstmt.setDouble(3, allowance);
        pstmt.setDouble(4, deductions);
        pstmt.setDouble(5, netSalary);
        
        pstmt.setString(6, empId);
        pstmt.setDouble(7, basicSalary);
        pstmt.setDouble(8, allowance);
        pstmt.setDouble(9, deductions);
        pstmt.setDouble(10, netSalary);
        
        int rowsAffected = pstmt.executeUpdate();
        
        if(rowsAffected > 0) {
            response.sendRedirect("manageSalary.jsp?msg=updated");
        } else {
            response.sendRedirect("manageSalary.jsp?msg=error");
        }
        
    } catch(Exception e) {
        e.printStackTrace();
        response.sendRedirect("manageSalary.jsp?msg=error");
    } finally {
        if(pstmt != null) try { pstmt.close(); } catch(Exception e){}
        if(conn != null) try { conn.close(); } catch(Exception e){}
    }
%>