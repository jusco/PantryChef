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
						<h2 class="title"><a href="#">Search Result </a></h2>
						<div style="clear: both;">&nbsp;</div>
						<div class="entry">
							<%
							String s = request.getParameter("s");
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
								
							    String query2 = "SELECT COUNT(*) FROM Dish WHERE named LIKE \'%" + s + "%\'";
							    ResultSet rs2 = statement.executeQuery(query2);
							    rs2.next();
							    %><h3><%=rs2.getString(1)%> &nbsp &nbsp match(es) &nbsp &nbsp for &nbsp &nbsp <%="'" + s + "'"%></h3><br><%
							    		
							    String query = "SELECT * FROM Dish WHERE named LIKE \'%" + s + "%\'";
							    ResultSet rs = statement.executeQuery(query);
							    
							    int color=0;
							    %><table>
							    <tr><th>Dish</th>
							    <th>Ingredients</th></tr>
							    <%
							    while(rs.next()) {
							    	if (color==0) {
							    		%><tr><td><%=rs.getString(1)%></td><%
							    		%><td><%=rs.getString(4)%></td></tr><%
							    		color=1;
							    	}
							    	else {
							    		%><tr class="alt"><td><%=rs.getString(1)%></td><%
							    		%><td><%=rs.getString(4)%></td></tr><%
							    		color=0;
							    	}
							    }
							    %></table><%
							} catch (Exception e) {
								System.out.println("Failed Connection" + e.toString());
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
	<!-- end #page -->
</div>
</body>
</html>