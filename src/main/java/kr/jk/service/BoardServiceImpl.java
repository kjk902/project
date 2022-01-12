package kr.jk.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.jk.domain.BoardAttachVO;
import kr.jk.domain.BoardVO;
import kr.jk.domain.Criteria;
import kr.jk.mapper.BoardAttachMapper;
import kr.jk.mapper.BoardMapper;
import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class BoardServiceImpl implements BoardService{

	@Setter(onMethod_ = @Autowired)
	private BoardMapper mapper;
	
	//첨부파일 업로드
	@Setter(onMethod_ = @Autowired)
	private BoardAttachMapper attachMapper;

	
	//C
	//게시글 등록
	@Transactional	//tbl_board, tbl_attach 양쪽 테이블에 insert를 위해 트랜잭션 처리
	@Override
	public void register(BoardVO board) {
		
		log.info("게시글 등록(게시글번호 표시): " + board);
		
		mapper.insertSelectKey(board);
		
		if(board.getAttachList() == null || board.getAttachList().size() <= 0) {	//첨부파일 데이터가 없는 경우
			return;
		}
		board.getAttachList().forEach(attach -> {
			
			attach.setBno(board.getBno());
			attachMapper.insert(attach);
		});
		
	}

	
	//R
	//게시글 조회
	//페이징 처리를 위해 Criteria 타입의 파라미터 지정
	@Override
	public List<BoardVO> getList(Criteria cri) {
		
		log.info("게시글 목록 조회(페이징 처리): " + cri);
		
		return mapper.getListWithPaging(cri);
	}
	@Override
	public BoardVO get(Long bno) {

		log.info("읽을 게시글 번호: " + bno);
		
		return mapper.read(bno);
	}

	
	//U
	//게시글 수정
	@Transactional	//tbl_board, tbl_attach 양쪽 테이블에 update를 위해 트랜잭션 처리
	@Override
	public boolean modify(BoardVO board) {
		log.info("수정할 게시글: " + board);
		
		attachMapper.deleteAll(board.getBno());	//첨부파일 모두 삭제
		
		boolean modifyResult = mapper.update(board) == 1;	//수정이 완료되면 1리턴
		
		//업로드된 첨부파일이 있는 경우 첨부파일 등록
		if(modifyResult && board.getAttachList() != null && board.getAttachList().size() > 0) {
			board.getAttachList().forEach(attach -> {
				
				attach.setBno(board.getBno());
				attachMapper.insert(attach);
			});
		}
		
		return modifyResult;
	}

	
	//D
	//게시글 삭제
	@Transactional	//tbl_board, tbl_attach 양쪽 테이블에 delete를 위해 트랜잭션 처리
	@Override
	public boolean remove(Long bno) {
		log.info("삭제할 게시글 번호: " + bno);
		
		attachMapper.deleteAll(bno);
		
		return mapper.delete(bno) == 1;		//삭제가 완료되면 1 리턴
	}


	//MyBatis에서 전체 데이터의 개수 처리
	@Override
	public int getTotal(Criteria cri) {
		log.info("게시글 전체 개수");
		return mapper.getTotalCount(cri);
	}


	//특정 게시물 번호로 첨부파일 조회
	@Override
	public List<BoardAttachVO> getAttachList(Long bno) {
		log.info("게시글 번호를 통해서 첨부파일 목록 조회" + bno);
		
		return attachMapper.findByBno(bno);
	}
}
