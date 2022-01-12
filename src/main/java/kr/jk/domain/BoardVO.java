package kr.jk.domain;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class BoardVO {
	
	private Long bno;			//게시글 번호
	private String title;		//게시글 제목
	private String writer;		//게시글 작성자
	private String content;		//게시글 내용
	private Date regDate;		//게시글 작성일
	private Date updateDate;	//게시글 수정일
	private Long replyCnt;		//게시글에 달린 댓글 수
	
	private List<BoardAttachVO> attachList;	//등록시 한 번에 BoardAttachVO를 처리하기 위한 리스트
}
