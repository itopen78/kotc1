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
import com.kotc.service.EndService;

@Controller
public class EndController {

	private static final Logger logger = LoggerFactory.getLogger(EndController.class);
	
	@Autowired BeginService beginService;
	@Autowired EndService endService;
	
	@Autowired CommonService commonService;
	
	/**
	 * 수료보고 목록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/end/endClassList", method = RequestMethod.GET)
	public String endClassList(Model model) throws Exception {
		Map param = new HashMap<>();
		return "/end/endClassList";
	}
	
	/**
	 * 수료보고 등록
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/end/endClassWrite", method = RequestMethod.GET)
	public String endClassWrite(Model model, @RequestParam HashMap<String, Object> param) throws Exception {
		model.addAttribute("CLASS_ID", param.get("CLASS_ID"));
		model.addAttribute("AGC_ID", param.get("AGC_ID"));
		param.put("CD_TOP", "8");
		param.put("CD_MIDDLE", "1");
		model.addAttribute("cdClassTypeList", commonService.getCommonListByBottom(param));
		return "/end/endClassWrite";
	}
	
	/**
	 * 수료보고 변경 이력 목록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/end/hisEndClassList", method = RequestMethod.GET)
	public String hisEndClassList(Model model, @RequestParam HashMap<String, Object> param) throws Exception {
		model.addAttribute("CLASS_ID" ,param.get("CLASS_ID"));
		return "/end/hisEndClassList";
	}
	
	/**
	 * 수료보고 변경 이력 상세
	 * @param CHNG_ID
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/end/hisEndClassDetail", method = RequestMethod.GET)
	public String hisBusinessPlanDetail(Model model, @RequestParam HashMap<String, Object> param) throws Exception {
		model.addAttribute("CHNG_ID", param.get("CHNG_ID"));
		model.addAttribute("CLASS_ID" ,param.get("CLASS_ID"));
		return "/end/hisEndClassDetail";
	}
}
