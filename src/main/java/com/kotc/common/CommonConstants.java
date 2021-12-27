package com.kotc.common;

public class CommonConstants {
	public static final String DEFAULT_CHARSET = "UTF-8";

	public static final String SESSION_PUSH_TYPE = "SESSION_PUSH_TYPE";
	public static final String SESSION_PUSH_TARGET = "SESSION_PUSH_TARGET";
	public static final String SESSION_LOGIN_APP = "SESSION_LOGIN_APP";
	
	public static final String USER_LOG_TYPE_JOIN = "01";																	// 가입신청
	public static final String USER_LOG_TYPE_CONFIRM = "02";																// 가입승인
	public static final String USER_LOG_TYPE_LOGIN = "04";																	// 로그인성공
	public static final String USER_LOG_TYPE_LOGIN_FAIL = "05";																// 로그인실패
	public static final String USER_LOG_TYPE_LOGOUT = "06";																	// 로그아웃
	public static final String USER_LOG_TYPE_USER_INSERT = "07";															// 사용자 정보 입력
	public static final String USER_LOG_TYPE_USER_UPDATE = "08";															// 사용자 정보 수정
}
