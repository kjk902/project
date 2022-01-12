package kr.jk.service;


import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import kr.jk.domain.BoardVO;
import kr.jk.domain.Criteria;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class BoardServiceTests {

	@Setter(onMethod_ = @Autowired)
	private BoardService service;
	
	
	//게시글 등록 테스트
//	@Test
//	public void testRegister() {
//		
//		BoardVO board = new BoardVO();
//		board.setTitle("비즈니스 새글 등록");
//		board.setContent("서비스");
//		board.setWriter("service user");
//		
//		service.register(board);
//		log.info("생성된 게시물 번호 : " + board.getBno());
//		
//	}
	
	
	//게시글 목록 조회 테스트(페이징 처리까지)
//	@Test
//	public void testGetList() {
//		
//		service.getList(new Criteria(3, 10)).forEach(board -> log.info(board));
//	}
	

	//게시글 읽기 테스트
//	@Test
//	public void testRead() {
//		
//		log.info(service.get(3L));
//		
//	}
	
	
	//게시글 삭제 테스트
//	@Test
//	public void testDelete() {
//		
//		log.info(service.remove(7L));
//		
//	}
	
	
	//게시글 수정 테스트
//	@Test
//	public void testUpdate() {
//		
//		BoardVO board = service.get(6L);
//		
//		if(board == null) {
//			return;
//		}
//		
//		board.setTitle("비즈니스 제목 수정");
//		
//		log.info("수정된 게시글" + service.modify(board));
//	}
	
	
	
	
	
	
	
	
	
	
	
	
	
}
