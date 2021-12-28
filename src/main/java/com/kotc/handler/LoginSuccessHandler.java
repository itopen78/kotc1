package com.kotc.handler;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.session.SessionRegistry;
import org.springframework.security.web.authentication.SavedRequestAwareAuthenticationSuccessHandler;

import com.kotc.common.CommonConstants;

public class LoginSuccessHandler extends SavedRequestAwareAuthenticationSuccessHandler {
	private SessionRegistry sessionRegistry;

	//@Autowired UserLogService userLogService;
	
	public void setSessionRegistry(SessionRegistry sessionRegistry){
        this.sessionRegistry=sessionRegistry;
    }
	
	@Override
	public void onAuthenticationSuccess(HttpServletRequest req, HttpServletResponse res, 
			Authentication auth) throws IOException, ServletException {
		System.out.println("================>>>>>>");
		super.onAuthenticationSuccess(req, res, auth);
		
		//userLogService.insertUserLog("로그인 성공", req);
		if(req.getParameter("type").length() > 0) {																// 파라미터가 있을 경우 세션에 넣어줌
			req.getSession().setAttribute(CommonConstants.SESSION_PUSH_TYPE, req.getParameter("type"));
			req.getSession().setAttribute(CommonConstants.SESSION_PUSH_TARGET, req.getParameter("target"));
		}
		
		req.getSession().setAttribute(CommonConstants.SESSION_LOGIN_APP, req.getParameter("app_login"));		// 앱에서 로그인했는지 여부를 기록 (1:앱에서, '':앱아님)
		
		super.setAlwaysUseDefaultTargetUrl(true);
        super.onAuthenticationSuccess(req, res, auth);
	}
}
