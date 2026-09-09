<%-- 
    Document   : login
    Created on : 2 Sept 2026, 8:07:43 pm
    Author     : risha
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
                margin: 0 0 0 0;
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
                margin: 0 0 0 40px;
                float: left;
            }
            .home i {
                margin: 0 8px 0 0;
            }
            .home:hover {
                background-color: #4f6363;
                transition-duration:  0.4s;
            }
            .body { 
                background-image: url('image/ab.jpg');
                background-size: cover;
                background-repeat: no-repeat;
                background-position: center;
                margin: 0 0 0 0;
                width: 1215px;
                height: 680px;
            }
             img { 
                position: relative;
                width: 975px;
                height: 680px; 
                transform: scale(1); 
                overflow: hidden; 
            }
            .form-container {
                background-color: #F5F5DC;
                position: absolute;
                width: 360px;
                height: 240px;
                padding: 45px 20px;
                border-radius: 6px;
                margin: 165px 0 0 415px;
                box-shadow: 0 0 10px rgba(0,0,0,0.15);
            }
            .text {
                position: absolute;
                font-size: 47px;
                color: darkslategrey;
                z-index: 2;
                white-space: nowrap;
                margin: 90px 365px;
                font-weight: bold;
                font-family: STSong;
            }
            .text1 {
                position: absolute;
                font-size: 22px;
                color: maroon;
                z-index: 2;
                white-space: nowrap;
                margin: 68px 730px;
                font-weight: bold;
                font-family: Bradley Hand ITC;
            }
            .page {
                position: relative;
                background-color: #F1F1F1;
                width: 975px;
                height: 680px;
                float: left;
            }
            .btn { 
                position: absolute;
                display: block; 
                background: #4C7E80;
                border-radius: 8px;
                color: white; 
                padding: 12px 18px; 
                text-decoration: none; 
                margin: 40px 145px; 
                font-weight: bold;
                box-shadow: 0 0 10px rgba(0,0,0,0.3);
            }
            .btn:hover {
                transform: scale(1.04) translateX(2px);
                transition-duration:  0.5s;
                background: #4f6363; 
            }
            .footer {
              box-shadow: 0 0 10px rgba(0,0,0,0.5);  
            }
            
            .input-group {
                 margin: 20px 0 0 0;
            }
            .input-group label {
                 display: block;
                 color: #666666;
                margin: 0 0 10px 35px;
                font-size: 14px;
                font-weight: 600;
            }

            .input-group input {
                width: 220px;
                padding: 6px 8px;
                margin: 0 0 0 80px;
                border: 1px solid #cccccc;
                border-radius: 4px;
                font-size: 14px;
                transition: all 0.3s ease;
                outline: none;
            }
            .error-msg{
                color:red;
                margin: 0 0 10px 80px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <p>Employee MS</p>
                <a href="index.html" class="home"><i class="fa fa-home"></i>Home</a>
            </div>
            <div class="body">
                <p style="position: absolute; color: darkslategray; margin: 125px 0 5px 555px; font-size: 30px; font-weight: bold; font-family:Castellar;">LOGIN</p>
                <div class="form-container">
                     <% 
        String error = (String) request.getAttribute("errorMessage");
        if(error != null) { 
    %>
                <div class="error-msg"><%= error %></div>
    <% } %>
                    <form method="post" action="loginprocess.jsp">
            <div class="input-group">
                <label for="empid">Username :</label>
                <input type="text" id="username" name="username" placeholder="Enter your ID" required>
            </div>
            
            <div class="input-group">
                <label for="password">Password :</label>
                <input type="password" id="password" name="password" placeholder="Enter your password" required>
            </div>
        
                    <button type="submit" class="btn">LOGIN</button>
                    </form>
     
                </div>
       
            </div>
            <div class="footer">
                
            </div>
        </div>
    </body>
</html>
