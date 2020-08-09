<%@page import="java.text.SimpleDateFormat"%>
<%@page import="model1.LoginTO"%>
<%@page import="model1.LoginDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.naming.NamingException" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.Date" %>


<%
	request.setCharacterEncoding("utf-8");
	
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");


	LoginTO to = new LoginTO();
	to.setLoginID(request.getParameter("id"));
	to.setLoginPassword(request.getParameter("password"));
	
	LoginDAO dao = new LoginDAO();
	
	boolean flag = dao.loginOk(to);
	
	out.println("<script type='text/javascript'>");
	if( flag == true ){
		// 아이디 존재
		session.setAttribute("s_id", to.getLoginID());
		session.setAttribute("s_grade", "A 등급");
		session.setAttribute("s_time", format.format(new Date()));
		
		out.println("alert('로그인에 성공했습니다.');");
		out.println("location.href='./login_complete.jsp';");
	} else {
		out.println("alert('로그인에 실패했습니다.');");
		out.println("history.back();"); // 되돌아가기
	}
	out.println("</script>");
	
%>