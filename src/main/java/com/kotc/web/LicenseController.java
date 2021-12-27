package com.kotc.web;

import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.kotc.service.CommonService;
import com.kotc.service.LicenseService;

@Controller
public class LicenseController {

	private static final Logger logger = LoggerFactory.getLogger(LicenseController.class);
	
	@Autowired LicenseService licenseService;
	
	@Autowired CommonService commonService;
	
	/**
	 * 대상자 목록
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/license/studentList", method = RequestMethod.GET)
	public String studentList(Model model) throws Exception {
		Map param = new HashMap<>();
		param.put("CD_TOP", "8");
		param.put("CD_MIDDLE", "1");
		model.addAttribute("cdClassTypeList", commonService.getCommonListByBottom(param)); //교육과정구분
		return "/license/studentList";
	}
	
	/**
	 * 대상자 상세
	 * @param STU_ID
	 * @param param
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/license/studentWrite", method = RequestMethod.GET)
	public String studentWrite(@RequestParam(value="STU_ID", defaultValue="", required=false) String STU_ID, @RequestParam HashMap<String, Object> param, Model model) throws Exception {
		param.put("CD_TOP", "8");
		param.put("CD_MIDDLE", "1");
		model.addAttribute("cdClassTypeList", commonService.getCommonListByBottom(param)); //교육과정구분
		model.addAttribute("STU_ID", STU_ID);
		return "/license/studentWrite";
	}
}
