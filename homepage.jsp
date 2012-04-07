<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta name="keywords" content="" />
<meta name="description" content="" />
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<title>Pantry Chef</title>
<link href="http://fonts.googleapis.com/css?family=Arvo" rel="stylesheet" type="text/css" />
<link href="http://fonts.googleapis.com/css?family=Coda:400,800" rel="stylesheet" type="text/css" />
<link href="style.css" rel="stylesheet" type="text/css" media="screen" />
</head>
<body>
<div id="menu-wrapper">
	<div id="menu">
		<ul>
			<li class="current_page_item"><a href="homepage.jsp"><b>Pantry Chef</b></a></li>
			<li><a href="updatePantry.jsp">Update Pantry</a></li>
			<li><a href="addADish.jsp">Add a Dish</a></li>
			<li><a href="logout.jsp">Logout</a></li>
		</ul>
	<div id="search" >
		<form method="get" action="search.jsp">
		<div>
			<input type="text" name="s" id="search-text" value="" placeholder="Search..."/>
			<input type="submit" id="search-submit" value="Search" />
		</div>
		</form>
	</div>
	</div>
	
	<!-- end #menu -->
</div>
	
							
<div id="wrapper">
	<!-- end #header -->
	<div id="page">
		<div id="page-bgtop">
			<div id="page-bgbtm">
				<div id="content">
					<div class="post">
						<%
						String username = (String)(session.getAttribute("username"));
						if(username == null) {
							%><h2 class="title"><a href="#">You Are Not Logged In!</a></h2>
							<div>
								<form action="login.jsp">
								<div>
									<input type="submit" value="Login Here" />
								</div>
								</form>
							</div><%
							return;
						} 
						%>
						<div style="clear: both;">&nbsp;</div>
						<div class="entry">
							<%
							String s = request.getParameter("s");
							%><h2 class="title"><a href="#">Dishes You Can Make </a></h2><%
							response.setContentType("text/html");
							PrintWriter write = response.getWriter();
							
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
								
							    String update = "create table " + username + "Temp (named varchar2(100) PRIMARY KEY, ingredients varchar2(255), numOfIngredients number)";
							    statement.executeUpdate(update);
							    String query = "SELECT * FROM Account WHERE username=\'" + username + "\'";
							    ResultSet rs = statement.executeQuery(query);
							    if(rs.next()) {
							    	int num = rs.getInt(53);
							    	for(int i = 3; i <= num + 2; i++) {
								    	update = "INSERT INTO " + username + "Temp select d.named, d.ingredients, d.numOfIngredients from Dish d where d.ingredients LIKE \'" + rs.getString(i) + "\'";
							    	}
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
				<div id="sidebar">
					<ul>
						<li>
							<h2>Pantry Chef</h2>
							<p>Find Dishes That You Can Make with the Ingredients in Your Pantry.</p>
						</li>
						<li>
							<h2>Tables</h2>
							<ul>
								<li><a href="#">Dishes That You Can Make</a></li>
								<li><a href="#">Last 10 Dishes You Have Made</a></li>
								<li><a href="#">Last 10 Dishes Made by Users</a></li>
							</ul>
						</li>
					</ul>
				</div>
				<!-- end #sidebar -->
				<div style="clear: both;">&nbsp;</div>
			</div>
		</div>
	</div>
	<!-- end #page -->
</div>
</body>
</html>
