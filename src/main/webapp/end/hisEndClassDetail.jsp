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
    var _CLASS_ID = '${CLASS_ID}';
    
	$(document).ready(function() {
		fnFieldDisabled();
		
		getHisEndClassDetail();
		
		/************************************************************************
		* 취소, 다음
		************************************************************************/
		$('.move').on('click', function() {
			$('.sub_con').hide();
			$('.step_'+$(this).data('move')).show();
		});
	});
	
	function getHisEndClassDetail() {
		if(CHNG_ID == null || CHNG_ID == '') {
			return false;
		}
		
		var params = {
				'class' : 'service.EndService',
				'method' : 'getHisEndClassDetail',
				'param' : {'CHNG_ID' : CHNG_ID},
				'callback' : function(data) {
					if(data.success) {
						loadingStop();
					
						var endClassDetail = data.endClassDetail;
						var studentList = data.studentList;
						$('#CLASS_TITLE').val(endClassDetail.CLASS_TITLE);
						$('#STUDENT_TOTAL_COUNT').val(endClassDetail.STUDENT_TOTAL_COUNT);
						$('#CLASS_NOTE').val(endClassDetail.CLASS_NOTE);
						
						//교육생 명부
						var _html = '';
						if(studentList.length > 0) {
							$('#studentList .none').remove();
							$.each(studentList, function(index, item) {
								_html += '<tr class="tbl_list02 items" data-stu_id="'+item.STU_ID+'" data-cd_class_type="'+item.CD_CLASS_TYPE+'" data-stu_note="'+item.STU_NOTE+'">'+
											'<td>'+item.NO+'</td>'+
											'<td>'+item.CD_CLASS_TYPE_NAME+'</td>'+
											'<td>'+item.STU_NAME+'</td>'+
											'<td>'+item.STU_ID_NUMBER+'</td>'+
											'<td>'+item.STU_TEL+'</td>'+
										'</tr>';
								
							});
							$('#studentList').append(_html);
						}
						_html = '';
						if(studentList.length > 0) {
							$.each(studentList, function(index, item) {
								_html += '<tr class="tbl_focus items" data-stu_id='+item.STU_ID+' data-cd_class_type="'+item.CD_CLASS_TYPE+'" data-stu_note="'+item.STU_NOTE+'">'
									_html += '<td>'+item.NO+'</td>'
									_html += '<td>'+item.CD_CLASS_TYPE_NAME+'</td>'
									_html += '<td>'+item.STU_NAME+'</td>'
									_html += '<td>'+item.STU_ID_NUMBER+'</td>'
									_html += '<td>'+item.STU_TEL+'</td>'
									_html += '<td><input type="text" class="tbl_input wd65 t_center" data-time_id="P_TIME1_'+item.STU_ID+'" name="P_TIME1" value="'+item.P_TIME1+'" readonly/></td>'
									_html += '<td><input type="text" class="tbl_input wd65 t_center" data-time_id="P_TIME2_'+item.STU_ID+'" name="P_TIME2" value="'+item.P_TIME2+'" readonly/></td>'
									_html += '<td><input type="text" class="tbl_input wd65 t_center" data-time_id="S_TIME_'+item.STU_ID+'" name="S_TIME" value="'+item.S_TIME+'" readonly/></td>'
								_html += '</tr>'
							});
							$('#enterStudentList').append(_html);
						}
						_html = '';
						if(studentList.length > 0) {
							$.each(studentList, function(index, item) {
								_html += '<tr class="tbl_ty2 items" data-stu_id='+item.STU_ID+' data-cd_class_type="'+item.CD_CLASS_TYPE+'">'
									_html += '<td>'+item.NO+'</td>'
									_html += '<td>'+item.CD_CLASS_TYPE_NAME+'</td>'
									_html += '<td>'+item.STU_NAME+'</td>'
									_html += '<td>'+item.STU_ID_NUMBER+'</td>'
									_html += '<td></td>'
									_html += '<td></td>'
									_html += '<td></td>'
									_html += '<td>'+item.STU_NOTE+'</td>'
								_html += '</tr>'
							});
							$('#fixStudentList').append(_html);
						}
						$('#enterStudentList .items').each(function(i) {
							var SUM = 0;
							var P_TIME1 = $(this).find('input[name=P_TIME1]').val();
							var P_TIME2 = $(this).find('input[name=P_TIME2]').val();
							var S_TIME = $(this).find('input[name=S_TIME]').val();
							if(P_TIME1 == '' && P_TIME2 == '' && S_TIME == '') {
								SUM = '';
							} else {
								if(P_TIME1 != '') {
									SUM += parseInt(P_TIME1);
								}
								if(P_TIME2 != '') {
									SUM += parseInt(P_TIME2);
								}
								if(S_TIME != '') {
									SUM += parseInt(S_TIME);
								}
							}
							$('#fixStudentList .items:eq('+i+')').find('td:eq(4)').text(SUM);
							$('#fixStudentList .items:eq('+i+')').find('td:eq(6)').text(SUM);
						});
					}
				}
		};
		apiCall(params);
	}
	
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
					<span class="nav">수료보고</span>
					<span class="nav">수료보고</span>
					<span class="nav">상세정보</span>
				</div>
				<form name="frm" id="frm" method="post">
				<input type="hidden" name="CLASS_ID" id="CLASS_ID" value="${CLASS_ID}"/>
				<div class="sub_box">
					<div class="sub_menu">
						<div class="sub_title">수료보고</div>
						<div class="sub_list">
							<ul>
								<li class="sub_on"><a href="/end/endClassWrite">수료보고</a></li>
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
										<div class="step_txt">수료 개요</div>
									</li>
									<li class="step_list">
										<div class="step_num">2</div>
										<!--<div class="step_check"><img src="/assets/images/step_check.png"/></div>-->
										<div class="step_txt">실습이수시간 작성</div>
									</li>
									<li class="step_list">
										<div class="step_num">3</div>
										<div class="step_txt">교육생 명부</div>
									</li>
								</ul>
							</div>
						</div>
						<!--conBox-->
						<div class="conBox mgt40">
							<div class="con_title">수료 개요</div>
							<div class="con_form">
								<table class="tbl_ty1">
									<colgroup>
										<col width="160px"/>
										<col width="300px"/>
										<col width="160px"/>
										<col width="300px"/>
									</colgroup>
									<tr>
										<td class="t_head">
											수료과정명
										</td>
										<td class="pdl15 pdr15">
											<input type="text" class="tbl_input wd250" id="CLASS_TITLE" name="CLASS_TITLE"/>
										</td>
										<td class="t_head">
											교육인원
										</td>
										<td>
											<input type="text" class="tbl_input wd250" id="STUDENT_TOTAL_COUNT" name="STUDENT_TOTAL_COUNT"/>
										</td>
									</tr>
								</table>
							</div>
							
						</div>
						<!--conBox end-->		
						
						<!--conBox-->
						<div class="conBox mgt40">
							<div class="con_title">
								교육생 명부 등록
							</div>
							<div class="con_form over_y mhi417">
								<table class="tbl_ty3" id="studentList">
									<colgroup>
										<col width="60px"/>
										<col width="155px"/>
										<col width="90px"/>
										<col width="140px"/>
										<col width="140px"/>
									</colgroup>
									<tr class="tb_header">
										<td>순번</td>
										<td>구분</td>
										<td>성명</td>
										<td>주민등록번호</td>
										<td>연락처</td>
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
										<div class="step_txt">수료 개요</div>
									</li>
									<li class="step_list step_on">
										<div class="step_num">2</div>
										<!--<div class="step_check"><img src="/assets/images/step_check.png"/></div>-->
										<div class="step_txt">실습이수시간 작성</div>
									</li>
									<li class="step_list">
										<div class="step_num">3</div>
										<div class="step_txt">교육생 명부</div>
									</li>
								</ul>
							</div>
						</div>
					
						<!--conBox-->
						<div class="conBox mgt40">
							<div class="con_title">실습이수시간 작성</div>
							
							<div class="con_form mgt10">
								<table class="tbl_ty3" id="enterStudentList">
									<colgroup>
										<col width="80px"/>
										<col width="130px"/>
										<col width="130px"/>
										<col width="200px"/>
										<col width="180px"/>
										<col width="80px"/>
										<col width="80px"/>
										<col width="80px"/>
									</colgroup>
									<tr>
										<td>순번</td>
										<td>과정구분</td>
										<td>이름</td>
										<td>주민등록번호</td>
										<td>연락처</td>
										<td>요양</td>
										<td>재가</td>
										<td>대체</td>
									</tr>
									
								</table>
							</div>
						</div>
						<!--conBox end-->
						
						<div class="main_btn">
							<ul class="wd295">
								<li class="page_back mgr5"><a href="javascript:void(0);" class="move" data-move="01">취소</a></li>
								<li class="page_ok"><a href="javascript:void(0);" class="move" data-move="03" id="calc">다음</a></li>
							</ul>
						</div>
					</div>
					<!--sub con end / step_02 end-->
					
					<div class="sub_con step_03">
						<!--conBox-->
						<div class="conBox mgt40">
							<div class="sub_step">
								<ul class="page02_step">
									<li class="step_list ">
										<div class="step_check"><img src="/assets/images/step_check2.png"/></div>
										<div class="step_txt">수료 개요</div>
									</li>
									<li class="step_list ">
										<div class="step_check"><img src="/assets/images/step_check2.png"/></div>
										<div class="step_txt">실습이수시간 작성</div>
									</li>
									<li class="step_list step_on">
										<div class="step_num">3</div>
										<div class="step_txt">교육생 명부</div>
									</li>
								</ul>
							</div>
						</div>
						
						<!--conBox-->
						<div class="conBox mgt40">
							<div class="con_title">교육생 명부</div>
							<div class="con_form">
								<table class="tbl_ty2" id="fixStudentList">
									<colgroup>
										<col width="80px"/>
										<col width="120px"/>
										<col width="100px"/>
										<col width="190px"/>
										<col width="120px"/>
										<col width="100px"/>
										<col width="100px"/>
										<col width="150px"/>
									</colgroup>
									<tr>
										<td>순번</td>
										<td>과정구분</td>
										<td>이름</td>
										<td>주민등록번호</td>
										<td>실습 이수 시간</td>
										<td>이론</td>
										<td>총</td>
										<td>비고</td>
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
											<textarea class="tbl_area" id="CLASS_NOTE" name="CLASS_NOTE"></textarea>
										</td>
									</tr>			
								</table>
							</div>
						</div>
						<!--conBox end-->
						
						<div class="main_btn">
							<ul class="wd295">
								<li class="page_back"><a href="javascript:void(0);" class="move" data-move="02">취소</a></li>
							</ul>
						</div>
					</div>
					<!--sub con end / step_03 end-->
				</div>
				</form>
			</div>
		</div>
		
		<c:import url="/inc/footer_base.jsp" />
	</div>
</body>
</html>
