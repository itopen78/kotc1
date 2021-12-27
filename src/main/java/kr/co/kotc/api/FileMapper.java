package kr.co.kotc.api;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;


@Mapper
@Repository
public interface FileMapper {
	public List<Map> selectFile(Map param);
	public Map viewFile(Map param);
	public int insertFile(Map param);
	public int updateFile(Map param);
	public int deleteFile(Map param);
	
	
	
	
	public void removeFile(Map param);
	public Map getFile(Map fileMap);
	public void addFile(Map fileMap);
	public void setFile(Map fileMap);
}
