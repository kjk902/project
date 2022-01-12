package kr.jk.mapper;

import java.util.List;
import java.util.stream.IntStream;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringRunner;

import kr.jk.domain.Criteria;
import kr.jk.domain.ReplyVO;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class ReplyMapperTests {

	@Setter(onMethod_ = @Autowired)
	private ReplyMapper mapper;
	
	
	//객체 생성 테스트
//	@Test
//	public void testMapper() {
//		log.info(mapper);
//	}
	
	
	//댓글 등록 테스트
	private Long[] bnoArr = {498L, 494L, 492L, 491L, 489L};
//	
//	@Test
//	public void testCreat() {
//		
//		IntStream.rangeClosed(1, 10).forEach(i -> { //1~10 반복
//			
//			ReplyVO vo = new ReplyVO();
//			
//			//게시물 번호
//			vo.setBno(bnoArr[i % 5]);
//			vo.setReply("댓글 테스트" + i);
//			vo.setReplyer("replyer" + i);
//			
//			mapper.insert(vo);
//		});
//	}
	
	
	
	//특정 댓글 조회 테스트
//	@Test
//	public void testRead() {
//		
//		Long targetRno = 27L;
//		
//		ReplyVO vo = mapper.read(targetRno);
//		
//		log.info(vo);
//	}
	
	
	
	//댓글 수정 테스트
//	@Test
//	public void testUpdate() {
//		
//		Long targetRno = 7L;
//		
//		ReplyVO vo = mapper.read(targetRno);
//		
//		vo.setReply("댓글 수정");
//		
//		int count = mapper.update(vo);	//수정이 완료되면 1
//		
//		log.info("수정된 댓글 수: " + count);
//	}
	
	
	
	//댓글 삭제 테스트
//	@Test
//	public void testDelete() {
//		
//		Long targetRno = 5L;
//		
//		mapper.delete(targetRno);
//	}
	

	
	//댓글 목록 조회 테스트
//	@Test
//	public void testList() {
//		
//		Criteria cri = new Criteria();
//		
//		//498번 게시글
//		List<ReplyVO> replies = mapper.getListWithPaging(cri, bnoArr[0]);
//				
//		replies.forEach(reply -> log.info(reply));
//	}
	
	
	
	//댓글 목록 페이징 처리 테스트
//	@Test
//	public void testList2() {
//		
//		Criteria cri = new Criteria(1, 10);
//		
//		//게시글 번호484
//		List<ReplyVO> replies = mapper.getListWithPaging(cri, 484L);
//		
//		replies.forEach(reply -> log.info(reply));
//	}
	
	
	
	
	
	
	
	
	
	
	
}
