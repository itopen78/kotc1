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
    var AGC_ID = '${sessionScope.userInfo.AGC_ID}';
    
	$(document).ready(function() {
		getBusinessPlanDetail();
		
		/************************************************************************
		* 취소, 다음
		************************************************************************/
		$('.move').on('click', function() {
			$('.sub_con').hide();
			$('.step_'+$(this).data('move')).show();
		});
		
		/************************************************************************
		* 연간사업계획 개요 O,X 제어 
		************************************************************************/
		$('.costPosition select').on('change', function() {
			if($(this).val() == 'Y') {
				$('#'+$(this).data('id')).css('background-color','');
				$('#'+$(this).data('id')).prop("readonly",false);
			} else {
				$('#'+$(this).data('id')).val('');
				$('#'+$(this).data('id')).css('background-color','#DEDEDE');
				$('#'+$(this).data('id')).prop("readonly",true);
			}
		});
		
		/************************************************************************
		* 연계실습기관 등록 시설구분 제어 
		************************************************************************/
		$('#subAgency1').on('change', function() {
			var CD_MIDDLE = $(this).val();
			if(CD_MIDDLE == '') {
				$('#subAgency2').empty();
				$('#subAgency2').append('<option value="">전체</>');
			} else {
				var params = {
						'class' : 'commonMapper',
						'method' : 'getCommonListByBottom',
						'param' : {'CD_TOP' : '6', 'CD_MIDDLE' : CD_MIDDLE},
						'callback' : function(data){
							if(data.success){
								loadingStop();
								$('#subAgency2').empty();
								$('#subAgency2').append('<option value="">전체</>');
								$.each(data.list, function(i, item) {
									$('#subAgency2').append('<option value="'+item.CODE+'">'+item.NAME+'</>');
								});
							}
						}
				};
				apiCall(params);
			}
		});
		
		/************************************************************************
		* 과목별 교수요원 - 교수요원 선택 
		************************************************************************/
		var agts = '';
		var items = '';
		$('.searchAgent').on('click', function() {
			agts = $(this).data('agts');
			items = $(this).closest('.items').attr('id');
			var CD_CLS_LEV1 = items.split('_')[0];
			var CD_CLS_LEV2 = items.split('_')[1];
			var AGC_ID = '${sessionScope.userInfo.AGC_ID}';
			var CD_ADD_STATE = '3'; //등록승인
			
			var agtIds = $(this).data('agt_ids');
			
			var params = {
					'class' : 'eduMapper',
					'method' : 'getAgentClassList',
					'param' : {
							'CD_CLS_LEV1' : CD_CLS_LEV1
							, 'CD_CLS_LEV2' : CD_CLS_LEV2
							, 'AGC_ID' : AGC_ID
							, 'CD_ADD_STATE' : CD_ADD_STATE
					},
					'callback' : function(data){
						if(data.success){
							loadingStop();
							
							$('#agentClassList .items').remove();
							var _html = '';
							if(data.list.length > 0) {
								$(data.list).each(function(i, item) {
									_html += '<tr class="items" data-agt_id="'+item.AGT_ID+'" data-agt_name="'+item.AGT_NAME+'">'
										_html += '<td>'+(i+1)+'</td>'
										_html += '<td>'+item.CD_AGT_TYPE_NAME+'</td>'
										_html += '<td>'+item.AGT_NAME+'</td>'
										_html += '<td  class="check_form">'
											_html += '<input type="checkbox" id="pop_check'+i+'" class="tbl_check" data-agt_id="'+item.AGT_ID+'" '+(agtIds.includes(item.AGT_ID) ? 'checked' : '')+'/>'
											_html += '<label for="pop_check'+i+'"><span></span></label>'
										_html += '</td>'
									_html += '</tr>'
								});
							} else {
								_html += '<tr class="items"><td colspan="4">등록된 데이터가 없습니다.</td></tr>'
							}
							$('#agentClassList').append(_html);
							$('#w01').window('open');
						}
					}
			};
			apiCall(params);
		});
		
		/************************************************************************
		* 과목별 교수요원 - 교수요원 선택 - 레이어 선택
		************************************************************************/
		$('.addAgentClass').on('click', function() {
			var agtIds = new Array();
			var agtNames = '';
			if($('#agentClassList input:checkbox:checked').length > 0) {
				$('#agentClassList input:checkbox:checked').each(function() {
					agtIds.push($(this).closest('.items').data('agt_id'));
					agtNames += (agtNames == '' ? '' : ', ') + $(this).closest('.items').data('agt_name');
				});
			}
			$('.planClassAgentList #'+items+' a.'+agts).data('agt_ids', agtIds.join());
			$('.planClassAgentList #'+items+' span.'+agts).text(agtNames);
			$('#w01').window('close');
		});
		
		/************************************************************************
		* 저장
		************************************************************************/
		$('.saveBusinessPlan').on('click', function() {
			var CD_ADD_STATE = $(this).data('cd_add_state');
			
			if($('#PLAN_TITLE').val() == '') {
				alert('제목을 입력하세요.');
				$('#PLAN_TITLE').focus();
				return false;
			}
			
			if($('#PERSONNEL').val() == '') {
				alert('정원을 입력하세요.');
				$('#PERSONNEL').focus();
				return false;
			}
			
			/************************************************************************
			* 연간사업계획
			************************************************************************/
			var businessPlanDetail = {
				'PLAN_ID' : $('#PLAN_ID').val()
				, 'PLAN_TITLE' : $('#PLAN_TITLE').val()
				, 'NATIONAL_YN' : $('#NATIONAL_YN').val()
				, 'NEW_YN' : $('#NEW_YN').val()
				, 'CAREER_YN' : $('#CAREER_YN').val()
				, 'LICENSE_YN' : $('#LICENSE_YN').val()
				, 'ADVANCE_YN' : $('#ADVANCE_YN').val()
				, 'NATIONAL_COST' : $('#NATIONAL_COST').val()
				, 'NEW_COST' : $('#NEW_COST').val()
				, 'CAREER_COST' : $('#CAREER_COST').val()
				, 'LICENSE_COST' : $('#LICENSE_COST').val()
				, 'ADVANCE_COST' : $('#ADVANCE_COST').val()
				, 'PERSONNEL' : $('#PERSONNEL').val()
				, 'CD_ADD_STATE' : CD_ADD_STATE
				, 'PLAN_NOTE' : $('#PLAN_NOTE').val()
			};
			
			/************************************************************************
			* 연계실습기관
			************************************************************************/
			var sagcIds = new Array();
			$('.subAgencyList .items input:checkbox:checked').each(function() {
				sagcIds.push($(this).closest('.items').data('sagc_id'));
			});
			
			/************************************************************************
			* 실습지도자
			************************************************************************/
			var sagtIds = new Array();
			$('.subAgentList .items input:checkbox:checked').each(function() {
				sagtIds.push($(this).closest('.items').data('sagt_id'));
			});
			
			/************************************************************************
			* 교수요원
			************************************************************************/
			var agtIds = new Array();
			$('.agentList .items input:checkbox:checked').each(function() {
				agtIds.push($(this).closest('.items').data('agt_id'));
			});
			
			/************************************************************************
			* 과목별 교수요원
			************************************************************************/
			var planClassList = new Array();
			$('.planClassAgentList .items').each(function() {
				var CD_CLS_LEV1 = $(this).attr('id').split('_')[0];
				var CD_CLS_LEV2 = $(this).attr('id').split('_')[1];
				
				var agts1 = $(this).find('.agts1').data('agt_ids');
				var agts2 = $(this).find('.agts2').data('agt_ids');
				planClassList.push({'CD_CLS_LEV1' : CD_CLS_LEV1, 'CD_CLS_LEV2' : CD_CLS_LEV2, 'agts1' : agts1, 'agts2' : agts2});
			});

			if(!confirm('저장하시겠습니까?')) {
				return false;
			}

			var params = {
					'class' : 'service.BizService',
					'method' : 'saveBusinessPlan',
					'param' : {
							'businessPlanDetail' : JSON.stringify(businessPlanDetail)
							, 'sagcIds' : JSON.stringify(sagcIds)
							, 'sagtIds' : JSON.stringify(sagtIds)
							, 'agtIds' : JSON.stringify(agtIds)
							, 'planClassList' : JSON.stringify(planClassList)
					},
					'callback' : function(data){
						if(data.success){
							loadingStop();
							alert('저장 되었습니다.');
							location.href='/biz/businessPlanList';
						}
					}
			};
			apiCall(params);
		});
	});
	
	function getBusinessPlanDetail() {
		if($('#PLAN_ID').val() == null || $('#PLAN_ID').val() == '') {
			var params = {
					'class' : 'eduMapper',
					'method' : 'getAgencyDetail',
					'param' : {'AGC_ID' : AGC_ID},
					'callback' : function(data){
						if(data.success){
							loadingStop();
							var view = data.view;
							$('#AGC_NAME').text(view.AGC_NAME);
							$('#AGC_SERIAL').text(view.AGC_SERIAL);
							$('#AGC_CORP').text(view.AGC_CORP);
							$('#AGC_CORP_SERIAL').text(view.AGC_CORP_SERIAL);
							$('#AGC_ADDRESS').text(view.AGC_ADDRESS);
							$('#AGC_ZIP').text(view.AGC_ZIP);
							$('#AGC_CORP_BOSS_NAME').text(view.AGC_CORP_BOSS_NAME);
							$('#AGC_CORP_BOSS_TEL').text(view.AGC_CORP_BOSS_TEL);
							$('#AGC_BOSS_NAME').text(view.AGC_BOSS_NAME);
							$('#AGC_BOSS_TEL').text(view.AGC_BOSS_TEL);
						}
					}
			};
			apiCall(params);
		} else {
			var params = {
					'class' : 'service.BizService',
					'method' : 'getBusinessPlanDetail',
					'param' : {'PLAN_ID' : $('#PLAN_ID').val()},
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
							
							$('.costPosition select').each(function() {
								if($(this).val() == 'N') {
									$('#'+$(this).data('id')).val('');
									$('#'+$(this).data('id')).css('background-color','#DEDEDE');
									$('#'+$(this).data('id')).prop("readonly",true);
								}
							});
							
							$(data.planSagencyList).each(function(i, item) {
								$('.subAgencyList #subAgencyChk'+item.SAGC_ID).closest(".tbl_list").children("td").css({"background":"#ebf0f9"});
								$('.subAgencyList #subAgencyChk'+item.SAGC_ID).prop('checked', true);
							});
							
							$(data.planSagentList).each(function(i, item) {
								$('.subAgentList #subAgentChk'+item.SAGT_ID).closest(".tbl_list02").children("td").css({"background":"#ebf0f9"});
								$('.subAgentList #subAgentChk'+item.SAGT_ID).prop('checked', true);
							});
							
							$(data.planAgentList).each(function(i, item) {
								$('.agentList #agentChk'+item.AGT_ID).closest(".tbl_list03").children("td").css({"background":"#ebf0f9"});
								$('.agentList #agentChk'+item.AGT_ID).prop('checked', true);
							});
							
							$(data.planClassList).each(function(i, planClass) {
								var cd_cls_lev = planClass.CD_CLS_LEV1 + '_' + planClass.CD_CLS_LEV2;
								if(planClass.planClassAgentList.length > 0) {
									var agts1 = '';
									var agts2 = '';
									var agts1Name = '';
									var agts2Name = '';
									$(planClass.planClassAgentList).each(function(x, planClassAgent) {
										var AGT_ID = planClassAgent.AGT_ID;
										var AGT_NAME = planClassAgent.AGT_NAME;
										if(planClassAgent.AGT_TYPE == '1') {
											agts1 += (agts1 != '' ? ',' : '') + AGT_ID
											agts1Name += (agts1Name != '' ? ', ' : '') + AGT_NAME
										} else {
											agts2 += (agts2 != '' ? ',' : '') + AGT_ID
											agts2Name += (agts2Name != '' ? ', ' : '') + AGT_NAME
										}
									});
									
									$('.planClassAgentList #'+cd_cls_lev).find('a.agts1').data('agt_ids', agts1);
									$('.planClassAgentList #'+cd_cls_lev).find('span.agts1').text(agts1Name);
									$('.planClassAgentList #'+cd_cls_lev).find('a.agts2').data('agt_ids', agts2);
									$('.planClassAgentList #'+cd_cls_lev).find('span.agts2').text(agts2Name);
								}
							})
						}
					}
			};
			apiCall(params);
		}
	}
	
	/****************************************************************************
	* 연계실습기관 검색
	****************************************************************************/
	function searchSubAgency() {
		var subAgency0 = $('.subAgencyList #subAgency0').val();
		var subAgency1 = $('.subAgencyList #subAgency1').val();
		var subAgency2 = $('.subAgencyList #subAgency2').val();
		var subAgency3 = $('.subAgencyList #subAgency3').val().toLowerCase();
		var subAgency4 = $('.subAgencyList #subAgency4').val().toLowerCase();
		var subAgency5 = $('.subAgencyList #subAgency5').val();
		
		$('.subAgencyList .items').each(function() {
			var value0 = $(this).children(":eq(0)").data('value');
			var value1 = $(this).children(":eq(1)").data('value');
			var value2 = $(this).children(":eq(2)").data('value');
			var value3 = $(this).children(":eq(3)").data('value').toLowerCase();
			var value4 = $(this).children(":eq(4)").data('value').toLowerCase();
			var value5 = $(this).find('input[name=chk]').is(':checked') == true ? 'Y' : 'N';
			
			if((subAgency0 == '' || (subAgency0 == value0))
				&& (subAgency1 == '' || (subAgency1 == value1))
				&& (subAgency2 == '' || (subAgency2 == value2))
				&& (subAgency3 == '' || (value3.indexOf(subAgency3) > -1))
				&& (subAgency4 == '' || (value4.indexOf(subAgency4) > -1))
				&& (subAgency5 == '' || (subAgency5 == value5))
			) {
				$(this).show();
			} else {
				$(this).hide();
			}
		});
	}
	
	/****************************************************************************
	* 실습지도자 검색
	****************************************************************************/
	function searchSubAgent() {
		var subAgent0 = $('.subAgentList #subAgent0').val();
		var subAgent1 = $('.subAgentList #subAgent1').val();
		var subAgent2 = $('.subAgentList #subAgent2').val();
		var subAgent3 = $('.subAgentList #subAgent3').val().toLowerCase();
		var subAgent4 = $('.subAgentList #subAgent4').val()
		
		$('.subAgentList .items').each(function() {
			var value0 = $(this).children(":eq(0)").data('value');
			var value1 = $(this).children(":eq(1)").data('value');
			var value2 = $(this).children(":eq(2)").data('value');
			var value3 = $(this).children(":eq(3)").data('value').toLowerCase();
			var value4 = $(this).find('input[name=chk]').is(':checked') == true ? 'Y' : 'N';
			
			if((subAgent0 == '' || (subAgent0 == value0))
				&& (subAgent1 == '' || (subAgent1 == value1))
				&& (subAgent2 == '' || (subAgent2 == value2))
				&& (subAgent3 == '' || (value3.indexOf(subAgent3) > -1))
				&& (subAgent4 == '' || (subAgent4 == value4))
			) {
				$(this).show();
			} else {
				$(this).hide();
			}
		});
	}
	
	/****************************************************************************
	* 교수요원 검색
	****************************************************************************/
	function searchAgent() {
		var agent0 = $('.agentList #agent0').val();
		var agent1 = $('.agentList #agent1').val();
		var agent2 = $('.agentList #agent2').val().toLowerCase();
		var agent3 = $('.agentList #agent3').val().toLowerCase();
		var agent4 = $('.agentList #agent4').val()
		
		$('.agentList .items').each(function() {
			var value0 = $(this).children(":eq(0)").data('value');
			var value1 = $(this).children(":eq(1)").data('value');
			var value2 = $(this).children(":eq(2)").data('value').toLowerCase();
			var value3 = $(this).children(":eq(3)").data('value').toLowerCase();
			var value4 = $(this).find('input[name=chk]').is(':checked') == true ? 'Y' : 'N';
			
			if((agent0 == '' || (agent0 == value0))
				&& (agent1 == '' || (agent1 == value1))
				&& (agent2 == '' || (value2.indexOf(agent2) > -1))
				&& (agent3 == '' || (value3.indexOf(agent3) > -1))
				&& (agent4 == '' || (agent4 == value4))
			) {
				$(this).show();
			} else {
				$(this).hide();
			}
		});
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
								<li class="page_back mgr5"><a href="javascript:void(0);" class="saveBusinessPlan" data-cd_add_state="6">임시저장</a></li>
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
										<col width="60px"/>
									</colgroup>
									<tr>
										<td>순번</td>
										<td>시설구분</td>
										<td>시설구분(세)</td>
										<td>시설명</td>
										<td>대표전화</td>
										<td class="check_form over_hide">
											<div class="float_l">선택</div>
											<input type="checkbox" id="all_check" class="all_check"/>
											<label for="all_check" class="float_l mgl15"><span></span></label>
										</td>
									</tr>
									<tr>
										<td>
											<input type="text" class="tbl_input wd60" id="subAgency0" onkeyup="searchSubAgency();"/>
										</td>
										<td>
											<select class="tbl_select wd140" id="subAgency1" onchange="searchSubAgency();">
												<option value="" selected>전체</option>
												<c:forEach var="item" items="${cdFacilityLev1List}">
													<option value="${item.CODE}">${item.NAME}</option>
												</c:forEach>
											</select>
										</td>
										<td>
											<select class="tbl_select wd200" id="subAgency2" onchange="searchSubAgency();">
												<option value="" selected>전체</option>
											</select>
										</td>
										<td>
											<input type="text" class="tbl_input wd100" id="subAgency3" onkeyup="searchSubAgency();"/>
										</td>
										<td>
											<input type="text" class="tbl_input wd220" id="subAgency4" onkeyup="searchSubAgency();"/>
										</td>
										<td>
											<select class="tbl_select wd60" id="subAgency5" onchange="searchSubAgency();">
												<option value="">전체</option>
												<option value="Y">Y</option>
												<option value="N">N</option>
											</select>
										</td>
									</tr>
									<c:forEach var="item" items="${subAgencyList}" varStatus="status">
										<tr class="tbl_list items" data-sagc_id="${item.SAGC_ID}">
											<td data-value="${status.index + 1}">${status.index + 1}</td>
											<td data-value="${item.CD_FACILITY_LEV1}">${item.CD_FACILITY_LEV1_NAME}</td>
											<td data-value="${item.CD_FACILITY_LEV2}">${item.CD_FACILITY_LEV2_NAME}</td>
											<td data-value="${item.SAGC_NAME}">${item.SAGC_NAME}</td>
											<td data-value="${item.SAGC_BOSS_TEL}">${item.SAGC_BOSS_TEL}</td>
											<td class="check_form">
												<input type="checkbox" id="subAgencyChk${item.SAGC_ID}" name="chk" class="tbl_check"/>
												<label for="subAgencyChk${item.SAGC_ID}"><span></span></label>
											</td>
										</tr>
									</c:forEach>
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
										<col width="60px"/>
									</colgroup>
									<tr>
										<td>순번</td>
										<td>시설명</td>
										<td>직무</td>
										<td>성명</td>
										<td class="check_form over_hide">
											<div class="float_l">선택</div>
											<input type="checkbox" id="all_check02" class="all_check"/>
											<label for="all_check02" class="float_l mgl15"><span></span></label>
										</td>
									</tr>
									<tr>
										<td>
											<input type="text" class="tbl_input wd60" id="subAgent0" onkeyup="searchSubAgent();"/>
										</td>
										<td>
											<select class="tbl_select" id="subAgent1" onchange="searchSubAgent();">
												<option value="">전체</option>
												<c:forEach var="item" items="${subAgencyList}" varStatus="status">
													<option value="${item.SAGC_ID}">${item.SAGC_NAME}</option>
												</c:forEach>
											</select>
										</td>
										<td>
											<select class="tbl_select" id="subAgent2" onchange="searchSubAgent();">
												<option value="">전체</option>
												<c:forEach var="item" items="${cdSagtTypeList}">
													<option value="${item.CODE}">${item.NAME}</option>
												</c:forEach>
											</select>
										</td>
										<td>
											<input type="text" class="tbl_input" id="subAgent3" onkeyup="searchSubAgent();"/>
										</td>
										<td>
											<select class="tbl_select wd60" id="subAgent4" onchange="searchSubAgent();">
												<option value="">전체</option>
												<option value="Y">Y</option>
												<option value="N">N</option>
											</select>
										</td>
									</tr>
									<c:forEach items="${subAgentList}" var="item" varStatus="status">
										<tr class="tbl_list02 items" data-sagt_id="${item.SAGT_ID}">
											<td data-value="${status.index + 1}">${status.index + 1}</td>
											<td data-value="${item.SAGC_ID}">${item.SAGC_NAME}</td>
											<td data-value="${item.CD_SAGT_TYPE}">${item.CD_SAGT_TYPE_NAME}</td>
											<td data-value="${item.SAGT_NAME}">${item.SAGT_NAME}</td>
											<td class="check_form">
												<input type="checkbox" id="subAgentChk${item.SAGT_ID}" name="chk2" class="tbl_check"/>
												<label for="subAgentChk${item.SAGT_ID}"><span></span></label>
											</td>
										</tr>
									</c:forEach>

								</table>
								
							</div>
						</div>
						<!--conBox end-->
						
						<div class="main_btn">
							<ul class="wd295">
								<li class="page_back mgr5"><a href="javascript:void(0);" class="move" data-move="01">취소</a></li>
								<li class="page_back mgr5"><a href="javascript:void(0);" class="saveBusinessPlan" data-cd_add_state="6">임시저장</a></li>
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
										<col width="60px"/>
									</colgroup>
									<tr>
										<td>순번</td>
										<td>구분</td>
										<td>성명</td>
										<td>연락처</td>
										<td class="check_form over_hide">
											<div class="float_l">선택</div>
											<input type="checkbox" id="all_check03" class="all_check"/>
											<label for="all_check03" class="float_l mgl15"><span></span></label>
										</td>
									</tr>
									<tr>
										<td>
											<input type="text" class="tbl_input wd60" id="agent0" onkeyup="searchAgent();"/>
										</td>
										<td>
											<select class="tbl_select" id="agent1" onchange="searchAgent();">
												<option value="">전체</option>
												<c:forEach var="item" items="${cdAgtTypeList}">
													<option value="${item.CODE}">${item.NAME}</option>
												</c:forEach>
											</select>
										</td>
										<td>
											<input type="text" class="tbl_input" id="agent2" onkeyup="searchAgent();"/>
										</td>
										<td>
											<input type="text" class="tbl_input" id="agent3" onkeyup="searchAgent();"/>
										</td>
										<td>
											<select class="tbl_select wd60" id="agent4" onchange="searchAgent();">
												<option value="">전체</option>
												<option value="Y">Y</option>
												<option value="N">N</option>
											</select>
										</td>
									</tr>
									<c:forEach items="${agentList}" var="item" varStatus="status">
										<tr class="tbl_list03 items" data-agt_id="${item.AGT_ID}">
											<td data-value="${status.index + 1}">${status.index + 1}</td>
											<td data-value="${item.CD_AGT_TYPE}">${item.CD_AGT_TYPE_NAME}</td>
											<td data-value="${item.AGT_NAME}">${item.AGT_NAME}</td>
											<td data-value="${item.AGT_TEL}">${item.AGT_TEL}</td>
											<td class="check_form">
												<input type="checkbox" id="agentChk${item.AGT_ID}" name="chk3" class="tbl_check"/>
												<label for="agentChk${item.AGT_ID}"><span></span></label>
											</td>
										</tr>
									</c:forEach>

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
									<c:forEach items="${classCodeList}" var="item">
										<c:set var="cd_cls_lev" value="${item.CD_MIDDLE}_${item.CD_BOTTOM}"/>
										<tr class="items" id="${cd_cls_lev}">
											<td>${item.CD_MIDDLE_KR}</td>
											<td>${item.CD_BOTTOM_KR}</td>
											<td><a class="reply_btn wd100 searchAgent agts1" href="javascript:void(0)" data-agts="agts1" data-agt_ids="">교수요원 선택</a><span class="pdl10 agts1"></span></td>
											<td><a class="reply_btn wd100 searchAgent agts2" href="javascript:void(0)" data-agts="agts2" data-agt_ids="">교수요원 선택</a><span class="pdl10 agts2"></span></td>
										</tr>
									</c:forEach>
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
								<li class="page_back mgr5"><a href="javascript:void(0);" class="saveBusinessPlan" data-cd_add_state="6">임시저장</a></li>
								<li class="page_ok"><a href="javascript:void(0);" class="saveBusinessPlan" data-cd_add_state="1">등록신청</a></li>
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
