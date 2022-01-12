package kr.jk.domain;

import lombok.Data;

@Data
public class AuthVO {
	
	private String memberId;	//회원 아이디
	private String authName;	//권한 이름
}
