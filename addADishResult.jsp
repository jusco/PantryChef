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
			<li><a href="homepage.jsp"><b>Pantry Chef</b></a></li>
			<li><a href="updatePantry.jsp">Update Pantry</a></li>
			<li class="current_page_item"><a href="addADish.jsp">Add a Dish</a></li>
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
						
						<div style="clear: both;">&nbsp;</div>
						<div class="entry">
							<%
							String named = request.getParameter("named");
							String ingredients = request.getParameter("ingredients");
							int numOfIngredients = 0;
							if(ingredients.length() > 0) {
								numOfIngredients = 1;
							}
							for(int i = 0; i < ingredients.length(); i++) {
							    if(ingredients.charAt(i) == ',') 
							    	numOfIngredients++;
							}
							String cuisine = request.getParameter("cuisine");
							response.setContentType("text/html");
							
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
								String query = "SELECT * FROM Dish WHERE named=\'" + named + "\'";
							    ResultSet rs = statement.executeQuery(query);
							    if(!(rs.next())) {
								    String update = "INSERT INTO Dish (named,ingredients,cuisine,numOfIngredients) VALUES (\'" + named + "\',\'" + ingredients + "\',\'" + cuisine + "\'," + numOfIngredients + ")";
									statement.executeUpdate(update);
									%><h2 class="title"><a href="#">Dish Added to Database!</a></h2><%
							    }
								else {
								    %><h2 class="title"><a href="#">Dish With This Name Already Exists!</a></h2><%
								}
							} catch (Exception e) {
								System.out.println("Failed Connection");
							} finally {
								try {
									connection.close();
								} catch(Exception e) {}
							} %>
						</div>
						<div>
							<form action="addADish.jsp">
							<div>
								<input type="submit" value="Return to Add a Dish Page" />
							</div>
							</form>
						</div>
					</div>
					<div style="clear: both;">&nbsp;</div>
				</div>
				<!-- end #content -->
				<div style="clear: both;">&nbsp;</div>
			</div>
		</div>
	</div>
	<!-- end #page -->
</div>
</body>
</html>