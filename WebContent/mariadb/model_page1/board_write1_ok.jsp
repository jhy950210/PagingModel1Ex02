<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="model1.BoardTO" %>
<%@ page import="model1.BoardDAO" %>

<%
	request.setCharacterEncoding("utf-8");

	BoardTO to = new BoardTO();
	to.setSubject(request.getParameter("subject"));
	to.setWriter(request.getParameter("writer"));
	to.setMail("");
	if( !request.getParameter("mail1").equals("") && !request.getParameter("mail2").equals("")){
		to.setMail(request.getParameter("mail1") + "@" + request.getParameter("mail2"));
	}
		
	
	to.setPassword(request.getParameter("password"));
	to.setContent(request.getParameter("content"));
	String emotVal = request.getParameterValues("emot")[0].replace("emot", "");
	to.setEmot(emotVal);
	
	to.setWip(request.getRemoteAddr());
	
	// jsp -> 데이터베이스 연결과 관련 문장이 있으면 안됨
	BoardDAO dao = new BoardDAO();
	int flag = dao.boardWriteOk(to);
	
	out.println("<script type='text/javascript'>");
	if( flag == 0 ){
		out.println("alert('글쓰기에 성공했습니다.');");
		out.println("location.href='./board_list1.jsp';");
	} else {
		out.println("alert('글쓰기에 실패했습니다.');");
		out.println("history.back();"); // 되돌아가기
	}
	out.println("</script>");
	
%>