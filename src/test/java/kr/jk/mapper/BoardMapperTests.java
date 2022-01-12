package kr.jk.mapper;

import java.util.List;

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
public class BoardMapperTests {

	@Setter(onMethod_ = @Autowired)
	private BoardMapper mapper;
	
	//게시글 목록 출력 테스트
//	@Test
//	public void testGetList() {
//		mapper.getList().forEach(board -> log.info(board));
//	}
	
	
	//게시글 등록 처리 테스트
//	@Test
//	public void testInsert() {
//		BoardVO board = new BoardVO();
//		board.setTitle("게시글 등록");
//		board.setContent("게시글 등록");
//		board.setWriter("user00");
//		
//		mapper.insert(board);
//		
//		log.info(board);
//	}
	
	
	//게시글 번호 값 처리 테스트
//	@Test
//	public void testInsertSelectKey() {
//		
//		BoardVO board = new BoardVO();		
//		board.setTitle("새글 번호");
//		board.setContent("새글 내용");
//		board.setWriter("user01");
//		
//		mapper.insertSelectKey(board);
//		
//		log.info(board);
//	}
	
	
	//게시글번호를 이용한 게시글 읽기 테스트
//	@Test
//	public void testRead() {
//		
//		BoardVO board = mapper.read(5L);
//		
//		log.info(board);
//	}
	
	
	//게시글 삭제
//	@Test
//	public void testDelete() {
//		
//		log.info("delete bno: " + mapper.delete(5L));
//		
//	}
	
	
	//게시글 수정
//	@Test
//	public void testUpdate() {
//		
//		BoardVO board = new BoardVO();
//		board.setBno(4L);
//		board.setTitle("수정된 제목");
//		board.setContent("수정된 내용");
//		board.setWriter("updated user");
//		
//		int count = mapper.update(board);
//		log.info("update count: " + count);
//	}
	
	
	
	//페이징 처리 테스트
//	@Test
//	public void testPaging() {
//		Criteria cri = new Criteria();
//		
//		cri.setPageNum(2);
//		cri.setAmount(10);
//		
//		List<BoardVO> list = mapper.getListWithPaging(cri);
//		
//		list.forEach(board -> log.info(board));
//	}
	
	
	//검색 조건 처리를 위한 동적SQL 테스트
//	@Test
//	public void testSearch() {
//		Criteria cri = new Criteria();
//		
//		//단일 검색(제목)
//		//cri.setKeyword("1");
//		//cri.setType("T");
//		
//		//다중 검색(제목 + 내용)
//		cri.setKeyword("1");
//		cri.setType("TC");
//		
//		List<BoardVO> list = mapper.getListWithPaging(cri);
//		list.forEach(board -> log.info(board));
//	}
	
	
	
	
	
	
	
}
