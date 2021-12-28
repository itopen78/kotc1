package com.kotc.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.kotc.common.StringUtil;
import com.kotc.mapper.UserMapper;
import com.kotc.vo.LoginToken;

@Service
public class UserService implements AuthenticationProvider {

	@Autowired UserMapper userMapper;
	
	@Value("${admin.agency.serial}")
	private String adminAgencySerial;
	
	@Override
    public Authentication authenticate(Authentication authentication) throws AuthenticationException {
		RequestAttributes requestAttributes = RequestContextHolder.getRequestAttributes();
		HttpServletRequest request = ((ServletRequestAttributes) requestAttributes).getRequest();
		
		HttpSession session = request.getSession();
		
		LoginToken loginToken = null;
		String userid = authentication.getName();
        String passwd = (String) authentication.getCredentials();
        String passwdEnc = StringUtil.encryptSHA256(passwd);
        Map userParam = new HashMap<>();
        userParam.put("userId", userid);
        userParam.put("adminAgencySerial", adminAgencySerial);
        Map userInfo = userMapper.getUserInfo(userParam);
        
        List<GrantedAuthority> grantedAuths = new ArrayList<GrantedAuthority>();
        if(userInfo != null) {
        	if(!userInfo.get("USER_PASSWORD").toString().equals(passwdEnc)) {
    			throw new BadCredentialsException("id or password incorrect!");
    		}
        	
	        //grantedAuths.add(new SimpleGrantedAuthority(user.getRole()));

        	/*
        	if(userInfo.getRole().equals("A")) {
        		grantedAuths.add(new SimpleGrantedAuthority("ROLE_ADMIN"));
        	} else {
        		grantedAuths.add(new SimpleGrantedAuthority("ROLE_USER"));
        	}
        	*/

        	session.setAttribute("userInfo", userInfo);
	        loginToken = new LoginToken(userInfo);
        } else {
        	throw new BadCredentialsException("id or password incorrect!");
        }
        
        return new UsernamePasswordAuthenticationToken(loginToken, passwd, grantedAuths);
	}

	@Override
    public boolean supports(Class<?> arg0) {
        return true;
    }

	/**
	 * 아이디 중복체크 
	 * @param param
	 */ 
	public Map lookup(Map<String, Object> param) {
		Map result = new HashMap<>();
		System.out.println("param : " + param.toString());
		
		try {
			result.put("result", userMapper.lookup(param));
			result.put("success", true);
		} catch(Exception e) {
			result.put("success", false);
			result.put("message", e.getMessage());
		}
		return result;
	}

	/**
	 * 사용자 정보 입력
	 * @param param
	 */
	public Map<String, Object> signup(Map<String, Object> param) {
		if(param.get("USER_PASSWORD") != null && !param.get("USER_PASSWORD").equals("")) {
			param.replace("USER_PASSWORD", StringUtil.encryptSHA256(param.get("USER_PASSWORD").toString()));
		}
		
		Map<String, Object> map = new HashMap<>();
		
		try {
			userMapper.insertUser(param);
			map.put("success", true);
		}catch(Exception e) {
			map.put("success", false);
			map.put("message", e.getMessage());
		}
		return map;
	}

	/**
	 * 아이디 찾기
	 * @param param
	 */
	public Map findId(Map<String, Object> param) {
		Map result = new HashMap<>();
		try {
			Map findInfo = userMapper.findId(param);
			if(findInfo != null) {
				result.put("success", true);
				result.put("userId", findInfo.get("USER_ID"));
			}else {
				result.put("success", true);
				result.put("userInfo", "NoData");
			}
		}catch(Exception e) {
			result.put("success", false);
			result.put("message", e.getMessage());
		}
		return result;
	}
	
	public Map findPw(Map<String, Object> param) {
		if(param.get("USER_PASSWORD") != null && !param.get("USER_PASSWORD").equals("")) {
			param.replace("USER_PASSWORD", StringUtil.encryptSHA256(param.get("USER_PASSWORD").toString()));
		}
		
		Map result = new HashMap<>();
		try {
			Map findInfo = userMapper.findPw(param);
			if(findInfo != null) {
				result.put("success", true);
				result.put("userPw", findInfo.get("USER_PASSWORD"));
			}else {
				result.put("success", true);
				result.put("userInfo", "NoData");
			}
		}catch(Exception e) {
			result.put("success", false);
			result.put("message", e.getMessage());
		}
		return result;
	}

	/**
	 * 회원정보 변경
	 * @param param
	 */
	@Transactional
	public Map setUserInfo(Map<String, Object> param) {
		if(param.get("USER_PASSWORD") != null && !param.get("USER_PASSWORD").equals("")) {
			param.replace("USER_PASSWORD", StringUtil.encryptSHA256(param.get("USER_PASSWORD").toString()));
		}
		
		Map<String, Object> result = new HashMap<>();
		
		try {
			userMapper.setUserInfo(param);;
			result.put("success", true);
		}catch(Exception e) {
			result.put("success", false);
			result.put("message", e.getMessage());
		}
		
		RequestAttributes requestAttributes = RequestContextHolder.getRequestAttributes();
		HttpServletRequest request = ((ServletRequestAttributes) requestAttributes).getRequest();
		HttpSession session = request.getSession();
		
		if(param.get("SESSION_USER_ID") != null) {
			String userId = param.get("SESSION_USER_ID").toString();
			Map userParam = new HashMap<>();
	        userParam.put("userId", userId);
	        userParam.put("adminAgencySerial", adminAgencySerial);
			Map userInfo = userMapper.getUserInfo(userParam);
			
			session.setAttribute("userInfo", userInfo);
		}
		
		return result;
	}
}
