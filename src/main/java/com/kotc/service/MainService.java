package com.kotc.service;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.kotc.mapper.MainMapper;

import kr.co.kotc.api.ApiService;

@Service
public class MainService {

	private static final Logger logger = LoggerFactory.getLogger(MainService.class);
	
	@Autowired MainMapper mainMapper;

	@Autowired ApiService apiService;
	
	/**
	 * 공지사항 저장
	 * @param param
	 * @param request
	 * @return
	 */
	public Map<String, Object> saveNotice(HashMap<String, Object> param, HttpServletRequest request) {
		Map<String, Object> result = new HashMap<>();
		
		try {
			Map fileMap = new HashMap();
			MultipartHttpServletRequest multipart = (MultipartHttpServletRequest)request;
			
			Map user = (Map) request.getSession().getAttribute("userInfo");
			param.put("ACC_ID", user.get("ACC_ID"));
			mainMapper.addNotice(param);
			
			if(multipart.getFiles("noticeFile").size() > 0) {
				MultipartFile file = multipart.getFile("noticeFile");
				if(!file.isEmpty()) {
					fileMap.put("CD_TABLE", "MAS_NOTICE");
					fileMap.put("ID_PK", param.get("NOTICE_ID"));
					fileMap.put("FILE", file);
					apiService.fileSave(fileMap);
				}
			}
			
			result.put("success", true);
		}catch(Exception e) {
			e.printStackTrace();
			result.put("success", false);
		}
		
		return result;
	}
	
	/**
	 * 공지사항 목록
	 * @param param
	 * @return
	 */
	public Map<String, Object> getNoticeList(Map param) {
		Map<String, Object> result = new HashMap<>();
		result.put("count", mainMapper.getNoticeCount(param));
		result.put("list", mainMapper.getNoticeList(param));
		result.put("success", true);
		return result;
	}
}
