package kr.jk.security;

import java.util.Collection;
import java.util.stream.Collectors;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import kr.jk.domain.MemberVO;

import lombok.Getter;

@Getter
//org.springframework.security.core.userdetails.User 클래스 상속
public class CustomUser extends User {

	private static final long serialVersionUID = 1L;
	
	private MemberVO member;
	
	public CustomUser(String username, String password,
			Collection<? extends GrantedAuthority> authorities) {
		super(username, password, authorities);
	}
	
	//AuthVO 인스턴스를 GrantedAuthority 객체로 변환
	public CustomUser(MemberVO vo) {
		super(vo.getMemberId(), vo.getPw(),vo.getAuthList().stream()
				.map(auth -> new SimpleGrantedAuthority(auth.getAuthName())).
				collect(Collectors.toList()));
		
		this.member = vo;
	}
}