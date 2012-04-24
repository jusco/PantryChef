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
<link rel='shortcut icon' href='http://www.bfeedme.com/wp-content/uploads/2006/04/Cook%20Chef%20Hat%20Spoons.gif' type='image/x-icon'/ >
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
							%><div class="entry" style= "padding-right: 20px;">
							<h2 class="title"><a href="#">You Are Not Logged In!</a></h2>
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
						<div class="entry" style="clear: both; top: -50px; left: 150px; position: relative;">
						<h2 class="title"><a href="#">Search Result </a></h2>
							<%
							String s = request.getParameter("s");
							if (s=="")
							{
								%><h3>Please specify a dish. <br>Below is every available dish</h3><%
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
							    
							    
							    %><table width="96%">
							    <%
							    String temp;
							    while(rs.next()) {
							    	%><tr><td style="background-image: url('images/img06.gif'); background-repeat: no-repeat;" vertical-align="middle"><h4><%=rs.getString(1)%></h4><%
							    				if(rs.getString(4)==null)
									    			temp = "";
									    		else
									    			temp = rs.getString(4);
							    		%>Ingredients: <%=temp%></td><td align="center" style="background-image: url('images/img06.gif'); background-repeat: no-repeat;" vertical-align="middle"><img src="images/<%=rs.getString(1)%>.jpg" align = "middle" border= "1px"/></td></tr><%
							    		
							    	
							    }
							    %></table><%
							} catch (Exception e) {
								System.out.println("Failed Connection" + e.toString());
							} finally {
								try {connection.close();} 
								catch(Exception e) {}
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
							<p>Find Dishes That You Can Make <br>with the Ingredients in Your Pantry.</br></p>
						</li>
						<li>
							<h2>Tables</h2>
							<ul>
								<li><a href="homepage.jsp">Dishes That You Can Make</a></li>
								<li><a href="last10User.jsp">Last 10 Dishes You Have Made</a></li>
								<li><a href="last10Everyone.jsp">Last 10 Dishes Made by Users</a></li>
								<li><a href="suggested.jsp">Suggested Dishes</a></li>
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