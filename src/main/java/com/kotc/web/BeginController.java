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

import com.kotc.service.BeginService;
import com.kotc.service.CommonService;

@Controller
public class BeginController {

	private static final Logger logger = LoggerFactory.getLogger(BeginController.class);
	
	@Autowired BeginService beginService;
	
	@Autowired CommonService commonService;
	
	/**
	 * 1
	 * 개강 : 이론/실기 목록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/begin/logicList", method = RequestMethod.GET)
	public String logicList(Model model) throws Exception {
		Map param = new HashMap<>();
		//param.put("CD_TOP", "5");
		//param.put("CD_MIDDLE", "1");
		//model.addAttribute("cdAreaList", commonService.getCommonListByBottom(param)); //지역구분
		return "/begin/logicList";
	}
	
	
	
	
	/**
	 * 2
	 * 개강 : 이론/실기 ==> 변경목록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/begin/logicChangeList", method = RequestMethod.GET)
	public String logicChangeList(Model model, @RequestParam HashMap<String, Object> param) throws Exception {
		model.addAttribute("CLASS_ID" ,param.get("CLASS_ID"));
		model.addAttribute("CLASS_TITLE" ,param.get("CLASS_TITLE"));
		//Map param = new HashMap<>();
		//param.put("CD_TOP", "5");
		//param.put("CD_MIDDLE", "1");
		//model.addAttribute("cdAreaList", commonService.getCommonListByBottom(param)); //지역구분
		return "/begin/logicChangeList";
	}
	
	

	/**
	 * 3
	 * 개강 : 실습 목록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/begin/practiceList", method = RequestMethod.GET)
	public String practiceList(Model model) throws Exception {
		return "/begin/practiceList";
	}
	
	
	
	
	/**
	 * 4
	 * 개강 : 실습 ==> 변경목록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/begin/practiceChangeList", method = RequestMethod.GET)
	public String practiceChangeList(Model model, @RequestParam HashMap<String, Object> param) throws Exception {
		model.addAttribute("CLASS_ID" ,param.get("CLASS_ID"));
		model.addAttribute("CLASS_TITLE" ,param.get("CLASS_TITLE"));
		return "/begin/practiceChangeList";
	}
	

	/**
	 * 5
	 * 개강 : 대체실습 목록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/begin/subPracticeList", method = RequestMethod.GET)
	public String subPracticeList(Model model) throws Exception {
		return "/begin/subPracticeList";
	}
	
	
	
	
	/**
	 * 6
	 * 개강 : 대체실습 ==> 변경목록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/begin/subPracticeChangeList", method = RequestMethod.GET)
	public String subPracticeChangeList(Model model, @RequestParam HashMap<String, Object> param) throws Exception {
		model.addAttribute("CLASS_ID" ,param.get("CLASS_ID"));
		model.addAttribute("CLASS_TITLE" ,param.get("CLASS_TITLE"));
		return "/begin/subPracticeChangeList";
	}
	

	/**
	 * 7
	 * 개강 : 이론/실기 : STEP 1. 개강개요
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/begin/logicStep", method = RequestMethod.GET)
	public String logicStep(Model model, @RequestParam HashMap<String, Object> param) throws Exception {
		
		//Map param1 = new HashMap<>();
		param.put("CD_TOP", "8");
		param.put("CD_MIDDLE", "1");
		model.addAttribute("cdEduCourse", commonService.getCommonListByBottom(param)); //교육과정구분
		
		model.addAttribute("CLASS_ID" ,param.get("CLASS_ID"));
		model.addAttribute("AGC_ID" ,param.get("AGC_ID"));
		return "/begin/logicStep";
	}
	

	/**
	 * 8
	 * 개강 : 이론/실기 : STEP 2. 개강개요
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/begin/logicStep2", method = RequestMethod.GET)
	public String logicStep2(Model model, @RequestParam HashMap<String, Object> param) throws Exception {
		
		//Map param1 = new HashMap<>();
		param.put("CD_TOP", "13");
		param.put("CD_MIDDLE", "1");
		model.addAttribute("cdBigCourse", commonService.getCommonListByBottom(param)); //교육과정구분

		param.put("CD_TOP", "4");
		param.put("CD_MIDDLE", "");
		model.addAttribute("cdSmallCourse", commonService.getCommonListByBottom(param)); //교육과정구분
		
		model.addAttribute("CLASS_ID" ,param.get("CLASS_ID"));
		model.addAttribute("AGC_ID" ,param.get("AGC_ID"));
		return "/begin/logicStep2";
	}
	
	
	/**
	 * 개강 : 이론/실기 : STEP 2. 시간표 저장
	 * @param session
	 * @param param
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/begin/logicSave", produces = "application/json; charset=utf-8", method = {RequestMethod.POST})
	public @ResponseBody Map<String, Object> logicSave(HttpSession session, @RequestParam HashMap<String, Object> param, HttpServletRequest request) throws Exception {
		return beginService.logicSave(param, request);
	}
	
	/**
	 * 이론/실습 변경이력 상세
	 * @param CHNG_ID
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/begin/hisLogicStepDetail", method = RequestMethod.GET)
	public String hisLogicStepDetail(@RequestParam(value="CHNG_ID") String CHNG_ID, Model model) throws Exception {
		model.addAttribute("CHNG_ID", CHNG_ID);
		return "/begin/hisLogicStepDetail";
	}
	
	

	/**
	 ********************   실습   *************************************
	 */

	/**
	 * 7
	 * 개강 : 실습 : STEP
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/begin/practiceStep", method = {RequestMethod.GET, RequestMethod.POST})
	public String practiceStep(Model model, @RequestParam HashMap<String, Object> param) throws Exception {
		
		//Map param1 = new HashMap<>();
		param.put("CD_TOP", "8");
		param.put("CD_MIDDLE", "1");
		model.addAttribute("cdEduCourse", commonService.getCommonListByBottom(param)); //교육과정구분
		
		model.addAttribute("CLASS_ID" ,param.get("CLASS_ID"));
		model.addAttribute("AGC_ID" ,param.get("AGC_ID"));
		return "/begin/practiceStep";
	}
	

	
	
}
