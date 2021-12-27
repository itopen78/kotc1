package com.kotc.handler;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.stereotype.Component;

@Component
public class Http401UnauthorizedEntryPoint implements AuthenticationEntryPoint {
	private static final Logger LOGGER = LoggerFactory.getLogger(Http401UnauthorizedEntryPoint.class.getName());

    /**
     * Always returns a 401 error code to the client.
     */
    @Override
    public void commence(HttpServletRequest request, HttpServletResponse response, AuthenticationException aex)
            throws IOException, ServletException {
    	if(LOGGER.isInfoEnabled()) {
    		LOGGER.info("###############################");
    		LOGGER.info("# 401 # Pre-authenticated entry point called. Rejecting access");
    		LOGGER.info(aex.getMessage());
    		LOGGER.info("###############################");
    	}
        response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Access Denied");
    }
}