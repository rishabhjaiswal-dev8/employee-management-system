<%-- 
    Document   : manageLeaves
    Created on : 6 Sept 2026, 9:07:42 pm
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

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

%>
<!DOCTYPE html>
<html>
    <head>
       <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Manage Leaves</title>
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
            .page { background-image: url('image/bg6.jpg');
                background-size: cover;
                background-repeat: no-repeat;
                background-position: center; width: 975px; height: 1050px; float: left; }
            
            .title-bar {background-color: #eee; border-radius:8px; text-align:center; width:470px; padding:4px; margin: 30px 0 0 40px; font-family: cursive; font-weight: bold; font-size: 34px; color: #2E3135; }
            
            .leave-table { width: 95%; margin: 35px auto; border-collapse: collapse; background: white; border-radius: 6px; overflow: hidden; box-shadow: 0 2px 10px rgba(0,0,0,0.15); font-family: Arial, sans-serif; }
            .leave-table th, .leave-table td { padding: 12px 10px; text-align: left; border-bottom: 1px solid #eeeeee; font-size: 14px; }
            .leave-table th { background-color: #2E3135; color: white; font-weight: 600; text-align: center; }
            .leave-table td { text-align: center; }
            .leave-table tr:hover { background-color: #f5f5f5; }
            
            .badge { padding: 5px 10px; border-radius: 4px; font-weight: bold; font-size: 12px; display: inline-block; }
            .status-pending { background-color: #fff3cd; color: #856404; border: 1px solid #ffeeba; }
            .status-approved { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
            .status-rejected { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
            
            .btn-action { padding: 6px 12px; text-decoration: none; border-radius: 4px; font-size: 12px; font-weight: bold; margin: 0 3px; display: inline-block; color: white; }
            .btn-approve { background-color: #2e7d32; }
            .btn-approve:hover { background-color: #1b5e20; }
            .btn-reject { background-color: #c62828; }
            .btn-reject:hover { background-color: #b71c1c; }
            
            ul { list-style-type: none; margin: 20px 16px; padding: 0; border-radius: 4px; width: 210px; background-color: #2E3135; }
            li a { display: block; color: whitesmoke; font-size: 17.5px; padding: 14px 22px; text-align: center; border-radius: 3px; text-decoration: none; }
            li a i { transition: transform 0.3s ease; float: left; }
            li a:hover i { transform: scale(1.2) translateX(4px); }
            li a:hover { background-color: #01796F; transition-duration: 0.4s; color: white; }
            
            .alert { width: 90%; margin: 15px auto -15px auto; padding: 10px; border-radius: 4px; font-family: Arial, sans-serif; font-weight: bold; text-align: center; }
            .success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
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
                        <li><a href="viewMyProfile.jsp"><i class="fa-solid fa-user"></i>My Profile</a></li>
                        <li><a href="viewMySalary.jsp"><i class="fa-solid fa-wallet"></i>My Salary slips</a></li>
                        <% } %>
                        <li><a href="manageLeaves.jsp"><i class="fa-solid fa-calendar-minus"></i>Leave</a></li>
                        <li><a href=""><i class="fa-solid fa-gear"></i>Setting</a></li>
                    </ul>
                </div>
                
                <div class="page">
                    <%
                    try {
                        Class.forName("oracle.jdbc.driver.OracleDriver");
                        conn = DriverManager.getConnection("jdbc:oracle:thin:@LAPTOP-VK8PMP4T:1521:XE", "system", "password");

                        // Multi-Table Join fetching Employee Profile information along with Leave details
                        String sql = "SELECT l.leave_id, l.emp_id, e.emp_name, l.leave_type, " +
                                     "TO_CHAR(l.start_date, 'YYYY-MM-DD') as start_dt, " +
                                     "TO_CHAR(l.end_date, 'YYYY-MM-DD') as end_dt, " +
                                     "l.reason, l.status " +
                                     "FROM leave_applications l " +
                                     "JOIN employees e ON l.emp_id = e.emp_id " +
                                     "ORDER BY l.leave_id DESC";

                        pstmt = conn.prepareStatement(sql);
                        rs = pstmt.executeQuery();
                    %>
            <div class="title-bar">Leave Applications Registry</div>
            
            <% if("processed".equals(request.getParameter("msg"))) { %>
                <div class="alert success">
                    <i class="fa fa-check-circle"></i> Leave status updated successfully!
                </div>
            <% } %>

            <table class="leave-table">
                <thead>
                    <tr>
                        <th>Emp ID</th>
                        <th>Name</th>
                        <th>Type</th>
                        <th>Duration</th>
                        <th>Reason</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        while(rs.next()) {
                            int leaveId = rs.getInt("leave_id");
                            String id = rs.getString("emp_id");
                            String name = rs.getString("emp_name");
                            String type = rs.getString("leave_type");
                            String startStr = rs.getString("start_dt");
                            String endStr = rs.getString("end_dt");
                            String reason = rs.getString("reason");
                            String status = rs.getString("status");

                            // Assign conditional UI badge styles based on database status string text
                            String statusClass = "status-pending";
                            if("Approved".equalsIgnoreCase(status)) statusClass = "status-approved";
                            if("Rejected".equalsIgnoreCase(status)) statusClass = "status-rejected";
                    %>
                    <tr>
                        <td><%= id %></td>
                        <td><%= name %></td>
                        <td><%= type %></td>
                        <td style="font-size: 13px; white-space: nowrap;"><%= startStr %> to <%= endStr %></td>
                        <td><%= (reason == null) ? "-" : reason %></td>
                        <td><span class="badge <%= statusClass %>"><%= status %></span></td>
                        <td>
                            <% if("Pending".equalsIgnoreCase(status)) { %>
                                <a href="updateLeaveProcess.jsp?leave_id=<%= leaveId %>&action=Approved" class="btn-action btn-approve" title="Approve">
                                    <i class="fa fa-check"></i>
                                </a>
                                <a href="updateLeaveProcess.jsp?leave_id=<%= leaveId %>&action=Rejected" class="btn-action btn-reject" title="Reject">
                                    <i class="fa fa-times"></i>
                                </a>
                            <% } else { %>
                                <span style="color: #888; font-size: 12px; font-style: italic;">Processed</span>
                            <% } %>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>

                    <%
                        } catch(Exception e) {
                            e.printStackTrace();
                                } finally {
                                    if(rs != null) try { rs.close(); } catch(Exception e){}
                                    if(pstmt != null) try { pstmt.close(); } catch(Exception e){}
                                    if(conn != null) try { conn.close(); } catch(Exception e){}
                    }
                    %>
                        </div><!-- comment -->
                    </div><!-- comment -->
        </div>
    </body>
</html>
