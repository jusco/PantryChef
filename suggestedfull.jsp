<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
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
					<div class="post" style="padding-left: 200px;width:800px">
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
						<div class="entry">
							<h2 class="title"><a href="#">Your Suggested Dishes</a></h2><%
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
								//Suggests dishes based on non null cuisine
							    String query = "SELECT y.named, y.ingredients, y.type_of_dish1 FROM madeDish x, Dish z, Dish y where x.username='" 
							                      + username + "' AND x.named = z.named AND z.cuisine IS NOT NULL AND z.cuisine = y.cuisine" ;
							    ResultSet rs = statement.executeQuery(query);
								int count = 0;
								int color = 0;
								String temp,temp2 = "";
								%><table width="96%"><%
								while(rs.next()) {
									if(rs.getString(2)==null)
						    			temp = "";
						    		else
						    			temp = rs.getString(2);
									if(rs.getString(3)==null)
						    			temp2 = "";
						    		else
						    			temp2 = rs.getString(3);
									%><tr><td style="background-image: url('images/img06.gif'); background-repeat: no-repeat;" vertical-align="middle"><h4><%=rs.getString(1)%></h4>Ingredients: <%=temp%><br /> Type of Dish:<%=temp2%></td>
						    		<td align="center" style="background-image: url('images/img06.gif'); background-repeat: no-repeat;" vertical-align="middle"><img src="images/<%=rs.getString(1)%>.jpg" align = "middle" border= "1px"/></td></tr><%
									count++;
							    }
								%></table>
								<a href="suggested.jsp">See Less Results...</a>
								<%
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
