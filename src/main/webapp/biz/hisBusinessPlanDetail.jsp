<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <c:import url="/inc/assets_base.jsp" />
    
    <script type="text/javascript">
    var CHNG_ID = '${CHNG_ID}';
    
	$(document).ready(function() {
		fnFieldDisabled();
		
		getHisBusinessPlanDetail();
		
		/************************************************************************
		* 취소, 다음
		************************************************************************/
		$('.move').on('click', function() {
			$('.sub_con').hide();
			$('.step_'+$(this).data('move')).show();
		});
	});
	
	function getHisBusinessPlanDetail() {
		if(CHNG_ID == null || CHNG_ID == '') {
			return false;
		}
		
		var params = {
				'class' : 'service.BizService',
				'method' : 'getHisBusinessPlanDetail',
				'param' : {'CHNG_ID' : CHNG_ID},
				'callback' : function(data){
					if(data.success){
						loadingStop();
						var businessPlanDetail = data.businessPlanDetail;
						$('#CD_ADD_STATE').val(businessPlanDetail.CD_ADD_STATE);
						$('#CD_CHNG_STATE').val(businessPlanDetail.CD_CHNG_STATE);
							
						$('#PLAN_TITLE').val(businessPlanDetail.PLAN_TITLE);
						$('#PERSONNEL').val(businessPlanDetail.PERSONNEL);
						
						$('#AGC_NAME').text(businessPlanDetail.AGC_NAME);
						$('#AGC_SERIAL').text(businessPlanDetail.AGC_SERIAL);
						$('#AGC_CORP').text(businessPlanDetail.AGC_CORP);
						$('#AGC_CORP_SERIAL').text(businessPlanDetail.AGC_CORP_SERIAL);
						$('#AGC_ADDRESS').text(businessPlanDetail.AGC_ADDRESS);
						$('#AGC_ZIP').text(businessPlanDetail.AGC_ZIP);
						$('#AGC_CORP_BOSS_NAME').text(businessPlanDetail.AGC_CORP_BOSS_NAME);
						$('#AGC_CORP_BOSS_TEL').text(businessPlanDetail.AGC_CORP_BOSS_TEL);
						$('#AGC_BOSS_NAME').text(businessPlanDetail.AGC_BOSS_NAME);
						$('#AGC_BOSS_TEL').text(businessPlanDetail.AGC_BOSS_TEL);
						
						$('#NATIONAL_YN').val(businessPlanDetail.NATIONAL_YN);
						$('#NEW_YN').val(businessPlanDetail.NEW_YN);
						$('#CAREER_YN').val(businessPlanDetail.CAREER_YN);
						$('#LICENSE_YN').val(businessPlanDetail.LICENSE_YN);
						$('#ADVANCE_YN').val(businessPlanDetail.ADVANCE_YN);
						
						$('#NATIONAL_COST').val(businessPlanDetail.NATIONAL_COST);
						$('#NEW_COST').val(businessPlanDetail.NEW_COST);
						$('#CAREER_COST').val(businessPlanDetail.CAREER_COST);
						$('#LICENSE_COST').val(businessPlanDetail.LICENSE_COST);
						$('#ADVANCE_COST').val(businessPlanDetail.ADVANCE_COST);
						
						$('#PLAN_NOTE').val(businessPlanDetail.PLAN_NOTE);
						
						$('.costPosition select').each(function() {
							if($(this).val() == 'N') {
								$('#'+$(this).data('id')).val('');
								$('#'+$(this).data('id')).css('background-color','#DEDEDE');
								$('#'+$(this).data('id')).prop("readonly",true);
							}
						});
						
						var _html = '';
						if(data.planSagencyList.length > 0) {
							$(data.planSagencyList).each(function(i, item) {
								_html += '<tr class="tbl_list items" style="background:#ebf0f9">'
									_html += '<td>'+(i+1)+'</td>'
									_html += '<td>'+item.CD_FACILITY_LEV1_NAME+'</td>'
									_html += '<td>'+item.CD_FACILITY_LEV2_NAME+'</td>'
									_html += '<td>'+item.SAGC_NAME+'</td>'
									_html += '<td>'+item.SAGC_BOSS_TEL+'</td>'
								_html += '</tr>'
							});
						} else {
							_html += '<tr class="none"><td colspan="5">등록된 데이터가 없습니다.</td></tr>'
						}
						$('.subAgencyList').append(_html);
						
						_html = '';
						if(data.planSagentList.length > 0) {
							$(data.planSagentList).each(function(i, item) {
								_html += '<tr class="tbl_list02 items" style="background:#ebf0f9">'
									_html += '<td>'+(i+1)+'</td>'
									_html += '<td>'+item.SAGC_NAME+'</td>'
									_html += '<td>'+item.CD_SAGT_TYPE_NAME+'</td>'
									_html += '<td>'+item.SAGT_NAME+'</td>'
								_html += '</tr>'
							
								$('.subAgentList #subAgentChk'+item.SAGT_ID).closest(".tbl_list02").children("td").css({"background":"#ebf0f9"});
							});
						} else {
							_html += '<tr class="none"><td colspan="4">등록된 데이터가 없습니다.</td></tr>'
						}
						$('.subAgentList').append(_html);
						
						_html = '';
						if(data.planAgentList.length > 0) {
							$(data.planAgentList).each(function(i, item) {
								_html += '<tr class="tbl_list03 items" style="background:#ebf0f9">'
									_html += '<td>'+(i+1)+'</td>'
									_html += '<td>'+item.CD_AGT_TYPE_NAME+'</td>'
									_html += '<td>'+item.AGT_NAME+'</td>'
									_html += '<td>'+item.AGT_TEL+'</td>'
								_html += '</tr>'
							});
						} else {
							_html += '<tr class="none"><td colspan="4">등록된 데이터가 없습니다.</td></tr>'
						}
						$('.agentList').append(_html);
						
						_html = '';
						console.log(data.planClassList);
						if(data.planClassList.length > 0) {
							$(data.planClassList).each(function(i, planClass) {
								var cd_cls_lev = planClass.CD_CLS_LEV1 + '_' + planClass.CD_CLS_LEV2;
								if(planClass.planClassAgentList.length > 0) {
									var agts1Name = '';
									var agts2Name = '';
									$(planClass.planClassAgentList).each(function(x, planClassAgent) {
										var AGT_ID = planClassAgent.AGT_ID;
										var AGT_NAME = planClassAgent.AGT_NAME;
										if(planClassAgent.AGT_TYPE == '1') {
											agts1Name += (agts1Name != '' ? ', ' : '') + AGT_NAME
										} else {
											agts2Name += (agts2Name != '' ? ', ' : '') + AGT_NAME
										}
									});
								}
								
								_html += '<tr class="items">'
									_html += '<td>'+planClass.CD_CLS_LEV1_NAME+'</td>'
									_html += '<td>'+planClass.CD_CLS_LEV2_NAME+'</td>'
									_html += '<td><span class="pdl10 agts1">'+(agts1Name == null ? '' : agts1Name)+'</span></td>'
									_html += '<td><span class="pdl10 agts2">'+(agts2Name == null ? '' : agts2Name)+'</span></td>'
								_html += '</tr>'
							});
						} else {
							_html += '<tr class="none"><td colspan="4">등록된 데이터가 없습니다.</td></tr>'
						}
						$('.planClassAgentList').append(_html);
					}
				}
		};
		apiCall(params);
	}
    </script>
</head>
<body>
	<div id="wrap">
		<c:import url="/inc/header_base.jsp" />
		
		<div class="contents">
			<div class="sub_form">
				<div class="sub_navi">
					<span class="home_navi"><img src="/assets/images/home_icon.png"/></span>
					<span class="nav">사업계획서</span>
					<span class="nav">사업계획서 제출</span>
					<span class="nav">상세정보</span>
				</div>
				<form name="frm" id="frm" method="post">
				<input type="hidden" name="PLAN_ID" id="PLAN_ID" value="${PLAN_ID}"/>
				<input type="hidden" name="CD_ADD_STATE" id="CD_ADD_STATE"/>
				<input type="hidden" name="CD_CHNG_STATE" id="CD_CHNG_STATE"/>
				<div class="sub_box">
					<div class="sub_menu">
						<div class="sub_title">사업계획서</div>
						<div class="sub_list">
							<ul>
								<li class="sub_on"><a href="/biz/businessPlanList">사업계획서 제출</a></li>
							</ul>
						</div>
					</div>
					<div class="sub_con step_01">
						<!--conBox-->
						<div class="conBox">
							<div class="sub_step">
								<ul class="page02_step">
									<li class="step_list step_on">
										<div class="step_num">1</div>
										<div class="step_txt">연간사업계획 개요</div>
									</li>
									<li class="step_list">
										<div class="step_num">2</div>
										<!--<div class="step_check"><img src="/assets/images/step_check.png"/></div>-->
										<div class="step_txt">연계실습기관 및 실습지도자 등록</div>
									</li>
									<li class="step_list">
										<div class="step_num">3</div>
										<div class="step_txt">교수요원 및 과목별 교수요원 등록</div>
									</li>
								</ul>
							</div>
						</div>
						<!--conBox-->
						<div class="conBox mgt40">
							<div class="con_title">연간사업계획 개요</div>
							
							<div class="con_form">
								<table class="tbl_ty1">
									<colgroup>
										<col width="160px"/>
										<col width="400px"/>
										<col width="160px"/>
										<col width="200px"/>
									</colgroup>
									<tr>
										<td class="t_head">제목</td>
										<td class="pdl15 pdr15">
											<input type="text" class="tbl_input" id="PLAN_TITLE" name="PLAN_TITLE"/>
										</td>
										<td class="t_head">정원</td>
										<td class="pdl15 pdr15">
											<input type="text" class="tbl_input" id="PERSONNEL" name="PERSONNEL"/>
										</td>
									</tr>
								</table>
							</div>
							
							<div class="con_form">
								<table class="tbl_ty1">
									<colgroup>
										<col width="160px"/>
										<col width="400px"/>
										<col width="160px"/>
										<col width="200px"/>
									</colgroup>
									<tr>
										<td class="t_head">교육기관 명칭</td>
										<td id="AGC_NAME"></td>
										<td class="t_head">교육기관 지정코드</td>
										<td id="AGC_SERIAL"></td>
									</tr>
									<tr>
										<td class="t_head">법인명</td>
										<td id="AGC_CORP"></td>
										<td class="t_head">법인등록번호</td>
										<td id="AGC_CORP_SERIAL"></td>
									</tr>
									<tr>
										<td class="t_head">소재지 주소(도로명)</td>
										<td id="AGC_ADDRESS"></td>
										<td class="t_head">우편번호</td>
										<td id="AGC_ZIP"></td>
									</tr>
									<tr>
										<td class="t_head">대표명</td>
										<td id="AGC_CORP_BOSS_NAME"></td>
										<td class="t_head">대표 연락처</td>
										<td id="AGC_CORP_BOSS_TEL"></td>
									</tr>
									<tr>
										<td class="t_head">기관장</td>
										<td id="AGC_BOSS_NAME"></td>
										<td class="t_head">기관장 연락처</td>
										<td id="AGC_BOSS_TEL"></td>
									</tr>
									
								</table>
							</div>
						</div>
						<!--conBox end-->		
						<!--conBox-->
						<div class="conBox">
							<div class="con_form">
								<table class="tbl_ty3 costPosition">
									<colgroup>
										
									</colgroup>
									<tr>
										<td>구분</td>
										<td>국비과정</td>
										<td>신규자반</td>
										<td>경력자반</td>
										<td>국가자격 소지자반</td>
										<td>승급자반</td>
									</tr>
									<tr>
										<td class="tbl_focus">
											개설여부
										</td>
										<td>
											<select class="tbl_select wd145" id="NATIONAL_YN" name="NATIONAL_YN" data-id="NATIONAL_COST">
												<option value="Y">O</option>
												<option value="N">X</option>
											</select>
										</td>
										<td>
											<select class="tbl_select wd145" id="NEW_YN" name="NEW_YN" data-id="NEW_COST">
												<option value="Y">O</option>
												<option value="N">X</option>
											</select>
										</td>
										<td>
											<select class="tbl_select wd145" id="CAREER_YN" name="CAREER_YN" data-id="CAREER_COST">
												<option value="Y">O</option>
												<option value="N">X</option>
											</select>
										</td>
										<td>
											<select class="tbl_select wd145" id="LICENSE_YN" name="LICENSE_YN" data-id="LICENSE_COST">
												<option value="Y">O</option>
												<option value="N">X</option>
											</select>
										</td>
										<td>
											<select class="tbl_select wd145" id="ADVANCE_YN" name="ADVANCE_YN" data-id="ADVANCE_COST">
												<option value="Y">O</option>
												<option value="N">X</option>
											</select>
										</td>
									</tr>
									<tr>
										<td class="tbl_focus">
											수강료
										</td>
										<td>
											<input type="text" class="tbl_input wd125" id="NATIONAL_COST" name="NATIONAL_COST"/> 원
										</td>
										<td>
											<input type="text" class="tbl_input wd125" id="NEW_COST" name="NEW_COST"/> 원
										</td>
										<td>
											<input type="text" class="tbl_input wd125" id="CAREER_COST" name="CAREER_COST"/> 원
										</td>
										<td>
											<input type="text" class="tbl_input wd125" id="LICENSE_COST" name="LICENSE_COST"/> 원
										</td>
										<td>
											<input type="text" class="tbl_input wd125" id="ADVANCE_COST" name="ADVANCE_COST"/> 원
										</td>
									</tr>									
									
								</table>
							</div>
						</div>
						<!--conBox end-->
					
						
						<div class="main_btn">
							<ul class="wd295">
								<li class="page_back mgr5"><a href="javascript:history.back();">취소</a></li>
								<li class="page_ok"><a href="javascript:void(0);" class="move" data-move="02">다음</a></li>
							</ul>
						</div>
					</div>
					<!--sub con end / step_01 end-->
					
					<div class="sub_con step_02">
						<!--conBox-->
						<div class="conBox">
							<div class="sub_step">
								<ul class="page02_step">
									<li class="step_list ">
										<div class="step_check"><img src="/assets/images/step_check2.png"/></div>
										<div class="step_txt">연간사업계획 개요</div>
									</li>
									<li class="step_list step_on">
										<div class="step_num">2</div>
										<!--<div class="step_check"><img src="/assets/images/step_check.png"/></div>-->
										<div class="step_txt">연계실습기관 및 실습지도자 등록</div>
									</li>
									<li class="step_list">
										<div class="step_num">3</div>
										<div class="step_txt">교수요원 및 과목별 교수요원 등록</div>
									</li>
								</ul>
							</div>
						</div>

						<!--conBox-->
						<div class="conBox mgt40">
							<div class="con_title">
								연계실습기관 등록
							</div>
							<div class="con_form over_y mhi415">
								<table class="tbl_ty5 subAgencyList">
									<colgroup>
										<col width="60px"/>
										<col width="140px"/>
										<col width="200px"/>
										<col width="100px"/>
										<col width="220px"/>
									</colgroup>
									<tr>
										<td>순번</td>
										<td>시설구분</td>
										<td>시설구분(세)</td>
										<td>시설명</td>
										<td>대표전화</td>
									</tr>
								</table>
								
							</div>
						</div>
						<!--conBox end-->
						
						<!--conBox-->
						<div class="conBox mgt40">
							<div class="con_title">
								실습지도자 등록
							</div>
							<div class="con_form over_y mhi415">
								<table class="tbl_ty5 subAgentList">
									<colgroup>
										<col width="60px"/>
										<col width="140px"/>
										<col width="310px"/>
										<col width="225px"/>
									</colgroup>
									<tr>
										<td>순번</td>
										<td>시설명</td>
										<td>직무</td>
										<td>성명</td>
									</tr>
								</table>
								
							</div>
						</div>
						<!--conBox end-->
						
						<div class="main_btn">
							<ul class="wd295">
								<li class="page_back mgr5"><a href="javascript:void(0);" class="move" data-move="01">취소</a></li>
								<li class="page_ok"><a href="javascript:void(0);" class="move" data-move="03">다음</a></li>
							</ul>
						</div>
					</div>
					<!--sub con end / step_02 end-->
					
					<div class="sub_con step_03">
						<!--conBox-->
						<div class="conBox">
							<div class="sub_step">
								<ul class="page02_step">
									<li class="step_list ">
										<div class="step_check"><img src="/assets/images/step_check2.png"/></div>
										<div class="step_txt">연간사업계획 개요</div>
									</li>
									<li class="step_list ">
										<div class="step_check"><img src="/assets/images/step_check2.png"/></div>
										<div class="step_txt">연계실습기관 및 실습지도자 등록</div>
									</li>
									<li class="step_list step_on">
										<div class="step_num">3</div>
										<div class="step_txt">교수요원 및 과목별 교수요원 등록</div>
									</li>
								</ul>
							</div>
						</div>
						
						<!--conBox-->
						<div class="conBox mgt40">
							<div class="con_title">
								교수요원 등록
							</div>
							<div class="con_form over_y mhi417">
								<table class="tbl_ty5 agentList">
									<colgroup>
										<col width="60px"/>
										<col width="140px"/>
										<col width="266px"/>
										<col width="229px"/>
									</colgroup>
									<tr>
										<td>순번</td>
										<td>구분</td>
										<td>성명</td>
										<td>연락처</td>
									</tr>
								</table>
								
							</div>
						</div>
						<!--conBox end-->
						
						<!--conBox-->
						<div class="conBox">
							<div class="con_title">
								과목별 교수요원
							</div>
							<div class="con_form">
								<table class="tbl_ty2 planClassAgentList">
									<colgroup>
										<col width="175px"/>
										<col width="285px"/>
										<col width="250px"/>
										<col width="250px"/>
									</colgroup>
									<tr>
										<td>대과목</td>
										<td>중과목</td>
										<td>이론교수</td>
										<td>실기교수</td>
									</tr>
								</table>
							</div>
						</div>
						<!--conBox end-->
						
						<!--conBox-->
						<div class="conBox">
							<div class="con_form mgt10">
								<table class="tbl_ty1">
									<colgroup>
										<col width="160px"/>
										<col width="800px"/>
									</colgroup>
									<tr>
										<td class="t_head">비고</td>
										<td class="pdr10 pdl10 pdt7 pdb7">
											<textarea class="tbl_area" id="PLAN_NOTE" name="PLAN_NOTE"></textarea>
										</td>
									</tr>			
								</table>
							</div>
						</div>
						<!--conBox end-->
						
						<div class="main_btn">
							<ul class="wd295">
								<li class="page_back mgr5"><a href="javascript:void(0);" class="move" data-move="02">취소</a></li>
							</ul>
						</div>
					</div>
					<!--sub con end / step_03 end-->
				</div>
				</form>
			</div>
		</div>
		
		<!--담당과목 팝업-->
		<div id="w01" class="easyui-window" title="교수요원 담당과목 선택" data-options="modal:true,closed:true,iconCls:'icon-save'" style="width:610px;height:328px;padding:0px;">
			<div class="pop_con">
				<table class="tbl_ty2" id="agentClassList">
					<colgroup>
						<col width="80px"/>
						<col width="150px"/>
						<col width="150px"/>
						<col width="150px"/>
					</colgroup>
					<tr>
						<td>순번</td>
						<td>구분</td>
						<td>이름</td>
						<td>선택</td>
					</tr>
				</table>
				
				
				<div class="btn_box mgt20 mgb30 wd205">
					<a href="javascript:void(0);" class="pop_closed wd100 float_l mgr5" onclick="$('#w01').window('close');">닫기</a>
					<a href="javascript:void(0);" class="pop_choice wd100 float_l addAgentClass">선택</a>
				</div>
			</div>
		</div>
		
		<c:import url="/inc/footer_base.jsp" />
	</div>
</body>
</html>
