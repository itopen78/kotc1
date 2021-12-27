package com.kotc.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface BizMapper {
	public int getBusinessPlanCount(Map param);
	public List<Map> getBusinessPlanList(Map param);
	public Map getBusinessPlanDetail(Map param);
	public void addBusinessPlan(Map param);
	public void setBusinessPlan(Map param);
	public void removePlanSagency(Map param);
	public int getPlanSagencyCount(Map param);
	public void addPlanSagency(Map param);
	public void removePlanSagent(Map param);
	public int getPlanSagentCount(Map param);
	public void addPlanSagent(Map param);
	public void removePlanAgent(Map param);
	public int getPlanAgentCount(Map param);
	public void addPlanAgent(Map param);
	public void removePlanClass(Map param);
	public String getPlanClassMapperId(Map param);
	public void addPlanClass(Map param);
	public void removePlanClassAgent(Map param);
	public int getPlanClassAgentCount(Map param);
	public void addPlanClassAgent(Map param);
	public List<Map> getPlanSagencyList(Map param);
	public List<Map> getPlanSagentList(Map param);
	public List<Map> getPlanAgentList(Map param);
	public List<Map> getPlanClassList(Map param);
	public List<Map> getPlanClassAgentList(Map param);
	public void addHisBusinessPlanChange(Map param);
	public List<Map> getHisBusinessPlanList(Map param);
	public Map getHisBusinessPlanDetail(Map param);
}
