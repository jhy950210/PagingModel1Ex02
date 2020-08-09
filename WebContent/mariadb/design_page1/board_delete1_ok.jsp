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
	
	String seq = request.getParameter("seq");
	String password = request.getParameter("password");
	
	Connection conn = null;
	PreparedStatement pstmt = null;
	
	int flag = 2;
	
	try{
		Context initCtx = new InitialContext();
	      Context envCtx = (Context)initCtx.lookup("java:comp/env");
	      DataSource dataSource = (DataSource)envCtx.lookup("jdbc/mariadb1");
	      
	      conn = dataSource.getConnection();
	      
	      String sql = "delete from emot_board1 where seq=? and password=?";
	      pstmt = conn.prepareStatement(sql);
	      pstmt.setInt(1, Integer.parseInt(seq));
	      pstmt.setString(2, password);
	      
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
		out.println("alert('글삭제에 성공했습니다.');");
		out.println("location.href='./board_list1.jsp';");
	}else if( flag == 1){
		out.println("alert('비밀번호가 잘못되었습니다.');");
		out.println("history.back();");
	}else {
		out.println("alert('이상한 값입니다.');");
		out.println("history.back();"); // 되돌아가기
	}
	out.println("</script>");
	
%>