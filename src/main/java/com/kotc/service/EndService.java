package com.kotc.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.apache.ibatis.session.SqlSession;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.kotc.mapper.EndMapper;

@Service
public class EndService {
	
	private static final Logger logger = LoggerFactory.getLogger(EndService.class);
	
	@Autowired
	@Qualifier("kotcSessionTemplate")
	private SqlSession kotcSqlSession;
	
	@Autowired
	@Qualifier("innodisSessionTemplate")
	private SqlSession innodisSqlSession;
	
	@Autowired EndMapper endMapper;
	
	/**
	 * 수료보고 목록
	 * @param param
	 * @return
	 */
	public Map<String, Object> getEndClassList(Map param) {
		Map<String, Object> result = new HashMap<>();
		result.put("count", endMapper.getEndClassCount(param));
		result.put("list", endMapper.getEndClassList(param));
		result.put("success", true);
		return result;
	}
	
	/**
	 * 수료보고 상세정보
	 * @param param
	 * @return
	 */
	public Map<String, Object> getEndClassDetail(Map param) {
		Map<String, Object> result = new HashMap<>();
		
		result.put("endClassDetail", endMapper.getEndClassDetail(param));
		result.put("studentList", endMapper.getStudentList(param));
		result.put("success", true);
		return result;
	}
	
	/**
	 * 수료보고 변경이력 상세
	 * @param param
	 * @return
	 */
	public Map<String, Object> getHisEndClassDetail(Map param) {
		Map<String, Object> result = new HashMap<>();
		try {
			Map hisEndClassDetail = endMapper.getHisEndClassDetail(param);
			
			ObjectMapper om = new ObjectMapper();
			
			Map endClassDetail = om.readValue(hisEndClassDetail.get("endClassDetail").toString(), Map.class);
			List<Map> studentList = om.readValue(hisEndClassDetail.get("studentList").toString(), new TypeReference<List<Map>>() {});

			result.put("endClassDetail", endClassDetail);
			result.put("studentList", studentList);
			result.put("success", true);
		} catch(Exception e) {
			e.printStackTrace();
			result.put("success", false);
		}
		return result;
	}
	
	
	/**
	 *  삭제 신청
	 * @param param
	 * @return
	 */
	public Map<String, Object> removeEndClass(Map param) {
		Map<String, Object> result = new HashMap<>();
		try {
			Map endClassDetail = endMapper.getEndClassDetail(param);
			ObjectMapper om = new ObjectMapper();
			
			/******************************************************************
			 *  (JSON) 저장
			 ******************************************************************/
			Map data = new HashMap<>();
			data.put("endClassDetail", endClassDetail);
			param.put("CHNG_JSON", om.writeValueAsString(data));
			param.put("CD_ADD_STATE", "3"); //삭제 : 3
			endMapper.addHisEndClassChange(param);
			
			endMapper.setEndClass(param);
			result.put("success", true);
		} catch(Exception e) {
			result.put("success", false);
		}
		return result;
	}
	
	/**
	 * 수료보고 변경이력 (JSON) 저장
	 * @param param
	 * @return
	 */
	public boolean addHisEndClassChange(Map param) {
		try {
			Map data = new HashMap<>();
			param.put("COMPLETE_REPORT_ID", param.get("CLASS_ID").toString());
			Map endClassDetail = endMapper.getEndClassDetail(param);
			data.put("endClassDetail", endClassDetail);
			data.put("studentList", endMapper.getStudentList(param));
			ObjectMapper om = new ObjectMapper();
			param.put("CHNG_JSON", om.writeValueAsString(data));
			endMapper.addHisEndClassChange(param);
		} catch(Exception e) {
			return false;
		}
		return true;
	}
	
	/**
	 * 수료보고 저장
	 * @param param
	 * @return
	 */
	public Map<String, Object> saveEndClass(Map param) {
		Map<String, Object> result = new HashMap<>();
		//String CLASS_ID ;
		ObjectMapper om = new ObjectMapper();
		String accId = param.get("SESSION_ACC_ID").toString();
		System.out.println(">>>>>>>>>>>>>>>" + param);
		try {
			
			//history 				
			//Map endClassDetail = endMapper.getEndClassDetail(param);
			Map<String, Object> endClassDetail = om.readValue(param.get("endClassDetail").toString(),
	                new TypeReference<Map<String, Object>>() {
	        });
			endClassDetail.put("ACC_ID", accId);
			if(endClassDetail.get("CLASS_ID") != null && StringUtils.isNotBlank(endClassDetail.get("CLASS_ID").toString())) {
				endMapper.setEndClass(endClassDetail);
			}else {
				endMapper.addEndClass(endClassDetail);
			}
			
			String CLASS_ID = endClassDetail.get("CLASS_ID").toString();
			param.put("CLASS_ID", CLASS_ID);
			

			/******************************************************************
			 *  MAPPER_END_STUDENT
			 ******************************************************************/
			List<String> stuIds = om.readValue(param.get("stuIds").toString(),
					new TypeReference<List<String>>() {
			});
			Map mapperEndStudent = new HashMap<>();
			mapperEndStudent.put("CLASS_ID", CLASS_ID);
			mapperEndStudent.put("stuIds", stuIds);
			endMapper.removeStudent(mapperEndStudent);
			for(String stuId : stuIds) {
				mapperEndStudent.put("STU_ID", stuId);
				int count = endMapper.getStudentCount(mapperEndStudent);
				if(count <= 0) {
					endMapper.addStudent(mapperEndStudent);
				}
			}
			
			/******************************************************************
			 *  MAS_STUDENT
			 ******************************************************************/
			List<Map<String, Object>> studentList = om.readValue(param.get("studentList").toString(), 
					new TypeReference<List<Map<String,Object>>>() {
			});
			for(Map endStudent : studentList) {
				String STU_ID = endStudent.get("STU_ID").toString();
				System.out.println(">>>>>>>>>>>>>>>>" + STU_ID);
				endStudent.put("CLASS_ID", CLASS_ID);
				param.put("STU_ID", STU_ID);
				endMapper.setStudent(endStudent);
				endMapper.removeCompleteId(param);
				endMapper.addCompleteId(param);
			}
			
		
			//변경이력(JSON) 저장
			addHisEndClassChange(param);
			
		} catch(Exception e) {
			e.printStackTrace();
			result.put("success", false);
		}
		result.put("success", true);
		return result;
	}

	
	
	
}
