package com.kotc.web;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kotc.service.UserService;

import net.sf.json.JSONObject;

@Controller
public class UserController {

	private static final Logger logger = LoggerFactory.getLogger(UserController.class);
	
	@Autowired UserService userService;
	
	/**
	 * 로그인
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/user/login", method = RequestMethod.GET)
	public String login() throws Exception {
		return "/user/login";
	}
	
	/**
	 * 로그아웃
	 * @return
	 */
	@RequestMapping(value = "/logout.do", method = RequestMethod.GET)
    public String logout(HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		return "redirect:/logout";
    }
	
	/**
	 * 약관 동의
	 * @return
	 */
	@RequestMapping(value= {"/user/joinTerms"}, method= RequestMethod.GET)
	public String joinTerms(Model model, @RequestParam HashMap<String, Object> param) {
		return "/user/joinTerms";
	}
	
	/**
	 * 사용자 정보 입력
	 * @return
	 */
	@RequestMapping(value= {"/user/joinUs"}, method= RequestMethod.GET)
	public String joinUs(Model model, @RequestParam HashMap<String, Object> param) {
		return "/user/joinUs";
	}
	
	/**
	 * 가입 완료
	 * @return
	 */
	@RequestMapping(value= {"/user/joinComplete"}, method= RequestMethod.GET)
	public String joinComplete(Model model, @RequestParam HashMap<String, Object> param) {
		model.addAttribute("USER_NAME", param.get("USER_NAME"));
		return "/user/joinComplete";
	}
	
	/**
	 * 아이디/비밀번호 찾기
	 * @return
	 */
	@RequestMapping(value= {"/user/find"}, method= RequestMethod.GET)
	public String find(Model model, @RequestParam HashMap<String, Object> param) {
		return "/user/find";
	}
	
	@RequestMapping(value= {"/user/myPage"}, method= RequestMethod.GET)
	public String myPage(Model model, @RequestParam HashMap<String, Object> param) {
		return "/user/myPage";
	}
	
	@RequestMapping(value= {"/user/changePasswd"}, method= RequestMethod.GET)
	public String changePasswd(Model model, @RequestParam HashMap<String, Object> param) {
		return "/user/changePasswd";
	}
	
	

}
