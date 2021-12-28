package com.kotc.web;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kotc.service.MainService;

@Controller
public class MainController {

	private static final Logger logger = LoggerFactory.getLogger(MainController.class);
	
	@Autowired MainService mainService;
	
	/**
	 * 메인 페이지
	 * @param session
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String main(HttpSession session, Model model) throws Exception {
		Map userInfo = (Map) session.getAttribute("userInfo");
		if("Y".equals(userInfo.get("ADMIN_YN").toString())) {
			return "/main/main";
		} else {
			return "/main/agency_main";
		}
	}
	
	/**
	 * 공지사항 저장
	 * @param session
	 * @param param
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/main/saveNotice", produces = "application/json; charset=utf-8", method = {RequestMethod.POST})
	public @ResponseBody Map<String, Object> saveNotice(HttpSession session, @RequestParam HashMap<String, Object> param, HttpServletRequest request) throws Exception {
		return mainService.saveNotice(param, request);
	}
}
