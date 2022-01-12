package kr.jk.controller;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@Log4j
@ContextConfiguration({"file:src/main/webapp/WEB-INF/spring/root-context.xml",
		"file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml"})
public class BoardControllerTests {

	@Setter(onMethod_ = @Autowired)
	private WebApplicationContext ctx;
	
	private MockMvc mockMvc;
	
	
	//모든 테스트 전에 실행되는 메소드
	@Before		//import org.junit.Before;
	public void setup() {
		this.mockMvc = MockMvcBuilders.webAppContextSetup(ctx).build();
	}
	
	
	//게시글 목록 조회 테스트
//	@Test
//	public void testList() throws Exception {
//		
//		log.info(
//				mockMvc.perform(MockMvcRequestBuilders.get("/board/list"))
//				.andReturn().getModelAndView().getModelMap());
//	}
	
	
	//게시글 목록 조회 테스트(페이징 처리까지)
//	@Test
//	public void testListPaging() throws Exception {
//		
//		log.info(mockMvc.perform(MockMvcRequestBuilders.get("/board/list")
//				.param("pageNum", "3")		//페이지 번호
//				.param("amount", "10"))		//페이지 당 출력할 게시물 갯수
//				.andReturn().getModelAndView().getModelMap());
//		
//	}
	
	//게시글 등록 테스트
//	@Test
//	public void testRegister() throws Exception {
//		
//		String resultPage = mockMvc.perform(MockMvcRequestBuilders.post("/board/register")
//				.param("title", "프레젠테이션 제목")			//POST 방식의 파라미터 전달 (http://localhost/board/register?title=""&content=""&writer="")
//				.param("content", "프레젠테이션 내용")
//				.param("writer", "presentation user"))
//				.andReturn().getModelAndView().getViewName();
//				
//		log.info(resultPage);
//	}
	
	
	//게시글 수정 테스트
//	@Test
//	public void testModify() throws Exception {
//		
//		String resultPage = mockMvc.perform(MockMvcRequestBuilders.post("/board/modify")
//				.param("bno", "3")		//수정할 게시글 번호(MockMvc를 이용해서 파라미터를 전달할 때에는 문자열로만 처리)
//				.param("title", "프레젠테이션 수정 제목")
//				.param("content", "프레젠테이션 수정 내용"))
//				.andReturn().getModelAndView().getViewName();		
//		
//		log.info(resultPage);
//	}
	
	
	//게시글 삭제 테스트
//	@Test
//	public void testRemove() throws Exception {
//		
//		String resultPage = mockMvc.perform(MockMvcRequestBuilders.post("/board/remove")
//				.param("bno", "2"))		//삭제할 게시글 번호
//				.andReturn().getModelAndView().getViewName();
//		
//		log.info(resultPage);
//	}
	
	
}
