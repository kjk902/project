package kr.jk.service;


import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.jk.domain.AuthVO;
import kr.jk.domain.Criteria;
import kr.jk.domain.MemberVO;
import kr.jk.mapper.MemberMapper;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class MemberServiceImpl implements MemberService {

		@Setter(onMethod_ = @Autowired)
		private MemberMapper mapper;
		
		//C
		//회원가입
		@Override
		public void join(MemberVO vo) {
			
			log.info(vo);
			mapper.registMember(vo);
		}
		
		//권한 부여
		@Override
		public void giveRole(AuthVO auth) {
			
			log.info(auth);
			mapper.giveAuth(auth);
		}

		
		//R
		//회원 정보 목록 조회(페이징 처리를 위해 Criteria 타입의 파라미터 지정)
		@Override
		public List<MemberVO> getMemberList(Criteria cri) {
			
			log.info("회원 정보 목록 조회(페이징 처리): " + cri);
			
			return mapper.getMemberListWithPaging(cri);
		}

		
		//MyBatis를 이용해서 전체 회원수 처리
		@Override
		public int getTotalMember(Criteria cri) {
			
			return mapper.getTotalMemberCount(cri);
		}

		
		//U
		//회원 정보 수정 
		@Override
		public boolean modifyProfile(MemberVO vo) {
			
			boolean modifyResult = mapper.updateProfile(vo) == 1;	//수정이 완료되면 1리턴
			
			return modifyResult;
		}

		
		//D
		//회원 탈퇴
		@Override
		public boolean resignMember(String memberId) {
			
			log.info("탈퇴한 회원 아이디: " + memberId);
			
			return mapper.resign(memberId) == 1;	//탈퇴가 완료되면 1리턴
		}
		
		//권한 삭제
		@Override
		public boolean deleteRole(String memberId) {
			
			return mapper.deleteAuth(memberId) == 1;
		}
		
}
