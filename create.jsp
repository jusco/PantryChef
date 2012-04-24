<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.regex.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<!-- CIS330 Project -->
  <meta name="keywords" content="" />
  <meta name="description" content="" />
  <meta http-equiv="content-type"
 content="text/html; charset=utf-8" />
  <title>Pantry Chef</title>
  <link href="http://fonts.googleapis.com/css?family=Arvo"
 rel="stylesheet" type="text/css" />
  <link href="http://fonts.googleapis.com/css?family=Coda:400,800"
 rel="stylesheet" type="text/css" />
  <link href="style.css" rel="stylesheet"
 type="text/css" media="screen" />
<link rel='shortcut icon' href='http://www.bfeedme.com/wp-content/uploads/2006/04/Cook%20Chef%20Hat%20Spoons.gif' type='image/x-icon'/ >
</head>
<body>
<!-- <div id="header-wrapper"> <div id="header"> <div id="logo"> <h1><a href="#">blah </a></h1> <p>Blah<a href="#">blah</a></p> </div> </div> </div>-->
<div id="menu-wrapper">
<div id="menu">
<ul>
  <li class="current_page_item"><a href="#"><b>Pantry
Chef</b></a></li>
</ul>
</div>
<!-- end #menu --></div>
<div id="wrapper"><!-- end #header -->
<div id="page">
<div id="page-bgtop">
<div id="page-bgbtm">
<div id="content">
<div class="post">

<div style="clear: both;">&nbsp;</div>
<div class="entry">
<h2 class="title"><a href="#">Create an
Account</a></h2>
<p>Enter your login information:</p>
<form name="form" method="post" action="create.jsp">
  
        <div>Username:
        <input name="username" type="text" /></div>
         <p>
        <div>Password:
        <input name="password" type="password" /></div>
      <p>
        <div>Re-enter password:
        <input name="password2" type="password" />
        <input value="Submit" type="submit" /></div>
        <p>
      <div><a href="login.jsp">Return to Login Page</a></div>
</form>

<%
							
	String user,pass,pass2 = null;
	user = request.getParameter("username");
	pass = request.getParameter("password");
	pass2 = request.getParameter("password2");
	if (user == null || pass == null){
		return ;
	}
		response.setContentType("text/html");
		PrintWriter write = response.getWriter();
		//load driver
		try { 
			Class.forName("oracle.jdbc.driver.OracleDriver"); 
		} catch (ClassNotFoundException cnfe) {
			System.out.println("Error loading driver: " + cnfe);
		}
		Connection connection = null;
		Pattern p = Pattern.compile("^[A-Za-z0-9_-]{4,15}$");
		Matcher m = p.matcher(user);
		if(!m.find()){
			%><p><b>Username must contain alphanumeric characters (no spaces) and must be between 4 and 15 characters long.</b></p><%
			return ; 
		}
		p = Pattern.compile("^[A-Za-z0-9_-]{6,15}$");
		m = p.matcher(pass);
		if(!m.find()){
			%><p>Password must contain alphanumeric characters (no spaces) and must be between 6 and 15 characters long.</p><%
			return ; 
		}
		if(!pass.equals(pass2)){
			%><p>Passwords do not match!</p><% 
			return ;
		}
		try {
			//create connection and statement
			connection = DriverManager.getConnection("jdbc:oracle:thin:@//fling.seas.upenn.edu:1521/cisora","CIS330GB","oW4gD8fW");
			Statement statement = connection.createStatement();
			//Hash password
			int total = 0;
			char [] pass3 = pass.toCharArray();
			for(int i=0; i<pass3.length;i++){
				total= total + ((Character)pass3[i]).hashCode();
			}
		    String query = "INSERT INTO Account(username,password,numofingredients) Values(\'" + user + "\',"+ ((Integer)total).toString() + ",\'0\')";
		    statement.executeUpdate(query);							
		   response.sendRedirect("login.jsp");
			} catch (Exception e) {
				System.out.println("Failed Connection");
				%><p><b>Username is already taken.</b></p><% 
			} finally {
		try {
			connection.close();
		} catch(Exception e) {}
		} 
							
	
	
		%>
	</div>
	</div>
<div style="clear: both;">&nbsp;</div>
</div>
<!-- end #content -->
<div style="clear: both;">&nbsp;</div>
</div>
</div>
</div>
<!-- end #page --></div>
</body>
</html>