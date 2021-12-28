package com.kotc.handler;

import java.io.IOException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.LockedException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;

import com.kotc.common.CommonConstants;


public class LoginFailureHandler implements AuthenticationFailureHandler{
	//@Autowired UserLogMapper userLogMapper;
	
	
	@Override
	public void onAuthenticationFailure(HttpServletRequest req,
			HttpServletResponse res, AuthenticationException aex)
			throws IOException, ServletException {
		System.out.println("onAuthenticationFailure ==========================>> ");
		String clientIp = req.getHeader("X-Forwarded-For");
		if(clientIp == null) {
			clientIp = req.getRemoteAddr();
		}
		String lang = req.getHeader("Accept-Language");
		String url = req.getRequestURI();
		String browser = req.getHeader("User-Agent");
		Enumeration params = req.getParameterNames();
		String postData = "";
		while (params.hasMoreElements()){
		    String key = (String)params.nextElement();
		    postData += key +"=" + req.getParameter(key) + ",";
		}
		Map<String, Object> param = new HashMap<>();
		param.put("user_id", req.getParameter("user_id"));
		param.put("log_type", CommonConstants.USER_LOG_TYPE_LOGIN_FAIL);
		param.put("page_title", "로그인 실패");
		param.put("url", url);
		param.put("client_ip", clientIp);
		param.put("client_browser", browser);
		param.put("client_lang", lang);
		param.put("post_data", postData);
		//userLogMapper.insertUserLog(param);
		
		url = "/user/l?x=credential";
		if(aex instanceof LockedException) { 							//잠겨있는 계정
			url = "/user/login?x=locked";
		} else if(aex instanceof DisabledException) { 					//IP 제한
			url = "/user/login?x=denied";
		} else if(aex instanceof UsernameNotFoundException) { 			//userid 없음
			url = "/user/login.html?x=none";
		} else if(aex instanceof BadCredentialsException) { 			//비밀번호 오류
			url = "/user/login?x=password";
		} else {
			url = "/user/login?x=unknown";
		}
		
		System.out.println("url ==========================>> " + url );
		
		res.sendRedirect(url);

	}
}