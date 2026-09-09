<%-- 
    Document   : viewEmployees
    Created on : 2 Sept 2026, 10:51:19 pm
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
                height: 680px;
            }
            .detail {
                background-color: #2E3135;
                width: 240px;
                height: 680px;
                float: left;
            }
            .page {
                background-image: url('image/bg2.webp');
                background-size: cover;
                background-repeat: no-repeat;
                background-position: center;
                width: 975px;
                height: 680px;
                float: left;
            }
            .action-bar { display: flex; justify-content: space-between; align-items: center; margin: 0 0 0 0; }
            .action-bar p { margin: 30px 0 0 50px; color: #2E3135; font-family: inherit; font-weight: bold; font-size: 34px; }
            .add-btn { background-color: #01796F; margin: 40px 50px 0 0; color: white; padding: 14px 18px; text-decoration: none; border-radius: 4px; font-weight: bold; font-size: 14px; box-shadow: 0 2px 5px rgba(0,0,0,0.8); }
            .add-btn:hover { background-color: #4C7E80; }
            .emp-table { width: 85%; margin: 65px 0 0 80px; border-collapse: collapse; background: white; border-radius: 6px; overflow: hidden; box-shadow: 0 2px 5px rgba(0,0,0,0.5); }
            .emp-table th, .emp-table td { padding: 12px 15px; text-align: left; border-bottom: 1px solid #eeeeee; }
            .emp-table th { background-color: #2E3135; color: white; font-weight: 600; text-align: center;}
            .emp-table td { text-align: center;}
            .emp-table tr:hover { background-color: #f9f9f9; }
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
                        <p style="background:#eeeeee; border-radius:8px; padding:4px;">Employee Master Directory</p>
                        <!-- Register shortcut button accessible only by Admins -->
                        <a href="addEmployee.jsp" class="add-btn"><i class="fa-solid fa-plus"></i> Add New Employee</a>
                    </div>
                    
                    <table class="emp-table">
                        <thead>
                            <tr>
                                <th>Emp ID</th>
                                <th>Full Name</th>
                                <th>Username</th>
                                <th>Access Role</th>
                                <th>Department Name</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                         <tbody>
                            <%
                                Connection conn = null;
                                Statement stmt = null;
                                ResultSet rs = null;
                                
                                 try {
                                    Class.forName("oracle.jdbc.driver.OracleDriver");
                                    conn = DriverManager.getConnection("jdbc:oracle:thin:@LAPTOP-VK8PMP4T:1521:XE", "system", "password");
                                    stmt = conn.createStatement();
                                    
                                    rs = stmt.executeQuery("SELECT e.emp_id, e.emp_name, username, e.role, d.dept_name " +
                                                                "FROM employees e " +
                                                                "LEFT JOIN department d ON e.dept_id = d.dept_id " +
                                                                "ORDER BY e.emp_id ASC");
                                    
                                    while(rs.next()) {
                                        String id = rs.getString("emp_id");
                                        String currentName = rs.getString("emp_name");
                                        String currentUname = rs.getString("username");
                                        String currentRole = rs.getString("role");
                                        String currentdept = rs.getString("dept_name");
                                        String badgeClass = "Admin".equalsIgnoreCase(currentRole) ? "badge-admin" : "badge-emp";
                            %>
                            <tr>
                                <td><strong><%= id %></strong></td>
                                <td><%= currentName %></td>
                                <td><%= currentUname %></td>
                                <td><span class="role-badge <%= badgeClass %>"><%= currentRole %></span></td>
                                <td><%= currentdept %></td>
                                <td>
                                    <a href="editEmployee.jsp?emp_id=<%= id %>" style="color: #01796F; text-decoration: none; margin-right: 15px; font-weight: bold;" title="Edit">
                                        <i class="fa-solid fa-pen-to-square"></i> Edit
                                    </a>
                                    <a href="updateDeleteHandler.jsp?action=delete&emp_id=<%= id %>" style="color: #c9302c; text-decoration: none; font-weight: bold;" title="Delete" onclick="return confirm('Are you absolutely sure you want to delete this employee?');">
                                        <i class="fa-solid fa-trash"></i> Delete
                                    </a>
                                </td>
                            </tr>
                            <%
                                    }
                                } catch(Exception e) {
                            %>
                            <tr>
                                <td colspan="4" style="color: #dc3545; text-align: center; font-weight: bold;">
                                    Database Connection Error: <%= e.getMessage() %>
                                </td>
                            </tr>
                            <%
                                } finally {
                                    if(rs != null) try { rs.close(); } catch(SQLException e){}
                                    if(stmt != null) try { stmt.close(); } catch(SQLException e){}
                                    if(conn != null) try { conn.close(); } catch(SQLException e){}
                                }
                            %>
                        </tbody>
                    </table>
                </div>
                </div>
    </body>
</html>
