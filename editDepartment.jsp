<%-- 
    Document   : editDepartment
    Created on : 4 Sept 2026, 6:03:52 pm
    Author     : risha
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%   
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
            .dept-action-bar {
                background-color: #FFFFFF;
                padding: 15px 25px;
                border-radius: 4px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
                margin-bottom: 25px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }
            .dept-action-bar .left-section h2 {
                margin: 0;
                font-size: 22px;
                color: #2E3135;
                font-weight: bold;
            }
            .dept-action-bar .left-section p {
                margin: 4px 0 0 0;
                font-size: 13px;
                color: #7f8c8d;
            }
            .dept-action-bar .right-section {
                display: flex;
                gap: 10px;
            }
            .back-btn { 
                text-decoration: none; 
                padding: 10px 18px; 
                border-radius: 4px; 
                font-size: 14px; 
                font-weight: 600; 
                background-color: #2E3135; 
                color: white; 
                display:inline-flex; 
                align-items: center; 
                gap: 8px; 
            }
            .form-container {
                background-color: #eee;
                padding: 50px;
                margin: 60px 180px;
                border-radius: 8px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.8);
                max-width: 600px;
                font-family: 'Segoe UI', sans-serif;
            }
            .form-group {
                margin-bottom: 22px;
            }
            .form-group label {
                display: block;
                font-size: 15px;
                font-weight: 600;
                color: #2E3135;
                margin-bottom: 8px;
            }
            .form-group input[type="text"] {
                width: 100%;
                padding: 10px 14px;
                border: 1px solid #ccc;
                border-radius: 4px;
                font-size: 14px;
                box-sizing: border-box;
                transition: border-color 0.3s;
            }
            .form-group input[type="text"]:focus {
                border-color: #01796F;
                outline: none;
            }
            .form-actions {
                display: flex;
                gap: 12px;
                margin-top: 30px;
            }
            .submit-btn {
                background-color: #01796F;
                color: white;
                border: none;
                padding: 12px 24px;
                border-radius: 4px;
                font-size: 15px;
                font-weight: bold;
                cursor: pointer;
                transition: background 0.3s;
                display: inline-flex;
                align-items: center;
                gap: 8px;
            }
            .submit-btn:hover {
                background-color: #015e56;
            }
            .footer {
              box-shadow: 0 0 10px rgba(0,0,0,0.5);  
            }
        </style>
    </head>
    <body>
        <%
           String deptId = request.getParameter("id");
           String deptName = ""; 
        
            Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@LAPTOP-VK8PMP4T:1521:XE", "system", "password");
        
        pstmt = conn.prepareStatement("SELECT dept_id, dept_name FROM department WHERE dept_id = ?");
        pstmt.setString(1, deptId);
        rs = pstmt.executeQuery();
        
        if(rs.next()) {
            deptName = rs.getString("dept_name");
        } else {
            response.sendRedirect("editDepartment.jsp?error=notfound");
            return;
        }
    } catch(Exception e) {
        e.printStackTrace();
    } finally {
        if(rs != null) try { rs.close(); } catch(Exception e){}
        if(pstmt != null) try { pstmt.close(); } catch(Exception e){}
        if(conn != null) try { conn.close(); } catch(Exception e){}
    }
%>
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
                    <div class="dept-action-bar">
                        <div class="left-section">
                            <h2><i class="fa-solid fa-pen-to-square"></i> Modify Department</h2>
                            <p>Update configuration mappings for active workforce segments.</p>
                        </div>
                        <div class="right-section">
                            <a href="department.jsp" class="back-btn"><i class="fa-solid fa-arrow-left"></i> Cancel and Return</a>
                        </div>
                    </div>
                    <div class="form-container">
                        <form action="updateDepartment.jsp" method="POST">
                            <div class="form-group">
                                <label>Department ID (Read Only):</label>
                                <!-- Primary key field is locked as read-only to prevent breaking relational constraints -->
                                <input type="text" name="id" value="<%= deptId %>" readonly style="color: #7f8c8d; cursor: not-allowed;">
                            </div>
                            <div class="form-group">
                                <label for="dept_name">Department Name:</label>
                                <input type="text" id="dept_name" name="dept_name" value="<%= deptName %>" required autocomplete="off" style="background-color: #fff;">
                            </div>
                            <button type="submit" class="submit-btn"><i class="fa-solid fa-square-check"></i> Apply Structural Update</button>
                        </form>
                    </div>
                </div>
            </div>
            <div class="footer"></div>
        </div>
    </body>
</html>
