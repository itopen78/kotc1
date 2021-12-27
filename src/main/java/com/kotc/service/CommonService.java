package com.kotc.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kotc.mapper.BeginMapper;
import com.kotc.mapper.CommonMapper;

@Service
public class CommonService {

	@Autowired CommonMapper commonMapper;
	@Autowired BeginMapper beginMapper;

	public List<Map> getCommonListTop(Map param) {
		return commonMapper.getCommonListTop(param);
	}
	
	public List<Map> getCommonListByMiddle(Map param) {
		return commonMapper.getCommonListByMiddle(param);
	}
	
	public List<Map> getCommonListByBottom(Map param) {
		return commonMapper.getCommonListByBottom(param);
	}
	
	public Map<String, Object> getAgentClassCdClsLev(Map param) {
		Map<String, Object> result = new HashMap<>();
		List<Map> cdClasLev1List = commonMapper.getCommonListByMiddle(param);
		List<Map> cdClasLev2List = new ArrayList<Map>();
		List<Map> cdAgentList = new ArrayList<Map>();
		if(cdClasLev1List.size() > 0) {
			param.put("CD_MIDDLE", cdClasLev1List.get(0).get("CODE"));
			cdClasLev2List = commonMapper.getCommonListByBottom(param);
		}
		result.put("cdClasLev1List", cdClasLev1List);
		result.put("cdClasLev2List", cdClasLev2List);
		
		if(cdClasLev2List.size() > 0) {
			param.put("CD_CLS_LEV1", cdClasLev1List.get(0).get("CODE"));
			param.put("CD_CLS_LEV2", cdClasLev2List.get(0).get("CODE"));
			cdAgentList = beginMapper.getAgentList(param);
		}		
		result.put("cdAgentList", cdAgentList);
		
		result.put("success", true);
		return result;
	}

	public List<Map> getCodeList(Map param) {
		return commonMapper.getCodeList(param);
	}
	
	

	public Map<String, Object> getAgentClassCdClsLevAdd(Map param) {
		Map<String, Object> result = new HashMap<>();
		
		String CD_MIDDLE = param.get("CD_MIDDLE").toString();
		param.put("CD_MIDDLE", "");
		List<Map> cdClasLev1List = commonMapper.getCommonListByMiddle(param);
		param.put("CD_MIDDLE", CD_MIDDLE);
		List<Map> cdClasLev2List = new ArrayList<Map>();
		List<Map> cdAgentList = new ArrayList<Map>();
		
		if(CD_MIDDLE=="")
		{
			CD_MIDDLE = cdClasLev1List.get(0).get("CODE").toString();
		}
		
		param.put("CD_MIDDLE", CD_MIDDLE);
		cdClasLev2List = commonMapper.getCommonListByBottom(param);
				
		result.put("cdClasLev1List", cdClasLev1List);
		result.put("cdClasLev2List", cdClasLev2List);
		result.put("cdAgentList", beginMapper.getAgentList(param));
		
		result.put("success", true);
		return result;
	}	
	
	

	public Map<String, Object> getPracticeAdd(Map param) {
		Map<String, Object> result = new HashMap<>();
		
		String CD_MIDDLE = param.get("CD_MIDDLE").toString();
		param.put("CD_MIDDLE", "");
		List<Map> cdFacilityLev1List = commonMapper.getCommonListByMiddle(param);
		param.put("CD_MIDDLE", CD_MIDDLE);
		List<Map> cdFacilityLev2List = new ArrayList<Map>();
		List<Map> cdSubAgencyList = new ArrayList<Map>();
		
		if(CD_MIDDLE=="")
		{
			CD_MIDDLE = cdFacilityLev1List.get(0).get("CODE").toString();
		}
		
		param.put("CD_MIDDLE", CD_MIDDLE);
		cdFacilityLev2List = commonMapper.getCommonListByBottom(param);
		
		
		param.put("CD_FACILITY_LEV1", CD_MIDDLE);
		param.put("CD_FACILITY_LEV2", cdFacilityLev2List.get(0).get("CODE").toString());
		
		
		result.put("cdFacilityLev1List", cdFacilityLev1List);
		result.put("cdFacilityLev2List", cdFacilityLev2List);
		result.put("cdSubAgencyList", beginMapper.getSubAgencyList(param));
		
		result.put("success", true);
		return result;
	}	
	
}
