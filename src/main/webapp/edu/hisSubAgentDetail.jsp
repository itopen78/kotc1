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
	fnFieldDisabled();
	
	var CHNG_ID = '${CHNG_ID}';
	
	$(document).ready(function() {
		getHisSubAgentDeatil();
	});
		
 	function getHisSubAgentDeatil() {
		if(CHNG_ID == null || CHNG_ID == '') {
			return false;
		}
		
		var params = {
			'class' : 'service.EduService',
			'method' : 'getHisSubAgentDetail',
			'param' : {'CHNG_ID' : CHNG_ID},
			'callback' : function(data){
				
				console.log(data);
				
				if(data.success){
					loadingStop();
					var subAgentDetail = data.subAgentDetail;	//실습지도자 조회
					var subAgentLicenseList = data.subAgentLicenseList; //자격사항 목록 조회
					var subAgentCareerList = data.subAgentCareerList; //경력사항 목록 조회
					
					//기본 정보
					$('#CD_SAGT_TYPE').append('<option>'+subAgentDetail.CD_SAGT_TYPE_NAME+'</option>');
					$('#SAGT_NAME').val(subAgentDetail.SAGT_NAME);
					$('#SAGT_BIRTHDAY').val(subAgentDetail.SAGT_BIRTHDAY);
					$('#SAGT_TEL').val(subAgentDetail.SAGT_TEL);
					$('#REQUEST_DATE').text(subAgentDetail.REQUEST_DATE);
					$('#APPLY_DATE').text(subAgentDetail.APPLY_DATE);
					$('#FINAL_APL_DATE').text(subAgentDetail.FINAL_APL_DATE);
					$('#SAGT_NOTE').val(subAgentDetail.SAGT_NOTE);
					$('#CD_ADD_STATE_NAME').text(subAgentDetail.CD_ADD_STATE_NAME);
					$('#CD_CHNG_STATE_NAME').text(subAgentDetail.CD_CHNG_STATE_NAME);

					
					var _html = '';
					
					//자격사항 목록
					_html = '';
					if(subAgentLicenseList.length > 0) {
						var id_pks = new Array();
						$('#subAgentLicenseList .none').remove();
						$.each(subAgentLicenseList, function(index, item) {
							id_pks.push(item.LCNS_ID);
							var fileNo = (index+1);
							_html += '<tr class="items" data-lcns_id="'+item.LCNS_ID+'" data-file_no="'+fileNo+'">'
								_html += '<input type="hidden" name="LCNS_ID" value="'+item.LCNS_ID+'"/>'
								_html += '<td class="no">'+(index+1)+'</td>'
								_html += '<td><input type="text" class="tbl_input" name="LCNS_NAME" value="'+item.LCNS_NAME+'"/></td>'
								_html += '<td>'
									_html += '<ul class="file_form">'
										_html += '<li class="filesText" id="subAgentLicenseFiles_text_'+fileNo+'">'
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
						$('#subAgentLicenseList .filter').after(_html);
						
						$('.subAgentLicenseFileDown').data('cd_table', 'SUB_AGENT_LICENSE');
						$('.subAgentLicenseFileDown').data('id_pks', id_pks);
						$('.subAgentLicenseFileDown').show();
					}
					//경력사항 목록
					_html = '';
					if(subAgentCareerList.length > 0) {
						var id_pks = new Array();
						$('#subAgentCareerList .none').remove();
						$.each(subAgentCareerList, function(index, item) {
							id_pks.push(item.CRR_ID);
							var fileNo = (index+1);
							_html += '<tr class="items" data-crr_id="'+item.CRR_ID+'" data-file_no="'+fileNo+'">'
								_html += '<input type="hidden" name="CRR_ID" value="'+item.CRR_ID+'"/>'
								_html += '<td class="no">'+(index+1)+'</td>'
								_html += '<td><input type="text" class="tbl_input" name="CRR_NAME" value="'+item.CRR_NAME+'"/></td>'
								_html += '<td>'
									_html += '<ul class="file_form">'
										_html += '<li class="filesText" id="subAgentCareerFiles_text_'+fileNo+'">'
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
						$('#subAgentCareerList .filter').after(_html);
						
						$('.subAgentCareerFileDown').data('cd_table', 'SUB_AGENT_CAREER');
						$('.subAgentCareerFileDown').data('id_pks', id_pks);
						$('.subAgentCareerFileDown').show();
					}
						
					$('#SAGT_NOTE').val(subAgentDetail.SAGT_NOTE);
					
					fnFieldDisabled();
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
					<span class="nav">실습지도자</span>
					<span class="nav">실습지도자 등록</span>
				</div>
				<div class="sub_box">
					<div class="sub_menu">
						<div class="sub_title">교육기관</div>
						<div class="sub_list">
							<ul>
								<li><a href="">기관정보</a></li>
								<li><a href="">교수요원</a></li>
								<li><a href="">연계실습기관</a></li>
								<li class="sub_on"><a href="">실습지도자</a></li>
								<li><a href="">교육생</a></li>
								<li><a href="">자체점검</a></li>
							</ul>
						</div>
					</div>
					<div class="sub_con">
						<!--conBox-->
						<div class="conBox">
							<div class="con_title">기본 정보</div>
							<div class="con_form">
								<table class="tbl_ty1">
									<colgroup>
										<col width="160px"/>
										<col width="295px"/>
										<col width="160px"/>
										<col width="295px"/>
									</colgroup>
									<tr>
										<td class="t_head">직무</td>
										<td class="pdl15 pdr15">
											<select class="tbl_select" id="CD_SAGT_TYPE" name="CD_SAGT_TYPE">
											</select>
										</td>
										<td class="t_head">최초신청일자</td>
										<td>
											<span id="REQUEST_DATE"></span>
										</td>
									</tr>
									<tr>
										<td class="t_head">성명</td>
										<td class="pdl15 pdr15">
											<input type="text" class="tbl_input" id="SAGT_NAME" name="SAGT_NAME" />
										</td>
										<td class="t_head">최초승인일자</td>
										<td>
											<span id="APPLY_DATE"></span>
										</td>
									</tr>
									<tr>
										<td class="t_head">생년월일</td>
										<td class="pdl15 pdr15">
											<input type="date" class="tbl_input" id="SAGT_BIRTHDAY" name="SAGT_BIRTHDAY" />
										</td>
										<td class="t_head">최종승인일자</td>
										<td>
											<span id="FINAL_APL_DATE"></span>
										</td>
									</tr>
									<tr>
										<td class="t_head">연락처</td>
										<td class="pdl15 pdr15">
											<input type="text" class="tbl_input" id="SAGT_TEL" name="SAGT_TEL" />
										</td>
										<td class="t_head">현재 상태</td>
										<td>
											<span id="CD_ADD_STATE_NAME"></span>
										</td>
									</tr>
									<tr>
										<td class="t_head">변경 상태</td>
										<td colspan="3">
											<span id="CD_CHNG_STATE_NAME"></span>
										</td>
									</tr>
								</table>
							</div>
						</div>
					
					<!--conBox end-->
					
					<!--conBox-->
					<div class="conBox">
						<div class="con_title">
							자격사항 
							<a href="javascript:void(0);" class="title_btn wd160 mgr5 getFilesDown subAgentLicenseFileDown" style="diplay:none;">자격사항 전체 다운로드</a>
						</div>
						<div class="con_form mgt10">
						
							<table class="tbl_ty3" id="subAgentLicenseList">
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
						<div class="con_title">
							경력사항 
							<a href="javascript:void(0);" class="title_btn wd160 mgr5 getFilesDown subAgentCareerFileDown" style="diplay:none;">경력사항 전체 다운로드</a>
						</div>
						<div class="con_form mgt10">
						
							<table class="tbl_ty3" id="subAgentCareerList">
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
						<div class="con_form mgt10">
							<table class="tbl_ty1">
								<colgroup>
									<col width="160px"/>
									<col width="800px"/>
								</colgroup>
								<tr>
									<td class="t_head">비고</td>
									<td class="pdr10 pdl10 pdt7 pdb7">
										<textarea class="tbl_area" id="SAGT_NOTE" name="SAGT_NOTE"></textarea>
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