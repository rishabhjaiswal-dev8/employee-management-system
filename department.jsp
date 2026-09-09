<%-- 
    Document   : department
    Created on : 4 Sept 2026, 2:42:04 pm
    Author     : risha
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%     
     response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
    response.setHeader("Pragma", "no-cache"); // HTTP 1.0
    response.setDateHeader("Expires", 0);
    
    if(session.getAttribute("users") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
        
    String username = (String) session.getAttribute("users");
    String empName = (String) session.getAttribute("empName");
    String empRole = (String) session.getAttribute("empRole");
    
    if(empName == null) empName = username;
    if(empRole == null) empRole = "Employee";

    if(!"Admin".equalsIgnoreCase(empRole)) {
        response.sendRedirect("dashboard.jsp"); 
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <style>
            .container {
                width: 1215px;
                height: 800px;
                background-color: #E7E7E7; 
                box-shadow: 0 0 10px rgba(0,0,0,0);
                padding: 20px;
                margin: auto;
            }
            .header {
                background-color: #01796F;
                width: 1215px;
                height: 55px;
                box-shadow: 0 0 10px rgba(0,0,0,0.5);
            }
            .header p {
                font-size: 28px;
                margin: 10px 0 0 35px;
                font-family: Bradley Hand ITC;
                font-weight: bold;
                color: white;
                float: left;
            }
            .user-wrapper {
                position: absolute;
                margin: 18.5px 0 0 240px;
                z-index: 5;
            }
            .user-tag { 
                background-color: #4C7E80;
                box-shadow: 0 0 10px rgba(0,0,0,0.3);
                padding: 18.5px 22px;
                border-radius: 2px;
                text-decoration: none;
                color: whitesmoke;
                font-family: Arial, sans-serif; 
                font-size: 16px; 
                white-space: nowrap;
            }
            .user-tag i {
                margin: 0 8px 0 0;
            }
            .user-tag:hover {
                background-color: #4f6363;
                transition-duration:  0.4s;
            }
            .logout {
                background-color: #4C7E80;
                box-shadow: 0 0 10px rgba(0,0,0,0.3);
                padding: 14px 15px;
                border-radius: 2px;
                text-decoration: none;
                color: whitesmoke;
                margin: 4.5px 0 0 896.5px;
                float: left;
            }
            .logout i {
                transition: transform 0.3s ease;
                margin: 0 10px 0 0;
            }
            .logout:hover i {
                transform: scale(1.1) translateX(2px);
            }
            .logout:hover {
                background-color: #4f6363;
                transition-duration:  0.5s; 
            }
            .sub {               
                width: 1215px;
                height: 680px;
            }
            .detail {
                background-color: #2E3135;
                width: 240px;
                height: 680px;
                float: left;
            }
            .page {
                background-image: url('image/bg5.avif');
                background-size: cover;
                background-repeat: no-repeat;
                background-position: center;
                width: 975px;
                height: 680px;
                float: left;
            }
            .dept-menu-bar {
                background-color: #FFFFFF;
                padding: 12px 20px;
                border-radius: 4px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
                margin-bottom: 20px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .dept-menu-bar h2 {
                margin: 0;
                font-size: 22px;
                color: #2E3135;
                font-family: 'Segoe UI', sans-serif;
            }
            .add-dept-btn {
                background-color: #01796F;
                color: white;
                text-decoration: none;
                padding: 8px 16px;
                border-radius: 4px;
                font-weight: bold;
                font-size: 14px;
                transition: background 0.3s;
            }
            .add-dept-btn:hover {
                background-color: #4C7E80;
            }
            .dept-table {
                width: 98%;
                margin-left: 10px;
                border-collapse: collapse;
                background-color: white;
                box-shadow: 0 2px 5px rgba(0,0,0,0.5);
                border-radius: 4px;
                overflow: hidden;
            }
            .dept-table th, .dept-table td {
                padding: 12px 15px;
                text-align: left;
                font-family: 'Segoe UI', sans-serif;
            }
            .dept-table th {
                background-color: #2E3135;
                color: white;
                font-weight: 600;
                font-size: 15px;
            }
            .dept-table tr {
                border-bottom: 1px solid #E7E7E7;
            }
            .dept-table tr:last-child {
                border-bottom: none;
            }
            .dept-table tr:hover {
                background-color: #F9F9F9;
            }
            ul {
                list-style-type: none;
                margin: 20px 16px;
                padding: 0;
                border-radius: 4px;
                width: 210px;
                background-color: #2E3135;
            }
            li a {
                display: block;
                color: whitesmoke;
                font-size: 17.5px;
                padding: 14px 22px;
                text-align: center;
                border-radius: 3px;
                text-decoration: none;
            }
            li a i {
                transition: transform 0.3s ease;
                float:left;
            }
            li a:hover i {
                  transform: scale(1.2) translateX(4px); 
            }
            li a:hover {
                background-color: #01796F;
                transition-duration:  0.4s;
                color: white;
            }
            .action-btn {
                text-decoration: none;
                padding: 6px 12px;
                border-radius: 3px;
                font-size: 14px;
                color: white;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                transition: background-color 0.2s ease;
            }
            .btn-edit { 
                background-color: #4C7E80; 
                margin-right: 5px;
            }
            .btn-edit:hover { 
                background-color: #3d6567; 
            }
            .btn-delete { 
                background-color: #e74c3c; 
            }
            .btn-delete:hover { 
                background-color: #c0392b; 
            }
            .error-msg { 
                color: #e74c3c; 
                font-weight: bold; 
                font-family: monospace;
            }
            .footer {
              box-shadow: 0 0 10px rgba(0,0,0,0.5);  
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <p>Employee MS</p>
                <div class="user-wrapper">
                <a href="index.html" class="user-tag"><i class="fa fa-home"></i>Home</a>
                </div>
                <a href="logout.jsp" class="logout"><i class="fa fa-sign-out"></i>Logout</a>
            </div>
            <div class="sub">
                <div class="detail">
                    <ul>
                        <li><a href="dashboard.jsp"><i class="fa-solid fa-grip"></i>Dashboard</a></li>
                        
                        <% if("Admin".equalsIgnoreCase(empRole)) { %>
                        <li><a href="viewEmployees.jsp"><i class="fa-solid fa-user-tie"></i>Employee</a></li>
                        <li><a href="department.jsp"><i class="fa-solid fa-laptop-code"></i>Department</a></li>
                        <li><a href="manageSalary.jsp"><i class="fa-solid fa-money-check-dollar"></i>Manage Salaries</a></li>
                        
                        <% } else { %>
                        <li><a href="viewMyProfile.jsp"><i class="fa-solid fa-user"></i>My Profile</a></li>
                        <li><a href="viewMySalary.jsp"><i class="fa-solid fa-wallet"></i>My Salary slips</a></li>
                        <% } %>
                        <li><a href="manageLeaves.jsp"><i class="fa-solid fa-calendar-minus"></i>Leave</a></li>
                        <li><a href=""><i class="fa-solid fa-gear"></i>Setting</a></li>
                    </ul>
                </div>
                <div class="page">
                    <div class="dept-menu-bar">
                        <h2><i class="fa-solid fa-building-user" style="color: #01796F; margin-right: 8px;"></i> Department Registry</h2>
                        <a href="addDepartment.jsp" class="add-dept-btn"><i class="fa-solid fa-plus"></i> Add Department</a>
                    </div>
                    
                    <table class="dept-table">
                        <thead>
                            <tr>
                                <th style="width: 15%;">Dept ID</th>
                                <th style="width: 40%; text-align:center;">Department Name</th>
                                <th style="width: 25%; text-align:center;">Total Employees</th>
                                <th style="width: 20%; text-align:center;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                Connection conn = null;
                                PreparedStatement pstmt = null;
                                ResultSet rs = null;
                                
                                try {
                                        Class.forName("oracle.jdbc.driver.OracleDriver");
                                        conn = DriverManager.getConnection("jdbc:oracle:thin:@LAPTOP-VK8PMP4T:1521:XE", "system", "password");

                                        pstmt = conn.prepareStatement("SELECT d.dept_id, d.dept_name, COUNT(e.emp_id) AS active_count " +
                                                                        "FROM department d " +
                                                                        "LEFT JOIN employees e ON d.dept_id = e.dept_id " +
                                                                        "GROUP BY d.dept_id, d.dept_name " +
                                                                        "ORDER BY d.dept_id ASC");
                                        rs = pstmt.executeQuery();
                                        boolean hasData = false;
                                        while(rs.next()) {
                                            hasData = true;
                                            String deptId = rs.getString("dept_id");
                                            String deptName = rs.getString("dept_name");
                                            int totalEmp = rs.getInt("active_count");
                            %>
                            <tr>
                                <td><strong><%= deptId %></strong></td>
                                <td style="text-align: center;"> <%= deptName %></td>
                                <td style="text-align: center;"><%= totalEmp %></td>
                                <td style="text-align: center;">
                                    <a href="editDepartment.jsp?id=<%= deptId %>" class="action-btn btn-edit" title="Edit Structure"><i class="fa-solid fa-pen-to-square"></i></a>
                                    <a href="DeleteDeptController.jsp?id=<%= deptId %>" class="action-btn btn-delete" title="Remove Record" onclick="return confirm('Warning: Deleting this department might disconnect linked employees. Proceed?')"><i class="fa-solid fa-trash-can"></i></a>
                                </td>
                            <%}if(!hasData) {%>
                                 <tr>
                                        <td colspan="4" style="text-align: center; color: #7f8c8d; padding: 30px;">No operational department records configured inside Oracle.</td>
                                 </tr>
                            <%
                                }
                                } catch(Exception e) {
                            %>
                            <tr>
                                <td colspan="4" class="error-msg" style="padding: 20px;">Oracle Core Connection Exception: <%= e.getMessage() %></td>
                            </tr>
                        
                            <%
                                } finally {
                                if(rs != null) try { rs.close(); } catch(Exception e){}
                                if(pstmt != null) try { pstmt.close(); } catch(Exception e){}
                                if(conn != null) try { conn.close(); } catch(Exception e){}
                                }
                            %>
                           </tbody>
                    </table><!-- comment -->
                </div>
            </div><!-- comment -->
        </div>

    </body>
</html>
