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
	
	Connection conn = null;
	PreparedStatement pstmt = null;
	
	int flag = 1;
	
	try{
		Context initCtx = new InitialContext();
	      Context envCtx = (Context)initCtx.lookup("java:comp/env");
	      DataSource dataSource = (DataSource)envCtx.lookup("jdbc/mariadb1");
	      
	      conn = dataSource.getConnection();
	      
	      String sql = "insert into emot_board1 values(0, ?, ?, ?, ?, ?, ?, 0, ?, now())";//subject, writer, mail, password, content, emot, wip
	      pstmt = conn.prepareStatement(sql);
	      
	      for(int i=1; i<=100; i++){
	    	  pstmt.setString(1, "제목" + i);
		      pstmt.setString(2, "이름");
		      pstmt.setString(3, "test@test.com");
		      pstmt.setString(4, "123456");
		      pstmt.setString(5, "내용");
		      pstmt.setString(6, "01");
		      pstmt.setString(7, "000.000.000.000");
		      
		      pstmt.executeUpdate();
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
		out.println("alert('글쓰기에 성공햇습니다.');");
		out.println("location.href='./board_list1.jsp';");
	} else {
		out.println("alert('글쓰기에 성공햇습니다.');");
		out.println("history.back();"); // 되돌아가기
	}
	out.println("</script>");
	
%>