package com.kotc.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.kotc.service.BizService;
import com.kotc.service.CommonService;
import com.kotc.service.EduService;

@Controller
public class BizController {

	private static final Logger logger = LoggerFactory.getLogger(BizController.class);
	
	@Autowired BizService bizService;
	
	@Autowired EduService eduService;
	
	@Autowired CommonService commonService;
	
	/**
	 * 사업계획서 목록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/biz/businessPlanList", method = RequestMethod.GET)
	public String businessPlanList(Model model) throws Exception {
		Map param = new HashMap<>();
		param.put("CD_TOP", "1");
		param.put("CD_MIDDLE", "1");
		model.addAttribute("cdAddStateList", commonService.getCommonListByBottom(param)); //등록상태
		param.put("CD_TOP", "2");
		param.put("CD_MIDDLE", "1");
		model.addAttribute("cdChngStateList", commonService.getCommonListByBottom(param)); //변경상태
		return "/biz/businessPlanList";
	}
	
	/**
	 * 사업계획서 등록
	 * @param PLAN_ID
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/biz/businessPlanWrite", method = RequestMethod.GET)
	public String businessPlanWrite(@RequestParam(value="PLAN_ID", defaultValue="", required=false) String PLAN_ID, HttpSession session, Model model) throws Exception {
		Map param = new HashMap<>();
		param.put("CD_TOP", "4");
		model.addAttribute("classCodeList", commonService.getCodeList(param)); //과목전체
		
		param.put("CD_TOP", "6"); //시설구분
		List<Map> cdFacilityLev1List = commonService.getCommonListByMiddle(param);
		model.addAttribute("cdFacilityLev1List", cdFacilityLev1List);
		
		param.put("CD_TOP", "7");
		param.put("CD_MIDDLE", "1");
		model.addAttribute("cdSagtTypeList", commonService.getCommonListByBottom(param)); //인력구분
		
		param.put("CD_TOP", "3");
		param.put("CD_MIDDLE", "1");
		model.addAttribute("cdAgtTypeList", commonService.getCommonListByBottom(param)); //교수 인력구분
		
		model.addAttribute("PLAN_ID", PLAN_ID);
		Map user = (Map)session.getAttribute("userInfo");
		model.addAllAttributes(eduService.getBusinessPlanByAgentInfo(user));
		return "/biz/businessPlanWrite";
	}
	
	/**
	 * 사업계획서 변경이력 목록
	 * @param PLAN_ID
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/biz/hisBusinessPlanList", method = RequestMethod.GET)
	public String hisBusinessPlanList(@RequestParam(value="PLAN_ID") String PLAN_ID, Model model) throws Exception {
		model.addAttribute("PLAN_ID", PLAN_ID);
		return "/biz/hisBusinessPlanList";
	}
	
	/**
	 * 사업계획서 변경이력 상세
	 * @param CHNG_ID
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/biz/hisBusinessPlanDetail", method = RequestMethod.GET)
	public String hisBusinessPlanDetail(@RequestParam(value="CHNG_ID") String CHNG_ID, Model model) throws Exception {
		model.addAttribute("CHNG_ID", CHNG_ID);
		return "/biz/hisBusinessPlanDetail";
	}
}
