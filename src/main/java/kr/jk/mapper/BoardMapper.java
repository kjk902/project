package kr.jk.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import kr.jk.domain.BoardVO;
import kr.jk.domain.Criteria;

public interface BoardMapper {
	
	//C
	//게시글 등록시 게시글번호까지 표시
	public void insertSelectKey(BoardVO board);
	
	
	//R
	//게시글 목록
	public List<BoardVO> getList();
	//게시글 읽기
	public BoardVO read(Long bno);
	
	
	//U
	//게시글 수정
	public int update(BoardVO board);
	
	
	//D
	//게시글 삭제
	public int delete(Long bno);
	
	
	//페이징 처리
	public List<BoardVO> getListWithPaging(Criteria cri);
	
	//MyBatis를 이용해서 전체 게시물의 개수 처리
	//게시글 목록과 전체 게시글 개수는 항상 같이 동작하기 때문에 Criteria를 파라미터로 지정 
	public int getTotalCount(Criteria cri);
	
	//댓글 개수 처리
	//2개 이상의 데이터 전달을 위해 @Param을 사용하고 amount는 댓글의 증가나 감소를 의미(댓글이 추가되면 1, 감소하면 -1)
	public void updateReplyCnt(@Param("bno") Long bno, @Param("amount") int amount);
}
