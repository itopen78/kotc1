package com.kotc.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface BeginMapper {
	
	//1
	public int getLogicCount(Map param);
	public List<Map> getLogicList(Map param);
	

	//2
	public List<Map> getLogicChangeList(Map param);


	//이론/실기 삭제
	public Map getLogicDetail(Map param);
	public int addHisLogic(Map param);
	public void setLogic(Map param);




	//5
	public int getSubPracticeCount(Map param);
	public List<Map> getSubPracticeList(Map param);
	

	//6
	public List<Map> getSubPracticeChangeList(Map param);


	//대체실습 삭제
	public Map getSubPracticeDetail(Map param);
	public int addHisSubPractice(Map param);
	public void setSubPractice(Map param);


	//7
	public List<Map> getLogicStudentList(Map param);

	//
	public void addLogic(Map param);

	public void removeStudent(Map param);
	public void addStudent(Map param);

	public void removeLectureId(Map param);
	public void addLectureId(Map param);
	//교수요원 
	List<Map> getAgentList(Map param);

	//교수요원 선택
	List<Map> getSelectAgentList(Map param);
	

	//지난 시간표 
	public List<Map> getOldLogicList(Map param);
	
	//이론/실기 시간표
	public List<Map> getLogicTimeTableList(Map param);
	//이론/실기 과목별 교수요원
	public List<Map> getLogicClassList(Map param);

	public void removeLogicTimeTable(String mapperId);
	public void setLogicTimeTable(Map param);
	public void addLogicTimeTable(Map param);
	
	public void removeLogicClassAgentAll(String parentId);
	public void removeLogicClass(String parentId);
	
	public void addLogicClass(Map param);
	
	public void removeLogicClassAgent(Map param);
	public void addLogicClassAgent(Map param);
	
	
	//히스토리 
	public Map getHisLogicStepDetail(Map param);
	
	//****************  실습 *********************//
	//3
	public int getPracticeCount(Map param);
	public List<Map> getPracticeList(Map param);

	//4
	public List<Map> getPracticeChangeList(Map param);

	//실습 삭제
	public Map getPracticeDetail(Map param);
	public int addHisPractice(Map param);
	public void setPractice(Map param);
	

	public List<Map> getPracticeStudentList(Map param);
	public List<Map> getPracticeTimeTableList(Map param);
	
	List<Map> getSubAgencyList(Map param);
	
}
