package kr.jk.security;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.access.AccessDeniedHandler;

import lombok.extern.log4j.Log4j;

@Log4j
//AccessDeniedHandler 인터페이스를 구현
//접근이 제한된 경우에 다양한 처리 가능
public class CustomAccessDeniedHandler implements AccessDeniedHandler {

	@Override
	public void handle(HttpServletRequest request, HttpServletResponse response,
			AccessDeniedException accessDeniedException) throws IOException, ServletException {
		
		log.info("Access Denied Handler");
		log.info("Redirect....");
		
		//accessError.jsp로 리다이렉트, 브라우저에서 http://localhost/accessError로 접근됨
		response.sendRedirect("/accessError");
	}
}