package kr.jk.task;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import kr.jk.domain.BoardAttachVO;
import kr.jk.mapper.BoardAttachMapper;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Component
public class FileCheckTask {
	
	@Setter(onMethod_ = @Autowired)
	private BoardAttachMapper attachMapper;
	
	//어제 날짜의 첨부파일 폴더
	private String getFolderYesterDay() {
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		Calendar cal = Calendar.getInstance();
		
		cal.add(Calendar.DATE, -1);
		
		String str = sdf.format(cal.getTime());
		
		return str.replace("-", File.separator);
	}
	
	
	@Scheduled(cron="0 0 2 * * *")	//매일 02시에 실행
	public void checkFiles() throws Exception {
		
		log.warn("File Check Task Run...............");
		log.warn(new Date());
		
		//데이터베이스에 존재하는 파일목록
		List<BoardAttachVO> fileList = attachMapper.getOldFiles();
		
		//ready for check file in directory with database file list
		List<Path> fileListPaths = fileList.stream().map(vo -> Paths.get("C:\\upload", vo.getUploadPath(), vo.getUuid() + "_" + vo.getFileName())).collect(Collectors.toList());
		
		//이미지 파일의 섬네일
		fileList.stream().filter(vo -> vo.isFileType() == true).map(vo -> Paths.get("C:\\upload", vo.getUploadPath(), "s_" + vo.getUuid() + "_" + vo.getFileName())).forEach(p -> fileListPaths.add(p));
		log.warn("==================================");
		
		fileListPaths.forEach(p -> log.warn(p));
		
		//어제 등록된 파일
		File targetDir = Paths.get("C:\\upload", getFolderYesterDay()).toFile();
		
		File[] removeFiles = targetDir.listFiles(file -> fileListPaths.contains(file.toPath()) == false);
		
		log.warn("----------------------------------");
		for(File file : removeFiles) {
			log.warn(file.getAbsoluteFile());
			file.delete();	//파일 삭제
		}
	}
}
