package kr.jk.controller;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.jk.domain.AuthVO;
import kr.jk.domain.Criteria;
import kr.jk.domain.MemberVO;
import kr.jk.domain.PageDTO;
import kr.jk.service.MemberService;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
public class MemberContoller {

	@Setter(onMethod_ = @Autowired)
	private MemberService service;
	
	// 패스워드 암호화를 위한 BcryptPasswordEncoder
	@Setter(onMethod_ = @Autowired)
	private PasswordEncoder pwencoder;

	
	//회원가입 페이지 이동
	@GetMapping("/join")
	public void memberJoin() {
	}
	
	
	//C
	//회원가입 처리
	@PostMapping("/memberJoin")
	public String memberJoin(MemberVO vo, AuthVO auth) {
		
		log.info("권한 부여" + auth);
		log.info("회원가입" + vo);
		
		//BcryptPasswordEncoder
		String password = vo.getPw();
		String pwd = pwencoder.encode(password);
		vo.setPw(pwd);
		
		service.join(vo);			//회원정보 입력
		service.giveRole(auth);		//회원 권한 부여
		
		return "redirect:/customLogin";
	}
	
	
	//R
	//회원 정보 목록 조회(페이징 처리를 위해 Criteria 타입의 파라미터 추가)
	@GetMapping("/memberManage")
	@PreAuthorize("hasRole('ROLE_ADMIN')")	//관리자만 조회가능
	public void memberList(Criteria cri, Model model) {	//BoardServiceImpl 객체를 담기 위해 Model 타입의 파라미터 사용
		log.info("회원 정보 목록(페이징 처리): " + cri);
		
		model.addAttribute("memberList", service.getMemberList(cri));	//addFlashAttribute와 다르게 데이터가 유지됨
		
		int total = service.getTotalMember(cri);	//전체 회원수를 total 변수로 선언
		log.info("전체 회원수: " + total);
		
		model.addAttribute("memberPageMaker", new PageDTO(cri, total));	//pageMaker라는 이름으로 PageDTO 클래스의 객체를 생성해서 Model에 담아줌
	}
	
	
	//회원정보 페이지 이동
	@GetMapping("/memberProfile")
	@PreAuthorize("hasRole('ROLE_MEMBER')")
	public void getMemberProfile() {
	}
	
	
	//U
	//회원정보 수정
	@PostMapping("/profileModify")
	@PreAuthorize("hasRole('ROLE_MEMBER')")
	public String modifyMemberInfo(MemberVO vo, RedirectAttributes rttr) {
		
		//BcryptPasswordEncoder(패스워드 수정시)
		String password = vo.getPw();
		String pwd = pwencoder.encode(password);
		vo.setPw(pwd);
		
		if(service.modifyProfile(vo)) {
			rttr.addFlashAttribute("result", "success");	
		}
		
		return "redirect:/board/list";
	}
	
	
	//D
	//회원 탈퇴
	@PostMapping("/resign")
	@PreAuthorize("hasAnyRole('ROLE_MEMBER', 'ROLE_ADMIN')")
	public String remove(@RequestParam("memberId") String memberId, RedirectAttributes rttr, Model model) {
	
		model.addAttribute("memberId", memberId);
		
		if(service.resignMember(memberId) && service.deleteRole(memberId)) {
			rttr.addFlashAttribute("result", "success");
		}
		
		return "redirect:/customLogout";
	}
}
