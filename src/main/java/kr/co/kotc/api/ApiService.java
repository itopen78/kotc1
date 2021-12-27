package kr.co.kotc.api;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.UUID;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.List;
import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.lang.reflect.*;
import java.net.URLDecoder;
import java.nio.file.Files;
import java.nio.file.Paths;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.ApplicationContext;
import org.springframework.core.io.InputStreamResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.kotc.common.DateUtils;

/**
 * api 서비스 클래스
 * 
 * 필요설정
 * kotc.api.packageName = mapper, service
 * @author kotc10
 *
 */
@Service
@Transactional
public class ApiService {
	@Value("${kotc.api.targetPackage}")
	private String targetPackage;
	@Value("${kotc.api.file.storageRoot}")
	private String storageRoot;
	@Autowired
	private ApplicationContext context;
	@Autowired
	private FileMapper fileMapper;
	
	/**
	 * 공통 서비스 호출
	 * @param params
	 * @return
	 */
	public Map execute(Map params) {
		Map result = null;
		Map param = (Map)params.get("param");
		String className = params.get("class").toString();
		String methodName = params.get("method").toString();
		try {
			Object instance = null;
			Class target = null;
			Method method = null;
			if(className.startsWith("apiService")) {															// 현재 클래스 내
				if(methodName.equals("selectFile")) {
					result = selectFile(param);
				}else if(methodName.equals("deleteFile")) {
					result = deleteFile(param);
				}
			} else if(className.startsWith("service.")) {														// 서비스의 경우
				target = Class.forName(targetPackage + "." + className);
				if(target == null) {
					throw new ClassNotFoundException();
				}
				instance = target.newInstance();
				method = target.getDeclaredMethod(methodName, Map.class);
				context.getAutowireCapableBeanFactory().autowireBean(instance);
				result = (Map) method.invoke(instance, param);													// 무조건 Map으로 반환
			}else {
				instance = context.getBean(className);
				method = instance.getClass().getMethod(methodName, Map.class);
				result = new HashMap<String, Object>();
				if(method.getGenericReturnType() == List.class) {												// 리스트 타입
					System.out.println("execute list");
					List list = (List) method.invoke(instance, param);
					result.put("list", list);
					result.put("success", true);
				}else if(method.getGenericReturnType() == Map.class) {											// Map 타입
					Map view = (Map) method.invoke(instance, param);
					result.put("view", view);
					result.put("success", true);
				}else if(methodName.startsWith("count")) {														// count 타입
					int count = (int) method.invoke(instance, param);
					result.put("count", count);
					result.put("success", true);
				}else if(method.getGenericReturnType().toString().equals("int")) {								// DML
					Map before = new HashMap<>(param);
					int rowEffect = (int) method.invoke(instance, param);
					result.put("success", rowEffect > 0);
					if(before.size() < param.size()) {															// OUT 파라미터 존재여부 
						Iterator<String> i = param.keySet().iterator();
						while(i.hasNext()) {
							String key = i.next();
							if(!before.containsKey(key)) {
								result.put(key, param.get(key));
							}
						}
					}
				}else {
					result.put("success", false);
					result.put("message", "ApiService 규칙을 찾을 수 없음");
				}
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			result.put("success", false);
			result.put("message", "요청하신 클래스를 찾을 수 없습니다.");
		} catch (NoSuchMethodException e) {
			e.printStackTrace();
			result.put("success", false);
			result.put("message", "요청하신 메서드를 찾을 수 없습니다.");
		} catch (SecurityException e) {
			e.printStackTrace();
			result.put("success", false);
			result.put("message", "요청하신 메서드를 로딩 할 수 없습니다.");
		} catch (InstantiationException e) {
			e.printStackTrace();
			result.put("success", false);
			result.put("message", "요청하신 클래스를 인스턴싱 할 수 없습니다.");
		} catch (IllegalAccessException e) {
			e.printStackTrace();
			result.put("success", false);
			result.put("message", "요청하신 클래스를 인스턴싱 할 수 없습니다.");
		} catch (IllegalArgumentException e) {
			e.printStackTrace();
			result.put("success", false);
			result.put("message", "요청하신 메서드 실행 도중 오류가 발생했습니다.");
		} catch (InvocationTargetException e) {
			e.printStackTrace();
			result.put("success", false);
			result.put("message", "요청하신 메서드 실행 도중 오류가 발생했습니다.");
		} catch (Exception e) {
			e.printStackTrace();
			result.put("success", false);
			result.put("message", e.getMessage());
		}
		
		return result;
	}
	
	public Map selectFile(Map param) throws Exception {
		Map result = new HashMap<String, Object>();
		result.put("success", true);
		result.put("list", fileMapper.selectFile(param));
		return result;
	}
	
	public Map deleteFile(Map param) throws Exception {
		Map view = fileMapper.viewFile(param);
		
		File file = new File(FilenameUtils.getName(view.get("FILE_PATH").toString()));
		if(file.exists()) {
			file.delete();
		}
		fileMapper.deleteFile(param);
		
		Map result = new HashMap<String, Object>();
		result.put("success", true);
		return result;
	}
	
	public Map saveFile(Map param) throws Exception {
		MultipartFile file = (MultipartFile)param.get("FILE");
		String file_name = file.getOriginalFilename();
		String file_ext = file_name.substring(file_name.indexOf('.') + 1, file_name.length());
		String file_path = storageRoot + File.separator + param.get("TABLE_ID") + File.separator + param.get("REF_ID") + File.separator + param.get("FILE_TYPE");
		int file_seq = 1;
		
		if(param.containsKey("FILE_ID")) {
			Map view = fileMapper.viewFile(param);
			File file_before = new File(FilenameUtils.getName(view.get("FILE_PATH").toString()));
			if(file_before.exists()) {
				file_before.delete();
			}
		}
		
		File dir = new File(FilenameUtils.getName(file_path));
		
		if(!dir.exists()) {
			dir.mkdirs();
		}else {
			File[] files = dir.listFiles();
			for(int i=0; i<files.length; i++) {
				int seq = Integer.parseInt(files[i].getName().substring(0, files[i].getName().indexOf(".")));
				if(file_seq < seq) {
					file_seq = seq;
				}
			}
			file_seq++;
		}
		file_path += File.separator + file_seq + "." + file_ext;
		File saved = new File(FilenameUtils.getName(file_path));
		FileUtils.copyInputStreamToFile(file.getInputStream(), saved);
		
		param.put("FILE_NAME", file_name);
		param.put("FILE_EXT", file_ext);
		param.put("FILE_PATH", file_path);
		param.put("FILE_SIZE", file.getSize());
		if(param.containsKey("FILE_ID")) {
			fileMapper.updateFile(param);
		}else {
			fileMapper.insertFile(param);
		}
		
		Map result = new HashMap<String, Object>();
		result.put("success", true);
		result.put("FILE_ID", param.get("FILE_ID"));
		return result;
	}
	
	public ResponseEntity<Resource> fileDownload(Map param) throws Exception{
		Map view = fileMapper.viewFile(param);
		InputStream is = Files.newInputStream(Paths.get(FilenameUtils.getName(view.get("FILE_PATH").toString())));
		InputStreamResource resource = new InputStreamResource(is);
		return ResponseEntity.ok()
				.header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + new String(view.get("FILE_NAME").toString().getBytes("UTF-8"), "ISO-8859-1") + "\"")
				.contentLength(Integer.parseInt(view.get("FILE_SIZE").toString())).contentType(MediaType.parseMediaType("application/octet-stream"))
				.body(resource);
	}

	public Map fileSave(Map param) throws Exception {
		MultipartFile file = (MultipartFile)param.get("FILE");
		String file_name = file.getOriginalFilename();
		String file_ext = file_name.substring(file_name.indexOf('.') + 1, file_name.length());
		String file_path = storageRoot + File.separator + param.get("CD_TABLE").toString() + File.separator + param.get("ID_PK").toString();

		File dir = new File(FilenameUtils.getName(file_path));
		
		if(!dir.exists()) {
			dir.mkdirs();
		}
		
		file_path += File.separator + UUID.randomUUID().toString() + "." + file_ext;
		File saved = new File(FilenameUtils.getName(file_path));
		FileUtils.copyInputStreamToFile(file.getInputStream(), saved);
		
		param.put("ORIGINAL_FILE_NAME", file_name);
		param.put("SERVER_FILE_NAME", file_path);
		
		Map fileView = fileMapper.getFile(param);
		if(fileView != null) {
			fileMapper.setFile(param);
		} else {
			fileMapper.addFile(param);
		}
		
		Map result = new HashMap<String, Object>();
		result.put("success", true);
		result.put("FILE_ID", param.get("FILE_ID"));
		return result;
	}

	public void getFilesDown(HttpServletRequest request, HttpServletResponse response, HashMap<String, Object> param) {
		ObjectMapper om = new ObjectMapper();
		int bufferSize = 1024 * 2;
		String ouputName = DateUtils.getThisDay("yyyymmddhhmmssms");
		            
		ZipOutputStream zos = null;
		try {
			 if (request.getHeader("User-Agent").indexOf("MSIE 5.5") > -1) {
			        response.setHeader("Content-Disposition", "filename=" + ouputName + ".zip" + ";");
			    } else {
			        response.setHeader("Content-Disposition", "attachment; filename=" + ouputName + ".zip" + ";");
			    }
			    response.setHeader("Content-Transfer-Encoding", "binary");
			    
			    OutputStream os = response.getOutputStream();
			    zos = new ZipOutputStream(os); // ZipOutputStream
			    zos.setLevel(8); // 압축 레벨 - 최대 압축률은 9, 디폴트 8
			    BufferedInputStream bis = null;
				
			String cdTable = URLDecoder.decode(param.get("CD_TABLE").toString(), "UTF-8");
			List<String> idPks = om.readValue(URLDecoder.decode(param.get("ID_PKS").toString(), "UTF-8"),
					new TypeReference<List<String>>() {
			});
			
			Map fileMap = new HashMap();
			for(String idPk:idPks) {
				fileMap.put("CD_TABLE", cdTable);
				fileMap.put("ID_PK", idPk);
				Map result = fileMapper.getFile(fileMap);
				
				if(result != null) {
					File sourceFile = new File(FilenameUtils.getName(result.get("SERVER_FILE_NAME").toString()));
                    
			        bis = new BufferedInputStream(new FileInputStream(sourceFile));
			        ZipEntry zentry = new ZipEntry(result.get("ORIGINAL_FILE_NAME").toString());
			        zentry.setTime(sourceFile.lastModified());
			        zos.putNextEntry(zentry);
			        
			        byte[] buffer = new byte[bufferSize];
			        int cnt = 0;
			        while ((cnt = bis.read(buffer, 0, bufferSize)) != -1) {
			            zos.write(buffer, 0, cnt);
			        }
			        zos.closeEntry();
				}
			}
			zos.close();
		    bis.close();
		} catch (Exception e) {
		}
	}
}
