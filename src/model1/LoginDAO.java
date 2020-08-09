package model1;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public class LoginDAO {
	private DataSource dataSource = null;
	
	public LoginDAO() {
		// TODO Auto-generated constructor stub
		try {
			Context initCtx = new InitialContext();
			Context envCtx = (Context)initCtx.lookup("java:comp/env");
			this.dataSource = (DataSource)envCtx.lookup("jdbc/mariadb2");
		} catch (NamingException e) {
			// TODO Auto-generated catch block
			System.out.println("[에러]" + e.getMessage());
		}
	}
	
	public boolean loginOk(LoginTO to) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		boolean flag = false;
		String count = "";
		try{
			
	    	conn = dataSource.getConnection();
			String sql = "select count(*) from user where user=? && password=password(?)";
	    	pstmt = conn.prepareStatement(sql);
	    
	    	pstmt.setString(1, to.getLoginID());
	    	pstmt.setString(2, to.getLoginPassword());
	    	rs = pstmt.executeQuery();
	    	
	    	
	   	 	if(rs.next()){
	    		count = rs.getString("count(*)");
	    	}
	   	 	if(Integer.parseInt(count) == 1) {
	   	 		//flag = 0; (true은 값은 1)
	   	 		flag = true; 
	   	 	}
		}catch( SQLException e) {
		 	System.out.println(" [에러] : " + e.getMessage());
		}finally {
		 	if( pstmt != null ) try{pstmt.close();} catch(SQLException e) {}
		 	if( conn != null ) try{conn.close();} catch(SQLException e) {}
		 	if( rs != null ) try{rs.close();} catch(SQLException e) {}
		}
		return flag;
		
	}
}
