package com.kotc.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface EndMapper {
	
	public int getEndClassCount(Map param);
	public List<Map> getEndClassList(Map param);
	public Map getEndClassDetail(Map param);
	public void addEndClass(Map param);
	public void setEndClass(Map param);
	
	public void addHisEndClassChange(Map param);
	public List<Map> getHisEndClassList(Map param);
	public Map getHisEndClassDetail(Map param);
	
	public List<Map> getStudentList(Map param);
	public void removeStudent(Map param);
	public void addStudent(Map param);
	public int getStudentCount(Map param);
	
	public void setStudent(Map param);
	public void removeCompleteId(Map param);
	public void addCompleteId(Map param);
}
