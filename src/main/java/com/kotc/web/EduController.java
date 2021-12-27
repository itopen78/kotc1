package com.kotc.web;

import java.util.HashMap;
import java.util.List;
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

import com.kotc.service.CommonService;
import com.kotc.service.EduService;

@Controller
public class EduController {

	private static final Logger logger = LoggerFactory.getLogger(EduController.class);
	
	@Autowired EduService eduService;
	
	@Autowired CommonService commonService;
	
	/**
	 * 기관정보 목록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/edu/agencyList", method = RequestMethod.GET)
	public String agencyList(HttpSession session, Model model) throws Exception {
		Map userInfo = (Map) session.getAttribute("userInfo");
		if("N".equals(userInfo.get("ADMIN_YN").toString())) {
			return "redirect:/edu/agencyWrite?AGC_ID="+userInfo.get("AGC_ID").toString();
		}
		
		Map param = new HashMap<>();
		param.put("CD_TOP", "5");
		param.put("CD_MIDDLE", "1");
		model.addAttribute("cdAreaList", commonService.getCommonListByBottom(param)); //지역구분
		return "/edu/agencyList";
	}
	
	/**
	 * 기관정보 등록
	 * @param AGC_ID
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/edu/agencyWrite", method = RequestMethod.GET)
	public String agencyWrite(@RequestParam(value="AGC_ID", defaultValue="", required=false) String AGC_ID, Model model) throws Exception {
		Map param = new HashMap<>();
		param.put("CD_TOP", "5");
		param.put("CD_MIDDLE", "1");
		model.addAttribute("cdAreaList", commonService.getCommonListByBottom(param)); //지역구분
		model.addAttribute("AGC_ID", AGC_ID);
		return "/edu/agencyWrite";
	}
	
	/**
	 * 기관정보 상세
	 * @param AGC_ID
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/edu/agencyDetail", method = RequestMethod.GET)
	public String agencyDetail(HttpSession session, Model model) throws Exception {
		return "/edu/agencyDetail";
	}

	/**
	 * 기관정보 변경 이력
	 * @param AGC_ID
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/edu/hisAgencyList", method = RequestMethod.GET)
	public String hisAgencyList(@RequestParam(value="AGC_ID") String AGC_ID, Model model) throws Exception {
		model.addAttribute("AGC_ID", AGC_ID);
		return "/edu/hisAgencyList";
	}
	
	/**
	 * 기관정보 변경 이력 상세
	 * @param CHNG_ID
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/edu/hisAgencyDetail", method = RequestMethod.GET)
	public String hisAgencyDetail(@RequestParam(value="CHNG_ID") String CHNG_ID, Model model) throws Exception {
		model.addAttribute("CHNG_ID", CHNG_ID);
		return "/edu/hisAgencyDetail";
	}
	
	/**
	 * 교수요원 목록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/edu/agentList", method = RequestMethod.GET)
	public String agentList(Model model) throws Exception {
		Map param = new HashMap<>();
		param.put("CD_TOP", "3");
		param.put("CD_MIDDLE", "1");
		model.addAttribute("cdAgtTypeList", commonService.getCommonListByBottom(param)); //인력구분
		param.put("CD_TOP", "1");
		param.put("CD_MIDDLE", "1");
		model.addAttribute("cdAddStateList", commonService.getCommonListByBottom(param)); //등록상태
		param.put("CD_TOP", "2");
		param.put("CD_MIDDLE", "1");
		model.addAttribute("cdChngStateList", commonService.getCommonListByBottom(param)); //변경상태
		return "/edu/agentList";
	}
	
	/**
	 * 교수요원 등록
	 * @param AGT_ID
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/edu/agentWrite", method = RequestMethod.GET)
	public String agentWrite(@RequestParam(value="AGT_ID", defaultValue="", required=false) String AGT_ID, Model model) throws Exception {
		Map param = new HashMap<>();
		param.put("CD_TOP", "3");
		param.put("CD_MIDDLE", "1");
		model.addAttribute("cdAgtTypeList", commonService.getCommonListByBottom(param)); //인력구분
		model.addAttribute("AGT_ID", AGT_ID);
		return "/edu/agentWrite";
	}
	
	/**
	 * 교수요원 저장
	 * @param session
	 * @param param
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/edu/agentSave", produces = "application/json; charset=utf-8", method = {RequestMethod.POST})
	public @ResponseBody Map<String, Object> agentSave(HttpSession session, @RequestParam HashMap<String, Object> param, HttpServletRequest request) throws Exception {
		return eduService.agentSave(param, request);
	}
	
	/**
	 * 교수요원 변경이력 목록
	 * @param AGT_ID
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/edu/hisAgentList", method = RequestMethod.GET)
	public String hisAgentList(@RequestParam(value="AGT_ID") String AGT_ID, Model model) throws Exception {
		model.addAttribute("AGT_ID", AGT_ID);
		return "/edu/hisAgentList";
	}
	
	/**
	 * 교수요원 변경 이력 상세
	 * @param CHNG_ID
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/edu/hisAgentDetail", method = RequestMethod.GET)
	public String hisAgentDetail(@RequestParam(value="CHNG_ID") String CHNG_ID, Model model) throws Exception {
		model.addAttribute("CHNG_ID", CHNG_ID);
		return "/edu/hisAgentDetail";
	}
	
	/**
	 * 연계실습기관 목록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/edu/subAgencyList", method = RequestMethod.GET)
	public String subAgencyList(@RequestParam HashMap<String, Object> param, Model model) throws Exception {
		param.put("CD_TOP", "6"); //시설구분
		model.addAttribute("cdFacilityLev1List", commonService.getCommonListByMiddle(param));
		param.put("CD_TOP", "1");
		param.put("CD_MIDDLE", "1");
		model.addAttribute("cdAddStateList", commonService.getCommonListByBottom(param)); //등록상태
		param.put("CD_TOP", "2");
		param.put("CD_MIDDLE", "1");
		model.addAttribute("cdChngStateList", commonService.getCommonListByBottom(param)); //변경상태
		return "/edu/subAgencyList";
	}
	
	/**
	 * 연계실습기관 등록
	 * @param SUB_AGC_ID
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/edu/subAgencyWrite", method = RequestMethod.GET)
	public String subAgencyWrite(@RequestParam(value="SAGC_ID", defaultValue="", required=false) String SAGC_ID, @RequestParam HashMap<String, Object> param, Model model) throws Exception {
		param.put("CD_TOP", "6"); //시설구분
		List<Map> cdFacilityLev1List = commonService.getCommonListByMiddle(param);
		param.put("CD_MIDDLE", cdFacilityLev1List.get(0).get("CODE"));
		List<Map> cdFacilityLev2List = commonService.getCommonListByBottom(param);
		model.addAttribute("cdFacilityLev1List", cdFacilityLev1List);
		model.addAttribute("cdFacilityLev2List", cdFacilityLev2List);
		model.addAttribute("SAGC_ID", SAGC_ID);
		return "/edu/subAgencyWrite";
	}
	
	/**
	 * 연계실습기관 저장
	 * @param session
	 * @param param
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/edu/subAgencySave", produces = "application/json; charset=utf-8", method = {RequestMethod.POST})
	public @ResponseBody Map<String, Object> subAgencySave(HttpSession session, @RequestParam HashMap<String, Object> param, HttpServletRequest request) throws Exception {
		return eduService.subAgencySave(param, request);
	}
	
	/**
	 * 연계실습기관 변경 이력
	 * @param SAGC_ID
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/edu/hisSubAgencyList", method = RequestMethod.GET)
	public String hisSubAgencyList(@RequestParam(value="SAGC_ID") String SAGC_ID, Model model) throws Exception {
		model.addAttribute("SAGC_ID", SAGC_ID);
		return "/edu/hisSubAgencyList";
	}
	
	/**
	 * 연계실습기관 변경 이력 상세
	 * @param CHNG_ID
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/edu/hisSubAgencyDetail", method = RequestMethod.GET)
	public String hisSubAgencyDetail(@RequestParam(value="CHNG_ID") String CHNG_ID, Model model) throws Exception {
		model.addAttribute("CHNG_ID", CHNG_ID);
		return "/edu/hisSubAgencyDetail";
	}
	
	/**
	 * 실습지도자 목록
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/edu/subAgentList", method = RequestMethod.GET)
	public String subAgentList(Model model) throws Exception {
		Map param = new HashMap<>();
		param.put("CD_TOP", "6");
		model.addAttribute("cdFaclLev1List", commonService.getCommonListByMiddle(param));
		param.put("CD_TOP", "7");
		param.put("CD_MIDDLE", "1");
		model.addAttribute("cdSagtTypeList", commonService.getCommonListByBottom(param)); //인력구분
		param.put("CD_TOP", "1");
		param.put("CD_MIDDLE", "1");
		model.addAttribute("cdAddStateList", commonService.getCommonListByBottom(param)); //등록상태
		param.put("CD_TOP", "2");
		param.put("CD_MIDDLE", "1");
		model.addAttribute("cdChngStateList", commonService.getCommonListByBottom(param)); //변경상태
		
		return "/edu/subAgentList";
	}
	
	/**
	 * 실습지도자 등록
	 * @param SAGT_ID
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/edu/subAgentWrite", method = RequestMethod.GET)
	public String subAgentWrite(@RequestParam(value="SAGT_ID", defaultValue="", required=false) String SAGT_ID, Model model) throws Exception {
		Map<String, Object> param = new HashMap<>();
		param.put("CD_TOP", "7");
		param.put("CD_MIDDLE", "1");
		model.addAttribute("cdSagtTypeList", commonService.getCommonListByBottom(param));	//직무 구분
		model.addAttribute("SAGT_ID", SAGT_ID);
		return "/edu/subAgentWrite";
	}
	
	@RequestMapping(value = "/edu/saveSubAgent", produces = "application/json; charset=utf-8", method = {RequestMethod.POST})
	public @ResponseBody Map<String, Object> saveSubAgent(HttpSession session, @RequestParam HashMap<String, Object> param, HttpServletRequest request) throws Exception {
		return eduService.saveSubAgent(param, request);
	}
	
	/**
	 * 실습지도자 변경 이력
	 * @param SAGT_ID
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/edu/hisSubAgentList", method = RequestMethod.GET)
	public String hisSubAgentList(@RequestParam(value="SAGT_ID") String SAGT_ID, Model model) throws Exception {
		model.addAttribute("SAGT_ID", SAGT_ID);
		return "/edu/hisSubAgentList";
	}
	
	/**
	 * 실습지도자 변경 이력 상세
	 * @param CHNG_ID
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/edu/hisSubAgentDetail", method = RequestMethod.GET)
	public String hisSubAgentDetail(@RequestParam(value="CHNG_ID") String CHNG_ID, Model model) throws Exception {
		model.addAttribute("CHNG_ID", CHNG_ID);
		return "/edu/hisSubAgentDetail";
	}
	
	/**
	 * 교육생 목록
	 * @param param
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/edu/studentList", method = RequestMethod.GET)
	public String studentList(@RequestParam HashMap<String, Object> param, Model model) throws Exception {
		param.put("CD_TOP", "8");
		param.put("CD_MIDDLE", "1");
		model.addAttribute("cdClassTypeList", commonService.getCommonListByBottom(param)); //교육과정구분
		return "/edu/studentList";
	}
	
	/**
	 * 교육생 등록
	 * @param STU_ID
	 * @param param
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/edu/studentWrite", method = RequestMethod.GET)
	public String studentWrite(@RequestParam(value="STU_ID", defaultValue="", required=false) String STU_ID, @RequestParam HashMap<String, Object> param, Model model) throws Exception {
		param.put("CD_TOP", "8");
		param.put("CD_MIDDLE", "1");
		model.addAttribute("cdClassTypeList", commonService.getCommonListByBottom(param)); //교육과정구분
		model.addAttribute("STU_ID", STU_ID);
		return "/edu/studentWrite";
	}
	
	/**
	 * 교육생 변경 이력
	 * @param STU_ID
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/edu/hisStudentList", method = RequestMethod.GET)
	public String hisStudentList(@RequestParam(value="STU_ID") String STU_ID, Model model) throws Exception {
		model.addAttribute("STU_ID", STU_ID);
		return "/edu/hisStudentList";
	}
	
	/**
	 * 교육생 변경 이력 상세
	 * @param CHNG_ID
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/edu/hisStudentDetail", method = RequestMethod.GET)
	public String hisStudentDetail(@RequestParam(value="CHNG_ID") String CHNG_ID, Model model) throws Exception {
		model.addAttribute("CHNG_ID", CHNG_ID);
		return "/edu/hisStudentDetail";
	}
	
	/**
	 * 자체점검 목록
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/edu/selfCheckList", method = RequestMethod.GET)
	public String selfCheckList(Model model) throws Exception {
		return "/edu/selfCheckList";
	}
	
	/**
	 * 자제점검 저장
	 * @param session
	 * @param param
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/edu/selfCheckSave", produces = "application/json; charset=utf-8", method = {RequestMethod.POST})
	public @ResponseBody Map<String, Object> selfCheckSave(HttpSession session, @RequestParam HashMap<String, Object> param, HttpServletRequest request) throws Exception {
		return eduService.selfCheckSave(param, request);
	}
}
