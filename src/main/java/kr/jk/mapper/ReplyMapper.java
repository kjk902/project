package kr.jk.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import kr.jk.domain.Criteria;
import kr.jk.domain.ReplyVO;

public interface ReplyMapper {

	//C
	//댓글 등록
	public int insert(ReplyVO vo);
	
	
	//R
	//특정 댓글 조회
	public ReplyVO read(Long rno);
	
	//댓글 목록 조회(페이징 처리)
	//@Param 어노테이션을 이용한 댓글 페이징 처리(두 개 이상의 데이터를 파라미터로 전달하는 방식)
	public List<ReplyVO> getListWithPaging(
			@Param("cri") Criteria cri,
			@Param("bno") Long bno);

	//댓글의 개수 파악
	public int getCountByBno(Long bno);
	
	
	//U
	//댓글 수정
	public int update(ReplyVO reply);
	
	
	//D
	//댓글 삭제
	public int delete(Long rno);
}
