<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	session.invalidate();

	out.println("<script type='text/javascript'>");

	out.println("alert('로그아웃 되었습니다.');");
	out.println("location.href='./board_list1.jsp';");
	//out.println("history.back();"); // 되돌아가기

	out.println("</script>");

%>