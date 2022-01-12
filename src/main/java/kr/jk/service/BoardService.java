package kr.jk.service;

import java.util.List;

import kr.jk.domain.BoardAttachVO;
import kr.jk.domain.BoardVO;
import kr.jk.domain.Criteria;

public interface BoardService {

	//C
	//게시글 등록
	public void register(BoardVO board);


	//R
	//게시글 목록 조회(페이징 처리를 위해 Criteria 타입의 파라미터 지정)
	public List<BoardVO> getList(Criteria cri);
	//게시글 조회
	public BoardVO get(Long bno);
	
	
	//U
	//게시글 수정
	public boolean modify(BoardVO board);
	
	
	//D
	//게시글 삭제
	public boolean remove(Long bno);
	
	
	//MyBatis를 이용해서 전체 게시물의 개수 처리
	//게시글 목록과 전체 게시글 개수는 항상 같이 동작하기 때문에 Criteria를 파라미터로 지정 
	public int getTotal(Criteria cri);
	
	
	//특정 게시물 번호로 첨부파일 조회
	public List<BoardAttachVO> getAttachList(Long bno);
}
