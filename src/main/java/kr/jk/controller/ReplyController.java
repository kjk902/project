package kr.jk.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import kr.jk.domain.Criteria;
import kr.jk.domain.ReplyPageDTO;
import kr.jk.domain.ReplyVO;
import kr.jk.service.ReplyService;
import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@RestController					//메소드의 리턴 타입으로 사용자가 정의한 클래스 타입을 사용, JSON이나 XML로 자동 처리 가능(데이터 포맷과 데이터 타입을 명확히 해야함)
@RequestMapping("/replies/")	//브라우저에서 http://localhost/replies/...
@Log4j
@AllArgsConstructor				//생성자 자동 생성
public class ReplyController {

	//@Setter(onMethod_ = @Autowired)
	private ReplyService service;
	
	
	//C
	//댓글 등록
	@PostMapping(value = "/new",						//브라우저에서 http://localhost/replies/new
			consumes = "application/json",				//JSON 방식의 데이터만 처리
			produces = { MediaType.TEXT_PLAIN_VALUE })	//문자열 반환
	//스프링 시큐리티 처리
	@PreAuthorize("isAuthenticated()")
	//리턴 타입을 ResponseEntity로 지정
	/* URL상에서 데이터를 전달하는 경우(form 태그 등)에는 @RequestParam을 이용하고,
	 * 실제 등록되는 데이터가 JSON이나 XML 포맷인 경우에는 @RequestBody 이용(객체 생성 가능) */
	public ResponseEntity<String> create(@RequestBody ReplyVO vo) {	
		
		log.info("ReplyVO: " + vo);
		
		int insertCount = service.register(vo);	//댓글이 등록되면 1리턴
		
		log.info("댓글 등록: " + insertCount);
		
		//삼항 연산자 처리 : 댓글 등록이 정상적으로 처리되면 ResponseEntity를 통해 HTTP 헤더에 OK 메시지를 전달, 그렇지 않으면 에러 메시지를 전달함
		return insertCount == 1 ? new ResponseEntity<String>("success", HttpStatus.OK) :
									new ResponseEntity<String>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	
	//R
	//게시글의 댓글 조회
	@GetMapping(value = "/{rno}",									//ex.브라우저에서 http://localhost/replies/10(댓글번호)
			produces = { MediaType.APPLICATION_JSON_UTF8_VALUE,		//JSON 방식으로 데이터 처리(스프링 5.2버전 이상부터는 APPLICATION_JSON_VALUE로 작성), 브라우저에서 URL 마지막에 .json 작성
							MediaType.APPLICATION_XML_VALUE })		//XML 방식으로 데이터 처리, 브라우저에서 URL 마지막에 .xml 작성
	public ResponseEntity<ReplyVO> get(
			@PathVariable("rno") Long rno) {						//URL 상에 경로의 일부를 파라미터로 사용
		
		log.info("조회할 댓글 번호: " + rno);
		
		return new ResponseEntity<ReplyVO>(service.get(rno), HttpStatus.OK);
	}
	
	//게시글의 댓글 목록 조회
	@GetMapping(value ="/pages/{bno}/{page}",						//ex.브라우저에서 http://localhost/replies/489(게시글번호)/1(페이지번호)
			produces = { MediaType.APPLICATION_JSON_UTF8_VALUE,		
							MediaType.APPLICATION_XML_VALUE })		
	//ResponseEntity를 이용해서 리스트 타입으로 댓글 목록(페이징 처리)을 받아냄
	public ResponseEntity<ReplyPageDTO> getList(
			@PathVariable("page") int page,
			@PathVariable("bno") Long bno) {
		
		log.info("댓글 조회");
		
		Criteria cri = new Criteria(page, 10);	//한 페이지당 표시할 댓글 개수는 10
		
		log.info(bno);
		
		log.info(cri);
		
		return new ResponseEntity<ReplyPageDTO>(service.getListPage(cri, bno), HttpStatus.OK);
	}
	
	
	//U
	//댓글 수정
	/* 댓글의 수정은 PUT 방식이나 PATCH 방식을 이용 
	 * PATCH는 일부를 수정할 때, PUT은 전체를 수정할 때 */
	@RequestMapping(method = { RequestMethod.PUT, RequestMethod.PATCH },
			value = "/{rno}",
			consumes = "application/json")
	//스프링 시큐리티 처리
	@PreAuthorize("principal.username == #vo.replyer")
	public ResponseEntity<String> modify(
			@RequestBody ReplyVO vo,			//reply.js에서 JSON 타입으로 처리 된 댓글 내용 데이터를 받음
			@PathVariable("rno") Long rno) {
		
		vo.setRno(rno);
		log.info("수정할 댓글 번호: " + rno);
		log.info("수정한 댓글: " + vo);
		
		return service.modify(vo) == 1 ? new ResponseEntity<String>("success", HttpStatus.OK) :
											new ResponseEntity<String>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	
	//D
	//댓글 삭제
	@DeleteMapping(value = "/{rno}")
	//스프링 시큐리티 처리
	@PreAuthorize("principal.username == #vo.replyer or hasRole('ROLE_ADMIN')")	//작성자 또는 관리자만 삭제 가능
	public ResponseEntity<String> remove(
			@RequestBody ReplyVO vo,			//reply.js에서 JSON 타입으로 처리 된 댓글번호와 댓글작성자 데이터를 받음
			@PathVariable("rno") Long rno) {
		
		log.info("삭제할 댓글: " + rno);
		log.info("댓글 작성자: " + vo.getReplyer());
		
		return service.remove(rno) == 1 ? new ResponseEntity<String>("success", HttpStatus.OK) :
											new ResponseEntity<String>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
}
