<%-- 
    Document   : dashboard
    Created on : 2 Sept 2026, 7:42:03 pm
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
            .home {
                background-color: #4C7E80;
                box-shadow: 0 0 10px rgba(0,0,0,0.3);
                padding: 18.5px 22px;
                border-radius: 2px;
                text-decoration: none;
                color: whitesmoke;
                margin: 0 0 0 43px;
                float: left;
            }
            .home i {
                margin: 0 8px 0 0;
            }
            .home:hover {
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
                margin: 4.5px 0 0 744.5px;
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
                background-image: url('image/bg.avif');
                background-size: cover;
                background-repeat: no-repeat;
                background-position: center;
                width: 975px;
                height: 680px;
                float: left;
            }
            .welcome-card { 
                background: #eee; 
                padding: 60px; 
                border-radius: 6px; 
                box-shadow: 0 2px 5px rgba(0,0,0,0.1); 
                margin-top: 30px; }
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
                <a href="index.html" class="home"><i class="fa fa-home"></i>Home</a>
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
                        <li><a href="myLeaves.jsp"><i class="fa-solid fa-calendar-minus"></i>Leave</a></li>
                        <li><a href=""><i class="fa-solid fa-gear"></i>Setting</a></li>
                    </ul>
                </div>
                <div class="page">
                        <h1 style="margin: 40px 0 0 25px;width:300px; background-color:#eee; border-radius:8px; padding:4px 8px; text-align:center;">Welcome, <%= empName %>!</h1>
                    
                     <div class="welcome-card">
                        <h3><i class="fa-solid fa-circle-check" style="color: #01796F;"></i> Authorized Session Validated</h3>
                        <p><strong>Username Reference:</strong> <%= username %></p>
                        <p><strong>System Access Level:</strong> <%= empRole %></p>
                        <hr style="border: 0; border-top: 1px solid #eee; margin: 20px 0;">
                        
                        <% if("Admin".equalsIgnoreCase(empRole)) { %>
                            <p>You logged in as an <strong>Administrator</strong>. You have full access to manage employees, handle departments, and process salary data matrix tables.</p>
                        <% } else { %>
                            <p>You logged in as an <strong>Employee</strong>. You can view your personal profile files, check your attendance leave metrics, or update your password settings.</p>
                        <% } %>
                    </div>
                    
                </div>
            </div>
            <div class="footer">
                
            </div>
        </div>
    </body>
</html>
