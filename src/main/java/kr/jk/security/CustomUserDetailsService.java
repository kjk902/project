package kr.jk.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import kr.jk.domain.MemberVO;
import kr.jk.mapper.MemberMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
//UserDetailsService 인터페이스를 구현
//MemberMapper의 read 기능
public class CustomUserDetailsService implements UserDetailsService {

	@Setter(onMethod_ = @Autowired)
	private MemberMapper memberMapper;

	@Override
	public UserDetails loadUserByUsername(String userName) throws UsernameNotFoundException {
		
		log.warn("회원 아이디를 통한 호출: " + userName);
		
		//userName은 userid를 의미
		MemberVO vo = memberMapper.read(userName);
				
		log.warn("MemberMapper에 의한 쿼리: " + vo);
		
		//데이터베이스에 등록된 회원이 로그인하면 CustomUser를 통해 회원정보가진 객체를 생성
		return vo == null ? null : new CustomUser(vo);
	}
}