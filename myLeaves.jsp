<%-- 
    Document   : myLeaves
    Created on : 6 Sept 2026, 11:23:17 pm
    Author     : risha
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%
    // 1. Session Access Control and Employee Authorization Validations
    String empRole = (String) session.getAttribute("empRole");
    
    if(session.getAttribute("users") == null) {
        response.sendRedirect("login.jsp");
        return;       
    }
    
    String usernameSession = (String) session.getAttribute("users");
    String empName = (String) session.getAttribute("empName");
    if(empName == null) empName = usernameSession;

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@LAPTOP-VK8PMP4T:1521:XE", "system", "password");
        
        // 2. Query isolated strictly to the logged-in employee via their active session username
        String sql = "SELECT l.leave_id, l.leave_type, " +
                     "TO_CHAR(l.start_date, 'YYYY-MM-DD') as start_dt, " +
                     "TO_CHAR(l.end_date, 'YYYY-MM-DD') as end_dt, " +
                     "l.reason, l.status " +
                     "FROM leave_applications l " +
                     "JOIN employees e ON l.emp_id = e.emp_id " +
                     "WHERE e.username = ? " +
                     "ORDER BY l.leave_id DESC";
                     
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, usernameSession);
        rs = pstmt.executeQuery();
%>
<!DOCTYPE html>
<html>
    <head>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>My Leaves</title>
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
            
            .title-bar {background-color: #eee; border-radius:8px; text-align:center; width:420px; padding:4px; margin: 30px 0 0 40px; font-family: cursive; font-weight: bold; font-size: 34px; color: #2E3135; }
            
            .action-bar { display: flex; justify-content: flex-end; padding-right: 40px; margin-top: 20px; }
            .apply-btn { background-color: #01796F; color: white; padding: 12px 18px; text-decoration: none; border-radius: 4px; font-weight: bold; font-size: 14px; box-shadow: 0 2px 5px rgba(0,0,0,0.3); }
            .apply-btn:hover { background-color: #4C7E80; transition: 0.3s; }
            
            .leave-table { width: 93%; margin: 30px auto; border-collapse: collapse; background: white; border-radius: 6px; overflow: hidden; box-shadow: 0 2px 10px rgba(0,0,0,0.15); font-family: Arial, sans-serif; }
            .leave-table th, .leave-table td { padding: 14px 12px; text-align: left; border-bottom: 1px solid #eeeeee; font-size: 14px; }
            .leave-table th { background-color: #2E3135; color: white; font-weight: 600; text-align: center; }
            .leave-table td { text-align: center; }
            .leave-table tr:hover { background-color: #f5f5f5; }
            
            /* Status Badges */
            .badge { padding: 5px 10px; border-radius: 4px; font-weight: bold; font-size: 12px; display: inline-block; }
            .status-pending { background-color: #fff3cd; color: #856404; border: 1px solid #ffeeba; }
            .status-approved { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
            .status-rejected { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
            
            .alert { width: 90%; margin: 15px auto -15px auto; padding: 10px; border-radius: 4px; font-family: Arial, sans-serif; font-weight: bold; text-align: center; }
            .success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
            
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
                        <li><a href="viewMyProfile.jsp"><i class="fa-solid fa-user"></i>My Profile</a></li>
                        <li><a href="viewMySalary.jsp"><i class="fa-solid fa-wallet"></i>My Salary slips</a></li>
                        <% } %>
                        
                        <li><a href="myLeaves.jsp" style="background-color: #01796F;"><i class="fa-solid fa-calendar-minus"></i>Leave</a></li>
                        <li><a href="settings.jsp"><i class="fa-solid fa-gear"></i>Setting</a></li>
                    </ul>
                </div>
                        
                <div class="page">
    <!-- Header title bar aligned with workspace design requirements -->
    <div class="title-bar">My Leave History</div>
    
    <!-- Action panel giving the employee a link to open the request form -->
    <div class="action-bar">
        <a href="applyLeave.jsp" class="apply-btn"><i class="fa fa-plus-circle"></i> Apply For Leave</a>
    </div>
    
    <%-- Flash banner message printed upon successful applyLeaveProcess updates --%>
    <% if("applied".equals(request.getParameter("msg"))) { %>
        <div class="alert success" style="width: 90%; margin: 15px auto -15px auto; padding: 10px; border-radius: 4px; font-family: Arial, sans-serif; font-weight: bold; text-align: center; background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb;">
            <i class="fa fa-check-circle"></i> Leave request submitted successfully!
        </div>
    <% } %>
    
    <!-- Individual Leave History Data Log Grid Table -->
    <table class="leave-table">
        <thead>
            <tr>
                <th>Leave ID</th>
                <th>Leave Type</th>
                <th>Start Date</th>
                <th>End Date</th>
                <th>Reason / Remarks</th>
                <th>Status</th>
            </tr>
        </thead>
        <tbody>
            <%
                while(rs.next()) {
                    int leaveId = rs.getInt("leave_id");
                    String type = rs.getString("leave_type");
                    String startStr = rs.getString("start_dt");
                    String endStr = rs.getString("end_dt");
                    String reason = rs.getString("reason");
                    String status = rs.getString("status");
                    
                    // Assign conditional UI style attributes based on row status cell values
                    String statusClass = "status-pending";
                    if("Approved".equalsIgnoreCase(status)) statusClass = "status-approved";
                    if("Rejected".equalsIgnoreCase(status)) statusClass = "status-rejected";
            %>
            <tr>
                <td>#<%= leaveId %></td>
                <td style="font-weight: 600; color: #2E3135;"><%= type %></td>
                <td><%= startStr %></td>
                <td><%= endStr %></td>
                <td><%= (reason == null || reason.trim().isEmpty()) ? "-" : reason %></td>
                <td><span class="badge <%= statusClass %>"><%= status %></span></td>
            </tr>
            <%
                }
            %>
        </tbody>
    </table>
</div>
            </div><!-- comment -->
        </div>
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
    </body>
</html>
