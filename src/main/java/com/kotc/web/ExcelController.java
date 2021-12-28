package com.kotc.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.kotc.common.WriteToXLS;
import com.kotc.mapper.EduMapper;
import com.kotc.mapper.EndMapper;

@Controller
public class ExcelController {
	@Autowired EduMapper eduMapper;
	@Autowired EndMapper endMapper;
	
	private static final Logger logger = LoggerFactory.getLogger(ExcelController.class);
	
	/**
	 * 엑셀 다운
	 * @return
	 */
	@RequestMapping(value="/edu/excelDown.do", method= {RequestMethod.GET, RequestMethod.POST})
	public void agencyToExcel(HttpServletResponse response, @RequestParam Map<String, Object> param) {
		WriteToXLS wls = new WriteToXLS();
		if(param.containsKey("flag") && param.get("flag") != null && param.get("flag").equals("agencyList")) {
			String[] enames = {"NO" ,"AGC_NAME","AGC_SERIAL","CD_AREA_NAME","USER_NAME","AGC_CORP_BOSS_NAME","AGC_CORP_BOSS_TEL","USE_YN"};
			String[] knames = {"순번","교육기관 명칭","교육기관 지정코드","지역구분","담당자","대표자","대표자 연락처","사용여부"};
			List<Map> list = eduMapper.getAgencyList(param);
			wls.writeXls(response , "agencyList", enames , knames, list); //response:파일명:쿼리컬럼명:엑셀한글명:데이터리스트
		}
	}
	
	@RequestMapping(value="/edu/agentToExcel", method={RequestMethod.GET, RequestMethod.POST})
	public void agentToExcel(HttpServletResponse response, @RequestParam Map<String, Object> param) {
		WriteToXLS wls = new WriteToXLS();
		if(param.containsKey("flag") && param.get("flag") != null && param.get("flag").equals("agentList")) {
			String[] enames = {"NO", "AGC_NAME", "CD_AGT_TYPE_NAME", "AGT_NAME", "AGT_TEL", "CD_ADD_STATE_NAME", "CD_CHNG_STATE_NAME", "FINAL_APL_DATE"};
			String[] knames = {"순번", "교육기관", "구분", "성명", "연락처", "등록상태", "변경상태", "최종승인일자"};
			List<Map> list = eduMapper.getAgentList(param);
			wls.writeXls(response , "교수요원목록", enames , knames, list);
		}
	}
	
	@RequestMapping(value="/edu/subAgencyToExcel", method={RequestMethod.GET, RequestMethod.POST})
	public void subAgencyToExcel(HttpServletResponse response, @RequestParam Map<String, Object> param) {
		WriteToXLS wls = new WriteToXLS();
		if(param.containsKey("flag") && param.get("flag") != null && param.get("flag").equals("subAgencyList")) {
			String[] enames = {"NO", "CD_FACILITY_LEV1_NAME", "CD_FACILITY_LEV2_NAME", "SAGC_BOSS_NAME", "SAGC_BOSS_TEL", "CD_ADD_STATE_NAME", "CD_CHNG_STATE_NAME", "FINAL_APL_DATE"};
			String[] knames = {"순번", "시설구분", "시설구분(세)", "시설명", "대표전화", "등록상태", "변경상태", "최종승인일자"};
			List<Map> list = eduMapper.getSubAgencyList(param);
			wls.writeXls(response , "연계실습기관목록", enames , knames, list);
		}
	}
	

	@RequestMapping(value="/end/endClassToExcel", method={RequestMethod.GET, RequestMethod.POST})
	public void endClassToExcel(HttpServletResponse response, @RequestParam Map<String, Object> param) {
		WriteToXLS wls = new WriteToXLS();
		if(param.containsKey("flag") && param.get("flag") != null && param.get("flag").equals("endClassList")) {
			String[] enames = {"NO" ,"WRITED_DATE","CLASS_TITLE","USER_NAME","CHNG_DATE"};
			String[] knames = {"순번","작성일자","제목","작성자","최종변경일자"};
			List<Map> list = endMapper.getEndClassList(param);
			wls.writeXls(response , "수료보고목록", enames , knames, list);
		}
	}
}
