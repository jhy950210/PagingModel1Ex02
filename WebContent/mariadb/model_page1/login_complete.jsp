<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("utf-8");

	if(session.getAttribute("s_id") == null  || session.getAttribute("s_grade") == null){
		// 로그인 안한 상태
		out.println("<script type='text/javascript'>");
		out.println("alert('로그인을 해야합니다.');");
		out.println("location.href='./login_form.jsp';");
		out.println("</script>");
	} else {
		// 로그인 상태
		out.println("<script type='text/javascript'>");
		out.println("location.href='./board_list1.jsp';");
		out.println("</script>");
	}
%>