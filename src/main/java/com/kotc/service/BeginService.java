package com.kotc.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.apache.ibatis.session.SqlSession;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.kotc.mapper.BeginMapper;
import com.kotc.mapper.CommonMapper;
import com.kotc.mapper.EduMapper;

@Service
public class BeginService {

	@Autowired
	@Qualifier("kotcSessionTemplate")
	private SqlSession kotcSqlSession;
	
	@Autowired
	@Qualifier("innodisSessionTemplate")
	private SqlSession innodisSqlSession;
	
	@Autowired BeginMapper beginMapper;

	@Autowired CommonMapper commonMapper;
	@Autowired EduMapper eduMapper;
	
	/**
	 * 1
	 * 이론/실기 목록
	 * @param param
	 * @return
	 */
	public Map<String, Object> getLogicList(Map param) {
		Map<String, Object> result = new HashMap<>();
		result.put("count", beginMapper.getLogicCount(param));
		result.put("list", beginMapper.getLogicList(param));
		result.put("success", true);
		return result;
	}
	

	/**
	 * 2
	 * 이론/실기 ==> 변경 목록
	 * @param param
	 * @return
	 */
	public Map<String, Object> getLogicChangeList(Map param) {
		Map<String, Object> result = new HashMap<>();
		//result.put("count", beginMapper.getLogicChangeCount(param));
		result.put("list", beginMapper.getLogicChangeList(param));
		result.put("success", true);
		return result;
	}
	
	

	/**
	 *  삭제
	 * @param param
	 * @return
	 */
	public Map<String, Object> removeLogic(Map param) {
		Map<String, Object> result = new HashMap<>();
		try {
			Map logicDetail = beginMapper.getLogicDetail(param);
			ObjectMapper om = new ObjectMapper();
			
			/******************************************************************
			 *  (JSON) 저장
			 ******************************************************************/
			Map data = new HashMap<>();
			data.put("logicDetail", logicDetail);
			param.put("CHNG_JSON", om.writeValueAsString(data));
			beginMapper.addHisLogic(param);
			
			param.put("CD_ADD_STATE", "3"); //삭제 : 3
			beginMapper.setLogic(param);
			result.put("success", true);
		} catch(Exception e) {
			result.put("success", false);
		}
		return result;
	}
	
	

	/**
	 * 3
	 * 실습 목록
	 * @param param
	 * @return
	 */
	public Map<String, Object> getPracticeList(Map param) {
		Map<String, Object> result = new HashMap<>();
		result.put("count", beginMapper.getPracticeCount(param));
		result.put("list", beginMapper.getPracticeList(param));
		result.put("success", true);
		return result;
	}
	

	/**
	 * 4
	 * 실습 ==> 변경 목록
	 * @param param
	 * @return
	 */
	public Map<String, Object> getPracticeChangeList(Map param) {
		Map<String, Object> result = new HashMap<>();
		result.put("list", beginMapper.getPracticeChangeList(param));
		result.put("success", true);
		return result;
	}
	
	

	/**
	 *  삭제
	 * @param param
	 * @return
	 */
	public Map<String, Object> removePractice(Map param) {
		Map<String, Object> result = new HashMap<>();
		try {
			Map practiceDetail = beginMapper.getPracticeDetail(param);
			ObjectMapper om = new ObjectMapper();
			
			/******************************************************************
			 *  (JSON) 저장
			 ******************************************************************/
			Map data = new HashMap<>();
			data.put("practiceDetail", practiceDetail);
			param.put("CHNG_JSON", om.writeValueAsString(data));
			beginMapper.addHisPractice(param);
			
			param.put("CD_ADD_STATE", "3"); //삭제 : 3
			beginMapper.setPractice(param);
			result.put("success", true);
		} catch(Exception e) {
			result.put("success", false);
		}
		return result;
	}
	
	

	/**
	 * 5
	 * 대체실습 목록
	 * @param param
	 * @return
	 */
	public Map<String, Object> getSubPracticeList(Map param) {
		Map<String, Object> result = new HashMap<>();
		result.put("count", beginMapper.getSubPracticeCount(param));
		result.put("list", beginMapper.getSubPracticeList(param));
		result.put("success", true);
		return result;
	}
	

	/**
	 * 6
	 * 대체실습 ==> 변경 목록
	 * @param param
	 * @return
	 */
	public Map<String, Object> getSubPracticeChangeList(Map param) {
		Map<String, Object> result = new HashMap<>();
		result.put("list", beginMapper.getSubPracticeChangeList(param));
		result.put("success", true);
		return result;
	}
	
	

	/**
	 *  삭제
	 * @param param
	 * @return
	 */
	public Map<String, Object> removeSubPractice(Map param) {
		Map<String, Object> result = new HashMap<>();
		try {
			Map subPracticeDetail = beginMapper.getSubPracticeDetail(param);
			ObjectMapper om = new ObjectMapper();
			
			/******************************************************************
			 *  (JSON) 저장
			 ******************************************************************/
			Map data = new HashMap<>();
			data.put("subPracticeDetail", subPracticeDetail);
			param.put("CHNG_JSON", om.writeValueAsString(data));
			beginMapper.addHisSubPractice(param);
			
			param.put("CD_ADD_STATE", "3"); //삭제 : 3
			beginMapper.setSubPractice(param);
			result.put("success", true);
		} catch(Exception e) {
			result.put("success", false);
		}
		return result;
	}
	

	/******************************************************************
	 * @@@ 개강 이론/실기 S
	 ******************************************************************/

	/**
	 * 이론/실기 상세정보
	 * @param param
	 * @return
	 */
	public Map<String, Object> getLogicDetail(Map param) {
		Map result = new HashMap<>();
		param.put("CD_TOP", "4");
		result.put("cdClasLev1List", commonMapper.getCommonListByMiddle(param));
		result.put("cdClasLev2List", commonMapper.getCodeList(param));
		
		
		result.put("logicDetail", beginMapper.getLogicList(param)); //개강개요 조회
		result.put("logicStudentList", beginMapper.getLogicStudentList(param));  //교육생 목록 조회
		
		result.put("cdAgentList", beginMapper.getAgentList(param));  //교수 콤보 조회
		result.put("logicTimeTableList", beginMapper.getLogicTimeTableList(param));  //시간표 목록 조회

		result.put("logicClassList", beginMapper.getLogicClassList(param));  //과목별 교수요원 목록 조회
		
		result.put("success", true);
		return result;
	}
	

	/******************************************************************
	 * 개강 이론/실기 E
	 ******************************************************************/
	

	/**
	 * 7
	 * 이론/실기 ==> 교육생 명부 목록
	 * @param param
	 * @return
	 */
	public Map<String, Object> getLogicStudentList(Map param) {
		Map<String, Object> result = new HashMap<>();
		result.put("list", beginMapper.getLogicStudentList(param));
		result.put("success", true);
		return result;
	}
	
	
	
	
	

	/**
	 * 교육기관 저장
	 * @param param
	 * @return
	 */
	public Map<String, Object> logicSave(Map param, HttpServletRequest request) {
		Map<String, Object> result = new HashMap<>();
		String CLASS_ID ;
		try {
			
			Map user = (Map) request.getSession().getAttribute("userInfo");
			param.put("ACC_ID", user.get("ACC_ID"));
			
			/******************************************************************
			 * 기본정보 저장
			 ******************************************************************/			
			if(param.get("CLASS_ID") != null && StringUtils.isNotBlank(param.get("CLASS_ID").toString())) {
				//업데이트 로직
				
				//history
				/******************************************************************
				 *  (JSON) 저장
				 ******************************************************************/
				
				param.put("L_LECTURE_ID", param.get("CLASS_ID").toString()); //변경 : 2
				Map data = new HashMap<>();
				data.put("logicDetail", beginMapper.getLogicDetail(param));						
				data.put("logicStudentList", beginMapper.getLogicStudentList(param));
				data.put("logicTimeTableList", beginMapper.getLogicTimeTableList(param));				
				data.put("logicClassList", beginMapper.getLogicClassList(param)); 
				
				ObjectMapper om = new ObjectMapper();
				param.put("CHNG_JSON", om.writeValueAsString(data));
				beginMapper.addHisLogic(param);
				
				CLASS_ID = param.get("CLASS_ID").toString();
				param.put("CD_ADD_STATE", "2"); //변경 : 2
				//개강개요
				beginMapper.setLogic(param);
			} else {
				//insert 로직
				beginMapper.addLogic(param);
				CLASS_ID = param.get("CLASS_ID").toString();				
				System.out.println("CLASS_ID:"+CLASS_ID);				
				//param.put("CLASS_ID", CLASS_ID);
			}

			//교육생 
			/******************************************************************
			 * 교육생 저장
			 ******************************************************************/
			beginMapper.removeStudent(param);
			if(param.get("STU_ID") != null && StringUtils.isNotBlank(param.get("STU_ID").toString()))
			{
				beginMapper.addStudent(param);	
			}
			
			//MAS_STUDENT UPDATE  : L_LECTURE_ID 이론/실기 개강보고 식별자
			beginMapper.removeLectureId(param);
			beginMapper.addLectureId(param);
			
			
			
			
			//시간표
			/******************************************************************
			 * 시간표 저장
			 ******************************************************************/
			//삭제
			String[] mapperIds = request.getParameterValues("mapperIds");
			
			if(mapperIds != null && mapperIds.length > 0) {
				for(String mapperId:mapperIds) {
					//eduMapper.removeAgentClass(clsId);
					beginMapper.removeLogicTimeTable(mapperId);
				}
			}
			
			//등록, 수정
			String[] MAPPER_ID_ARRAY = request.getParameterValues("MAPPER_ID");
			String[] LECTURE_DATE_ARRAY = request.getParameterValues("LECTURE_DATE");
			String[] BEGIN_TIME_ARRAY = request.getParameterValues("BEGIN_TIME");
			String[] END_TIME_ARRAY = request.getParameterValues("END_TIME");
			String[] CD_CLS_LEV1_ARRAY = request.getParameterValues("CD_CLS_LEV1");
			String[] CD_CLS_LEV2_ARRAY = request.getParameterValues("CD_CLS_LEV2");
			String[] AGT_ID_ARRAY = request.getParameterValues("AGT_ID");
			
			if(MAPPER_ID_ARRAY != null && MAPPER_ID_ARRAY.length > 0) {
				for(int i=0; i<MAPPER_ID_ARRAY.length; i++) {
					Map pLogicTimeTable = new HashMap();
					pLogicTimeTable.put("MAPPER_ID", MAPPER_ID_ARRAY[i]);
					pLogicTimeTable.put("CLASS_ID", CLASS_ID);
					pLogicTimeTable.put("LECTURE_DATE", LECTURE_DATE_ARRAY[i]);
					pLogicTimeTable.put("BEGIN_TIME", BEGIN_TIME_ARRAY[i]);
					pLogicTimeTable.put("END_TIME", END_TIME_ARRAY[i]);
					pLogicTimeTable.put("CD_CLS_LEV1", CD_CLS_LEV1_ARRAY[i]);
					pLogicTimeTable.put("CD_CLS_LEV2", CD_CLS_LEV2_ARRAY[i]);
					pLogicTimeTable.put("AGT_ID", AGT_ID_ARRAY[i]);
					if(MAPPER_ID_ARRAY[i] != null && StringUtils.isNotBlank(MAPPER_ID_ARRAY[i].toString())) {
						beginMapper.setLogicTimeTable(pLogicTimeTable);
					} else {
						beginMapper.addLogicTimeTable(pLogicTimeTable);
					}
				}
			}
			
			//교수요원
			/******************************************************************
			 * 교수요원 저장
			 ******************************************************************/
			String[] PARENT_ID_ARRAY = request.getParameterValues("PARENT_ID");
			
			String[] parentIds = request.getParameterValues("parentIds");
			
			if(parentIds != null && parentIds.length > 0) {
				for(String parentId:parentIds) {
					beginMapper.removeLogicClassAgentAll(parentId);
					beginMapper.removeLogicClass(parentId);
				}
			}
			
			
			String[] pCD_CLS_LEV1_ARRAY = request.getParameterValues("pCD_CLS_LEV1");
			String[] pCD_CLS_LEV2_ARRAY = request.getParameterValues("pCD_CLS_LEV2");
			
			String[] AGT_ID1_ARRAY = request.getParameterValues("AGT_ID1");
			String[] AGT_ID2_ARRAY = request.getParameterValues("AGT_ID2");
			

			if(AGT_ID1_ARRAY != null && AGT_ID1_ARRAY.length > 0) {
				

				
								
				for(int i=0; i<AGT_ID1_ARRAY.length; i++) {

					System.out.println("PARENT_ID_ARRAY : "+ PARENT_ID_ARRAY[i]);
					System.out.println("pCD_CLS_LEV1_ARRAY : "+ pCD_CLS_LEV1_ARRAY[i]);
					System.out.println("pCD_CLS_LEV2_ARRAY : "+ pCD_CLS_LEV2_ARRAY[i]);

					System.out.println("AGT_ID1_ARRAY : "+ AGT_ID1_ARRAY[i]);
					System.out.println("AGT_ID2_ARRAY : "+ AGT_ID2_ARRAY[i]);

					Map pLogicClassAgent = new HashMap();
					pLogicClassAgent.put("CLASS_ID", CLASS_ID);
					
					

					//먼저 MAPPER_LOGIC_CLASS 처리
					// 신규 과목별 교수 요원 저장 후 PARENT_ID Key 를 알아옴
					if( PARENT_ID_ARRAY[i] == null || StringUtils.isBlank(PARENT_ID_ARRAY[i].toString()) )
					{						
						pLogicClassAgent.put("CD_CLS_LEV1", pCD_CLS_LEV1_ARRAY[i]);
						pLogicClassAgent.put("CD_CLS_LEV2", pCD_CLS_LEV2_ARRAY[i]);
						
						//insert 로직
						beginMapper.addLogicClass(pLogicClassAgent);
						String MAPPER_ID = pLogicClassAgent.get("MAPPER_ID").toString();				
						System.out.println("NEW_MAPPER_ID:"+MAPPER_ID);			
						pLogicClassAgent.put("PARENT_ID", MAPPER_ID);
					}
					else
					{						
						pLogicClassAgent.put("PARENT_ID", PARENT_ID_ARRAY[i]);
					}
					
					
					//이론교수 삭제
					if(AGT_ID1_ARRAY[i] != null && StringUtils.isNotBlank(AGT_ID1_ARRAY[i].toString())) {
						pLogicClassAgent.put("AGT_ID", AGT_ID1_ARRAY[i]);
						pLogicClassAgent.put("AGT_TYPE", 1);

						beginMapper.removeLogicClassAgent(pLogicClassAgent);
					}
					//실기교수 삭제
					if(AGT_ID2_ARRAY[i] != null && StringUtils.isNotBlank(AGT_ID2_ARRAY[i].toString())) {
						pLogicClassAgent.put("AGT_ID", AGT_ID2_ARRAY[i]);
						pLogicClassAgent.put("AGT_TYPE", 2);
						
						beginMapper.removeLogicClassAgent(pLogicClassAgent);
					}
					

					
					//이론교수 입력
					if(AGT_ID1_ARRAY[i] != null && StringUtils.isNotBlank(AGT_ID1_ARRAY[i].toString())) {
						pLogicClassAgent.put("AGT_ID", AGT_ID1_ARRAY[i]);
						pLogicClassAgent.put("AGT_TYPE", 1);
						beginMapper.addLogicClassAgent(pLogicClassAgent);
					}
					//실기교수 입력
					if(AGT_ID2_ARRAY[i] != null && StringUtils.isNotBlank(AGT_ID2_ARRAY[i].toString())) {	
						pLogicClassAgent.put("AGT_ID", AGT_ID2_ARRAY[i]);
						pLogicClassAgent.put("AGT_TYPE", 2);
						beginMapper.addLogicClassAgent(pLogicClassAgent);
					}
				}
			}
			
			
			result.put("success", true);
			result.put("CLASS_ID", CLASS_ID);
		} catch(Exception e) {
			result.put("success", false);
		}
		
		return result;
	}
	



	/**
	 * 교수요원 콤보
	 * @param param
	 * @return
	 */
	public Map<String, Object> getAgentList(Map param) {
		Map<String, Object> result = new HashMap<>();
		List<Map> cdAgentList = beginMapper.getAgentList(param);
		result.put("cdAgentList", cdAgentList);
		result.put("success", true);
		return result;
	}

	/**
	 * 교수요원 선택 리스트
	 * @param param
	 * @return
	 */
	public Map<String, Object> getSelectAgentList(Map param) {
		Map<String, Object> result = new HashMap<>();
		List<Map> getSelectAgentList = beginMapper.getSelectAgentList(param);
		result.put("selectAgentList", getSelectAgentList);
		result.put("success", true);
		return result;
	}

	/**
	 * 이론/실기 ==> 시간표
	 * @param param
	 * @return
	 */
	public Map<String, Object> getLogicTimeTableList(Map param) {
		Map<String, Object> result = new HashMap<>();
		param.put("CD_TOP", "4");
		result.put("cdClasLev1List", commonMapper.getCommonListByMiddle(param));
		result.put("cdClasLev2List", commonMapper.getCodeList(param));
		result.put("cdAgentList", beginMapper.getAgentList(param));
		
		
		result.put("list", beginMapper.getLogicTimeTableList(param));
		result.put("success", true);
		return result;
	}
	
	

	/**
	 * 이론/실기 ==> 지난 시간표
	 * @param param
	 * @return
	 */
	public Map<String, Object> getOldLogicList(Map param) {
		Map<String, Object> result = new HashMap<>();
		result.put("oldLogicList", beginMapper.getOldLogicList(param));
		result.put("success", true);
		return result;
	}
	
	

	/**
	 * 이론/실기 변경이력 상세
	 * @param param
	 * @return
	 */
	public Map<String, Object> getHisLogicStepDetail(Map param) {
		Map<String, Object> result = new HashMap<>();
		try {
			Map hisLogicStepDetail = beginMapper.getHisLogicStepDetail(param);
			
			ObjectMapper om = new ObjectMapper();
			
			Map logicDetail = om.readValue(hisLogicStepDetail.get("logicDetail").toString(), Map.class);
			List<Map> logicStudentList = om.readValue(hisLogicStepDetail.get("logicStudentList").toString(), new TypeReference<List<Map>>() {});
			List<Map> logicTimeTableList = om.readValue(hisLogicStepDetail.get("logicTimeTableList").toString(), new TypeReference<List<Map>>() {});
			List<Map> logicClassList = om.readValue(hisLogicStepDetail.get("logicClassList").toString(), new TypeReference<List<Map>>() {});

			result.put("logicDetail", logicDetail);
			result.put("logicStudentList", logicStudentList);
			result.put("logicTimeTableList", logicTimeTableList);
			result.put("logicClassList", logicClassList);
			result.put("success", true);
		} catch(Exception e) {
			e.printStackTrace();
			result.put("success", false);
		}
		
		result.put("success", true);
		return result;
	}
	
	
	/******************************************************************
	 ************************* 실습  ************************************
	 ******************************************************************/

	/******************************************************************
	 * @@@ 개강 실습 S
	 ******************************************************************/

	/**
	 * 실습 상세정보
	 * @param param
	 * @return
	 */
	public Map<String, Object> getPracticeDetail(Map param) {
		Map result = new HashMap<>();
		
		param.put("CD_TOP", "6");
		result.put("cdFacilityLev1List", commonMapper.getCommonListByMiddle(param));
		result.put("cdFacilityLev2List", commonMapper.getCodeList(param));
		
		
		result.put("practiceDetail", beginMapper.getPracticeList(param)); //개강개요 조회
		result.put("practiceStudentList", beginMapper.getPracticeStudentList(param));  //교육생 목록 조회
		            
		//result.put("cdAgentList", beginMapper.getAgentList(param));  //실습기관 콤보 조회  MAS_SUB_AGENCY
		result.put("cdAgencyList", eduMapper.getAgencyList(param));  //실습기관 콤보 조회  MAS_SUB_AGENCY
		
		
		result.put("practiceTimeTableList", beginMapper.getPracticeTimeTableList(param));  //시간표 목록 조회
		
		result.put("success", true);
		return result;
	}

	/**
	 * 교육생 선택 리스트
	 * @param param
	 * @return
	 */
	public Map<String, Object> getPracticeStudentList(Map param) {
		Map<String, Object> result = new HashMap<>();
		List<Map> getPracticeStudentList = beginMapper.getPracticeStudentList(param);
		result.put("practiceStudentList", getPracticeStudentList);
		result.put("success", true);
		return result;
	}

}
