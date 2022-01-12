package kr.jk.mapper;

import java.util.List;

import kr.jk.domain.BoardAttachVO;

public interface BoardAttachMapper {

	//첨부파일 등록
	public void insert(BoardAttachVO vo);
	
	//첨부파일 삭제
	public void delete(String uuid);
	
	//특정 게시물 번호로 첨부파일 조회
	public List<BoardAttachVO> findByBno(Long bno);
	
	//게시글 삭제시 첨부파일 삭제
	public void deleteAll(Long bno);
	
	//어제 등록된 파일목록 가져오기
	public List<BoardAttachVO> getOldFiles();
}
