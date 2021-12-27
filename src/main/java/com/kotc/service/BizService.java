package com.kotc.service;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.kotc.mapper.BizMapper;
import com.kotc.mapper.EduMapper;

@Service
public class BizService {

	private static final Logger logger = LoggerFactory.getLogger(BizService.class);
	
	@Autowired
	@Qualifier("kotcSessionTemplate")
	private SqlSession kotcSqlSession;
	
	@Autowired
	@Qualifier("innodisSessionTemplate")
	private SqlSession innodisSqlSession;
	
	@Autowired BizMapper bizMapper;
	
	@Autowired EduMapper eduMapper;
	
	/**
	 * 사업계획서 목록
	 * @param param
	 * @return
	 */
	public Map<String, Object> getBusinessPlanList(Map param) {
		Map<String, Object> result = new HashMap<>();
		
		result.put("count", bizMapper.getBusinessPlanCount(param));
		result.put("list", bizMapper.getBusinessPlanList(param));
		result.put("success", true);
		return result;
	}
	
	/**
	 * 사업계획서 저장
	 * @param param
	 * @return
	 */
	public Map<String, Object> saveBusinessPlan(Map param) {
		Map<String, Object> result = new HashMap<>();
		
		ObjectMapper om = new ObjectMapper();
		try {
			String accId = param.get("SESSION_ACC_ID").toString();
			String agcId = param.get("SESSION_AGC_ID").toString();
			
			/************************************************************************
			 * 연간사업계획 
			 ************************************************************************/
			Map<String, Object> businessPlanDetail = om.readValue(param.get("businessPlanDetail").toString(),
	                new TypeReference<Map<String, Object>>() {
	        });
			if(businessPlanDetail.get("PLAN_ID") != null && StringUtils.isNotBlank(businessPlanDetail.get("PLAN_ID").toString())) {
				bizMapper.setBusinessPlan(businessPlanDetail);
			} else {
				businessPlanDetail.put("REQUEST_ID", accId);
				businessPlanDetail.put("AGC_ID", agcId);
				bizMapper.addBusinessPlan(businessPlanDetail);
			}
			
			String PLAN_ID = businessPlanDetail.get("PLAN_ID").toString();
			param.put("PLAN_ID", PLAN_ID);
			
			/************************************************************************
			 * 연계실습기관 
			 ************************************************************************/
			List<String> sagcIds = om.readValue(param.get("sagcIds").toString(),
					new TypeReference<List<String>>() {
			});
			Map planSagency = new HashMap<>();
			planSagency.put("PLAN_ID", PLAN_ID);
			planSagency.put("sagcIds", sagcIds);
			bizMapper.removePlanSagency(planSagency);
			for(String sagcId:sagcIds) {
				planSagency.put("SAGC_ID", sagcId);
				int count = bizMapper.getPlanSagencyCount(planSagency);
				if(count <= 0) {
					bizMapper.addPlanSagency(planSagency);
				}
			}
			
			/************************************************************************
			 * 실습지도자
			 ************************************************************************/
			List<String> sagtIds = om.readValue(param.get("sagtIds").toString(),
	                new TypeReference<List<String>>() {
	        });
			Map planSagent = new HashMap<>();
			planSagent.put("PLAN_ID", PLAN_ID);
			planSagent.put("sagtIds", sagtIds);
			bizMapper.removePlanSagent(planSagent);
			for(String sagtId:sagtIds) {
				planSagent.put("SAGT_ID", sagtId);
				int count = bizMapper.getPlanSagentCount(planSagent);
				if(count <= 0) {
					bizMapper.addPlanSagent(planSagent);
				}
			}
			
			/************************************************************************
			 * 교수요원
			 ************************************************************************/
			List<String> agtIds = om.readValue(param.get("agtIds").toString(),
					new TypeReference<List<String>>() {
			});
			Map planAgent = new HashMap<>();
			planAgent.put("PLAN_ID", PLAN_ID);
			planAgent.put("agtIds", agtIds);
			bizMapper.removePlanAgent(planAgent);
			for(String agtId:agtIds) {
				planAgent.put("AGT_ID", agtId);
				int count = bizMapper.getPlanAgentCount(planAgent);
				if(count <= 0) {
					bizMapper.addPlanAgent(planAgent);
				}
			}
			
			/************************************************************************
			 * 과목별 교수요원
			 ************************************************************************/
			List<Map<String, Object>> planClassList = om.readValue(param.get("planClassList").toString(),
					new TypeReference<List<Map<String, Object>>>() {
			});
			for(Map planClass:planClassList) {
				planClass.put("PLAN_ID", PLAN_ID);
				String MAPPER_ID = bizMapper.getPlanClassMapperId(planClass);
				if(MAPPER_ID != null && StringUtils.isNotBlank(MAPPER_ID)) {
					planClass.put("MAPPER_ID", MAPPER_ID);
				} else {
					bizMapper.addPlanClass(planClass);
				}
				
				Map planClassAgent = new HashMap<>();
				planClassAgent.put("PARENT_ID", planClass.get("MAPPER_ID").toString());
				
				if(planClass.get("agts1") != null && StringUtils.isNotBlank(planClass.get("agts1").toString())) {
					List<String> agts1 = Arrays.asList(planClass.get("agts1").toString().split(","));
					planClassAgent.put("agts", agts1);
					planClassAgent.put("AGT_TYPE", 1);
					bizMapper.removePlanClassAgent(planClassAgent);
					for(String agtId:agts1) {
						planClassAgent.put("AGT_ID", agtId);
						int count = bizMapper.getPlanClassAgentCount(planClassAgent);
						if(count <= 0) {
							bizMapper.addPlanClassAgent(planClassAgent);
						}
					}
				} else {
					planClassAgent.put("AGT_TYPE", 1);
					bizMapper.removePlanClassAgent(planClassAgent);
				}
				
				if(planClass.get("agts2") != null && StringUtils.isNotBlank(planClass.get("agts2").toString())) {
					List<String> agts2 = Arrays.asList(planClass.get("agts2").toString().split(","));
					List<String> agts1 = Arrays.asList(planClass.get("agts1").toString().split(","));
					planClassAgent.put("agts", agts2);
					planClassAgent.put("AGT_TYPE", 2);
					bizMapper.removePlanClassAgent(planClassAgent);
					for(String agtId:agts2) {
						planClassAgent.put("AGT_ID", agtId);
						int count = bizMapper.getPlanClassAgentCount(planClassAgent);
						if(count <= 0) {
							bizMapper.addPlanClassAgent(planClassAgent);
						}
					}
				} else {
					planClassAgent.put("AGT_TYPE", 2);
					bizMapper.removePlanClassAgent(planClassAgent);
				}
			}
			
			//사업계획서 변경이력 (JSON) 저장
			addHisBusinessPlanChange(param);
		} catch(Exception e) {
			e.printStackTrace();
			result.put("success", false);
		}
		
		result.put("success", true);
		return result;
	}
	
	/**
	 * 사업계획서 변경이력 (JSON) 저장
	 * @param param
	 * @return
	 */
	public boolean addHisBusinessPlanChange(Map param) {
		try {
			Map data = new HashMap<>();
			Map businessPlanDetail = bizMapper.getBusinessPlanDetail(param);
			data.put("businessPlanDetail", businessPlanDetail);
			data.put("planSagencyList", bizMapper.getPlanSagencyList(param));
			data.put("planSagentList", bizMapper.getPlanSagentList(param));
			data.put("planAgentList", bizMapper.getPlanAgentList(param));
			data.put("planClassList", bizMapper.getPlanClassList(param));
			ObjectMapper om = new ObjectMapper();
			param.put("CHNG_JSON", om.writeValueAsString(data));
			bizMapper.addHisBusinessPlanChange(param);
		} catch(Exception e) {
			return false;
		}
		return true;
	}

	/**
	 * 사업계획서 상세정보 조회
	 * @param param
	 * @return
	 */
	public Map<String, Object> getBusinessPlanDetail(Map param) {
		Map<String, Object> result = new HashMap<>();
		result.put("businessPlanDetail", bizMapper.getBusinessPlanDetail(param));
		result.put("planSagencyList", bizMapper.getPlanSagencyList(param));
		result.put("planSagentList", bizMapper.getPlanSagentList(param));
		result.put("planAgentList", bizMapper.getPlanAgentList(param));
		result.put("planClassList", bizMapper.getPlanClassList(param));
		result.put("success", true);
		return result;
	}
	
	/**
	 * 사업계획서 변경이력 상세
	 * @param param
	 * @return
	 */
	public Map<String, Object> getHisBusinessPlanDetail(Map param) {
		Map<String, Object> result = new HashMap<>();
		try {
			Map hisBusinessPlanDetail = bizMapper.getHisBusinessPlanDetail(param);
			
			ObjectMapper om = new ObjectMapper();
			
			Map businessPlanDetail = om.readValue(hisBusinessPlanDetail.get("businessPlanDetail").toString(), Map.class);
			List<Map> planSagencyList = om.readValue(hisBusinessPlanDetail.get("planSagencyList").toString(), new TypeReference<List<Map>>() {});
			List<Map> planSagentList = om.readValue(hisBusinessPlanDetail.get("planSagentList").toString(), new TypeReference<List<Map>>() {});
			List<Map> planAgentList = om.readValue(hisBusinessPlanDetail.get("planAgentList").toString(), new TypeReference<List<Map>>() {});
			List<Map> planClassList = om.readValue(hisBusinessPlanDetail.get("planClassList").toString(), new TypeReference<List<Map>>() {});
			
			result.put("businessPlanDetail", businessPlanDetail);
			result.put("planSagencyList", planSagencyList);
			result.put("planSagentList", planSagentList);
			result.put("planAgentList", planAgentList);
			result.put("planClassList", planClassList);
			result.put("success", true);
		} catch(Exception e) {
			e.printStackTrace();
			result.put("success", false);
		}
		
		result.put("success", true);
		return result;
	}
}
