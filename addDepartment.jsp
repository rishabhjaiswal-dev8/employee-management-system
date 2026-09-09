<%-- 
    Document   : addDepartment
    Created on : 4 Sept 2026, 5:17:11 pm
    Author     : risha
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
            .bar-btn {
                text-decoration: none;
                padding: 10px 18px;
                border-radius: 4px;
                font-size: 14px;
                font-weight: 600;
                transition: all 0.3s ease;
                display: inline-flex;
                align-items: center;
                gap: 8px;
            }
            .active-btn {
                background-color: #2E3135;
                color: white;
            }
            .view-btn {
                background-color: #4C7E80;
                color: white;
            }
            .bar-btn:hover {
                opacity: 0.9;
                transform: translateY(-1px);
            }
            .dept-table {
                width: 98%;
                margin-left: 10px;
                border-collapse: collapse;
                background-color: white;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
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
            .reset-btn {
                background-color: #e74c3c;
                color: white;
                border: none;
                padding: 12px 24px;
                border-radius: 4px;
                font-size: 15px;
                font-weight: bold;
                cursor: pointer;
                transition: background 0.3s;
            }
            .reset-btn:hover {
                background-color: #c0392b;
            }
            .alert-danger {
                background-color: #f8d7da;
                color: #721c24;
                padding: 12px 15px;
                border-radius: 4px;
                margin-bottom: 20px;
                font-family: sans-serif;
                font-size: 14px;
                font-weight: 500;
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
                   <div class="dept-action-bar">
                        <div class="left-section">
                            <h2><i class="fa-solid fa-building-user"></i> Department Creation</h2>
                            <p>Register a brand new operational team segment into the core data directory.</p>
                        </div>
                        <div class="right-section">
                            <a href="department.jsp" class="bar-btn view-btn"><i class="fa-solid fa-list-check"></i> View Registry</a>
                        </div>
                    </div>
                  <% if(request.getParameter("error") != null) { %>
                        <div class="alert-danger">
                            <i class="fa-solid fa-triangle-exclamation"></i> Error processing data structure transaction. Ensure uniqueness constraint values are followed.
                        </div>
                    <% } %>
                    <div class="form-container">
                        <form action="insertDepartment.jsp" method="POST">
                            
                            <div class="form-group">
                                <label for="dept_id">Department ID:</label>
                                <input type="text" id="dept_id" name="dept_id" placeholder="e.g., D-104" required autocomplete="off">
                            </div>
                            
                            <div class="form-group">
                                <label for="dept_name">Department Name:</label>
                                <input type="text" id="dept_name" name="dept_name" placeholder="e.g., Marketing & Sales" required autocomplete="off">
                            </div>
                            
                            <div class="form-actions">
                                <button type="submit" class="submit-btn"><i class="fa-solid fa-floppy-disk"></i> Save Department</button>
                                <button type="reset" class="reset-btn">Reset</button>
                            </div>
                            
                        </form>
                    </div>
                </div>
    </body>
</html>
