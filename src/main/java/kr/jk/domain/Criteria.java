package kr.jk.domain;

import org.springframework.web.util.UriComponentsBuilder;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Criteria {

	private int pageNum;	//페이지 번호
	private int amount;		//한 페이지 당 표시할 게시글 개수

	private String type;	//검색 타입
	private String keyword;	//검색 키워드
	
	
	public Criteria() {
		this(1, 10);	//기본 페이지 번호를 1, 한 페이지 당 10개의 게시물을 보여줌 
	}
	
	public Criteria(int pageNum, int amount) {
		this.pageNum = pageNum;
		this.amount = amount;
	}
	
	//MyBatis의 동적 태그 활용(검색 조건을 배열로 만들어서 한 번에 처리)
	public String[] getTypeArr() {
		return type == null ? new String[] {} : type.split("");
	}
	
	//UriComponentsBuilder(여러 개의 파라미터들을 연결해서 URL의 형태로 만들어줌)
	public String getListLink() {
		UriComponentsBuilder builder = UriComponentsBuilder.fromPath("")
				//queryParam()을 통해서 쉽게 필요한 파라미터를 추가 가능
				.queryParam("pageNum", this.pageNum)			//페이지 번호
				.queryParam("amount", this.getAmount())			//한 페이지 당 표시할 게시글 개수
				.queryParam("type", this.getType())				//검색 타입
				.queryParam("keyword", this.getKeyword());		//검색 키워드
		
		return builder.toUriString();
	}
}
