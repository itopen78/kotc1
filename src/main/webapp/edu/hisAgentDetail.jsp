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
		
		getHisAgentDetail();
    });
	
	function getHisAgentDetail() {
		if(CHNG_ID == null || CHNG_ID == '') {
			return false;
		}
		
		var params = {
				'class' : 'service.EduService',
				'method' : 'getHisAgentDetail',
				'param' : {'CHNG_ID' : CHNG_ID},
				'callback' : function(data){
					if(data.success){
						loadingStop();
						var agentDetail = data.agentDetail;	//교수요원 조회
						var agentClassList = data.agentClassList; //담당과목 목록 조회
						var agentLicenseList = data.agentLicenseList; //자격사항 목록 조회
						var agentCareerList = data.agentCareerList; //경력사항 목록 조회
						var agentOutsideLectureList = data.agentOutsideLectureList; //타 기관 출강여부 목록 조회
						
						//교수요원
						$('#CD_AGT_TYPE').append('<option>'+agentDetail.CD_AGT_TYPE_NAME+'</option>');
						$('#REQUEST_DATE').text(agentDetail.REQUEST_DATE);
						$('#AGT_NAME').val(agentDetail.AGT_NAME);
						$('#APPLY_DATE').text(agentDetail.APPLY_DATE);
						$('#AGT_BIRTHDAY').val(agentDetail.AGT_BIRTHDAY);
						$('#FINAL_APL_DATE').text(agentDetail.FINAL_APL_DATE);
						$('#AGT_TEL').val(agentDetail.AGT_TEL);
						$('#CD_ADD_STATE_NAME').text(agentDetail.CD_ADD_STATE_NAME);
						$('#CD_CHNG_STATE_NAME').text(agentDetail.CD_CHNG_STATE_NAME);
						
						var _html = '';

						//담당과목 목록
						if(agentClassList.length > 0) {
							$('#agentClassList .none').remove();
							$.each(agentClassList, function(index, item) {
								_html += '<tr class="items" data-cls_id="'+item.CLS_ID+'">'
									_html += '<input type="hidden" name="CLS_ID" value="'+item.CLS_ID+'"/>'
									_html += '<td class="no">'+(index+1)+'</td>'
									_html += '<td>'
										_html += '<select class="tbl_select" name="CD_CLS_LEV1">'
											_html += '<option>'+item.CD_CLS_LEV1_NAME+'</option>'
										_html += '</select>'
									_html += '</td>'
									_html += '<td>'
										_html += '<select class="tbl_select" name="CD_CLS_LEV2">'
											_html += '<option>'+item.CD_CLS_LEV2_NAME+'</option>'
										_html += '</select>'
									_html += '</td>'
								_html += '</tr>'
							});
							$('#agentClassList .filter').after(_html);
						}
						
						//자격사항 목록
						_html = '';
						if(agentLicenseList.length > 0) {
							var id_pks = new Array();
							$('#agentLicenseList .none').remove();
							$.each(agentLicenseList, function(index, item) {
								id_pks.push(item.LCNS_ID);
								var fileNo = (index+1);
								_html += '<tr class="items" data-lcns_id="'+item.LCNS_ID+'" data-file_no="'+fileNo+'">'
									_html += '<input type="hidden" name="LCNS_ID" value="'+item.LCNS_ID+'"/>'
									_html += '<td class="no">'+(index+1)+'</td>'
									_html += '<td><input type="text" class="tbl_input" name="LCNS_NAME" value="'+item.LCNS_NAME+'"/></td>'
									_html += '<td>'
										_html += '<ul class="file_form">'
											_html += '<li class="filesText" id="agentLicenseFiles_text_'+fileNo+'">'
												if(item.ID_PK != null && item.ID_PK != '') {
													_html += '<a href="javascript:void(0);" class="file_down getFileDown" data-original_file_name="'+item.ORIGINAL_FILE_NAME+'" data-server_file_name="'+item.SERVER_FILE_NAME+'">'+item.ORIGINAL_FILE_NAME+'</a>'
												}
											_html += '</li>'
										_html += '</ul>'
									_html += '</td>'
									_html += '<td><input type="date" class="tbl_date" name="LCNS_OBTAIN_DATE" value="'+item.LCNS_OBTAIN_DATE+'"/></td>'
									_html += '<td class="t_left pdl20"><input type="text" class="tbl_input" name="LCNS_NOTE" value="'+item.LCNS_NOTE+'"/></td>'
								_html += '</tr>'
							});
							$('#agentLicenseList .filter').after(_html);
							
							$('.agentLicenseFileDown').data('cd_table', 'AGENT_LICENSE');
							$('.agentLicenseFileDown').data('id_pks', id_pks);
							$('.agentLicenseFileDown').show();
						}
						
						//경력사항 목록
						_html = '';
						if(agentCareerList.length > 0) {
							var id_pks = new Array();
							$('#agentCareerList .none').remove();
							$.each(agentCareerList, function(index, item) {
								id_pks.push(item.CRR_ID);
								var fileNo = (index+1);
								_html += '<tr class="items" data-crr_id="'+item.CRR_ID+'" data-file_no="'+fileNo+'">'
									_html += '<input type="hidden" name="CRR_ID" value="'+item.CRR_ID+'"/>'
									_html += '<td class="no">'+(index+1)+'</td>'
									_html += '<td><input type="text" class="tbl_input" name="CRR_NAME" value="'+item.CRR_NAME+'"/></td>'
									_html += '<td>'
										_html += '<ul class="file_form">'
											_html += '<li class="filesText" id="agentCareerFiles_text_'+fileNo+'">'
												if(item.ID_PK != null && item.ID_PK != '') {
													_html += '<a href="javascript:void(0);" class="file_down getFileDown" data-original_file_name="'+item.ORIGINAL_FILE_NAME+'" data-server_file_name="'+item.SERVER_FILE_NAME+'">'+item.ORIGINAL_FILE_NAME+'</a>'
												}
											_html += '</li>'
										_html += '</ul>'
									_html += '</td>'
									_html += '<td><input type="date" class="tbl_date wd150" name="CRR_BEGIN_DATE" value="'+item.CRR_BEGIN_DATE+'"/>~<input type="date" class="tbl_date wd150" name="CRR_END_DATE" value="'+item.CRR_END_DATE+'"/></td>'
									_html += '<td class="t_left pdl20"><input type="text" class="tbl_input" name="CRR_NOTE" value="'+item.CRR_NOTE+'"/></td>'
								_html += '</tr>'
							});
							$('#agentCareerList .filter').after(_html);
							
							$('.agentCareerFileDown').data('cd_table', 'AGENT_CAREER');
							$('.agentCareerFileDown').data('id_pks', id_pks);
							$('.agentCareerFileDown').show();
						}
						
						
						//타 기관 출강여부 목록
						_html = '';
						if(agentOutsideLectureList.length > 0) {
							$('#agentOutsideLectureList .none').remove();
							$.each(agentOutsideLectureList, function(index, item) {
								_html += '<tr class="items" data-lctr_id="'+item.LCTR_ID+'">'
									_html += '<input type="hidden" name="LCTR_ID" value="'+item.LCTR_ID+'"/>'
									_html += '<td class="no">'+(index+1)+'</td>'
									_html += '<td><input type="text" class="tbl_input" name="LCTR_NAME" value="'+item.LCTR_NAME+'"/></td>'
									_html += '<td><input type="text" class="tbl_input" name="LCTR_NOTE" value="'+item.LCTR_NOTE+'"/></td>'
									_html += '<td><div class="delete_icon removeAgentOutsideLecture" data-lctr_id="'+item.LCTR_ID+'"></div></td>'
								_html += '</tr>'
							});
							$('#agentOutsideLectureList .filter').after(_html);
						}
						
						$('#AGT_NOTE').val(agentDetail.AGT_NOTE);
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
					<span class="nav">교육기관</span>
					<span class="nav">교수요원</span>
					<span class="nav">변경이력 상세</span>
				</div>
				<div class="sub_box">
					<div class="sub_menu">
						<div class="sub_title">교육기관</div>
						<div class="sub_list">
							<ul>
								<li><a href="">기관정보</a></li>
								<li class="sub_on"><a href="">교수요원</a></li>
								<li><a href="">연계실습기관</a></li>
								<li><a href="">실습지도자</a></li>
								<li><a href="">교육생</a></li>
								<li><a href="">자체점검</a></li>
							</ul>
						</div>
					</div>
					<div class="sub_con">
						<!--conBox-->
						<div class="conBox">
							<div class="con_title">기본정보</div>
							<div class="con_form">
								<table class="tbl_ty1">
									<colgroup>
										<col width="160px"/>
										<col width="295px"/>
										<col width="160px"/>
										<col width="295px"/>
									</colgroup>
									<tr>
										<td class="t_head over_hide pdt5">
											<span class="star">*</span>인력구분
										</td>
										<td class="pdl15 pdr15">
											<select class="tbl_select" id="CD_AGT_TYPE" NAME="CD_AGT_TYPE">
											</select>
										</td>
										<td class="t_head">최초신청일자</td>
										<td id="REQUEST_DATE"><!-- 2020년 10월 03일 --></td>
									</tr>
									<tr>
										<td class="t_head over_hide pdt5"><span class="star">*</span>성명</td>
										<td class="pdl15 pdr15">
											<input type="text" class="tbl_input" id="AGT_NAME" name="AGT_NAME"/>
										</td>
										<td class="t_head">최초승인일자</td>
										<td id="APPLY_DATE"><!-- 2020년 10월 03일 --></td>
									</tr>
									<tr>
										<td class="t_head over_hide pdt5"><span class="star">*</span>생년월일</td>
										<td class="pdl15 pdr15">
											<input type="date" class="tbl_date" id="AGT_BIRTHDAY" name="AGT_BIRTHDAY"/>
										</td>
										<td class="t_head">최종승인일자</td>
										<td id="FINAL_APL_DATE"><!-- 2020년 10월 04일 --></td>
									</tr>
									<tr>
										<td class="t_head over_hide pdt5"><span class="star">*</span>연락처</td>
										<td class="pdl15 pdr15">
											<input type="text" class="tbl_input" id="AGT_TEL" name="AGT_TEL"/>
										</td>
										<td class="t_head">등록 상태</td>
										<td id="CD_ADD_STATE_NAME"><!-- 등록 신청 --></td>
									</tr>
									<tr>
										<td class="t_head">변경 상태</td>
										<td colspan="3" id="CD_CHNG_STATE_NAME"></td>
									</tr>
								</table>
							</div>
						</div>
						<!--conBox end-->
						
						<!--conBox-->
						<div class="conBox">
							<div class="con_title">담당교육</div>
							<div class="con_form mgt10">
								<table class="tbl_ty3" id="agentClassList">
									<colgroup>
										<col width="110px"/>
										<col width="315"/>
										<col width="425px"/>
									</colgroup>
									<tr class="filter">
										<td>순번</td>
										<td>대과목</td>
										<td>중과목</td>
									</tr>
									<tr class="none"><td colspan="3">등록된 데이터가 없습니다.</td></tr>
								</table>
								
							</div>
						</div>
						<!--conBox end-->
						
						<!--conBox-->
						<div class="conBox">
							<div class="con_title">자격사항<a href="javascript:void(0);" style="diplay:none;" class="title_btn wd160 mgr5 getFilesDown agentLicenseFileDown">자격사항 전체 다운로드</a></div>
							<div class="con_form mgt10">
								<table class="tbl_ty3" id="agentLicenseList">
									<colgroup>
										<col width="110px"/>
										<col width="145px"/>
										<col width="180px"/>
										<col width="135px"/>
										<col width="290px"/>
									</colgroup>
									<tr class="filter">
										<td>순번</td>
										<td>자격사항</td>
										<td>첨부파일</td>
										<td>자격 취득일</td>
										<td>비고</td>
									</tr>
									<tr class="none"><td colspan="5">등록된 데이터가 없습니다.</td></tr>
									
								</table>
							</div>
						</div>
						<!--conBox end-->
						
						<!--conBox-->
						<div class="conBox">
							<div class="con_title">경력사항<a href="javascript:void(0);" style="display:none;" class="title_btn wd160 mgr5 getFilesDown agentCareerFileDown">경력사항 전체 다운로드</a></div>
							<div class="con_form mgt10">
								<table class="tbl_ty3" id="agentCareerList">
									<colgroup>
										<col width="110px"/>
										<col width="145px"/>
										<col width="180px"/>
										<col width="400px"/>
										<col width="120px"/>
									</colgroup>
									<tr class="filter">
										<td>순번</td>
										<td>경력사항</td>
										<td>첨부파일</td>
										<td>경력</td>
										<td>비고</td>
									</tr>
									<tr class="none"><td colspan="5">등록된 데이터가 없습니다.</td></tr>
								</table>
							</div>
						</div>
						<!--conBox end-->
						
						<!--conBox-->
						<div class="conBox">
							<div class="con_title">타 기관 출강여부</div>
							<div class="con_form mgt10">
								<table class="tbl_ty3" id="agentOutsideLectureList">
									<colgroup>
										<col width="110px"/>
										<col width="225px"/>
										<col width="515px"/>
									</colgroup>
									<tr class="filter">
										<td>순번</td>
										<td>타 기관명</td>
										<td>비고</td>
									</tr>
									<tr class="none"><td colspan="3">등록된 데이터가 없습니다.</td></tr>
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
											<textarea class="tbl_area" id="AGT_NOTE" name="AGT_NOTE"></textarea>
										</td>
									</tr>			
								</table>
							</div>
						</div>
						<!--conBox end-->
						<div class="main_btn">
							<ul>
								<li class="page_back mgr5"><a href="javascript:history.back();">취소</a></li>
							</ul>
						</div>
					</div>
				</div>
			</div>
		</div>
		
		<c:import url="/inc/footer_base.jsp" />
	</div>
</body>
</html>
