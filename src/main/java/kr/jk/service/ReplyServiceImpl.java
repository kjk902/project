package kr.jk.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.jk.domain.Criteria;
import kr.jk.domain.ReplyPageDTO;
import kr.jk.domain.ReplyVO;
import kr.jk.mapper.BoardMapper;
import kr.jk.mapper.ReplyMapper;
//import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class ReplyServiceImpl implements ReplyService {
	
	@Setter(onMethod_ = @Autowired)
	private ReplyMapper mapper;
	
	@Setter(onMethod_ = @Autowired)
	private BoardMapper bMapper;
	
	//C
	//댓글 등록
	//트랜잭션 처리(댓글수의 증가 amount +1)
	@Transactional
	@Override
	public int register(ReplyVO vo) {
		log.info("댓글 등록 " + vo);
		
		//댓글이 등록되면 댓글 개수 1 증가
		bMapper.updateReplyCnt(vo.getBno(), 1);
		
		return mapper.insert(vo);
	}
	
	
	
	//R
	//댓글 조회
	@Override
	public ReplyVO get(Long rno) {
		log.info("조회할 댓글 " + rno);
		return mapper.read(rno);
	}

	//댓글 목록 조회
	@Override
	public List<ReplyVO> getList(Criteria cri, Long bno) {
		log.info("조회할 댓글의 게시글 " + bno);
		return mapper.getListWithPaging(cri, bno);
	}
	
	//댓글 개수 파악
	@Override
	public ReplyPageDTO getListPage(Criteria cri, Long bno) {
		
		return new ReplyPageDTO(mapper.getCountByBno(bno), mapper.getListWithPaging(cri, bno));
	}
	
	
	
	//U
	//댓글 수정
	@Override
	public int modify(ReplyVO vo) {
		log.info("댓글 수정 " + vo);
		return mapper.update(vo);	//수정이 완료되면 1을 리턴
	}

	
	
	//D
	//댓글 삭제
	//트랜잭션 처리(댓글수의 감소 amount -1)
	@Transactional
	@Override
	public int remove(Long rno) {
		log.info("삭제할 댓글 번호: " + rno);
		
		//댓글의 삭제는 전달되는 파라미터가 댓글번호(rno)만을 받기 때문에 해당 게시물을 알아내는 과정이 필요
		ReplyVO vo = mapper.read(rno);
		bMapper.updateReplyCnt(vo.getBno(), -1);
		
		return mapper.delete(rno);	//삭제가 완료되면 1을 리턴
	}
	
}
