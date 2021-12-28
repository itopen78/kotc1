package com.kotc.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface EduMapper {
	public int getAgencyCount(Map param);
	public List<Map> getAgencyList(Map param);
	public void setAgency(Map param);
	public int addAgency(Map param);
	public int countAgencyByAgcSerial(Map param);
	public Map getAgencyDetail(Map param);
	public List<Map> getAgencyWorkerList(Map param);
	public int addAgencyWorker(Map param);
	public int removeAgency(Map param);
	public Map getAgencyWorkerDetail(Map param);
	public void setAgencyWorker(Map param);
	public int removeAgencyWorker(String workerId);
	
	public int getAgentCount(Map param);
	public List<Map> getAgentList(Map param);
	public int addAgent(Map param);
	public void setAgent(Map param);
	public void addAgentClass(Map param);
	public void setAgentClass(Map param);
	public List<Map> getAgentClassList(Map param);
	public void removeAgentClass(String clsId);
	public Map getAgentDetail(Map param);
	public void addHisAgentChange(Map param);
	public int getSubAgencyCount(Map param);
	public List<Map> getSubAgencyList(Map param);
	public int addSubAgency(Map param);
	public void setSubAgency(Map param);
	public Map getSubAgencyDetail(Map param);
	public int removeSubAgency(Map param);
	public List<Map> getHisAgentList(Map param);
	
	// 실습지도자 관련 Mapper(안명진)
	public int getSubAgentCount(Map param);
	public List<Map> getSubAgentList(Map param);
	public Map getSubAgentDetail(Map param);
	public List<Map> getSubAgentLicenseList(Map param);
	public List<Map> getSubAgentCareerList(Map param);
	public int addSubAgent(Map param);
	public void setSubAgent(Map param);
	public int removeSubAgent(Map param);
	public int removeSubAgentLicense(String lcnsId);
	public void addSubAgentLicense(Map subAgentLicense);
	public void setSubAgentLicense(Map subAgentLicense);
	public int removeSubAgentCareer(String crrId);
	public void addSubAgentCareer(Map subAgentCareer);
	public void setSubAgentCareer(Map subAgentCareer);
	public List<Map> getSubAgentLCNSListBySagtId(Map param);
	public List<Map> getSubAgentCRRListBySagtId(Map param);
	public int addHisSubAgentChange(Map param);
	public Map getSubAgencyByAgcId(Map param);
	public List<Map> getHisSubAgentList(Map param);
	public Map getHisSubAgentDetail(Map param);
	public void setSubAgentChngState(Map param);
	// ./실습지도자 관련 Mapper(안명진)
	
	public List<Map> getAgencyWorkerListByAgcId(Map param);
	public int addHisAgencyChange(Map param);
	public void setAgencyAgcNote(Map param);
	public List<Map> getHisAgencyList(Map param);
	public Map getHisAgencyDetail(Map param);
	public int removeAgentLicense(String lcnsId);
	public void addAgentLicense(Map agentLicense);
	public void setAgentLicense(Map agentLicense);
	public void removeAgentCareer(String crrId);
	public void addAgentCareer(Map agentCareer);
	public void setAgentCareer(Map agentCareer);
	public void removeAgentOutsideLecture(String lctrId);
	public void addAgentOutsideLecture(Map agentOutsideLecture);
	public void setAgentOutsideLecture(Map agentOutsideLecture);
	public List<Map> getAgentLicenseList(Map param);
	public List<Map> getAgentCareerList(Map param);
	public List<Map> getAgentOutsideLectureList(Map param);
	public Map getHisAgentDetail(Map param);
	public void removeSubAgencyContractDocument(String contDocId);
	public void addSubAgencyContractDocument(Map param);
	public void setSubAgencyContractDocument(Map param);
	public List<Map> getSubAgencyContractDocumentList(Map param);
	public void addHisSubAgencyChange(Map param);
	public void setAgentChngState(Map param);
	public void setSubAgencyChngState(Map param);
	public List<Map> getHisSubAgencyList(Map param);
	public Map getHisSubAgencyDetail(Map param);
	public int getStudentCount(Map param);
	public List<Map> getStudentList(Map param);
	public Map getStudentDetail(Map param);
	public void removeStudent(Map param);
	public void addHisStudentChange(Map param);
	public void addStudent(Map param);
	public void setStudent(Map param);
	public List<Map> getHisStudentList(Map param);
	public Map getHisStudentDetail(Map param);
	public int getSelfCheckCount(Map param);
	public List<Map> getSelfCheckList(Map param);
	public void addSelfCheck(Map param);
	public int removeSelfCheck(Map param);
	public String getAgencySerialByAdmin(Map param);
}
