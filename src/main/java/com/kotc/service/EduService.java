package com.kotc.service;

import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.apache.ibatis.session.SqlSession;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.kotc.mapper.CommonMapper;
import com.kotc.mapper.EduMapper;
import com.kotc.mapper.UserMapper;

import kr.co.kotc.api.ApiService;
import kr.co.kotc.api.FileMapper;

@Service
public class EduService {

	private static final Logger logger = LoggerFactory.getLogger(EduService.class);
			
	@Autowired
	@Qualifier("kotcSessionTemplate")
	private SqlSession kotcSqlSession;
	
	@Autowired
	@Qualifier("innodisSessionTemplate")
	private SqlSession innodisSqlSession;
	
	@Autowired UserMapper userMapper;
	
	@Autowired EduMapper eduMapper;
	
	@Autowired FileMapper fileMapper;
	
	@Autowired ApiService apiService;
	
	@Autowired CommonMapper commonMapper;
	
	@Value("${kotc.api.file.storageRoot}")
	private String storageRoot;
	
	@Value("${admin.agency.serial}")
	private String adminAgencySerial;
	
	/**
	 * 교육기관 목록
	 * @param param
	 * @return
	 */
	public Map<String, Object> getAgencyList(Map param) {
		Map<String, Object> result = new HashMap<>();
		result.put("count", eduMapper.getAgencyCount(param));
		result.put("list", eduMapper.getAgencyList(param));
		result.put("success", true);
		return result;
	}
	
	/**
	 * 교육기관 저장
	 * @param param
	 * @return
	 */
	public Map<String, Object> saveAgency(Map param) {
		Map<String, Object> result = new HashMap<>();
		try {
			/******************************************************************
			 * 입력한 교육기관 지정코드가 (GGADMIN)경기도청 코드라면
			 * 경기도청용 지정코드를 발급한다.
			 ******************************************************************/
			if(adminAgencySerial.toUpperCase().equals(param.get("AGC_SERIAL").toString().toUpperCase())) {
				param.put("adminAgencySerial", adminAgencySerial);
				String agcSerial = eduMapper.getAgencySerialByAdmin(param);
				param.put("AGC_SERIAL", agcSerial);
			}
			
			if(param.get("AGC_ID") != null && StringUtils.isNotBlank(param.get("AGC_ID").toString())) {
				Map asisAgencyDetail = eduMapper.getAgencyDetail(param);
				param.put("ORIGINAL_AGC_SERIAL", asisAgencyDetail.get("AGC_SERIAL"));
				//update
				eduMapper.setAgency(param);
				
				//사용자 교육기관 지정코드 변경
				userMapper.setAccountAgcSerialByOriginalAgcSerial(param);
			} else {
				//insert
				eduMapper.addAgency(param);
			}
			
			ObjectMapper om = new ObjectMapper();
			
			//사무원 삭제
			List<String> workerIds = om.readValue(param.get("workerIds").toString(),
	                new TypeReference<List<String>>() {
	        });
			
			for(String workerId:workerIds) {
				eduMapper.removeAgencyWorker(workerId);
			}
			
			//사무원 저장
			List<Map> saveAgencyWorkerList = om.readValue(param.get("saveAgencyWorkerList").toString(),
	                new TypeReference<List<Map>>() {
	        });
			
			for(Map agencyWorker:saveAgencyWorkerList) {
				agencyWorker.put("AGC_ID", param.get("AGC_ID").toString());
				if(agencyWorker.get("WORKER_ID") != null && StringUtils.isNotBlank(agencyWorker.get("WORKER_ID").toString())) {
					eduMapper.setAgencyWorker(agencyWorker);
				} else {
					eduMapper.addAgencyWorker(agencyWorker);
				}
			}
			
			//교육기관 (JSON) 저장
			addHisAgencyChange(param);
			
			result.put("success", true);
		} catch(Exception e) {
			result.put("success", false);
		}
		
		return result;
	}
	
	/**
	 * 교육기관 사무원 저장
	 * @param param
	 * @return
	 */
	public Map<String, Object> saveAgencyWorker(Map param) {
		Map<String, Object> result = new HashMap<>();
		try {
			eduMapper.setAgencyAgcNote(param);
			
			ObjectMapper om = new ObjectMapper();
			
			//사무원 삭제
			List<String> workerIds = om.readValue(param.get("workerIds").toString(),
	                new TypeReference<List<String>>() {
	        });
			
			for(String workerId:workerIds) {
				eduMapper.removeAgencyWorker(workerId);
			}
			
			//사무원 저장
			List<Map> saveAgencyWorkerList = om.readValue(param.get("saveAgencyWorkerList").toString(),
	                new TypeReference<List<Map>>() {
	        });
			
			for(Map agencyWorker:saveAgencyWorkerList) {
				agencyWorker.put("AGC_ID", param.get("AGC_ID").toString());
				if(agencyWorker.get("WORKER_ID") != null && StringUtils.isNotBlank(agencyWorker.get("WORKER_ID").toString())) {
					eduMapper.setAgencyWorker(agencyWorker);
				} else {
					eduMapper.addAgencyWorker(agencyWorker);
				}
			}
			
			//교육기관 (JSON) 저장
			addHisAgencyChange(param);
			
			result.put("success", true);
		} catch(Exception e) {
			result.put("success", false);
		}
		
		return result;
	}
	
	/**
	 * 교육기관 (JSON) 저장
	 * @param param
	 * @return
	 */
	public boolean addHisAgencyChange(Map param) {
		try {
			Map data = new HashMap<>();
			data.put("agencyDetail", eduMapper.getAgencyDetail(param));
			data.put("agencyWorkerList", eduMapper.getAgencyWorkerListByAgcId(param));
			ObjectMapper om = new ObjectMapper();
			param.put("CHNG_JSON", om.writeValueAsString(data));
			eduMapper.addHisAgencyChange(param);
		} catch(Exception e) {
			return false;
		}
		return true;
	}
	
	/**
	 *  교육기관 삭제
	 * @param param
	 * @return
	 */
	public Map<String, Object> removeAgency(Map param) {
		Map<String, Object> result = new HashMap<>();
		try {
			eduMapper.removeAgency(param);
			
			Map agencyDetail = eduMapper.getAgencyDetail(param);
			List<Map> agencyWorkerList = eduMapper.getAgencyWorkerListByAgcId(param);
			
			ObjectMapper om = new ObjectMapper();
			
			/******************************************************************
			 * 교육기관 (JSON) 저장
			 ******************************************************************/
			Map data = new HashMap<>();
			data.put("agencyDetail", agencyDetail);
			data.put("agencyWorkerList", agencyWorkerList);
			param.put("CHNG_JSON", om.writeValueAsString(data));
			eduMapper.addHisAgencyChange(param);
			
			result.put("success", true);
		} catch(Exception e) {
			result.put("success", false);
		}
		return result;
	}
	
	/**
	 * 교육기관 변경이력 상세
	 * @param param
	 * @return
	 */
	public Map<String, Object> getHisAgencyDetail(Map param) {
		Map<String, Object> result = new HashMap<>();
		try {
			Map hisAgencyDetail = eduMapper.getHisAgencyDetail(param);
			
			ObjectMapper om = new ObjectMapper();
			
			Map agencyDetail = om.readValue(hisAgencyDetail.get("agencyDetail").toString(), Map.class);
			List<Map> agencyWorkerList = om.readValue(hisAgencyDetail.get("agencyWorkerList").toString(), new TypeReference<List<Map>>() {});
			
			result.put("agencyDetail", agencyDetail);
			result.put("agencyWorkerList", agencyWorkerList);
			result.put("success", true);
		} catch(Exception e) {
			e.printStackTrace();
			result.put("success", false);
		}
		
		return result;
	}
	
	/**
	 * 교수요원 목록
	 * @param param
	 * @return
	 */
	public Map<String, Object> getAgentList(Map param) {
		Map<String, Object> result = new HashMap<>();
		result.put("count", eduMapper.getAgentCount(param));
		result.put("list", eduMapper.getAgentList(param));
		result.put("success", true);
		return result;
	}
	
	/**
	 * 교수요원 저장
	 * @param param
	 * @param request
	 * @param multipart
	 * @return
	 */
	public Map<String, Object> agentSave(Map param, HttpServletRequest request) {
		Map<String, Object> result = new HashMap<>();
		try {
			Map fileMap = new HashMap();
			MultipartHttpServletRequest multipart = (MultipartHttpServletRequest)request;

			/******************************************************************
			 * 기본정보 저장
			 ******************************************************************/
			if(param.get("AGT_ID") != null && StringUtils.isNotBlank(param.get("AGT_ID").toString())) {
				eduMapper.setAgent(param);
			} else {
				Map user = (Map) request.getSession().getAttribute("userInfo");
				param.put("AGC_ID", user.get("AGC_ID"));
				eduMapper.addAgent(param);
			}
			
			String AGT_ID = param.get("AGT_ID").toString();
			
			/******************************************************************
			 * 담당교육 저장
			 ******************************************************************/
			//삭제
			String[] clsIds = request.getParameterValues("clsIds");
			
			if(clsIds != null && clsIds.length > 0) {
				for(String clsId:clsIds) {
					eduMapper.removeAgentClass(clsId);
				}
			}
			
			//등록, 수정
			String[] CLS_ID_ARRAY = request.getParameterValues("CLS_ID");
			String[] CD_CLS_LEV1_ARRAY = request.getParameterValues("CD_CLS_LEV1");
			String[] CD_CLS_LEV2_ARRAY = request.getParameterValues("CD_CLS_LEV2");
			
			if(CLS_ID_ARRAY != null && CLS_ID_ARRAY.length > 0) {
				for(int i=0; i<CLS_ID_ARRAY.length; i++) {
					Map agentClass = new HashMap();
					agentClass.put("CLS_ID", CLS_ID_ARRAY[i]);
					agentClass.put("AGT_ID", AGT_ID);
					agentClass.put("CD_CLS_LEV1", CD_CLS_LEV1_ARRAY[i]);
					agentClass.put("CD_CLS_LEV2", CD_CLS_LEV2_ARRAY[i]);
					if(CLS_ID_ARRAY[i] != null && StringUtils.isNotBlank(CLS_ID_ARRAY[i].toString())) {
						eduMapper.setAgentClass(agentClass);
					} else {
						eduMapper.addAgentClass(agentClass);
					}
				}
			}
			
			/******************************************************************
			 * 자격사항 저장
			 ******************************************************************/
			//삭제
			String[] lcnsIds = request.getParameterValues("lcnsIds");
			
			if(lcnsIds != null && lcnsIds.length > 0) {
				for(String lcnsId:lcnsIds) {
					eduMapper.removeAgentLicense(lcnsId);
	
					//파일 데이터 삭제
					fileMap.put("CD_TABLE", "AGENT_LICENSE");
					fileMap.put("ID_PK", lcnsId);
					fileMapper.removeFile(fileMap);
				}
			}
			
			//등록, 수정
			String[] LCNS_ID_ARRAY = request.getParameterValues("LCNS_ID");
			String[] LCNS_NAME_ARRAY = request.getParameterValues("LCNS_NAME");
			String[] LCNS_OBTAIN_DATE_ARRAY = request.getParameterValues("LCNS_OBTAIN_DATE");
			String[] LCNS_NOTE_ARRAY = request.getParameterValues("LCNS_NOTE");
			
			if(LCNS_ID_ARRAY != null && LCNS_ID_ARRAY.length > 0) {
				for(int i=0; i<LCNS_ID_ARRAY.length; i++) {
					Map agentLicense = new HashMap();
					agentLicense.put("LCNS_ID", LCNS_ID_ARRAY[i]);
					agentLicense.put("AGT_ID", AGT_ID);
					agentLicense.put("LCNS_NAME", LCNS_NAME_ARRAY[i]);
					agentLicense.put("LCNS_OBTAIN_DATE", LCNS_OBTAIN_DATE_ARRAY[i]);
					agentLicense.put("LCNS_NOTE", LCNS_NOTE_ARRAY[i]);
					if(LCNS_ID_ARRAY[i] != null && StringUtils.isNotBlank(LCNS_ID_ARRAY[i].toString())) {
						eduMapper.setAgentLicense(agentLicense);
					} else {
						eduMapper.addAgentLicense(agentLicense);
					}
					
					if(multipart.getFiles("agentLicenseFiles").size() > 0) {
						MultipartFile file = multipart.getFiles("agentLicenseFiles").get(i);
						if(!file.isEmpty()) {
							fileMap.put("CD_TABLE", "AGENT_LICENSE");
							fileMap.put("ID_PK", agentLicense.get("LCNS_ID"));
							fileMap.put("FILE", file);
							apiService.fileSave(fileMap);
						}
					}
				}
			}
			
			/******************************************************************
			 * 경력사항 저장
			 ******************************************************************/
			//삭제
			String[] crrIds = request.getParameterValues("crrIds");
			
			if(crrIds != null && crrIds.length > 0) {
				for(String crrId:crrIds) {
					eduMapper.removeAgentCareer(crrId);
					
					//파일 데이터 삭제
					fileMap.put("CD_TABLE", "AGENT_LICENSE");
					fileMap.put("ID_PK", crrId);
					fileMapper.removeFile(fileMap);
				}
			}
			
			//등록, 수정
			String[] CRR_ID_ARRAY = request.getParameterValues("CRR_ID");
			String[] CRR_NAME_ARRAY = request.getParameterValues("CRR_NAME");
			String[] CRR_BEGIN_DATE_ARRAY = request.getParameterValues("CRR_BEGIN_DATE");
			String[] CRR_END_DATE_ARRAY = request.getParameterValues("CRR_END_DATE");
			String[] CRR_NOTE_ARRAY = request.getParameterValues("CRR_NOTE");
			
			if(CRR_ID_ARRAY != null && CRR_ID_ARRAY.length > 0) {
				for(int i=0; i<CRR_ID_ARRAY.length; i++) {
					Map agentCareer = new HashMap();
					agentCareer.put("CRR_ID", CRR_ID_ARRAY[i]);
					agentCareer.put("AGT_ID", AGT_ID);
					agentCareer.put("CRR_NAME", CRR_NAME_ARRAY[i]);
					agentCareer.put("CRR_BEGIN_DATE", CRR_BEGIN_DATE_ARRAY[i]);
					agentCareer.put("CRR_END_DATE", CRR_END_DATE_ARRAY[i]);
					agentCareer.put("CRR_NOTE", CRR_NOTE_ARRAY[i]);
					if(CRR_ID_ARRAY[i] != null && StringUtils.isNotBlank(CRR_ID_ARRAY[i].toString())) {
						eduMapper.setAgentCareer(agentCareer);
					} else {
						eduMapper.addAgentCareer(agentCareer);
					}
					
					if(multipart.getFiles("agentCareerFiles").size() > 0) {
						MultipartFile file = multipart.getFiles("agentCareerFiles").get(i);
						if(!file.isEmpty()) {
							fileMap.put("CD_TABLE", "AGENT_CAREER");
							fileMap.put("ID_PK", agentCareer.get("CRR_ID"));
							fileMap.put("FILE", file);
							apiService.fileSave(fileMap);
						}
					}
				}
			}
			
			/******************************************************************
			 * 타 기관 출강여부 저장
			 ******************************************************************/
			//삭제
			String[] lctrIds = request.getParameterValues("lctrIds");
			
			if(lctrIds != null && lctrIds.length > 0) {
				for(String lctrId:lctrIds) {
					eduMapper.removeAgentOutsideLecture(lctrId);
				}
			}
			
			//등록, 수정
			String[] LCTR_ID_ARRAY = request.getParameterValues("LCTR_ID");
			String[] LCTR_NAME_ARRAY = request.getParameterValues("LCTR_NAME");
			String[] LCTR_NOTE_ARRAY = request.getParameterValues("LCTR_NOTE");
			
			if(LCTR_ID_ARRAY != null && LCTR_ID_ARRAY.length > 0) {
				for(int i=0; i<LCTR_ID_ARRAY.length; i++) {
					Map agentOutsideLecture = new HashMap();
					agentOutsideLecture.put("LCTR_ID", LCTR_ID_ARRAY[i]);
					agentOutsideLecture.put("AGT_ID", AGT_ID);
					agentOutsideLecture.put("LCTR_NAME", LCTR_NAME_ARRAY[i]);
					agentOutsideLecture.put("LCTR_NOTE", LCTR_NOTE_ARRAY[i]);
					if(LCTR_ID_ARRAY[i] != null && StringUtils.isNotBlank(LCTR_ID_ARRAY[i].toString())) {
						eduMapper.setAgentOutsideLecture(agentOutsideLecture);
					} else {
						eduMapper.addAgentOutsideLecture(agentOutsideLecture);
					}
				}
			}
			
			//교수요원 변경신청 (JSON) 저장
			addHisAgentChange(param);
			
			result.put("success", true);
		} catch(Exception e) {
			e.printStackTrace();
			result.put("success", false);
		}
		
		return result;
	}
	
	/**
	 * 교수요원 변경신청 (JSON) 저장
	 * @param param
	 * @return
	 */
	public boolean addHisAgentChange(Map param) {
		try {
			Map data = new HashMap<>();
			data.put("agentDetail", eduMapper.getAgentDetail(param)); //교수요원 조회
			data.put("agentClassList", eduMapper.getAgentClassList(param)); //담당과목 목록 조회
			data.put("agentLicenseList", eduMapper.getAgentLicenseList(param)); //자격사항 목록 조회
			data.put("agentCareerList", eduMapper.getAgentCareerList(param)); //경력사항 목록 조회
			data.put("agentOutsideLectureList", eduMapper.getAgentOutsideLectureList(param)); //타 기관 출강여부 목록 조회
			ObjectMapper om = new ObjectMapper();
			param.put("CHNG_JSON", om.writeValueAsString(data));
			eduMapper.addHisAgentChange(param);
		} catch(Exception e) {
			return false;
		}
		return true;
	}
	
	/**
	 * 교수요원 상세정보
	 * @param param
	 * @return
	 */
	public Map<String, Object> getAgentDetail(Map param) {
		Map result = new HashMap<>();
		param.put("CD_TOP", "4");
		result.put("cdClasLev1List", commonMapper.getCommonListByMiddle(param));
		result.put("cdClasLev2List", commonMapper.getCodeList(param));
		result.put("agentDetail", eduMapper.getAgentDetail(param)); //교수요원 조회
		result.put("agentClassList", eduMapper.getAgentClassList(param)); //담당과목 목록 조회
		result.put("agentLicenseList", eduMapper.getAgentLicenseList(param)); //자격사항 목록 조회
		result.put("agentCareerList", eduMapper.getAgentCareerList(param)); //경력사항 목록 조회
		result.put("agentOutsideLectureList", eduMapper.getAgentOutsideLectureList(param)); //타 기관 출강여부 목록 조회
		result.put("success", true);
		return result;
	}
	
	/**
	 * 교수요원 변경이력 상세
	 * @param param
	 * @return
	 */
	public Map<String, Object> getHisAgentDetail(Map param) {
		Map<String, Object> result = new HashMap<>();
		try {
			Map hisAgentDetail = eduMapper.getHisAgentDetail(param);
			
			ObjectMapper om = new ObjectMapper();
			
			Map agentDetail = om.readValue(hisAgentDetail.get("agentDetail").toString(), Map.class);
			List<Map> agentClassList = om.readValue(hisAgentDetail.get("agentClassList").toString(), new TypeReference<List<Map>>() {});
			List<Map> agentLicenseList = om.readValue(hisAgentDetail.get("agentLicenseList").toString(), new TypeReference<List<Map>>() {});
			List<Map> agentCareerList = om.readValue(hisAgentDetail.get("agentCareerList").toString(), new TypeReference<List<Map>>() {});
			List<Map> agentOutsideLectureList = om.readValue(hisAgentDetail.get("agentOutsideLectureList").toString(), new TypeReference<List<Map>>() {});
			
			result.put("agentDetail", agentDetail);
			result.put("agentClassList", agentClassList);
			result.put("agentLicenseList", agentLicenseList);
			result.put("agentCareerList", agentCareerList);
			result.put("agentOutsideLectureList", agentOutsideLectureList);
			result.put("success", true);
		} catch(Exception e) {
			e.printStackTrace();
			result.put("success", false);
		}
		
		return result;
	}
	
	/**
	 * 교수요원 삭제 신청
	 * @param param
	 * @return
	 */
	public Map<String, Object> removeApplyAgent(Map param) {
		Map<String, Object> result = new HashMap<>();
		eduMapper.setAgentChngState(param);
		
		//교수요원 변경신청 (JSON) 저장
		addHisAgentChange(param);
		
		result.put("success", true);
		return result;
	}
	
	/**
	 * 연계실습기관 목록
	 * @param param
	 * @return
	 */
	public Map<String, Object> getSubAgencyList(Map param) {
		Map<String, Object> result = new HashMap<>();
		result.put("count", eduMapper.getSubAgencyCount(param));
		result.put("list", eduMapper.getSubAgencyList(param));
		result.put("success", true);
		return result;
	}
	
	/**
	 * 연계실습기관 저장
	 * @param param
	 * @param request
	 * @return
	 */
	public Map<String, Object> subAgencySave(Map param, HttpServletRequest request) {
		Map<String, Object> result = new HashMap<>();
		try {
			Map fileMap = new HashMap();
			MultipartHttpServletRequest multipart = (MultipartHttpServletRequest)request;
			
			/******************************************************************
			 * 기본정보 저장
			 ******************************************************************/
			if(param.get("SAGC_ID") != null && StringUtils.isNotBlank(param.get("SAGC_ID").toString())) {
				eduMapper.setSubAgency(param);
			} else {
				Map user = (Map) request.getSession().getAttribute("userInfo");
				param.put("AGC_ID", user.get("AGC_ID"));
				eduMapper.addSubAgency(param);
			}
			
			String SAGC_ID = param.get("SAGC_ID").toString();
			
			/******************************************************************
			 * 첨부서류 저장
			 ******************************************************************/
			//삭제
			String[] contDocIds = request.getParameterValues("contDocIds");
			
			if(contDocIds != null && contDocIds.length > 0) {
				for(String contDocId:contDocIds) {
					eduMapper.removeSubAgencyContractDocument(contDocId);
					
					//파일 데이터 삭제
					fileMap.put("CD_TABLE", "SUB_AGENCY_CONTRACT_DOCUMENT");
					fileMap.put("ID_PK", contDocId);
					fileMapper.removeFile(fileMap);
				}
			}
			
			//등록, 수정
			String[] CONT_DOC_ID_ARRAY = request.getParameterValues("CONT_DOC_ID");
			String[] CD_CONT_DOC_TYPE_ARRAY = request.getParameterValues("CD_CONT_DOC_TYPE");
			String[] CONT_DOC_NOTE_ARRAY = request.getParameterValues("CONT_DOC_NOTE");
			
			if(CONT_DOC_ID_ARRAY != null && CONT_DOC_ID_ARRAY.length > 0) {
				for(int i=0; i<CONT_DOC_ID_ARRAY.length; i++) {
					Map subAgencyContractDocument = new HashMap();
					subAgencyContractDocument.put("CONT_DOC_ID", CONT_DOC_ID_ARRAY[i]);
					subAgencyContractDocument.put("SAGC_ID", SAGC_ID);
					subAgencyContractDocument.put("CD_CONT_DOC_TYPE", CD_CONT_DOC_TYPE_ARRAY[i]);
					subAgencyContractDocument.put("CONT_DOC_NOTE", CONT_DOC_NOTE_ARRAY[i]);
					if(CONT_DOC_ID_ARRAY[i] != null && StringUtils.isNotBlank(CONT_DOC_ID_ARRAY[i].toString())) {
						eduMapper.setSubAgencyContractDocument(subAgencyContractDocument);
					} else {
						eduMapper.addSubAgencyContractDocument(subAgencyContractDocument);
					}
					
					if(multipart.getFiles("subAgencyContractDocumentFiles").size() > 0) {
						MultipartFile file = multipart.getFiles("subAgencyContractDocumentFiles").get(i);
						if(!file.isEmpty()) {
							fileMap.put("CD_TABLE", "SUB_AGENCY_CONTRACT_DOCUMENT");
							fileMap.put("ID_PK", subAgencyContractDocument.get("CONT_DOC_ID"));
							fileMap.put("FILE", file);
							apiService.fileSave(fileMap);
						}
					}
				}
			}
			
			//연계실습기관 변경신청 (JSON) 저장
			addHisSubAgencyChange(param);
			
			result.put("success", true);
		} catch(Exception e) {
			e.printStackTrace();
			result.put("success", false);
		}
		return result;
	}
	
	/**
	 * 연계실습기관 변경신청 (JSON) 저장
	 * @param param
	 * @return
	 */
	public boolean addHisSubAgencyChange(Map param) {
		try {
			/******************************************************************
			 * 연계실습기관 변경신청 (JSON) 저장
			 ******************************************************************/
			Map data = new HashMap<>();
			data.put("subAgencyDetail", eduMapper.getSubAgencyDetail(param));
			data.put("subAgencyContractDocumentList", eduMapper.getSubAgencyContractDocumentList(param)); //첨부서류 목록 조회
			ObjectMapper om = new ObjectMapper();
			param.put("CHNG_JSON", om.writeValueAsString(data));
			eduMapper.addHisSubAgencyChange(param);
		} catch(Exception e) {
			return false;
		}
		return true;
	}
	
	/**
	 * 연계실습기관 상세
	 * @param param
	 * @return
	 */
	public Map<String, Object> getSubAgencyDetail(Map param) {
		Map<String, Object> result = new HashMap<>();
		result.put("subAgencyDetail", eduMapper.getSubAgencyDetail(param));
		result.put("subAgencyContractDocumentList", eduMapper.getSubAgencyContractDocumentList(param)); //첨부서류 목록 조회
		result.put("success", true);
		return result;
	}
	
	/**
	 * 연계실습기관 삭제신청
	 * @param param
	 * @return
	 */
	public Map<String, Object> removeApplySubAgency(Map param) {
		Map<String, Object> result = new HashMap<>();
		eduMapper.setSubAgencyChngState(param);
		
		//연계실습기관 변경신청 (JSON) 저장
		addHisSubAgencyChange(param);
		
		result.put("success", true);
		return result;
	}
	
	/**
	 * 연계실습기관 변경이력 상세
	 * @param param
	 * @return
	 */
	public Map<String, Object> getHisSubAgencyDetail(Map param) {
		Map<String, Object> result = new HashMap<>();
		try {
			Map hisSubAgencyDetail = eduMapper.getHisSubAgencyDetail(param);
			
			ObjectMapper om = new ObjectMapper();
			
			Map subAgencyDetail = om.readValue(hisSubAgencyDetail.get("subAgencyDetail").toString(), Map.class);
			List<Map> subAgencyContractDocumentList = om.readValue(hisSubAgencyDetail.get("subAgencyContractDocumentList").toString(), new TypeReference<List<Map>>() {});
			
			result.put("subAgencyDetail", subAgencyDetail);
			result.put("subAgencyContractDocumentList", subAgencyContractDocumentList);
			result.put("success", true);
		} catch(Exception e) {
			e.printStackTrace();
			result.put("success", false);
		}
		return result;
	}
	
	// 실습지도자 관련 Service(안명진) 
	/**
	 * 실습지도자 목록
	 * @param param
	 * @return
	 */
	public Map<String, Object> getSubAgentList(Map param) {
		Map<String, Object> result = new HashMap<>();
		result.put("count", eduMapper.getSubAgentCount(param));
		result.put("list", eduMapper.getSubAgentList(param));
		result.put("success", true);
		return result;
	}
	
	/**
	 * 실습지도자 저장
	 * @param param
	 * @return
	 */
	public Map<String, Object> saveSubAgent(Map param, HttpServletRequest request) {
		Map<String, Object> result = new HashMap<>();
		
		try {
			Map fileMap = new HashMap();
			MultipartHttpServletRequest multipart = (MultipartHttpServletRequest)request;
			
			/******************************************************************
			 * 기본정보 저장
			 ******************************************************************/
			if(param.get("SAGT_ID") != null && StringUtils.isNotBlank(param.get("SAGT_ID").toString())) {
				eduMapper.setSubAgent(param);
			} else {
				Map user = (Map) request.getSession().getAttribute("userInfo");
				param.put("AGC_ID", user.get("AGC_ID"));
				
				Map subAgencyDetail = eduMapper.getSubAgencyByAgcId(param);
				param.put("SAGC_ID", subAgencyDetail.get("SAGC_ID"));
				
				eduMapper.addSubAgent(param);
			}
			
			String SAGT_ID = param.get("SAGT_ID").toString();
			
			/******************************************************************
			 * 자격사항 저장
			 ******************************************************************/
			//삭제
			String[] lcnsIds = request.getParameterValues("lcnsIds");
			
			if(lcnsIds != null && lcnsIds.length > 0) {
				for(String lcnsId:lcnsIds) {
					eduMapper.removeSubAgentLicense(lcnsId);
	
					//파일 데이터 삭제
					fileMap.put("CD_TABLE", "SUB_AGENT_LICENSE");
					fileMap.put("ID_PK", lcnsId);
					fileMapper.removeFile(fileMap);
				}
			}
			
			//등록, 수정
			String[] LCNS_ID_ARRAY = request.getParameterValues("LCNS_ID");
			String[] LCNS_NAME_ARRAY = request.getParameterValues("LCNS_NAME");
			String[] LCNS_OBTAIN_DATE_ARRAY = request.getParameterValues("LCNS_OBTAIN_DATE");
			String[] LCNS_NOTE_ARRAY = request.getParameterValues("LCNS_NOTE");
			
			if(LCNS_ID_ARRAY != null && LCNS_ID_ARRAY.length >0) {
				for(int i=0; i<LCNS_ID_ARRAY.length; i++) {
					Map subAgentLicense = new HashMap();
					subAgentLicense.put("LCNS_ID", LCNS_ID_ARRAY[i]);
					subAgentLicense.put("SAGT_ID", SAGT_ID);
					subAgentLicense.put("LCNS_NAME", LCNS_NAME_ARRAY[i]);
					subAgentLicense.put("LCNS_OBTAIN_DATE", LCNS_OBTAIN_DATE_ARRAY[i]);
					subAgentLicense.put("LCNS_NOTE", LCNS_NOTE_ARRAY[i]);
					if(LCNS_ID_ARRAY[i] != null && StringUtils.isNotBlank(LCNS_ID_ARRAY[i].toString())) {
						eduMapper.setSubAgentLicense(subAgentLicense);
					} else {
						eduMapper.addSubAgentLicense(subAgentLicense);
					}
					
					if(multipart.getFiles("subAgentLicenseFiles").size() > 0) {
						MultipartFile file = multipart.getFiles("subAgentLicenseFiles").get(i);
						if(!file.isEmpty()) {
							fileMap.put("CD_TABLE", "SUB_AGENT_LICENSE");
							fileMap.put("ID_PK", subAgentLicense.get("LCNS_ID"));
							fileMap.put("FILE", file);
							apiService.fileSave(fileMap);
						}
					}
				}
			}

			
			/******************************************************************
			 * 경력사항 저장
			 ******************************************************************/
			//삭제
			String[] crrIds = request.getParameterValues("crrIds");
			
			if(crrIds != null && crrIds.length > 0) {
				for(String crrId:crrIds) {
					eduMapper.removeSubAgentCareer(crrId);
					
					//파일 데이터 삭제
					fileMap.put("CD_TABLE", "SUB_AGENT_CAREER");
					fileMap.put("ID_PK", crrId);
					fileMapper.removeFile(fileMap);
				}
			}
			
			//등록, 수정
			String[] CRR_ID_ARRAY = request.getParameterValues("CRR_ID");
			String[] CRR_NAME_ARRAY = request.getParameterValues("CRR_NAME");
			String[] CRR_BEGIN_DATE_ARRAY = request.getParameterValues("CRR_BEGIN_DATE");
			String[] CRR_END_DATE_ARRAY = request.getParameterValues("CRR_END_DATE");
			String[] CRR_NOTE_ARRAY = request.getParameterValues("CRR_NOTE");
			
			if(CRR_ID_ARRAY != null && CRR_ID_ARRAY.length >0) {
				for(int i=0; i<CRR_ID_ARRAY.length; i++) {
					Map subAgentCareer = new HashMap();
					subAgentCareer.put("CRR_ID", CRR_ID_ARRAY[i]);
					subAgentCareer.put("SAGT_ID", SAGT_ID);
					subAgentCareer.put("CRR_NAME", CRR_NAME_ARRAY[i]);
					subAgentCareer.put("CRR_BEGIN_DATE", CRR_BEGIN_DATE_ARRAY[i]);
					subAgentCareer.put("CRR_END_DATE", CRR_END_DATE_ARRAY[i]);
					subAgentCareer.put("CRR_NOTE", CRR_NOTE_ARRAY[i]);
					if(CRR_ID_ARRAY[i] != null && StringUtils.isNotBlank(CRR_ID_ARRAY[i].toString())) {
						eduMapper.setSubAgentCareer(subAgentCareer);
					} else {
						eduMapper.addSubAgentCareer(subAgentCareer);
					}
					
					if(multipart.getFiles("subAgentCareerFiles").size() > 0) {
						MultipartFile file = multipart.getFiles("subAgentCareerFiles").get(i);
						if(!file.isEmpty()) {
							fileMap.put("CD_TABLE", "SUB_AGENT_CAREER");
							fileMap.put("ID_PK", subAgentCareer.get("CRR_ID"));
							fileMap.put("FILE", file);
							apiService.fileSave(fileMap);
						}
					}
				}
			}
			//실습지도자 변경신청 (JSON) 저장
			addHisSubAgentChange(param);
			
			result.put("success", true);
		}catch(Exception e) {
			e.printStackTrace();
			result.put("success", false);
		}
		
		return result;
	}
	
	/**
	 * 실습지도자 변경신청 (JSON) 저장
	 * @param param
	 * @return
	 */
	public boolean addHisSubAgentChange(Map param) {
		try {
			/******************************************************************
			 * 실습지도자 변경신청 (JSON) 저장
			 ******************************************************************/
			Map data = new HashMap<>();
			data.put("subAgentDetail", eduMapper.getSubAgentDetail(param)); //실습지도자 조회
			data.put("subAgentLicenseList", eduMapper.getSubAgentLicenseList(param)); //자격사항 목록 조회
			data.put("subAgentCareerList", eduMapper.getSubAgentCareerList(param)); //경력사항 목록 조회
			ObjectMapper om = new ObjectMapper();
			param.put("CHNG_JSON", om.writeValueAsString(data));
			eduMapper.addHisSubAgentChange(param);
			
		} catch(Exception e) {
			return false;
		}
		return true;
	}
	
	/**
	 * 실습지도자 상세정보
	 * @param param
	 * @return
	 */
	public Map<String, Object> getSubAgentDetail(Map param) {
		Map<String, Object> result = new HashMap<>();
		
		result.put("subAgentDetail", eduMapper.getSubAgentDetail(param));
		result.put("subAgentLicenseList", eduMapper.getSubAgentLicenseList(param));
		result.put("subAgentCareerList", eduMapper.getSubAgentCareerList(param));
		result.put("success", true);
		return result;
	}
	
	/**
	 * 실습지도자 삭제신청
	 * @param param
	 * @return
	 */
	public Map<String, Object> removeApplySubAgent(Map param) {
		Map<String, Object> result = new HashMap<>();
		eduMapper.setSubAgentChngState(param);
		
		//실습지도자 변경신청 (JSON) 저장
		addHisSubAgentChange(param);
		
		result.put("success", true);
		return result;
	}
	
	/**
	 * 실습지도자 변경이력 상세
	 * @param param
	 * @return
	 */
	public Map<String, Object> getHisSubAgentDetail(Map param) {
		Map<String, Object> result = new HashMap<>();
		try {
			Map hisSubAgentDetail = eduMapper.getHisSubAgentDetail(param);
			
			ObjectMapper om = new ObjectMapper();
			
			Map subAgentDetail = om.readValue(hisSubAgentDetail.get("subAgentDetail").toString(), Map.class);
			List<Map> subAgentLicenseList = om.readValue(hisSubAgentDetail.get("subAgentLicenseList").toString(), new TypeReference<List<Map>>() {});
			List<Map> subAgentCareerList = om.readValue(hisSubAgentDetail.get("subAgentCareerList").toString(), new TypeReference<List<Map>>() {});
			
			result.put("subAgentDetail", subAgentDetail);
			result.put("subAgentLicenseList", subAgentLicenseList);
			result.put("subAgentCareerList", subAgentCareerList);
			result.put("success", true);
		} catch(Exception e) {
			e.printStackTrace();
			result.put("success", false);
		}
		return result;
	}


	// 실습지도자 관련 Service(안명진) 
	
	/**
	 * 교육생 목록
	 * @param param
	 * @return
	 */
	public Map<String, Object> getStudentList(Map param) {
		Map<String, Object> result = new HashMap<>();
		result.put("count", eduMapper.getStudentCount(param));
		result.put("list", eduMapper.getStudentList(param));
		result.put("success", true);
		return result;
	}
	
	/**
	 * 교육생 상세정보
	 * @param param
	 * @return
	 */
	public Map<String, Object> getStudentDetail(Map param) {
		Map<String, Object> result = new HashMap<>();
		result.put("studentDetail", eduMapper.getStudentDetail(param));
		result.put("success", true);
		return result;
	}
	
	public Map<String, Object> removeStudent(Map param) {
		Map<String, Object> result = new HashMap<>();
		eduMapper.removeStudent(param);
		addHisStudentChange(param);
		result.put("success", true);
		return result;
	}
	
	/**
	 * 교육생 변경신청 (JSON) 저장
	 * @param param
	 * @return
	 */
	public boolean addHisStudentChange(Map param) {
		try {
			/******************************************************************
			 * 교육생 변경신청 (JSON) 저장
			 ******************************************************************/
			Map data = new HashMap<>();
			data.put("studentDetail", eduMapper.getStudentDetail(param));
			ObjectMapper om = new ObjectMapper();
			param.put("CHNG_JSON", om.writeValueAsString(data));
			eduMapper.addHisStudentChange(param);
		} catch(Exception e) {
			return false;
		}
		return true;
	}
	
	/**
	 * 교육생 저장
	 * @param param
	 * @return
	 */
	public Map<String, Object> saveStudent(Map param) {
		Map<String, Object> result = new HashMap<>();
		try {
			if(param.get("STU_ID") != null && StringUtils.isNotBlank(param.get("STU_ID").toString())) {
				//update
				eduMapper.setStudent(param);
			} else {
				//insert
				eduMapper.addStudent(param);
			}
			
			//교육생 (JSON) 저장
			addHisStudentChange(param);
			
			result.put("success", true);
		} catch(Exception e) {
			result.put("success", false);
		}
		
		return result;
	}
	
	/**
	 * 교육생 변경이력 상세
	 * @param param
	 * @return
	 */
	public Map<String, Object> getHisStudentDetail(Map param) {
		Map<String, Object> result = new HashMap<>();
		try {
			Map hisStudentDetail = eduMapper.getHisStudentDetail(param);
			
			ObjectMapper om = new ObjectMapper();
			
			Map studentDetail = om.readValue(hisStudentDetail.get("studentDetail").toString(), Map.class);
			
			result.put("studentDetail", studentDetail);
			result.put("success", true);
		} catch(Exception e) {
			e.printStackTrace();
			result.put("success", false);
		}
		return result;
	}
	
	/**
	 * 자체점검 목록
	 * @param param
	 * @return
	 */
	public Map<String, Object> getSelfCheckList(Map param) {
		Map<String, Object> result = new HashMap<>();
		result.put("count", eduMapper.getSelfCheckCount(param));
		result.put("list", eduMapper.getSelfCheckList(param));
		result.put("success", true);
		return result;
	}

	/**
	 * 자제점검 저장
	 * @param param
	 * @param request
	 * @return
	 */
	public Map<String, Object> selfCheckSave(Map param, HttpServletRequest request) {
		Map<String, Object> result = new HashMap<>();
		try {
			Map fileMap = new HashMap();
			MultipartHttpServletRequest multipart = (MultipartHttpServletRequest)request;
			
			/******************************************************************
			 * 기본정보 저장
			 ******************************************************************/
			Map user = (Map) request.getSession().getAttribute("userInfo");
			param.put("AGC_ID", user.get("AGC_ID"));
			param.put("WRITED_ID", user.get("ACC_ID"));
			eduMapper.addSelfCheck(param);
			
			String CHECK_ID = param.get("CHECK_ID").toString();
			
			/******************************************************************
			 * 첨부파일 저장
			 ******************************************************************/
			MultipartFile file = multipart.getFile("selfCheckFile");
			if(file != null && !file.isEmpty()) {
				fileMap.put("CD_TABLE", "MAS_SELF_CHECK");
				fileMap.put("ID_PK", CHECK_ID);
				fileMap.put("FILE", file);
				apiService.fileSave(fileMap);
			}
			
			result.put("success", true);
		} catch(Exception e) {
			e.printStackTrace();
			result.put("success", false);
		}
		return result;
	}
	
	/**
	 * 연계실습기관 목록, 실습지도자 목록, 교수요원 목록
	 * 사업계획서에서 필요
	 * @param user
	 * @return
	 */
	public Map<String, Object> getBusinessPlanByAgentInfo(Map user) {
		Map<String, Object> result = new HashMap<>();
		Map param = new HashMap<>();
		param.put("AGC_ID", user.get("AGC_ID").toString());
		param.put("CD_ADD_STATE", "3"); //등록승인
		result.put("subAgencyList", eduMapper.getSubAgencyList(param)); //연계실습기관 목록
		result.put("subAgentList", eduMapper.getSubAgentList(param)); //실습지도자 목록
		result.put("agentList", eduMapper.getAgentList(param)); //교수요원 목록
		return result;
	}
}
