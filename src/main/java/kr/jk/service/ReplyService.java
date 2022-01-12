package kr.jk.service;

import java.util.List;

import kr.jk.domain.Criteria;
import kr.jk.domain.ReplyPageDTO;
import kr.jk.domain.ReplyVO;

public interface ReplyService {

	//C
	//댓글 등록
	public int register(ReplyVO vo);
	
	
	//R
	//댓글 조회
	public ReplyVO get(Long rno);
	
	//댓글 목록 조회
	public List<ReplyVO> getList(Criteria cri, Long bno);
	
	//댓글 개수 파악
	public ReplyPageDTO getListPage(Criteria cri, Long bno);
	
	
	//U
	//댓글 수정
	public int modify(ReplyVO vo);
	
	
	//D
	//댓글 삭제
	public int remove(Long rno);
}
