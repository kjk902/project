package kr.jk.service;

import java.util.List;

import kr.jk.domain.AuthVO;
import kr.jk.domain.Criteria;
import kr.jk.domain.MemberVO;

public interface MemberService {
	
	//C
	//회원가입
	public void join(MemberVO vo);			
	
	//권한 부여
	public void giveRole(AuthVO auth);
	
	//U
	//회원 정보 수정
	public boolean modifyProfile(MemberVO vo);
	
	//D
	//회원탈퇴
	public boolean resignMember(String memberId);
	
	//권한삭제
	public boolean deleteRole(String memberId);
	
	
	//회원 정보 목록 조회(페이징 처리를 위해 Criteria 타입의 파라미터 지정)
	public List<MemberVO> getMemberList(Criteria cri);
	
	//MyBatis를 이용해서 전체 회원수 처리
	public int getTotalMember(Criteria cri);
}
