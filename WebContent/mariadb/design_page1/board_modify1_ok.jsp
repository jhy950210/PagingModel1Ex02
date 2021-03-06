<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.naming.NamingException" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.SQLException" %>

<%
	request.setCharacterEncoding("utf-8");

	String cpage = request.getParameter("cpage");
	String seq = request.getParameter("seq");
	
	String subject = request.getParameter("subject");
	String writer = request.getParameter("writer");
	String mail ="";
	if( !request.getParameter("mail1").equals("") && !request.getParameter("mail2").equals("")){
		mail = request.getParameter("mail1") + "@" + request.getParameter("mail2");
	}
	

	String password = request.getParameter("password");
	String content = request.getParameter("content");
	String[] emot = request.getParameterValues("emot");
	
	Connection conn = null;
	PreparedStatement pstmt = null;
	
	int flag = 2;
	
	try{
		Context initCtx = new InitialContext();
	      Context envCtx = (Context)initCtx.lookup("java:comp/env");
	      DataSource dataSource = (DataSource)envCtx.lookup("jdbc/mariadb1");
	      
	      conn = dataSource.getConnection();
	      
	      String sql = "update emot_board1 set subject=?, mail=?, content=?, emot=? where seq=? and password=?";//subject, mail, content, emot, seq, password
	      pstmt = conn.prepareStatement(sql);
	      
	      pstmt.setString(1, subject);
	      pstmt.setString(2, mail);
	      pstmt.setString(3, content);
	      pstmt.setString(4, emot[0].replace("emot", ""));
	      pstmt.setInt(5, Integer.parseInt(seq));
	      pstmt.setString(6, password);
	      
	      int result = pstmt.executeUpdate();
	      if(result == 0){
	    	  // 비밀번호를 잘못 기입
	    	  flag = 1;
	      }else if(result == 1){
	    	  // 정상
	    	  flag = 0;
	      }
	      
	}catch( NamingException e ){
	      System.out.println(" [에러 ] : " + e.getMessage());
	   } catch( SQLException e) {
	      System.out.println(" [에러 ] : " + e.getMessage());
	   } finally {
	      if( pstmt != null ) pstmt.close();
	      if( conn != null ) conn.close();
	   }
	
	out.println("<script type='text/javascript'>");
	if( flag == 0 ){
		out.println("alert('글수정에 성공했습니다.');");
		out.println("location.href='./board_view1.jsp?cpage="+cpage+"seq="+seq+"';");
	}else if( flag == 1){
		out.println("alert('비밀번호가 잘못되었습니다.');");
		out.println("history.back();");
	}else {
		out.println("alert('이상.');");
		out.println("history.back();"); // 되돌아가기
	}
	out.println("</script>");
	
%>