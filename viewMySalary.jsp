<%-- 
    Document   : viewMySalary
    Created on : 6 Sept 2026, 11:17:31 pm
    Author     : risha
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%
    // 1. Session Access Control and Employee Authorization Validations
    String empRole = (String) session.getAttribute("empRole");
    
    // Safety guard to block unauthenticated layout access
    if(session.getAttribute("users") == null) {
        response.sendRedirect("login.jsp");
        return;       
    }
    
    String usernameSession = (String) session.getAttribute("users");
    String empName = (String) session.getAttribute("empName");
    if(empName == null) empName = usernameSession;

    // Initialize tracking variables to hold structural finance data
    String employeeId = "";
    String employeeFullName = "";
    String departmentName = "";
    
    double basicSalary = 0.00;
    double allowance = 0.00;
    double deductions = 0.00;
    double netSalary = 0.00;
    
    boolean recordExists = false;

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@LAPTOP-VK8PMP4T:1521:XE", "system", "password");
        
        // 2. Multi-Table Join fetching Employee Meta Profile with their exact Salary Ledger cells
        String sql = "SELECT e.emp_id, e.emp_name, d.dept_name, " +
                     "s.basic_salary, s.allowance, s.deductions " +
                     "FROM employees e " +
                     "LEFT JOIN department d ON e.dept_id = d.dept_id " +
                     "LEFT JOIN salary_ledger s ON e.emp_id = s.emp_id " +
                     "WHERE e.username = ?";
                     
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, usernameSession);
        rs = pstmt.executeQuery();
        
        if(rs.next()) {
            employeeId = rs.getString("emp_id");
            employeeFullName = rs.getString("emp_name");
            departmentName = rs.getString("dept_name");
            
            if(departmentName == null || departmentName.trim().isEmpty()) {
                departmentName = "Unassigned";
            }
            
            // Check if active financial history exists for this target row profile
            if(rs.getObject("basic_salary") != null) {
                basicSalary = rs.getDouble("basic_salary");
                allowance = rs.getDouble("allowance");
                deductions = rs.getDouble("deductions");
                netSalary = basicSalary + allowance - deductions;
                recordExists = true;
            }
        }
%>
<!DOCTYPE html>
<html>
    <head>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>My Salary Slip</title>
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
            
            .title-bar {background-color: #eee; border-radius:8px; text-align:center; width:420px; padding:4px; margin: 40px 0 0 40px; font-family: cursive; font-weight: bold; font-size: 34px; color: #2E3135; }
            
            /* High-Fidelity Payslip Card Component styling rules */
            .payslip-card { width: 80%; margin: 75px auto; background: white; padding: 40px; border-radius: 8px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); font-family: Arial, sans-serif; }
            .payslip-header { border-bottom: 2px dashed #01796F; padding-bottom: 20px; margin-bottom: 25px; text-align: center; }
            .payslip-header h2 { margin: 0; color: #01796F; font-size: 24px; text-transform: uppercase; letter-spacing: 1px; }
            .payslip-header p { margin: 5px 0 0 0; color: #666; font-size: 14px; font-weight: bold; }
            
            .meta-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; margin-bottom: 30px; background-color: #f9f9f9; padding: 15px; border-radius: 4px; border-left: 4px solid #2E3135; }
            .meta-item { font-size: 14px; }
            .meta-label { font-weight: bold; color: #666; }
            .meta-val { color: #333; font-weight: 600; }
            
            .ledger-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 40px; border-bottom: 2px solid #eeeeee; padding-bottom: 20px; }
            .ledger-column h4 { margin: 0 0 15px 0; color: #2E3135; border-bottom: 2px solid #2E3135; padding-bottom: 5px; text-transform: uppercase; font-size: 14px; }
            
            .line-item { display: flex; justify-content: space-between; margin: 10px 0; font-size: 15px; }
            .line-label { color: #555; }
            .line-amount { font-weight: bold; }
            
            .net-pay-banner { background-color: #e8f5e9; border: 1px solid #c8e6c9; padding: 15px 25px; border-radius: 6px; margin-top: 25px; display: flex; justify-content: space-between; align-items: center; }
            .net-title { font-size: 18px; font-weight: bold; color: #2e7d32; text-transform: uppercase; }
            .net-value { font-size: 26px; font-weight: bold; color: #01796F; }
            
            .no-record-box { width: 70%; margin: 100px auto; background: white; padding: 50px 30px; text-align: center; border-radius: 6px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); font-family: Arial, sans-serif; }
            
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
                <!-- Navigation Sidebar Layout Map -->
                <div class="detail">
                    <ul>
                        <li><a href="dashboard.jsp"><i class="fa-solid fa-grip"></i>Dashboard</a></li>
                        
                        <% if("Admin".equalsIgnoreCase(empRole)) { %>
                        <li><a href="viewEmployees.jsp"><i class="fa-solid fa-user-tie"></i>Employee</a></li>
                        <li><a href="department.jsp"><i class="fa-solid fa-laptop-code"></i>Department</a></li>
                        <li><a href="manageSalary.jsp"><i class="fa-solid fa-money-check-dollar"></i>Manage Salaries</a></li>
                        <% } else { %>
                        <li><a href="viewMyProfile.jsp"><i class="fa-solid fa-user"></i>My Profile</a></li>
                        <li><a href="viewMySalary.jsp" style="background-color: #01796F;"><i class="fa-solid fa-wallet"></i>My Salary slips</a></li>
                        <% } %>
                        
                        <li><a href="myLeaves.jsp"><i class="fa-solid fa-calendar-minus"></i>Leave</a></li>
                        <li><a href="settings.jsp"><i class="fa-solid fa-gear"></i>Setting</a></li>
                    </ul>
                </div>
                        
                <div class="page">
    <!-- Header title bar aligned with system workspace typography rules -->
    <div class="title-bar">My Earnings Summary</div>
    
    <% if(recordExists) { %>
        <!-- Renders the verified structural payslip if financial history records clear -->
        <div class="payslip-card">
            <div class="payslip-header">
                <h2>Monthly Pay Statement</h2>
                <p>System Generated Slip</p>
            </div>
            
            <!-- Employee Information Grid Block Context -->
            <div class="meta-grid">
                <div class="meta-item"><span class="meta-label">Employee ID:</span> <span class="meta-val"><%= employeeId %></span></div>
                <div class="meta-item"><span class="meta-label">Department:</span> <span class="meta-val"><%= departmentName %></span></div>
                <div class="meta-item"><span class="meta-label">Full Name:</span> <span class="meta-val"><%= employeeFullName %></span></div>
                <div class="meta-item"><span class="meta-label">Username:</span> <span class="meta-val"><%= usernameSession %></span></div>
            </div>
            
            <!-- Earnings vs Deductions Comparative Breakdown Ledger Box Layout -->
            <div class="ledger-grid">
                <!-- Additions and Gross Earnings Stream Column -->
                <div class="ledger-column">
                    <h4>Additions & Add-ons</h4>
                    <div class="line-item">
                        <span class="line-label">Base Basic Pay</span>
                        <span class="line-amount" style="color: #2E3135;">₹<%= String.format("%,.2f", basicSalary) %></span>
                    </div>
                    <div class="line-item">
                        <span class="line-label">Allowances (HRA, Transport)</span>
                        <span class="line-amount" style="color: #2e7d32;">+₹<%= String.format("%,.2f", allowance) %></span>
                    </div>
                </div>
                
                <!-- Deductions and Tax Withholding Stream Column -->
                <div class="ledger-column">
                    <h4>Deductions & Offsets</h4>
                    <div class="line-item">
                        <span class="line-label">Standard Adjustments (Taxes/PF)</span>
                        <span class="line-amount" style="color: #c62828;">-₹<%= String.format("%,.2f", deductions) %></span>
                    </div>
                </div>
            </div>
            
            <!-- Final Computed Take-Home Net Pay Banner Box Context -->
            <div class="net-pay-banner">
                <div class="net-title">Net Take-Home Pay</div>
                <div class="net-value">₹<%= String.format("%,.2f", netSalary) %></div>
            </div>
        </div>
    <% } else { %>
        <!-- Informative fallback card layout block if admin hasn't generated their payroll records yet -->
        <div class="no-record-box">
            <i class="fa-solid fa-scale-unbalanced fa-4x" style="color: #4C7E80; margin-bottom: 15px;"></i>
            <h3 style="color: #2E3135; margin: 10px 0;">No Salary Records Found</h3>
            <p style="color: #666; font-size: 15px;">Your monthly financial distribution breakdown ledger has not been generated by the System Administrator yet.</p>
        </div>
    <% } %>
</div>
            </div>
        </div><!-- comment -->
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
