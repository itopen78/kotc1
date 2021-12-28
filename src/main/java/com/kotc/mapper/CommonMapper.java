package com.kotc.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface CommonMapper {

	List<Map> getCommonListTop(Map param);

	List<Map> getCommonListByMiddle(Map param);

	List<Map> getCommonListByBottom(Map param);

	List<Map> getCodeList(Map param);
}
