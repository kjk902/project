package kr.jk.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import kr.jk.domain.AttachFileDTO;

import lombok.extern.log4j.Log4j;
import net.coobird.thumbnailator.Thumbnailator;

@Controller
@Log4j
public class UploadController {

	//uploadForm.jsp로 이동
	@GetMapping("/uploadForm")
	public void uploadForm() {
		log.info("upload form");
	}
	
	//MultipartFile 타입을 이용한 다중 파일 첨부
	@PostMapping("/uploadFormAction")
	public void uploadFormPost(MultipartFile[] uploadFile, Model model) {	//file타입의 input 태그의 name 속성값인 uploadFile을 변수로 지정 
		
		String uploadFolder = "C:\\upload";	//업로드된 파일이 저장되는 경로 변수 선언
		
		//MultipartFile[] 타입으로 배열 처리된 여러 개의 첨부파일을 향상된 for문 처리
		for(MultipartFile multipartFile : uploadFile) {
			log.info("-------------------------------");
			log.info("Upload File Name: " + multipartFile.getOriginalFilename());	//파일의 이름 출력
			log.info("Upload File Size: " + multipartFile.getSize());				//파일의 크기 출력
			
			//java.io.File 객체를 이용하여 uploadFolder로 지정한 경로에 원래 파일의 이름으로 저장하는 변수 선언
			File saveFile = new File(uploadFolder, multipartFile.getOriginalFilename());
			
			try {
				multipartFile.transferTo(saveFile);	//transferTo()의 파라미터로 File의 객체를 지정하여 원래 파일의 이름으로 upload 폴더에 저장됨
			} catch (Exception e) {
				log.error(e.getMessage());
			}
		}
	}
	
	
	//현재 날짜의 경로를 '년/월/일' 단위의 문자열로 폴더 생성
	private String getFolder() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");	//날짜 포맷을 'yyyy-MM-dd' 형태로 지정
	
		Date date = new Date();
		
		String str = sdf.format(date);	//현재 날짜를 'yyyy-MM-dd'형태의 변수로 선언 
		
		//'-'를 파일 구분자 File.separator로 치환('-' -> '\') (2021\01\01)형태로 하위 폴더 경로 생성
		//File.separator == "\\"
		return str.replace("-", File.separator);	
	} 
	
	
	//이미지 파일의 판단
	private boolean checkImageType(File file) {
		
		try {
			String contentType = Files.probeContentType(file.toPath());	//파일의 확장자 탐색하는 probeContentType(파일경로)
			return contentType.startsWith("image");	//contentType이 이미지면 true 리턴
		} catch(IOException e) {
			e.printStackTrace();
		}
		
		return false;
	}
	
	
	//Ajax -> jQuery를 이용한 첨부파일 전송
	//스프링 시큐리티 처리
	@PreAuthorize("isAuthenticated()")	//로그인한 회원만 게시물 등록 가능
	//JSON 데이터를 반환하도록 변경
	@PostMapping(value = "/uploadAjaxAction",
				produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody	//http요청 body를 자바 객체로 전달
	//AttachFileDTO의 리스트를 반환하는 구조로 변경
	public ResponseEntity<List<AttachFileDTO>> uploadAjaxPost(MultipartFile[] uploadFile) {
		
		List<AttachFileDTO> list = new ArrayList<AttachFileDTO>();	//AttachFileDTO의 리스트 객체 생성
		
		String uploadFolder = "C:\\upload";		//업로드된 파일이 저장되는 경로 변수 선언
	
		String uploadFolderPath = getFolder();
		
		//make folder ---------
		File uploadPath = new File(uploadFolder, uploadFolderPath);
		
		if(uploadPath.exists() == false) {	//해당 경로가 있는지 검사
			uploadPath.mkdirs();	//mkdirs()는 파일 업로드시 저장되는 폴더의 상위 디렉토리까지 생성함 mkdir()은 상위 디렉토리가 없으면 생성 불가
		}
		//make yyyy/MM/dd folder
		
		//MultipartFile[] 타입으로 배열 처리된 여러 개의 첨부파일을 향상된 for문 처리
		for(MultipartFile multipartFile : uploadFile) {
			
			AttachFileDTO attachDTO = new AttachFileDTO();	//AttachFileDTO 객체 생성
			
			String uploadFileName = multipartFile.getOriginalFilename();
			
			//IE has file path(IE의 경우에는 전체 파일 경로가 전송되기 때문에 '\\' 부분을 잘라야함)
			uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\") + 1);	//파일이름에서 "\\"를 지운 것이 실제 파일 이름
			
			log.info("only file name: " + uploadFileName);
			
			attachDTO.setFileName(uploadFileName);	//AttachFileDTO에 업로드 되는 파일 이름을 저장
			
			//파일 이름 중복 방지를 위한 UUID 적용
			UUID uuid = UUID.randomUUID();
			uploadFileName = uuid.toString() + "_" + uploadFileName;	//'임의의 값_파일이름'의 형태
			
			//File saveFile = new File(uploadFolder, uploadFileName);	//java.io.File 객체를 이용하여 uploadFolder로 지정한 경로에 원래 파일의 이름으로 저장하는 변수 선언
			
			try {
				
				File saveFile = new File(uploadPath, uploadFileName);		//java.io.File 객체를 이용하여 uploadFolder로 지정한 경로(mkdirs()를 통해 만들어진 폴더 경로)에 원래 파일의 이름으로 저장하는 변수 선언
				
				multipartFile.transferTo(saveFile);	//transferTo()의 파라미터로 File의 객체를 지정하여 원래 파일의 이름으로 upload 폴더에 저장됨
				
				attachDTO.setUuid(uuid.toString());			//AttachFileDTO에 UUID값 저장
				attachDTO.setUploadPath(uploadFolderPath);	//AttachFileDTO에 업로드 경로 저장
				
				//check image type file
				if(checkImageType(saveFile)) {
					
					attachDTO.setImage(true);	//AttachFileDTO에 이미지 여부를 true로 저장
					
					//파일을 바이트 단위로 데이터를 읽어들이는 FileOutputStream 클래스
					FileOutputStream thumbnail = new FileOutputStream(new File(uploadPath, "s_" + uploadFileName));	//이미지 파일은 저장될 때 파일 이름 앞에 's_'가 붙음(주어진 이름의 파일을 쓰기 위한 객체 생성)
					
					//getInputStream()과 File 객체를 통해 파일을 생성할 수 있고, width와 height로 크기 지정
					Thumbnailator.createThumbnail(multipartFile.getInputStream(), thumbnail, 100, 100);
					
					thumbnail.close();	//스트림 연결 종료
				}
				
				list.add(attachDTO);	//AttachFileDTO의 구조로 list에 추가
				
			} catch (Exception e) {
				log.error(e.getMessage());
			}
		}
		
		return new ResponseEntity<List<AttachFileDTO>>(list, HttpStatus.OK);
	}
	
	
	//섬네일 데이터 전송
	@GetMapping("/display")
	@ResponseBody	//http요청 body를 자바 객체로 전달
	public ResponseEntity<byte[]> getFile(String fileName) {
		
		log.info("fileName: " + fileName);		
		
		File file = new File("C:\\upload\\" + fileName);	//파일의 경로와 파일 이름
		
		log.info("file: " + file);
		
		ResponseEntity<byte[]> result = null;
		
		try {
			HttpHeaders header = new HttpHeaders();	//http헤더 객체 생성
			header.add("Content-Type", Files.probeContentType(file.toPath()));	//http헤더에 파일 타입 데이터를 추가
			result = new ResponseEntity<byte[]>(FileCopyUtils.copyToByteArray(file), header, HttpStatus.OK);	//FileCopyUtils.copyToByteArray()를 통해 스트림의 내용을 새로운 byte[]에 복사(완료되면 자동으로 스트림을 닫음)
			
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return result;	//복사된 새로운 byte[] 반환
	}
	
	
	//첨부파일의 다운로드
	@GetMapping(value = "/download",
				produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)	//다운로드 할 수 있는 MIME 타입 지정
	@ResponseBody
	//브라우저의 종류 구분을 위한 User-Agent(IE/Edge 브라우저의 한글 문제 방지)
	public ResponseEntity<Resource> downloadFile(@RequestHeader("User-Agent") String userAgent, String fileName) {
		
		Resource resource = new FileSystemResource("C:\\upload\\" + fileName);	//다운로드할 파일의 경로
		
		//파일이 존재하지 않을 경우 NOT_FOUND 처리
		if(resource.exists() == false) {
			return new ResponseEntity<Resource>(HttpStatus.NOT_FOUND);
		}
		
		String resourceName = resource.getFilename();
		
		//UUID 제거
		String resourceOriginalName = resourceName.substring(resourceName.indexOf("_") + 1);
		
		HttpHeaders headers = new HttpHeaders();	//파일 이름 처리를 위한 HttpHeaders 객체 생성
		
		try {
			
			String downloadName = null; 
			
			if(userAgent.contains("Trident")) {			//IE 브라우저(Trident 또는 MSIE)
				log.info("IE browser");
				
				downloadName = URLEncoder.encode(resourceOriginalName, "UTF-8").replaceAll("\\+", " ");
			} else if (userAgent.contains("Edge")) {	//Edge 브라우저
				log.info("Edge browser");
				
				downloadName = URLEncoder.encode(resourceOriginalName, "UTF-8");	//Edge 브라우저는 'ISO-8859-1' 인코딩을 적용하지 않음
				
				log.info("Edge name: " + downloadName);
			} else {									//Chrome 브라우저
				log.info("Chrome browser");
				
				downloadName = new String(resourceOriginalName.getBytes("UTF-8"), "ISO-8859-1");
			}
			
			headers.add("Content-Disposition", "attachment; filename=" + downloadName);
			
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		
		return new ResponseEntity<Resource>(resource, headers, HttpStatus.OK);
	}

	
	//서버에서 첨부파일 삭제
	//스프링 시큐리티 처리
	@PreAuthorize("isAuthenticated()")	//로그인한 회원만 게시물 등록 가능
	@PostMapping("/deleteFile")
	@ResponseBody
	public ResponseEntity<String> deleteFile(String fileName, String type) {
		
		log.info("deleteFile: " + fileName);
		
		File file;
		
		try {
			file = new File("C:\\upload\\" + URLDecoder.decode(fileName, "UTF-8"));	//파일이름을 UTF-8로 디코딩
			
			file.delete();	//파일 삭제
			
			if(type.equals("image")) {	//삭제하려는 첨부파일이 이미지인 경우
				
				String largeFileName = file.getAbsolutePath().replace("s_", "");	//파일 절대경로에서 이름에 's_'가 포함되지 않은 원본 이미지 파일 변수 선언
				
				log.info("largeFileName: " + largeFileName);
				
				file = new File(largeFileName);
				
				file.delete();	//원본 이미지 파일 삭제
			}
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
			return new ResponseEntity<String>(HttpStatus.NOT_FOUND);
		}
		
		return new ResponseEntity<String>("deleted", HttpStatus.OK);
	}
}
