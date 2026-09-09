<%-- 
    Document   : viewMyProfile
    Created on : 6 Sept 2026, 11:13:04 pm
    Author     : risha
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%
    // 1. Session Access Control and Employee Authorization Validations
    String empRole = (String) session.getAttribute("empRole");
    
    // Safety guard to block unauthenticated access
    if(session.getAttribute("users") == null) {
        response.sendRedirect("login.jsp");
        return;       
    }
    
    String usernameSession = (String) session.getAttribute("users");
    String empName = (String) session.getAttribute("empName");
    if(empName == null) empName = usernameSession;

    // Initialize profile placeholder variables
    String employeeId = "";
    String employeeFullName = "";
    String employeeRole = "";
    String departmentName = "";

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@LAPTOP-VK8PMP4T:1521:XE", "system", "password");
        
        // 2. INNER JOIN Query: Fetches profile info alongside the department name from the department section [1]
        String sql = "SELECT e.emp_id, e.emp_name, e.role, d.dept_name " +
                     "FROM employees e " +
                     "LEFT JOIN department d ON e.dept_id = d.dept_id " +
                     "WHERE e.username = ?";
                     
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, usernameSession);
        rs = pstmt.executeQuery();
        
        if(rs.next()) {
            employeeId = rs.getString("emp_id");
            employeeFullName = rs.getString("emp_name");
            employeeRole = rs.getString("role");
            departmentName = rs.getString("dept_name");
            
            if(departmentName == null || departmentName.trim().isEmpty()) {
                departmentName = "Not Assigned";
            }
        }
%>
<!DOCTYPE html>
<html>
    <head>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>My Profile</title>
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
            .logout i { transition: transform 0.3s ease; margin: 0 10px 0 0; }
            .logout:hover i { transform: scale(1.1) translateX(2px); }
            .logout:hover { background-color: #4f6363; transition-duration: 0.5s; }
            
            .sub { width: 1215px; height: 1050px; }
            .detail { background-color: #2E3135; width: 240px; height: 1050px; float: left; }
            .page { background-image: url('image/bg2.webp');
                background-size: cover;
                background-repeat: no-repeat;
                background-position: center; width: 975px; height: 1050px; float: left; }
            
            .title-bar {background-color: #eee; border-radius:8px; text-align:center; width:420px; padding:4px; margin: 30px 0 0 40px; font-family: cursive; font-weight: bold; font-size: 34px; color: #2E3135; }
            
            /* Profile Grid Card Design */
            .profile-card { width: 65%; margin: 50px auto; background: white; padding: 40px; border-radius: 8px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); font-family: Arial, sans-serif; }
            .profile-avatar { text-align: center; margin-bottom: 30px; color: #01796F; }
            .profile-grid { display: grid; grid-template-columns: 1fr; gap: 20px; }
            .info-group { border-bottom: 1px solid #eeeeee; padding-bottom: 12px; }
            .info-label { font-size: 13px; font-weight: bold; color: #777; text-transform: uppercase; margin-bottom: 5px; }
            .info-value { font-size: 17px; font-weight: 600; color: #2E3135; }
            
            ul { list-style-type: none; margin: 20px 16px; padding: 0; border-radius: 4px; width: 210px; background-color: #2E3135; }
            li a { display: block; color: whitesmoke; font-size: 17.5px; padding: 14px 22px; text-align: center; border-radius: 3px; text-decoration: none; }
            li a i { transition: transform 0.3s ease; float: left; width: 25px; }
            li a:hover i { transform: scale(1.2) translateX(4px); }
            li a:hover { background-color: #01796F; transition-duration: 0.4s; color: white; }
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
                <!-- Navigation Sidebar Layout -->
                <div class="detail">
                    <ul>
                        <li><a href="dashboard.jsp"><i class="fa-solid fa-grip"></i>Dashboard</a></li>
                        
                        <% if("Admin".equalsIgnoreCase(empRole)) { %>
                        <li><a href="viewEmployees.jsp"><i class="fa-solid fa-user-tie"></i>Employee</a></li>
                        <li><a href="department.jsp"><i class="fa-solid fa-laptop-code"></i>Department</a></li>
                        <li><a href="manageSalary.jsp"><i class="fa-solid fa-money-check-dollar"></i>Manage Salaries</a></li>
                        <% } else { %>
                        <li><a href="viewMyProfile.jsp" style="background-color: #01796F;"><i class="fa-solid fa-user"></i>My Profile</a></li>
                        <li><a href="viewMySalary.jsp"><i class="fa-solid fa-wallet"></i>My Salary slips</a></li>
                        <% } %>
                        
                        <li><a href="myLeaves.jsp"><i class="fa-solid fa-calendar-minus"></i>Leave</a></li>
                        <li><a href="settings.jsp"><i class="fa-solid fa-gear"></i>Setting</a></li>
                    </ul>
                </div>
                
                <!-- Main Content Panel Block Interface Context -->
                <div class="page">
                    <div class="title-bar">My Corporate Profile</div>
                    
                    <div class="profile-card">
                        <div class="profile-avatar">
                            <i class="fa-solid fa-id-card-clip fa-5x"></i>
                        </div>
                        
                        <div class="profile-grid">
                            <div class="info-group">
                                <div class="info-label">Employee ID Token</div>
                                <div class="info-value"><%= employeeId %></div>
                            </div>
                            
                            <div class="info-group">
                                <div class="info-label">Full Registration Name</div>
                                <div class="info-value"><%= employeeFullName %></div>
                            </div>
                            
                            <div class="info-group">
                                <div class="info-label">System Login Username</div>
                                <div class="info-value"><%= usernameSession %></div>
                            </div>
                            
                            <div class="info-group">
                                <div class="info-label">Assigned Department</div>
                                <div class="info-value" style="color: #01796F;"><%= departmentName %></div>
                            </div>
                            
                            <div class="info-group">
                                <div class="info-label">Corporate Clearance Level</div>
                                <div class="info-value"><span style="background-color: #eee; padding: 3px 8px; border-radius: 4px; font-size:14px;"><%= employeeRole %></span></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
<%
    } catch(Exception e) {
        e.printStackTrace();
        out.println("<p style='color:red; text-align:center;'>Database Read Error: " + e.getMessage() + "</p>");
    } finally {
        // Safe context parameters cleanup
        if(rs != null) try { rs.close(); } catch(Exception e){}
        if(pstmt != null) try { pstmt.close(); } catch(Exception e){}
        if(conn != null) try { conn.close(); } catch(Exception e){}
    }
%>