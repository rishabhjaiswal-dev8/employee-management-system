<%-- 
    Document   : logout
    Created on : 2 Sept 2026, 9:23:26 pm
    Author     : risha
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%
    // Clears all session mappings
        session.invalidate(); 
    // Sends user back to login page
        response.sendRedirect("login.jsp"); 
        %>
    </body>
</html>
