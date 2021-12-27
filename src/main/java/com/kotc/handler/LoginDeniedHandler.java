package com.kotc.handler;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.access.AccessDeniedHandler;

public class LoginDeniedHandler implements AccessDeniedHandler{
	//@Autowired LogHistoryMapper logHistoryMapper;
	@Autowired MessageSource messageSource;
	
	private static final Logger LOGGER = LoggerFactory.getLogger(LoginDeniedHandler.class.getName());
	
	private String errorPage;

    public LoginDeniedHandler() {
    }

    public LoginDeniedHandler(String errorPage) {
        this.errorPage = errorPage;
    }
    
    public String getErrorPage() {
        return errorPage;
    }

    public void setErrorPage(String errorPage) {
        this.errorPage = errorPage;
    }
    
	@Override
	public void handle(HttpServletRequest req, HttpServletResponse res,
			AccessDeniedException ade) throws IOException, ServletException {
		if(LOGGER.isInfoEnabled()) {
			LOGGER.info("AccessDeniedException " + ade.getMessage());
			
			LOGGER.info("Exceiption : {}",ade);
			LOGGER.info("LocalizedMessage : {}",ade.getLocalizedMessage());
			LOGGER.info("Message : {}",ade.getMessage());
			LOGGER.info("StackTrace : {}",ade.getStackTrace());
		}

		String referer = req.getHeader("referer");
		referer = referer.substring(0, referer.indexOf(".do")+3);
		
		res.sendRedirect(referer+"?x=credentialsExpired");
	}
}