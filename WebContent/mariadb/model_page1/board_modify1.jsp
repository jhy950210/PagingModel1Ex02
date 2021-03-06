﻿<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="model1.BoardDAO"%>
<%@page import="model1.BoardTO"%>

<%
	request.setCharacterEncoding("utf-8");
	
	if(session.getAttribute("s_id") == null){
		// 로그인 안한 상태
		out.println("<script type='text/javascript'>");
		out.println("alert('로그인을 해야합니다.');");
		out.println("history.back()");
		out.println("</script>");
	}else{
	String cpage = request.getParameter("cpage");
	String seq = request.getParameter("seq");
	
	BoardTO to = new BoardTO();
	to.setSeq(seq);
	
	BoardDAO dao = new BoardDAO();
	to = dao.boardModify(to);
	
	String subject = to.getSubject();
	String writer = to.getWriter();
	String mail = to.getMail();
	String content = to.getContent();
	String mail1 = mail.substring(0,mail.indexOf("@"));
	String mail2 = mail.substring(mail.indexOf("@") + 1);
	String emot = to.getEmot();
	
	StringBuffer strHtml = new StringBuffer();
	
	for(int i = 1; i<=45; i++){
		if( i % 15 == 1 ){
			strHtml.append("<tr>");
		}
			if( i<10 ){
				if(Integer.parseInt(emot.substring(1)) == i){
							
					strHtml.append("<td>");
			      	strHtml.append("<img src='../../images/emoticon/emot0"+ i +".png' width='25'/>" + "<br />");
			      	strHtml.append("<input type='radio' name='emot' value='emot0"+ i +"' class='input_radio' checked='checked'/>");
			      	strHtml.append("</td>");
				} else {
					strHtml.append("<td>");
				    strHtml.append("<img src='../../images/emoticon/emot0"+ i +".png' width='25'/>" + "<br />");
				    strHtml.append("<input type='radio' name='emot' value='emot0"+ i +"' class='input_radio'/>");
				    strHtml.append("</td>");
				}
			}else{
				if(Integer.parseInt(emot) == i){
					strHtml.append("<td>");
				    strHtml.append("<img src='../../images/emoticon/emot"+ i +".png' width='25'/>" + "<br />");
				    strHtml.append("<input type='radio' name='emot' value='emot"+ i +"' class='input_radio' checked='checked'/>");
				    strHtml.append("</td>");
				} else {
					strHtml.append("<td>");
					strHtml.append("<img src='../../images/emoticon/emot"+ i +".png' width='25'/>" + "<br />");
					strHtml.append("<input type='radio' name='emot' value='emot"+ i +"' class='input_radio'/>");
					strHtml.append("</td>");
				}
			}		
					
		if(i % 15 == 0){
			strHtml.append("</tr>");
		}
	}
	
	%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="../../css/board_write.css">
<script type="text/javascript">
	window.onload = function() {
		document.getElementById('mbtn').onclick = function() {
			if( document.mfrm.password.value.trim() == '' ){
				alert('비밀번호를 입력하셔야 합니다.');
				return false;
			}
			document.mfrm.submit();
		};
	};
</script>
</head>

<body>
<!-- 상단 디자인 -->
<div class="con_title">
	<h3>게시판</h3>
	<p>HOME &gt; 게시판 &gt; <strong>게시판</strong></p>
</div>
<div class="con_txt">
	<form action="./board_modify1_ok.jsp" method="post" name="mfrm">
		<input type="hidden" name="seq" value="<%=seq %>" />
		<input type="hidden" name="cpage" value="<%=cpage %>" />
		<div class="contents_sub">	
			<!--게시판-->
			<div class="board_write">
				<table>
				<tr>
					<th class="top">글쓴이</th>
					<td class="top" colspan="3"><input type="text" name="writer" value="<%=writer %>" class="board_view_input_mail" maxlength="5" readonly/></td>
				</tr>
				<tr>
					<th>제목</th>
					<td colspan="3"><input type="text" name="subject" value="<%=subject %>" class="board_view_input" /></td>
				</tr>
				<tr>
					<th>비밀번호</th>
					<td colspan="3"><input type="password" name="password" value="" class="board_view_input_mail"/></td>
				</tr>
				<tr>
					<th>내용</th>
					<td colspan="3"><textarea name="content" class="board_editor_area"><%=content %></textarea></td>
				</tr>
				<tr>
					<th>이메일</th>
					<td colspan="3"><input type="text" name="mail1" value="<%=mail1 %>" class="board_view_input_mail"/> @ <input type="text" name="mail2" value="<%=mail2 %>" class="board_view_input_mail"/></td>
				</tr>
				<tr>
					<th>이모티콘</th>
					<td colspan="3" align="center">
						<table>
						<%=strHtml %>
						</table>
					</td>
				</tr>
				</table>
			</div>
			
			<div class="btn_area">
				<div class="align_left">
					<input type="button" value="목록" class="btn_list btn_txt02" style="cursor: pointer;" onclick="location.href='board_list1.jsp?cpage=<%=cpage %>'" />
					<input type="button" value="보기" class="btn_list btn_txt02" style="cursor: pointer;" onclick="location.href='board_view1.jsp?seq=<%=seq %>'" />
				</div>
				<div class="align_right">
					<input type="button" id="mbtn" value="수정" class="btn_write btn_txt01" style="cursor: pointer;" />
				</div>
			</div>
			<!--//게시판-->
		</div>
	</form>
</div>
<!-- 하단 디자인 -->

</body>
</html>
<%
}
%>