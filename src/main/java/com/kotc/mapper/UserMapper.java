package com.kotc.mapper;

import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface UserMapper {

	/**
	 * 사용자 정보 조회
	 * @param userId
	 * @return UserVO
	 */
	public Map getUserInfo(Map param);

	/**
	 * 아이디 중복 확인
	 * @param USER_ID
	 * @return int
	 */
	public int lookup(Map<String, Object> param);

	/**
	 * 유저 등록
	 * @param 
	 */
	public void insertUser(Map<String, Object> param);

	public void setAccountAgcSerialByOriginalAgcSerial(Map param);
	
	/**
	 * 아이디/비밀번호 찾기
	 * @param param
	 * @return UserVO
	 */	
	public Map findId(Map<String, Object> param);
	
	public Map findPw(Map<String, Object> param);
	
	/**
	 * 회원정보 변경
	 * @param param
	 */	
	public void setUserInfo(Map<String, Object> param);
	
	

}
