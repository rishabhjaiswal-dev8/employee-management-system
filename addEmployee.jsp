<%-- 
    Document   : addEmployee
    Created on : 3 Sept 2026, 4:51:03 pm
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

    String username = (String) session.getAttribute("users");
    String empName = (String) session.getAttribute("empName");
    if(empName == null) empName = username;
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
        <title>JSP Page</title>
         <style>
            .container {
                width: 1215px;
                height: 1200px;
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
                margin: 18px 0 0 290px;
                z-index: 5;
            }
            .user-tag { 
                color: white; 
                font-family: Arial, sans-serif; 
                font-size: 16px; 
                font-weight: bold;
                white-space: nowrap;
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
                height: 1050px;
            }
            .detail {
                background-color: #2E3135;
                width: 240px;
                height: 1050px;
                float: left;
            }
            .page {
                background-image: url('image/bg2.webp');
                background-size: cover;
                background-repeat: no-repeat;
                background-position: center;
                width: 975px;
                height: 1050px;
                float: left;
            }
            .action-bar { display: flex; justify-content: space-between; align-items: center; margin: 0 0 0 0; }
            .form-container p { margin: 0 0 0 150px; color: #2E3135; font-family: cursive; font-weight: bold; font-size: 34px; }
            .back-btn { background-color: #01796F; margin: 40px 0 0 750px; color: white; padding: 14px 18px; text-decoration: none; border-radius: 4px; font-weight: bold; font-size: 14px; box-shadow: 0 2px 5px rgba(0,0,0,0.8); }
            .back-btn:hover { background-color: #4C7E80; }
            .emp-table { width: 85%; margin: 65px 0 0 80px; border-collapse: collapse; background: white; border-radius: 6px; overflow: hidden; box-shadow: 0 2px 5px rgba(0,0,0,0.5); }
            .emp-table th, .emp-table td { padding: 12px 15px; text-align: left; border-bottom: 1px solid #eeeeee; }
            .emp-table th { background-color: #2E3135; color: white; font-weight: 600; text-align: center;}
            .emp-table td { text-align: center;}
            .emp-table tr:hover { background-color: #f9f9f9; }
            
            .form-container { width: 70%; margin: 45px auto 0 auto; background: white; padding: 60px 40px; border-radius: 6px; box-shadow: 0 2px 10px rgba(0,0,0,0.15); font-family: Arial, sans-serif; }
            .form-group { margin: 30px 0 20px 0; }
            .form-group label { display: block; margin-bottom: 8px; font-weight: bold; color: #333; font-size: 15px; }
            .form-group input, .form-group select { width: 96%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; font-size: 15px; }
            .form-group input:focus, .form-group select:focus { border-color: #01796F; outline: none; }
            
            .btn-submit { background-color: #01796F; margin: 50px 0 0 180px; color: white; border: none; padding: 12px 20px; border-radius: 4px; font-size: 16px; font-weight: bold; cursor: pointer; width: 50%; box-shadow: 0 2px 5px rgba(0,0,0,0.2); }
            .btn-submit:hover { background-color: #4C7E80; transition: 0.3s; }
            .alert-msg { background-color: #f8d7da; color: #721c24; padding: 12px; border-radius: 4px; margin-bottom: 20px; border: 1px solid #f5c6cb; font-family: sans-serif; }
            
            
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
                <span class="user-tag"><i class="fa-solid fa-user-circle"></i> <%= empName %> (<%= empRole %>)</span>
                </div>
                <a href="logout.jsp" class="logout"><i class="fa fa-sign-out"></i>Logout</a>
            </div>
            <div class="sub">
                <div class="detail">
                    <ul>
                        <li><a href="dashboard.jsp"><i class="fa-solid fa-grip"></i>Dashboard</a></li>
                        <li><a href="viewEmployees.jsp"><i class="fa-solid fa-user-tie"></i>Employee</a></li>
                        <li><a href="department.jsp"><i class="fa-solid fa-laptop-code"></i>Department</a></li>
                        <li><a href="manageSalary.jsp"><i class="fa-solid fa-money-check-dollar"></i>Manage Salaries</a></li>
                        <li><a href="manageLeaves.jsp"><i class="fa-solid fa-calendar-minus"></i>Leave</a></li>
                        <li><a href=""><i class="fa-solid fa-gear"></i>Setting</a></li>
                    </ul>
                </div>
                <div class="page">   
                    <div class="action-bar">
                        
                        <!-- Register shortcut button accessible only by Admins -->
                        <a href="viewEmployees.jsp" class="back-btn"><i class="fa-solid fa-arrow-left"></i> Back to Directory</a>
                    </div>
                    
                    <div class="form-container">
                        <% if(request.getParameter("error") != null) { %>
                            <div class="alert-msg">
                                <i class="fa-solid fa-triangle-exclamation"></i> Error processing data. Verify input configuration.
                            </div>
                        <% } %>
                        <form action="insertEmployee.jsp" method="POST">
                            <p>Register New Employee</p>
                            <div class="form-group">
                                <label for="emp_id">Employee ID:</label>
                                <input type="text" id="emp_id" name="emp_id" placeholder="e.g. EMP101" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="emp_name">Full Name:</label>
                                <input type="text" id="emp_name" name="emp_name" placeholder="e.g. Jane Doe" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="username">Username:</label>
                                <input type="text" id="username" name="username" placeholder="e.g. janedoe12" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="password">System Access Password:</label>
                                <input type="password" id="password" name="password" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="role">System Access Role:</label>
                                <select id="role" name="role" required>
                                    <option value="" disabled selected>-- Choose Role --</option>
                                    <option value="Employee">Employee</option>
                                    <option value="Admin">Admin</option>
                                </select>
                            </div>
                            
                            <div class="form-group">
                                <label>Assign Department:</label>
                                <select name="employeeDept">
                                <option value="">-- Select Department --</option>
                            <%
                                    Connection conn = null;
                                    PreparedStatement pstmt = null;
                                    ResultSet rs = null;
                                    
                                  try {
                                        Class.forName("oracle.jdbc.driver.OracleDriver");
                                        conn = DriverManager.getConnection("jdbc:oracle:thin:@LAPTOP-VK8PMP4T:1521:XE", "system", "password");

                                        pstmt = conn.prepareStatement("SELECT dept_id, dept_name FROM department ORDER BY dept_name ASC");
                                        
                                        rs = pstmt.executeQuery();  
                                                    while(rs.next()) {
                                                String deptId = rs.getString("dept_id");
                                                String deptName = rs.getString("dept_name");
                                    %>
                                                <option value="<%= deptId %>"><%= deptName %></option>
                                    <%
                                            }
                                        } catch(Exception e) {
                                            e.printStackTrace();
                                    %>
                                            <option value="">Error loading departments: <%= e.getMessage() %></option>
                                    <%
                                        } finally {
                                            // 5. Clean up database resources
                                            if(rs != null) rs.close();
                                            if(pstmt != null) pstmt.close();
                                            if(conn != null) conn.close();
                                        }
                                    %>
                                </select>
                            </div>
                            
                            <button type="submit" class="btn-submit">
                                <i class="fa-solid fa-user-plus"></i> Save Employee to Database
                            </button>
                        </form>
                    </div>
                </div>
            </div>
         </div>
    </body>
</html>
