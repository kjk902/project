package kr.jk.controller;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
//import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.jk.domain.BoardAttachVO;
import kr.jk.domain.BoardVO;
import kr.jk.domain.Criteria;
import kr.jk.domain.PageDTO;
import kr.jk.service.BoardService;
import lombok.AllArgsConstructor;
//import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/board*")		//브라우저에서 URI http://localhost/board/...
@AllArgsConstructor				//생성자 자동 생성
//프레젠테이션(웹) 영역
public class BoardController {

	//@Setter(onMethod_ = @Autowired)
	private BoardService service;
	
	
	//C
	//게시글 등록
	@PostMapping("/register")	//bno, title, content, writer 등 정보를 넘기기 떄문에 POST 방식 사용
	//스프링 시큐리티 처리
	@PreAuthorize("isAuthenticated()")	//로그인한 회원만 게시물 등록 가능
	public String register(BoardVO board, RedirectAttributes rttr) {
		
		log.info("등록 : "  + board);
		
		//업로드된 첨부파일 데이터 확인
		log.warn("----------------------------------------------------");
		if(board.getAttachList() != null) {
			board.getAttachList().forEach(attach -> log.warn(attach));
		}
		log.warn("----------------------------------------------------");
		
		service.register(board);
		
		rttr.addFlashAttribute("result", board.getBno());	//result에 글번호를 전달(일회성)
		
		return "redirect:/board/list";	//등록 작업이 끝난 후 게시판 목록으로 이동
	}
	
	//등록페이지 이동
	@GetMapping("/register")
	//스프링 시큐리티 처리
	@PreAuthorize("isAuthenticated()")	//로그인한 회원만 게시물 등록 가능
	public void register() {
		//게시글 등록 페이지를 보여주는 역할만을 하기 때문에 별도의 처리가 필요하지 않음
	}
	
	
	//R
	//게시판 메인(게시글 목록)(페이징 처리를 위해 Criteria 타입의 파라미터 추가)
	@GetMapping("/list") 	//	http://localhost/board/list
	public void list(Criteria cri, Model model) {	//BoardServiceImpl 객체를 담기 위해 Model 타입의 파라미터 사용
		log.info("게시글 목록(페이징 처리): " + cri);
		
		model.addAttribute("list", service.getList(cri));	//addFlashAttribute와 다르게 데이터가 유지됨
		
		int total = service.getTotal(cri);	//전체 게시글 개수를 total 변수로 선언
		log.info("전체 게시글 개수: " + total);
		
		model.addAttribute("pageMaker", new PageDTO(cri, total));	//pageMaker라는 이름으로 PageDTO 클래스의 객체를 생성해서 Model에 담아줌
	}
	
	//게시글 조회(수정/삭제 페이지 이동)
	@GetMapping({"/get", "/modify"})	//URI를 배열로 처리
	/* @ModelAttribute를 이용하여 Model에 Criteria 클래스의 pageNum과 amount를 cri라는 이름으로 Model에
	 	담아서 조회 페이지에서 목록 페이지로 이동했을 때 사용자가 보던 페이지를 유지하게 함 */
	public void get(@RequestParam("bno") Long bno, @ModelAttribute("cri") Criteria cri, Model model) {
		log.info("조회 또는 수정");
		model.addAttribute("board", service.get(bno));
	}
	
	
	//U
	//게시글 수정
	//UriComponentsBuilder 사용
	@PostMapping("/modify")
	//스프링 시큐리티 처리
	@PreAuthorize("principal.username == #board.writer")
	public String modify(BoardVO board, Criteria cri, RedirectAttributes rttr) {
		
		log.info("수정 : " + board);
		
		if(service.modify(board)) {	//service의 수정이 true면
			rttr.addFlashAttribute("result", "success");	
		}

		//UriComponentsBuilder 사용
		/*
		 * //게시글 수정 후 목록 페이지로 이동할 때 pageNum과 amount 각각에 데이터를 담아서 유지하여 사용자가 보던 페이지를 유지함
		 * rttr.addAttribute("pageNum", cri.getPageNum()); rttr.addAttribute("amount",
		 * cri.getAmount());
		 * 
		 * //수정 작업 후에도 검색 조건과 키워드 유지 rttr.addAttribute("type", cri.getType());
		 * rttr.addAttribute("keyword", cri.getKeyword());
		 */
		
		return "redirect:/board/list" + cri.getListLink();	//수정 작업이 끝난 후 게시판 목록으로 이동
	}
	
	
	//D
	//게시글 삭제
	@PostMapping("/remove")
	//스프링 시큐리티 처리
	@PreAuthorize("principal.username == #writer or hasRole('ROLE_ADMIN')")	//작성자 또는 관리자만 삭제 가능
	public String remove(@RequestParam("bno") Long bno, Criteria cri, RedirectAttributes rttr, String writer) {	//게시글의 번호(bno)를 이용하여 삭제처리하기 때문에 @RequestParam 사용, 작성자만 삭제가 가능하도록 writer 파라미터 추가
		
		log.info("삭제 : " + bno);
		
		List<BoardAttachVO> attachList = service.getAttachList(bno);
		
		if(service.remove(bno)) {	//service의 삭제가 true면
			
			deleteFiles(attachList);	//첨부파일 삭제
			
			rttr.addFlashAttribute("result", "success");
		}
		
		//UriComponentsBuilder 사용
		/*
		 * //게시글 삭제 후 목록 페이지로 이동할 때 pageNum과 amount 각각에 데이터를 담아서 유지하여 사용자가 보던 페이지를 유지함
		 * rttr.addAttribute("pageNum", cri.getPageNum()); rttr.addAttribute("amount",
		 * cri.getAmount());
		 * 
		 * //삭제 작업 후에도 검색 조건과 키워드 유지 rttr.addAttribute("type", cri.getType());
		 * rttr.addAttribute("keyword", cri.getKeyword());
		 */
		
		return "redirect:/board/list" + cri.getListLink();	//삭제 작업이 끝난 후 게시판 목록으로 이동
	}
	
	
	
	//특정 게시물 번호로 첨부파일 조회
	@GetMapping(value = "/getAttachList",
				produces = MediaType.APPLICATION_JSON_UTF8_VALUE)	//첨부파일 데이터를 JSON으로 반환
	@ResponseBody	//@RestController을 사용하지 않기 때문에 적용
	public ResponseEntity<List<BoardAttachVO>> getAttachList(Long bno) {
		
		log.info("getAttachList" + bno);
		
		return new ResponseEntity<List<BoardAttachVO>>(service.getAttachList(bno), HttpStatus.OK);
	}
	
	
	
	//게시글 삭제시 첨부파일 삭제
	private void deleteFiles(List<BoardAttachVO> attachList) {
		
		if(attachList == null || attachList.size() == 0) {	//첨부파일이 없는 경우
			return;
		}
		
		log.info("delete attach files.............");
		log.info(attachList);
		
		attachList.forEach(attach -> {
			
			try {
				Path file = Paths.get("C:\\upload\\" + attach.getUploadPath() + "\\" + attach.getUuid() + "_" + attach.getFileName());
				
				Files.deleteIfExists(file);	//파일이 존재하면 삭제
				
				if(Files.probeContentType(file).startsWith("image")) {	//이미지 파일인 경우
					Path thumbNail = Paths.get("C:\\upload\\" + attach.getUploadPath() + "\\s_" + attach.getUuid() + "_" + attach.getFileName());
					
					Files.delete(thumbNail);	//섬네일 삭제
				}
			} catch (Exception e) {
				log.error("delete file error" + e.getMessage());
			}
		});
	}
}
