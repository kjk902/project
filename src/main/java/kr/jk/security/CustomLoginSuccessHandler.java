package kr.jk.security;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

import lombok.extern.log4j.Log4j;

@Log4j
//AuthenticationSuccessHandler 인터페이스를 구현
//로그인한 사용자의 경로 설정과 별도의 쿠키 생성 처리 가능
public class CustomLoginSuccessHandler implements AuthenticationSuccessHandler {
	
	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
			Authentication auth) throws IOException, ServletException {
	
		log.warn("로그인 성공");

		//사용자의 권한을 리스트로 받아냄
		List<String> roleNames = new ArrayList<>();
		
		auth.getAuthorities().forEach(authority -> {
			roleNames.add(authority.getAuthority());
		});
	
		log.warn("사용자 권한 이름: " + roleNames);
		
		response.sendRedirect("/");	//home.jsp로 이동
	}
}