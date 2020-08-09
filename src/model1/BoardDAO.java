package model1;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;


public class BoardDAO {
	private DataSource dataSource = null;
	
	public BoardDAO() {
		// TODO Auto-generated constructor stub
		try {
			Context initCtx = new InitialContext();
			Context envCtx = (Context)initCtx.lookup("java:comp/env");
			this.dataSource = (DataSource)envCtx.lookup("jdbc/mariadb1");
		} catch (NamingException e) {
			// TODO Auto-generated catch block
			System.out.println("[에러]" + e.getMessage());
		}
	}
	
	public void boardWrite() {
		
	}
	
	public int boardWriteOk(BoardTO to) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		
		int flag = 1;
		
		try{
		      conn = this.dataSource.getConnection();
		      
		      String sql = "insert into emot_board1 values(0, ?, ?, ?, ?, ?, ?, 0, ?, now())";//subject, writer, mail, password, content, wip
		      pstmt = conn.prepareStatement(sql);
		      
		      pstmt.setString(1, to.getSubject());
		      pstmt.setString(2, to.getWriter());
		      pstmt.setString(3, to.getMail());
		      pstmt.setString(4, to.getPassword());
		      pstmt.setString(5, to.getContent());
		      pstmt.setString(6, to.getEmot());
		      pstmt.setString(7, to.getWip());
		      
		      int result = pstmt.executeUpdate();
		      if(result == 1){
		    	  flag = 0;
		      }
		      
		   } catch( SQLException e) {
		      System.out.println(" [에러] : " + e.getMessage());
		   } finally {
		      if( pstmt != null ) try{pstmt.close();} catch(SQLException e) {}
		      if( conn != null ) try{conn.close();} catch(SQLException e) {}
		   }
		return flag;
	}

	public BoardListTO boardList(BoardListTO listTO) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		int cpage = listTO.getCpage();
		int recordPerPage = listTO.getRecordPerPage();
		int blockPerPage = listTO.getBlockPerPage();
		
		try{
		    conn = this.dataSource.getConnection();
		    
		    String sql = "select seq, subject, writer, DATE(wdate) wdate, hit, datediff(now(), wdate) wgap from emot_board1 order by seq desc";
		    pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY); // 총 게시글 수 알기 위해
		    
		    rs = pstmt.executeQuery();
		   
		    rs.last();
		    listTO.setTotalRecord(rs.getRow());
		    rs.beforeFirst();
		    
		    listTO.setTotalPage(((listTO.getTotalRecord()-1)/recordPerPage)+1);
		    
		    int skip = ((cpage-1)* recordPerPage);
		    if(skip != 0) rs.absolute( skip );
		    
		    ArrayList<BoardTO> lists = new ArrayList<BoardTO>();
		    for( int i=0; i<recordPerPage && rs.next(); i++ ){
		    	BoardTO to = new BoardTO();
		    	
		    	to.setSeq(rs.getString("seq"));
		    	to.setSubject(rs.getString("subject"));
		    	to.setWriter(rs.getString("writer"));
		    	to.setWdate(rs.getString("wdate"));
		    	to.setHit(rs.getString("hit"));
		    	to.setWgap(rs.getInt("wgap"));
		    	
		    	lists.add(to);
		    } 
		
		    listTO.setBoardLists(lists);
		    
		    listTO.setStartBlock(((cpage-1) / blockPerPage) * blockPerPage + 1);
		    listTO.setEndBlock(((cpage-1) / blockPerPage) * blockPerPage + blockPerPage);
		    
		    if( listTO.getEndBlock() >= listTO.getTotalPage() ) {
		    	listTO.setEndBlock(listTO.getTotalPage());
		    }
		}catch( SQLException e) {
		   System.out.println(" [에러] : " + e.getMessage());
		}finally {
		   if( pstmt != null ) try{pstmt.close();} catch(SQLException e) {}
		   if( conn != null ) try{conn.close();} catch(SQLException e) {}
		   if( rs != null ) try{rs.close();} catch(SQLException e) {}
		}
		
		return listTO;
	}
	
	public ArrayList<BoardTO> boardList() {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		
		
		ArrayList<BoardTO> lists = new ArrayList<BoardTO>();
		try{
		    conn = this.dataSource.getConnection();
		    
		    String sql = "select seq, subject, writer, DATE(wdate) wdate, hit, datediff(now(), wdate) wgap from emot_board1 order by seq desc";
		    pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY); // 총 게시글 수 알기 위해
		    
		    rs = pstmt.executeQuery();
		   
		    
		    while(rs.next()){
		    	BoardTO to = new BoardTO();
		    	
		    	to.setSeq(rs.getString("seq"));
		    	to.setSubject(rs.getString("subject"));
		    	to.setWriter(rs.getString("writer"));
		    	to.setWdate(rs.getString("wdate"));
		    	to.setHit(rs.getString("hit"));
		    	to.setWgap(rs.getInt("wgap"));
		    	
		    	lists.add(to);
		    } 
		
		}catch( SQLException e) {
		   System.out.println(" [에러] : " + e.getMessage());
		}finally {
		   if( pstmt != null ) try{pstmt.close();} catch(SQLException e) {}
		   if( conn != null ) try{conn.close();} catch(SQLException e) {}
		   if( rs != null ) try{rs.close();} catch(SQLException e) {}
		}
		
		return lists;
	}
	
	public BoardTO boardView(BoardTO to) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try{
			
		    conn = this.dataSource.getConnection();
		    
		    String sql = "update emot_board1 set hit=hit+1 where seq=?" ; // 조회수 증가
		    pstmt = conn.prepareStatement(sql);
		    pstmt.setString(1, to.getSeq());
		    
		    pstmt.executeUpdate();
		    pstmt.close();
		    
		    sql = "select subject, writer, mail, wip, wdate, hit, content, emot from emot_board1 where seq=?";
		    pstmt = conn.prepareStatement(sql);
		    
		    pstmt.setString(1, to.getSeq());
		    rs = pstmt.executeQuery();
		    
		    if(rs.next()){
		    	to.setSubject(rs.getString("subject"));
		    	to.setWriter(rs.getString("writer"));
		    	to.setMail(rs.getString("mail"));
		    	to.setWip(rs.getString("wip"));
		    	to.setWdate(rs.getString("wdate"));
		    	to.setHit(rs.getString("hit"));
		    	to.setContent(rs.getString("content").replaceAll("\n","<br />")); // 줄 바꿈 보여주기
		    	to.setEmot(rs.getString("emot"));
		    	
		    	}
		    
	
		}catch( SQLException e) {
		 	System.out.println(" [에러 ] : " + e.getMessage());
		}finally {
			if( pstmt != null ) try{pstmt.close();} catch(SQLException e) {}
			if( conn != null ) try{conn.close();} catch(SQLException e) {}
			if( rs != null ) try{rs.close();} catch(SQLException e) {}
		}
		return to;
	}
	
	public BoardTO boardModify(BoardTO to) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		int flag = 1;
		
		try{
		      conn = this.dataSource.getConnection();
		      
		      String sql = "select subject, writer, mail, content, emot from emot_board1 where seq=?";
		      pstmt = conn.prepareStatement(sql);
		      pstmt.setString(1, to.getSeq());
		      
		      rs = pstmt.executeQuery();
		      if(rs.next()){
			    	to.setSubject(rs.getString("subject"));
			    	to.setWriter(rs.getString("writer"));
			    	to.setMail(rs.getString("mail"));
			    	to.setContent(rs.getString("content"));
			    	
			    	to.setEmot(rs.getString("emot"));
			    	
			    	to.setMail(rs.getString("mail"));
		      }
	
		
		   } catch( SQLException e) {
		      System.out.println(" [에러] : " + e.getMessage());
		   } finally {
			   if( pstmt != null ) try{pstmt.close();} catch(SQLException e) {}
			   if( conn != null ) try{conn.close();} catch(SQLException e) {}
			   if( rs != null ) try{rs.close();} catch(SQLException e) {}
		   }
		return to;
	}
	
	public int boardModifyOk(BoardTO to) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		int flag = 2;
		
		
		try{
		      conn = this.dataSource.getConnection();
		      
		      String sql = "update emot_board1 set subject=?, mail=?, content=?, emot=? where seq=? and password=?";//subject, mail, content, emot, seq, password
		      pstmt = conn.prepareStatement(sql);
		      
		      pstmt.setString(1, to.getSubject());
		      pstmt.setString(2, to.getMail());
		      pstmt.setString(3, to.getContent());
		      pstmt.setString(4, to.getEmot());
		      pstmt.setString(5, to.getSeq());
		      pstmt.setString(6, to.getPassword());
		      
		      int result = pstmt.executeUpdate();
		      if(result == 0){
		    	  // 비밀번호를 잘못 기입
		    	  flag = 1;
		      }else if(result == 1){
		    	  // 정상
		    	  flag = 0;
		      }
	
		   } catch( SQLException e) {
		      System.out.println(" [에러] : " + e.getMessage());
		   } finally {
			   if( pstmt != null ) try{pstmt.close();} catch(SQLException e) {}
			   if( conn != null ) try{conn.close();} catch(SQLException e) {}
		   }
		return flag;
	}
	
	public BoardTO boardDelete(BoardTO to) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try{
			
		    conn = this.dataSource.getConnection();
		    
		    String sql = "select subject, writer from emot_board1 where seq=?";
		    pstmt = conn.prepareStatement(sql);
		    pstmt.setString(1, to.getSeq());
		    
		    rs = pstmt.executeQuery();
		    
		    if(rs.next()){
		    	to.setSubject(rs.getString("subject"));
		    	to.setWriter(rs.getString("writer"));
		    }
		   
		}catch( SQLException e) {
			 System.out.println(" [에러 ] : " + e.getMessage());
		}finally {
			if( pstmt != null ) try{pstmt.close();} catch(SQLException e) {}
			if( conn != null ) try{conn.close();} catch(SQLException e) {}
			if( rs != null ) try{rs.close();} catch(SQLException e) {}
		}
		return to;
	}
	
	public int boardDeleteOk(BoardTO to) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		int flag = 2;
		
		try{
			
		      conn = this.dataSource.getConnection();
		      
		      String sql = "delete from emot_board1 where seq=? and password=?";
		      pstmt = conn.prepareStatement(sql);
		      pstmt.setString(1, to.getSeq());
		      pstmt.setString(2, to.getPassword());
		      
		      int result = pstmt.executeUpdate();
		      if(result == 0){
		    	  // 비밀번호를 잘못 기입
		    	  flag = 1;
		      }else if(result == 1){
		    	  // 정상
		    	  flag = 0;
		      }
		
		   } catch( SQLException e) {
		      System.out.println(" [에러] : " + e.getMessage());
		   } finally {
			   if( pstmt != null ) try{pstmt.close();} catch(SQLException e) {}
			if( conn != null ) try{conn.close();} catch(SQLException e) {}
		   }
		return flag;
	}
}
