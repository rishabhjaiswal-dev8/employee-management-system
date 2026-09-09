<%-- 
    Document   : editSalary
    Created on : 6 Sept 2026, 7:10:52 pm
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

    // 2. Extract Request Parameter and Initialize Form Variables
    String targetEmpId = request.getParameter("emp_id");
    String targetEmpName = "";
    String targetDeptName = "";
    
    double basicSalary = 0.00;
    double allowance = 0.00;
    double deductions = 0.00;
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@LAPTOP-VK8PMP4T:1521:XE", "system", "password");
        
        String sql = "SELECT e.emp_name, d.dept_name, s.basic_salary, s.allowance, s.deductions " +
                     "FROM employees e " +
                     "LEFT JOIN department d ON e.dept_id = d.dept_id " +
                     "LEFT JOIN salary_ledger s ON e.emp_id = s.emp_id " +
                     "WHERE e.emp_id = ?";
                     
        pstmt = conn.prepareStatement(sql);
        
        if(targetEmpId != null) {
            pstmt.setString(1, targetEmpId.trim());
        } else {
            response.sendRedirect("manageSalary.jsp?msg=error");
            return;
        }
        
        rs = pstmt.executeQuery();
        
        if(rs.next()) {
            targetEmpName = rs.getString("emp_name");
            targetDeptName = rs.getString("dept_name");
            
            if(rs.getObject("basic_salary") != null) {
                basicSalary = rs.getDouble("basic_salary");
                allowance = rs.getDouble("allowance");
                deductions = rs.getDouble("deductions");
            }
            
            if(targetDeptName == null || targetDeptName.trim().isEmpty()) {
                targetDeptName = "Unassigned";
            }
        } else {
            response.sendRedirect("manageSalary.jsp?msg=error");
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
<!DOCTYPE html>
<html>
    <head>
       <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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
            .logout i { transition: transform 0.3s ease; margin: 0 10px 0 0; }
            .logout:hover i { transform: scale(1.1) translateX(2px); }
            .logout:hover { background-color: #4f6363; transition-duration: 0.5s; }
            
            .sub { width: 1215px; height: 1050px; }
            .detail { background-color: #2E3135; width: 240px; height: 1050px; float: left; }
            .page { background-image: url('image/bg4.jpg');
                background-size: cover;
                background-repeat: no-repeat;
                background-position: center; width: 975px; height: 1050px; float: left; }
            
            .action-bar { display: flex; justify-content: space-between; align-items: center; }
            .form-container p { margin: 0 0 0 120px; color: #2E3135; font-family: cursive; font-weight: bold; font-size: 34px; }
            .back-btn { background-color: #01796F; margin: 40px 0 0 750px; color: white; padding: 14px 18px; text-decoration: none; border-radius: 4px; font-weight: bold; font-size: 14px; box-shadow: 0 2px 5px rgba(0,0,0,0.8); }
            .back-btn:hover { background-color: #4C7E80; }
            
            .form-container { width: 70%; margin: 45px auto 0 auto; background: white; padding: 40px 40px; border-radius: 6px; box-shadow: 0 2px 10px rgba(0,0,0,0.15); font-family: Arial, sans-serif; }
            .form-group { margin: 20px 0; }
            .form-group label { display: block; margin-bottom: 8px; font-weight: bold; color: #333; font-size: 15px; }
            .form-group input { width: 96%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; font-size: 15px; }
            .form-group input[readonly] { background-color: #f1f1f1; border-color: #ddd; color: #666; cursor: not-allowed; }
            .form-group input:focus:not([readonly]) { border-color: #01796F; outline: none; }
            
            .live-calc-box { background-color: #e8f5e9; border: 1px solid #c8e6c9; border-radius: 4px; padding: 15px; margin: 20px 0; font-family: Arial, sans-serif; }
            .live-calc-title { font-weight: bold; color: #2e7d32; font-size: 14px; margin-bottom: 5px; }
            .live-calc-value { font-size: 22px; font-weight: bold; color: #01796F; }
            
            .btn-submit { background-color: #01796F; margin: 25px 0 0 180px; color: white; border: none; padding: 12px 20px; border-radius: 4px; font-size: 16px; font-weight: bold; cursor: pointer; width: 50%; box-shadow: 0 2px 5px rgba(0,0,0,0.2); }
            .btn-submit:hover { background-color: #4C7E80; transition: 0.3s; }
            
            ul { list-style-type: none; margin: 20px 16px; padding: 0; border-radius: 4px; width: 210px; background-color: #2E3135; }
            li a { display: block; color: whitesmoke; font-size: 17.5px; padding: 14px 22px; text-align: center; border-radius: 3px; text-decoration: none; }
            li a i { transition: transform 0.3s ease; float: left; }
            li a:hover i { transform: scale(1.2) translateX(4px); }
            li a:hover { background-color: #01796F; transition-duration: 0.4s; color: white; }
        </style>
         <script>
            function calculateLiveNetPay() {
                
                var basic = parseFloat(document.getElementById("basic_salary").value) || 0;
                var allowance = parseFloat(document.getElementById("allowance").value) || 0;
                var deductions = parseFloat(document.getElementById("deductions").value) || 0;
                

                var netPay = basic + allowance - deductions;
                
                
                document.getElementById("net_salary_display").innerText = "₹" + netPay.toLocaleString('en-IN', {
                    minimumFractionDigits: 2,
                    maximumFractionDigits: 2
                });
            }
        </script>
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
    <div class="action-bar">
        <a href="manageSalary.jsp" class="back-btn"><i class="fa fa-arrow-left"></i> Back to Ledger</a>
    </div>
    
    <div class="form-container">
        <p style="margin:0 0 0 250px;">Adjust Salary</p>
        
        <form action="updateSalaryProcess.jsp" method="POST">
            <input type="hidden" name="emp_id" value="<%= targetEmpId %>">
            
            <div class="form-group">
                <label>Target Employee Profile</label>
                <input type="text" value="<%= targetEmpName %> (<%= targetDeptName %>)" readonly>
            </div>
            
            <div class="form-group">
                <label>Basic Salary (Base Pay)</label>
                <input type="number" step="0.01" id="basic_salary" name="basic_salary" value="<%= basicSalary %>" min="0" oninput="calculateLiveNetPay()" required>
            </div>
            
            <div class="form-group">
                <label>Allowances (Bonuses, HRA, Medical)</label>
                <input type="number" step="0.01" id="allowance" name="allowance" value="<%= allowance %>" min="0" oninput="calculateLiveNetPay()" required>
            </div>
            
            <div class="form-group">
                <label>Deductions (Provident Fund, Professional Tax)</label>
                <input type="number" step="0.01" id="deductions" name="deductions" value="<%= deductions %>" min="0" oninput="calculateLiveNetPay()" required>
            </div>
            
            <div class="live-calc-box">
                <div class="live-calc-title">Estimated Monthly Take-Home Pay (Net Salary)</div>
                <div id="net_salary_display" class="live-calc-value">₹<%= String.format("%,.2f", (basicSalary + allowance - deductions)) %></div>
            </div>
            
            <button type="submit" class="btn-submit"><i class="fa fa-save"></i> Save Financial Record</button>
        </form>
    </div>
</div>
            </div>
         </div>
    </body>
</html>
