package kr.jk.security;

import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.sql.DataSource;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({ "file:src/main/webapp/WEB-INF/spring/security-context.xml",
		"file:src/main/webapp/WEB-INF/spring/root-context.xml" })
@Log4j
public class MemberTests {

	// 패스워드 암호화를 위한 BcryptPasswordEncoder
	@Setter(onMethod_ = @Autowired)
	private PasswordEncoder pwencoder;

	@Setter(onMethod_ = @Autowired)
	private DataSource ds;

	
	//더미 회원정보 입력
//	@Test
//	public void testInsertMember() {
//		
//		String sql = "insert into tbl_member (memberid, pw, membername) values (?, ?, ?)";
//		
//		//for(int i=0; i< 10; i++) {
//		for(int i=0; i< 1; i++) {
//			
//			Connection con = null;
//			PreparedStatement pstmt = null;
//			
//			try {
//				con = ds.getConnection();
//				pstmt = con.prepareStatement(sql);
//				
////				pstmt.setString(2, pwencoder.encode("pw" + i));
//				
//				pstmt.setString(2, pwencoder.encode("admin"));
////				pstmt.setString(2, pwencoder.encode("qwer1234"));
//				
////				if(i < 9) {
////					
////					pstmt.setString(1, "member" + i);
////					pstmt.setString(3, "일반회원" + i);
////					
////				} else {
////					
////					pstmt.setString(1, "admin" + i);
////					pstmt.setString(3, "관리자" + i);
////					
////				}
//				
//				pstmt.setString(1, "admin");
//				pstmt.setString(3, "admin");
//				
//				pstmt.executeUpdate();
//				
//			} catch (Exception e) {
//				e.printStackTrace();
//			} finally {
//				
//				if(pstmt != null) {
//					try {
//						pstmt.close();
//					} catch (Exception e) {}
//				}
//				if(con != null) {
//					try {
//						con.close();
//					} catch (Exception e) {}
//					
//				}
//			}
//		}	//end for
//	}

	
	//회원 아이디별 권한 부여
//	@Test
//	public void testInsertAuth() {
//		
//		String sql = "insert into tbl_auth (memberid, authname) values (?, ?)";
//		
//		for(int i=0; i< 1; i++) {
//			
//			Connection con = null;
//			PreparedStatement pstmt = null;
//			
//			try {
//				con = ds.getConnection();
//				pstmt = con.prepareStatement(sql);
//				
//				
////				if(i < 9) {
////					
////					pstmt.setString(1, "member" + i);
////					pstmt.setString(2, "ROLE_MEMBER");
////					
////				} else {
////					
////					pstmt.setString(1, "admin" + i);
////					pstmt.setString(2, "ROLE_ADMIN");
////					
////				}
//				
//				pstmt.setString(1, "admin");
//				pstmt.setString(2, "ROLE_ADMIN");
//				
//				pstmt.executeUpdate();
//				
//			} catch (Exception e) {
//				e.printStackTrace();
//			} finally {
//				
//				if(pstmt != null) {
//					try {
//						pstmt.close();
//					} catch (Exception e) {}
//				}
//				if(con != null) {
//					try {
//						con.close();
//					} catch (Exception e) {}
//					
//				}
//			}
//		}	//end for
//		
//		
//	}

	
	
	
	
	
	
	
	
	 

}
