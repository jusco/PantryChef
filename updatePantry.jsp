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
			<li class="current_page_item"><a href="updatePantry.jsp">Update Pantry</a></li>
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
					<div class="post" style="padding-left: 200px;">
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
						
						<div class="entry" style="clear: both;">
						<h2 class="title"><a href="#">Update Pantry</a></h2>
						
							<%
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
								
							    String query = "SELECT * FROM Account WHERE username=\'" + username + "\'";
							    ResultSet rs = statement.executeQuery(query);
							    int color = 0;
							    if(rs.next()) {
							    	int num = rs.getInt(53);
							    	%><table id="update" border="1" ><%
							    	for(int i = 3; i <= num + 2; i++) {
							    		if (rs.getString(i)==null) {continue;}
							    		char[] temp=rs.getString(i).toCharArray();
							    		temp[0] = Character.toUpperCase(temp[0]);
							    		String temp2 = new String(temp);
							    		if (color==0) {
								    		%><tr >
									    	<td><%=temp2%></td>
									    	<td>
									    	<form action="deleteIngredient.jsp" method="post">
									    	<div>
										        <input type="submit" name="delete_ingredient" value="Delete" />
										        <input type="hidden" name="inum" value="<%=i%>" />
										    </div>
										    </form>	
									    	</td>
									    	</tr><%
									    	color=1;
								    	}
								    	else {
								    		%><tr class="alt">
									    	<td ><%=temp2%></td>
									    	<td >
									    	<form action="deleteIngredient.jsp" method="post">
									    	<div>
										        <input type="submit" name="delete_ingredient" value="Delete" />
										        <input type="hidden" name="inum" value="<%=i%>" />
										    </div>
										    </form>	
									    	</td>
									    	</tr><%
									    	color=0;
								    	}
							    	}
							    	%></table><%
							    }
							} catch (Exception e) {
								System.out.println("Failed Connection " + e.getMessage());
							} finally {
								try {
									connection.close();
								} catch(Exception e) {}
							} %>
							<div align="right">
								<form method="post" action="addIngredient.jsp">
								<div>
									<input type="text" name="ingredient" id="search-text" value="" />
									<input type="submit" value="Add" />
								</div>
								</form>
							</div>
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