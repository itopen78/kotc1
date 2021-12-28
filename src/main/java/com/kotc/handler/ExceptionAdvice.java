package com.kotc.handler;

import java.net.InetAddress;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice
public class ExceptionAdvice {
	private static final Logger LOGGER = LoggerFactory.getLogger(ExceptionAdvice.class.getName());
	//@Autowired UserLogMapper userLogMapper;
	
	@ExceptionHandler(Exception.class)
	public String exception(HttpServletRequest req, Exception ex){
		try {
			String userId = null;
			String clientIp = req.getRemoteAddr();
			String server = InetAddress.getLocalHost().getHostName();
			String url = req.getRequestURI();
			String exceptionType = ex.getClass().getCanonicalName();
			String exceptionMessage = ex.getMessage();
			String exceptionStack = null;
			StackTraceElement[] stacks = ex.getStackTrace();
			HttpSession session =req.getSession();
			
			if(session != null) {
				Map user = (Map)session.getAttribute("userInfo");
				if(user != null) {
					userId = user.get("MAS_USER_ID").toString();
				}
			}
			
			if(stacks.length > 0) {																						// 1번째 스택만 기록
				exceptionStack = String.format("[Class Name]%s, [Method Name]%s, [File Name]%s, [Line Number]%d", 
						stacks[0].getClassName(),
						stacks[0].getMethodName(),
						stacks[0].getFileName(),
						stacks[0].getLineNumber());
			}
			
			try {
				Map<String, Object> param = new HashMap<>();
				param.put("user_id", userId);
				param.put("client_ip", clientIp);
				param.put("server", server);
				param.put("url", url);
				param.put("exception_type", exceptionType);
				param.put("exception_message", exceptionMessage);
				param.put("exception_stack", exceptionStack);
				//userLogMapper.insertExceptionLog(param);
			}catch(Exception ee) {
				if(LOGGER.isErrorEnabled()) {
					LOGGER.error(exceptionStack);
				}
			}
			
		}catch(Exception e) {
			e.printStackTrace();
		}
		return "forward:/exception";
	}
}
