package kr.jk.domain;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class MemberVO {
	private String memberId;	//회원 아이디
	private String pw;			//회원 패스워드
	private String memberName;	//회원 이름
	private String phone;		//회원 휴대폰 번호
	private Date joinDate;		//회원 가입일
	private	int enabled;		//회원 블락 여부(1이면 가능, 0이면 불가능)
	
	private List<AuthVO> authList;	//회원 권한을 리스트 형태로로 담음
}
