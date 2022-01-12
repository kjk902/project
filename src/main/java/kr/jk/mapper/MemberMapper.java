package kr.jk.mapper;

import java.util.List;

import kr.jk.domain.AuthVO;
import kr.jk.domain.BoardVO;
import kr.jk.domain.Criteria;
import kr.jk.domain.MemberVO;

public interface MemberMapper {
	
	//C
	//회원 가입
	public void registMember(MemberVO vo);	
	
	//회원 권한부여
	public void giveAuth(AuthVO auth);					
	
	//R
	//회원 정보 및 권한 조회
	public MemberVO read(String memberId);
	
	//U
	//회원 정보 수정
	public int updateProfile(MemberVO vo);				
	
	//D
	//회원 탈퇴
	public int resign(String memberId); 		
	
	//권한 삭제
	public int deleteAuth(String memberId);
	
	
	//회원 정보 목록
	public List<MemberVO> getMemberList();
	
	//페이징 처리
	public List<MemberVO> getMemberListWithPaging(Criteria cri);
	
	//MyBatis를 이용해서 전체 회원수 처리
	public int getTotalMemberCount(Criteria cri);
}
