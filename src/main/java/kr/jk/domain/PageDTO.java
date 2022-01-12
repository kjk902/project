package kr.jk.domain;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class PageDTO {
	
	/*
	 * ★★★★★ 페이징 처리 공식 관련 ★★★★★
	 * 
	 * 페이징의 끝 번호(endPage) 계산 : this.endPage = (int) (Math.ceil(페이지번호 / 10.0)) * 10;
	 * 
	 * Math.ceil()은 소수점을 올림으로 처리하기 때문에 다음과 같은 상황이 가능하다.
	 * 1페이지의 경우 : Math.ceil(0.1) * 10 = 10	//1 * 10 = 10
	 * 10페이지의 경우 : Math.ceil(1) * 10 = 10		//1 * 10 = 10
	 * 11페이지의 경우 : Math.ceil(1.1) * 10 = 20	//2 * 10 = 20
	 * 
	 * 화면에 10개씩 보여준다면 시작 번호(startPage)는 무조건 끝 번호(endPage)에서 9라는 값을 뺀 값이 된다.
	 * 페이징의 시작 번호(startPage)계산 : this.startPage = this.endPage - 9;
	 * 
	 * 끝 번호는(endPage)는 전체 데이터 수(total)에 의해서 영향을 받는다.
	 * 예들 들어, 10개씩 보여주는 경우 전체 데이터수(total)가 80개라고 가정하면 끝 번호(endPage)는 10이 아닌 8이 되어야만 한다.
	 * 
	 * ※ 만일 끝 번호(endPage)와 한 페이지당 출력되는 데이터 수(amount)의 곱이 전체 데이터 수(total)보다 크다면 끝번호(endPage)는 다시 total을 이용해서 다시 계산되어야 한다.
	 * 
	 * total을 통한 endPage의 재계산 :
	 * realEnd = (int) (Math.ceil(total * 1.0) / amount) );
	 * if(realEnd < this.endPage) {
	 * 		this.endPage = realEnd;
	 * }
	 * 먼저 전체 데이터 수(total)를 이용해서 진짜 끝 페이지(realEnd)가 몇 번까지 되는지를 계산한다.
	 * 만일 진짜 끝 페이지(realEnd)가 구해둔 끝번호(endPage)보다 작다면 끝 번호는 작은 값이 되어야만 한다.
	 * 
	 * 이전(prev) 계산 : this.prev = this.startPage > 1;
	 * 이전(prev)의 경우는 시작 번호(startPage)가 1보다 큰 경우라면 존재하게 된다.
	 * 
	 * 다음(next) 계산 : this.next = this.endPage < realEnd;
	 * 다음(next)으로 가는 링크의 경우 realEnd가 끝 번호(endPage)보다 큰 경우에만 존재하게 된다.
	 */

	private int startPage;		//시작 페이지 번호
	private int endPage;		//끝 페이지 번호
	private boolean prev, next; //이전 페이지와 다음 페이지 존재 여부
	
	private int total;			//전체 게시물 개수
	private Criteria cri;		//pageNum과 amount 변수가 선언된 클래스
	
	public PageDTO(Criteria cri, int total) {	//Criteria와 전체 데이터 수(total)를 파라미터로 지정
		
		this.cri = cri;
		this.total = total;
		
		this.endPage = (int) ( Math.ceil(cri.getPageNum() / 10.0) ) * 10;
		this.startPage = endPage - 9;
		
		int realEnd = (int) ( Math.ceil( (total*1.0 / cri.getAmount()) ) );
		
		if(realEnd < this.endPage) {
			this.endPage = realEnd;
		}
		
		this.prev = this.startPage > 1;
		this.next = this.endPage < realEnd;
		
	}
}
