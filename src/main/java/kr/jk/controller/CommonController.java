package kr.jk.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import kr.jk.service.MemberService;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
public class CommonController {
	
	@Setter(onMethod_ = @Autowired)
	private MemberService memberService;
	

	//accessDenied 인터페이스를 구현하여 에러 페이지 처리
	@GetMapping("/accessError")
	public void accessDenied(Authentication auth) {
		
		log.warn("거부된 접근 권한");
	}
	
	
	//스프링 시큐리티의 기본 로그인 페이지가 아닌 커스텀 로그인 페이지
	@GetMapping("/customLogin")
	public void loginInput(String error) {
		
		log.info("로그인");
	}

	
	//로그아웃 처리
	@GetMapping("/customLogout")
	public void logoutGET() {
		
		log.info("로그아웃");
	}
	
	
	//에러 페이지 처리
	@GetMapping("/errorPage")
	public void errorPage() {
		
		log.warn("에러 발생");
	}
}
