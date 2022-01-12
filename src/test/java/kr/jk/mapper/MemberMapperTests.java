package kr.jk.mapper;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import kr.jk.domain.AuthVO;
import kr.jk.domain.MemberVO;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({ "file:src/main/webapp/WEB-INF/spring/root-context.xml" })
@Log4j
public class MemberMapperTests {

	@Setter(onMethod_ = @Autowired)
	private MemberMapper mapper;
	
	
	//MemberMapper 테스트
//	@Test
//	public void testRead() {
//		
//		MemberVO vo = mapper.read("admin9");
//		
//		log.info(vo);
//		
//		vo.getAuthList().forEach(authVO -> log.info(authVO));
//	}
	
	//회원가입 테스트
	@Test
	public void memberJoin() {
		
		MemberVO member = new MemberVO();
		AuthVO auth = new AuthVO();
		
		member.setMemberId("tester2");
		member.setPw("qwe123");
		member.setMemberName("테스터2");
		member.setPhone("01011113333");
		
		auth.setMemberId("테스터2");
		auth.setAuthName("ROLE_MEMBER");
		
		mapper.registMember(member);
		mapper.giveAuth(auth);
	}
	
}

