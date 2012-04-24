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
						<div style="clear: both">&nbsp;</div>
						<div class="entry" style="clear: both; left: 150px; position: relative;">
							<h2 class="title"><a href="#">Dishes You Can Make </a></h2><%
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
								ArrayList<String> pantryIngredients = new ArrayList<String>();
								String query = "SELECT * FROM Account WHERE username=\'" + username + "\'";
								ResultSet rs = statement.executeQuery(query);
								if(rs.next() && (rs.getInt(53)!= 0)){
									pantryIngredients = new ArrayList<String>();
									for(int i=0;i<rs.getInt(53);i++){
										pantryIngredients.add(rs.getString(i+3));
									}
								}
								else{
									%><h3 class="title"><a href="updatePantry.jsp">Click to update your Pantry</a></h3><%
									return;
								}
								query= "SELECT named, ingredients from Dish WHERE ingredients LIKE \'%"+ pantryIngredients.get(0) + "%\'";
								for(int k=1;k<pantryIngredients.size();k++){
									query = query + " OR ingredients LIKE '%" + pantryIngredients.get(k) + "%'";
								}

								rs = statement.executeQuery(query);
								ArrayList<String> dishIngredients;
								ArrayList<String> dishIngredientsHad;
								String had,missing = "";
								int count = 0;
								int color = 0;
								int dishingredsize = 0;
								%><table border="1" width="96%"><%
								while(rs.next()) {
									count =0;
									String [] parse = rs.getString(2).split(",");
									dishIngredients = new ArrayList<String>(Arrays.asList(parse));
									dishIngredientsHad = new ArrayList<String>();
									had = "";
									missing = "";
									dishingredsize = dishIngredients.size();
									for(int i=0;i<dishIngredients.size();i++){
										for(int j =0;j<pantryIngredients.size();j++){
										if(pantryIngredients.get(j)==null)
											continue;
										if(dishIngredients.get(i).contains(pantryIngredients.get(j))){
											
											count++;
											dishIngredientsHad.add(pantryIngredients.get(j));
											dishIngredients.remove(i);
											break;
										}
									}
									}

									if(count>=(dishingredsize*.5)){
									 	if(dishIngredientsHad.isEmpty())
									 		;
									 	else{
											had = dishIngredientsHad.get(0) ;
											for(int i=1;i<dishIngredientsHad.size();i++){
												had = had + ", " + dishIngredientsHad.get(i);
											}
									 	} 
									 	if(dishIngredients.isEmpty())
									 		;
									 	else{
									    	missing = dishIngredients.get(0);
											for(int i=1;i<dishIngredients.size();i++){
												missing = missing + ", " + dishIngredients.get(i);
											}				
										} 
									 	
								    		%><tr><td style="background-image: url('images/img06.gif'); background-repeat: no-repeat;" vertical-align="middle"><h4><%=rs.getString(1)%></h4>Ingredients You Have: <%=had%><br /> Ingredients Missing: 
								    		<%=missing%></td><td align="center" style="background-image: url('images/img06.gif'); background-repeat: no-repeat;" vertical-align="middle"><img src="images/<%=rs.getString(1)%>.jpg" align = "top" border= "1px"/> <br />
								    		<form action="madeDish.jsp" method="get">
									    	<div>
										     <input type="submit" name="make_dish" value="Make" />
										     <input type="hidden" name="dish" value="<%=rs.getString(1)%>" /></div></form></td></tr><%
								    		color=1;
								    	
								    	
								}
								}
							} catch (Exception e) {
								System.out.println("Failed Connection " + e.toString());
							} finally {
								try {
									connection.close();
								} catch(Exception e) {}
							}
							    %></table>

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
