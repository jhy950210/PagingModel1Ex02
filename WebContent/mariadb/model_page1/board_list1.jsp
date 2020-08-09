<%@page import="java.text.Format"%>
<%@page import="java.sql.PreparedStatement"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model1.BoardTO" %>
<%@ page import="model1.BoardDAO" %>
<%@ page import="model1.BoardListTO" %>
<%@ page import="java.util.ArrayList" %>
	<%
	request.setCharacterEncoding("utf-8");
	
	int cpage = 1;
	if( request.getParameter("cpage") != null && !request.getParameter("cpage").equals("")){
		cpage = Integer.parseInt(request.getParameter("cpage"));
	}
	
	String loginID = (String)session.getAttribute("s_id");
	String loginGrade = (String)session.getAttribute("s_grade");
	
	BoardListTO listTO = new BoardListTO();
	listTO.setCpage(cpage);
	
	BoardDAO dao = new BoardDAO();
	listTO = dao.boardList(listTO);
	
	
	int totalRecord = listTO.getTotalRecord();
	int totalPage = listTO.getTotalPage();
	
	int blockPerPage = listTO.getBlockPerPage();
	int startBlock = listTO.getStartBlock();
	int endBlock = listTO.getEndBlock();
	
	ArrayList<BoardTO> boardLists = listTO.getBoardLists();
	
	StringBuffer strHtml = new StringBuffer();
	for( BoardTO to : boardLists ){
	    String seq = to.getSeq();
	    String subject = to.getSubject();
	    String writer = to.getWriter();
	    String wdate = to.getWdate();
	    String hit = to.getHit();
	    int wgap = to.getWgap();
	    	
	    	
	    strHtml.append("<tr>");
	    strHtml.append("<td>&nbsp;</td>");
	    strHtml.append("<td>" + seq + "</td>");
	    strHtml.append("<td class='left'>");
	    strHtml.append("<a href='board_view1.jsp?cpage="+ cpage +"&seq=" + seq +"'>"+ subject +"</a>"); // &로 구분
	    if( wgap == 0 ){
	    	strHtml.append("&nbsp;<img src='../../images/icon_hot.gif' alt='HOT'>");
	    }
	    strHtml.append("</td>");
	    strHtml.append("<td>" + writer + "</td>");	
	    strHtml.append("<td>" + wdate + "</td>");	
	    strHtml.append("<td>" + hit +"</td>");	
	    strHtml.append("<td>&nbsp;</td>");
	    strHtml.append("</tr>");
	    	
	   } 
	
	%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="../../css/board_list.css">
<script type="text/javascript">
	window.onload = function() {
		document.getElementById("btn1").onclick = function() {
			
			if(document.frm.id.value.trim() == ''){
				alert('아이디를 입력하셔야 합니다.');
				
				return false;
			}
			if(document.frm.password.value.trim() == ''){
				alert('비밀번호를 입력하셔야 합니다.');
				return false;
			}
			document.frm.submit();
		}
		
	}
</script>
</head>

<body>
<!-- 상단 디자인 -->
<div class="con_title">
	<h3>게시판</h3>
	<p>HOME &gt; 게시판 &gt; <strong>게시판</strong></p>
</div>
<div class="con_txt">
	<div class="contents_sub">
		<div class="board_top">
			<div class="bold">총 <span class="txt_orange"><%=totalRecord %></span>건</div>
			<!-- 로그인 시작 -->
			<div align="right">
			<%
				if(loginID == null){
					
			%>
				<form action="login_ok.jsp" method="post" name="frm">
					아이디 <input type="text" name="id" value="" class="board_view_input_mail" maxlength="10" />
					비밀번호 <input type="password" name="password" value="" class="board_view_input_mail"/>
					<input type="button" id="btn1" value="로그인" class="btn_write btn_txt01" style="cursor: pointer;" />
				</form>
			<%
				} else {%>
					아이디: <%= (String)session.getAttribute("s_id")%>
					/등급: <%= (String)session.getAttribute("s_grade")%>
					/로그인 시간: <%=session.getAttribute("s_time") %>
					<input type="button" id="btn2" value="로그아웃" onclick="location.href='logout_ok.jsp'"/>
				<%				
				}
			%>
			</div>
			<!-- 로그인 끝-->
		</div>
	
		<!--게시판-->
		<div class="board">
			<table>
			<tr>
				<th width="3%">&nbsp;</th>
				<th width="5%">번호</th>
				<th>제목</th>
				<th width="10%">글쓴이</th>
				<th width="17%">등록일</th>
				<th width="5%">조회</th>
				<th width="3%">&nbsp;</th>
			</tr>
			<!-- 게시글 -->
			<%=strHtml %>
			</table>
		</div>	
		<!--//게시판-->

	<!--페이지넘버-->
				<div class="paginate_regular">
						<%
							if(startBlock == 1){
								out.println("<span><a>&lt;&lt;</a></span>");
							}else{
								out.println("<span><a href='board_list1.jsp?cpage="+ (startBlock - blockPerPage)+"'>&lt;&lt;</a></span>");
							}
							out.println("&nbsp;");
						%>
						<!--  <div align="absmiddle">
						-->
						<%
							if( cpage == 1 ){
								out.println("<span><a>&lt;</a></span>");
							}else{
								out.println("<span><a href='board_list1.jsp?cpage="+(cpage-1)+"'>&lt;</a></span>");
							}
							out.println("&nbsp;&nbsp;");
						%>
						
						
						<%
							for(int i=startBlock; i<=endBlock; i++){
								if( cpage == i ){
									out.println("<span><a>["+ i +"]</a></span>");
								}else{
									out.println("<span><a href='board_list1.jsp?cpage=" + i +"'>"+ i +"</a></span>");
								}
								
							}
						%>
					
						&nbsp;&nbsp;
						<%
							if( cpage == totalPage ){
								out.println("<span><a>&gt;</a></span>");
							}else{
								out.println("<span><a href='board_list1.jsp?cpage="+(cpage+1)+"'>&gt;</a></span>");
							}
							out.println("&nbsp;&nbsp;");
						%>
						<%
							if( endBlock == totalPage ){
								out.println("<span><a>&gt;&gt;</a></span>");
							}else{
								out.println("<span><a href='board_list1.jsp?cpage="+ (startBlock + blockPerPage)+"'>&gt;&gt;</a></span>");
							}
							out.println("&nbsp;");
						%>
						
					</div>
				</div>
		<!--//페이지넘버-->
		<div class="align_right">
		<%
				if(loginID != null){
				
			%>
			<input type="button" value="쓰기" class="btn_write btn_txt01" style="cursor: pointer;" onclick="location.href='board_write1.jsp?cpage=<%=cpage %>'" />
			<%
				}
			%>
		</div>
	</div>
</div>
<!--//하단 디자인 -->

</body>
</html>
