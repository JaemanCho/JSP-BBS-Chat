<!DOCTYPE html>
<html>
<head>
<%@ page import="java.sql.*, javax.sql.*, javax.naming.InitialContext, javax.naming.Context" %>
<meta charset="UTF-8">
</head>
<body>
	<%
	InitialContext initCtx = new InitialContext();
	Context envContext = (Context) initCtx.lookup("java:comp/env");
	DataSource ds = (DataSource) envContext.lookup("jdbc/JSP-BBS-Chat");
    Connection con = ds.getConnection();
    Statement stmt = con.createStatement();
    ResultSet result = stmt.executeQuery("SELECT VERSION();");
    while(result.next()) {
    	out.println("MariaDB version:" + result.getString("version()"));
    }
    result.close();
    stmt.close();
    con.close();
    initCtx.close();
	%>
</body>
</html>