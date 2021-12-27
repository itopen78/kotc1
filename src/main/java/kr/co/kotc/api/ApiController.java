package kr.co.kotc.api;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.URLDecoder;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FilenameUtils;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.core.io.InputStreamResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;

/**
 * kotc 공통 API 컨트롤러
 * 
 * 필요 설정
 * ComponentScan에 kr.co.kotc.api를 추가할 것
 * kotc.api.*의 설정이 필요.
 * 
 * 세션정보는 userInfo의 이름을 사용
 * 
 * @author kotc10
 *
 */
@Controller
public class ApiController {
	
	@Value("${kotc.api.sessionParamHeader}")
	private String sessionParamHeader;
	@Value("${kotc.api.sessionName}")
	private String sessionName;
	@Value("${kotc.api.sessionRegId}")
	private String sessionRegId;
	private Logger logger = LoggerFactory.getLogger(this.getClass());
	@Autowired
	private ApiService apiService;
	
	/**
	 * 세션없이 호출
	 * @param param
	 * @return
	 */
	@RequestMapping(value = "${kotc.api.url}", method = RequestMethod.POST) 
	@ResponseBody
	public Map<String, Object> call(@RequestBody Map<String, Object> params) {
		//logger.info("params : {}", params.toString());
		Map result = validation(params);
		if(result == null) {
			result = apiService.execute(params);
		}
		return result;
	}
	
	/**
	 * 세션이 필요한 호출
	 * @param param
	 * @return
	 */
	@RequestMapping(value = "/api/callCsrf", method = RequestMethod.POST) 
	@ResponseBody
	public Map<String, Object> callJstl(HttpSession session, @RequestBody Map<String, Object> params) {
		//logger.info("params : {}", params.toString());
		Map param = (Map)params.get("param");
		if(param == null) {
			param = new HashMap<>();
			params.put("param", param);
		}
		Map user = (Map) session.getAttribute(sessionName);
		Iterator<String> i = user.keySet().iterator();
		while(i.hasNext()) {
			String key = i.next();
			param.put(sessionParamHeader + key, user.get(key));																		// 파라미터에 세션 값을 헤더를 붙여서 추가
		}
		
		Map result = validation(params);
		if(result == null) {
			result = apiService.execute(params);
		}
		return result;
	}
	
	private Map validation(Map<String, Object> params) {
		String message = null;
		Map result = null;
		if(!params.containsKey("class") || params.get("class") == null || params.get("class").toString().length() == 0) {
			message = "파라미터 class가 없습니다.";
		}else if(!params.get("class").toString().equals("apiService") && !params.get("class").toString().endsWith("Mapper") && !params.get("class").toString().startsWith("service.")) {
			message = "호출할 수 없는 클래스 입니다.";
		}else if(!params.containsKey("method") || params.get("method") == null || params.get("method").toString().length() == 0) {
			message = "파라미터 method가 없습니다.";
		}
		
		if(message != null) {
			result = new HashMap<>();
			result.put("success", false);
			result.put("message", message);
		}
		return result;
	}
	
	@RequestMapping(value="/file/upload", method = RequestMethod.POST)
	public @ResponseBody Map FileUpload(HttpSession session, HttpServletRequest request) throws Exception {
		Map param = new HashMap<String, Object>();
		Map user = (Map)session.getAttribute("userInfo");
		MultipartHttpServletRequest multipart = (MultipartHttpServletRequest)request;
		param.put("TABLE_ID", multipart.getParameter("TABLE_ID"));
		param.put("REF_ID", multipart.getParameter("REF_ID"));
		param.put("FILE_TYPE", multipart.getParameter("FILE_TYPE"));
		param.put("REG_ID", user.get(sessionRegId));
		param.put("FILE", multipart.getFile("file"));
		if(multipart.getParameter("FILE_ID") != null) {
			param.put("FILE_ID", multipart.getParameter("FILE_ID"));			
		}
		return apiService.saveFile(param);
	}
	
	@RequestMapping(value="/file/download", method = RequestMethod.GET)
	public ResponseEntity<Resource> FileDownload(@RequestParam Map<String, Object> param) throws Exception {
		return apiService.fileDownload(param);
	}
	
	@RequestMapping(value="/getFileDown", method = RequestMethod.GET)
	public ResponseEntity<Resource> getFileDown(@RequestParam HashMap<String, Object> param) throws IOException {
		String serverFileName = URLDecoder.decode(param.get("SERVER_FILE_NAME").toString(), "UTF-8");
		String originalFileName = URLDecoder.decode(param.get("ORIGINAL_FILE_NAME").toString(), "UTF-8");
		File file = new File(FilenameUtils.getName(param.get("SERVER_FILE_NAME").toString()));
		//FileInputStream iss = new FileInputStream(file);
		
		InputStream is = Files.newInputStream(Paths.get(FilenameUtils.getName(param.get("SERVER_FILE_NAME").toString())));
			InputStreamResource resource = new InputStreamResource(is);
			String fileName = param.get("ORIGINAL_FILE_NAME").toString();
			return ResponseEntity.ok()
					.header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + fileName + "\"")
					.contentLength(file.length()).contentType(MediaType.parseMediaType("application/octet-stream"))
					.body(resource);
	}
	
	@RequestMapping(value="/getFilesDown", method = RequestMethod.GET)
	public void getFilesDown(HttpServletRequest request, HttpServletResponse response, @RequestParam HashMap<String, Object> param) throws IOException {
		apiService.getFilesDown(request, response, param);
	}
}
