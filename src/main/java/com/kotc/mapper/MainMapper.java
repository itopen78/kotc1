package com.kotc.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface MainMapper {

	public void addNotice(Map param);
	public int getNoticeCount(Map param);
	public List<Map> getNoticeList(Map param);

}
