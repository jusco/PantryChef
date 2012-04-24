<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>

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
<div style="float: left; position: relative; padding: 25px 0px 0px 0px; left: 40px; width: 250px; margin: 0px;">
<img src="images/homecooking.jpg" alt="homecooking" width="304" height="228" border= "4px blue"; />
</div>
<div id="wrapper"><!-- end #header -->
<div id="page">
<div id="page-bgtop">
<div id="page-bgbtm">
<div id="content">
<div class="post">


<div style="clear: both;">&nbsp;</div>
<div class="entry" style= "padding-right: 20px;">
<h2 class="title"><a href="#">Full Pantry,
but Nothing to Eat. </a></h2>
<p>This is the age old problem we plan to address. Instead of
ordering out, why don't you just use what you have? Don't worry, we'll
show you how.</p>

<form name="login" method="post" action="login.jsp">
        Username:
        <input name="username" type="text" />
        &nbsp Password:
        <input name="password" type="password" />
        <input value="Submit" type="submit" /> &nbsp 
        <a href="create.jsp">Create a login</a>
</form>
<%
String user = request.getParameter("username");
String pass = request.getParameter("password");
response.setContentType("text/html");

if(user == null) {
	return;
}
//load driver
try { 
	Class.forName("oracle.jdbc.driver.OracleDriver"); 
} catch (ClassNotFoundException cnfe) {
	System.out.println("Error loading driver: " + cnfe);
}
Connection connection = null;
try {
	//create connection and statement
	connection = DriverManager.getConnection("jdbc:oracle:thin:@//fling.seas.upenn.edu:1521/cisora","CIS330GB","oW4gD8fW");
	Statement statement = connection.createStatement();
	//Hash password
	int total = 0;
	char [] pass2 = pass.toCharArray();
	for(int i=0; i<pass2.length;i++){
		total= total + ((Character)pass2[i]).hashCode();
	}
	
    String query = "SELECT username FROM Account WHERE username=\'" + user + "\' AND password =" + ((Integer)total).toString();
    ResultSet rs = statement.executeQuery(query);
   
    if(!rs.next())
    	%> <br><br><b>Incorrect Password! </b><%
    else{
    	session.setAttribute("username", user);	
    	response.sendRedirect("homepage.jsp");
    }
} catch (Exception e) {
		System.out.println("Failed Connection");
} finally {
	try {
		connection.close();
	} catch(Exception e) {}
} %>
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
