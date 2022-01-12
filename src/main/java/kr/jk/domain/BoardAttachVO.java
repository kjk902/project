package kr.jk.domain;

import lombok.Data;

@Data
public class BoardAttachVO {
	
	private String uuid;		//UUID가 포함된 이름
	private String uploadPath;	//실제 파일이 업로드된 경로
	private String fileName;	//파일 이름
	private boolean fileType;	//이미지 파일 여부
	private Long bno;			//해당 게시물 번호 저장
}
