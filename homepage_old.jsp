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
								
							    String update = "create table temp" + username + " (named varchar2(100), ingredients varchar2(255), numOfIngredients number)";
							    statement.executeUpdate(update);
							    String query = "SELECT * FROM Account WHERE username=\'" + username + "\'";
							    %><h2>gets here</h2><%
							    ResultSet rs = statement.executeQuery(query);
							    if(rs.next()) {
							    	ArrayList<String> pantryIngredients = new ArrayList<String>();
							    	int num = rs.getInt(53);
							    	%><%=num%><%
							    	for(int i = 3; i <= num + 2; i++) {
							    		pantryIngredients.add(rs.getString(i));
								    	update = "INSERT INTO temp" + username + " select d.named, d.ingredients, d.numOfIngredients from Dish d where d.ingredients LIKE \'%" + rs.getString(i) + ",%\' OR d.ingredients LIKE \'%" + rs.getString(i) + "\'";
							    		statement.addBatch(update);
							    	}
							    	statement.executeBatch();
							    	query = "SELECT named, count(*) AS matches, numOfIngredients, ingredients FROM temp" + username + " GROUP BY named, numOfIngredients, ingredients";
							    	ResultSet dishes = statement.executeQuery(query);
							    	%><table border="1"><tr><td>Dish</td><td>Ingredients You Have</td><td>Ingredients Missing</td><td>Make?</td></tr><%
							    	while(dishes.next()) {
							    		if(((double)(dishes.getInt(2)))/dishes.getInt(3) >= .5) {
							    			%><tr>
								    		<td><%=dishes.getString(1)%></td><%
								    		String ingredients = dishes.getString(4);
								    		String have = "";
								    		String miss = "";
								    		int lastIndex = ingredients.indexOf(",");
								    		int parsed = 0;
								    		while(parsed < dishes.getInt(3)) {
								    			String dishIngr = "";
								    			if(lastIndex != -1) {
								    				dishIngr = ingredients.substring(0, lastIndex);
								    			}
								    			else {
								    				dishIngr = ingredients;
								    			}
								    			
									    		for(int i = 0; i < pantryIngredients.size(); i++) {
									    			String pantryIngr = pantryIngredients.get(i);
									    			if(pantryIngr.equalsIgnoreCase(dishIngr)) {
									    				have = have + dishIngr + ",";
									    			}
								    			}
									    		if(!(have.contains(dishIngr))) {
									    			miss = miss + dishIngr + ",";
									    		}
									    		if(lastIndex != -1) {
									    			ingredients = ingredients.substring(lastIndex + 1);
									    			lastIndex = ingredients.indexOf(",");
									    		}
									    		parsed++;
								    		}
								    		if(!(have.equals(""))) {
								    			have = have.substring(0, have.length() - 1);
								    		}
								    		if(!(miss.equals(""))) {
								    			miss = miss.substring(0, miss.length() - 1);	
								    		}
								    		%><td><%=have%></td>
								    		<td><%=miss%></td>
								    		<td>
								    		<form action="madeDish.jsp" method="get">
									    	<div>
										        <input type="submit" name="make_dish" value="Make" />
										        <input type="hidden" name="dish" value="<%=dishes.getString(1)%>" />
										    </div>
										    </form>	
								    		</td>
								    		</tr><%
							    		}
							    	}
							    	%></table><%
							    	update = "drop table temp" + username;
								    statement.executeUpdate(update);
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
