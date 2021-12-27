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
	    
		getHisSubAgencyDetail();
    });
	
	function getHisSubAgencyDetail() {
		if(CHNG_ID == null || CHNG_ID == '') {
			return false;
		}
		
		var params = {
				'class' : 'service.EduService',
				'method' : 'getHisSubAgencyDetail',
				'param' : {'CHNG_ID' : CHNG_ID},
				'callback' : function(data){
					if(data.success){
						loadingStop();
						var subAgencyDetail = data.subAgencyDetail;
						var subAgencyContractDocumentList = data.subAgencyContractDocumentList;
						
						$('#CD_FACILITY_LEV1').append('<option>'+subAgencyDetail.CD_FACILITY_LEV1_NAME+'</option>');
						$('#CD_FACILITY_LEV2').append('<option>'+subAgencyDetail.CD_FACILITY_LEV2_NAME+'</option>');
						$('#SAGC_NAME').val(subAgencyDetail.SAGC_NAME);
						$('#SAGC_ZIP').val(subAgencyDetail.SAGC_ZIP);
						$('#INSTALL_DATE').val(subAgencyDetail.INSTALL_DATE);
						$('#SAGC_ADDRESS').val(subAgencyDetail.SAGC_ADDRESS);
						$('#REQUEST_DATE').text(subAgencyDetail.REQUEST_DATE);
						$('#SAGC_BOSS_NAME').val(subAgencyDetail.SAGC_BOSS_NAME);
						$('#APPLY_DATE').text(subAgencyDetail.APPLY_DATE);
						$('#SAGC_BOSS_TEL').val(subAgencyDetail.SAGC_BOSS_TEL);
						$('#FINAL_APL_DATE').text(subAgencyDetail.FINAL_APL_DATE);
						$('#CONTRACT_BEGIN_DATE').val(subAgencyDetail.CONTRACT_BEGIN_DATE);
						$('#CONTRACT_END_DATE').val(subAgencyDetail.CONTRACT_END_DATE);
						$('#CD_ADD_STATE_NAME').text(subAgencyDetail.CD_ADD_STATE_NAME);
						$('#CD_CHNG_STATE_NAME').text(subAgencyDetail.CD_CHNG_STATE_NAME);
						
						$('#MEMBER_TOTAL_COUNT').val(subAgencyDetail.MEMBER_TOTAL_COUNT);
						$('#EVALUATION_RANK').val(subAgencyDetail.EVALUATION_RANK);
						if(subAgencyDetail.EVALUATION_RANK == '') {
							$('.evaluationYear').hide();
						}
						$('#MEMBER_CURRENT_COUNT').val(subAgencyDetail.MEMBER_CURRENT_COUNT);
						$('#EVALUATION_YEAR').val(subAgencyDetail.EVALUATION_YEAR);
						$('#STUDENT_TOTAL_COUNT').val(subAgencyDetail.STUDENT_TOTAL_COUNT);
						$('#STUDENT_DAILY_COUNT').val(subAgencyDetail.STUDENT_DAILY_COUNT);
						$('#STUDENT_DAILY_COST').val(subAgencyDetail.STUDENT_DAILY_COST);
						
						var _html = '';
						if(subAgencyContractDocumentList.length > 0) {
							var id_pks = new Array();
							$('#subAgencyContractDocumentList .none').remove();
							$.each(subAgencyContractDocumentList, function(index, item) {
								id_pks.push(item.CONT_DOC_ID);
								var fileNo = (index+1);
								_html += '<tr class="items" data-cont_doc_id="'+item.CONT_DOC_ID+'" data-file_no="'+fileNo+'">'
									_html += '<input type="hidden" name="CONT_DOC_ID" value="'+item.CONT_DOC_ID+'"/>'
									_html += '<td class="no">'+(index+1)+'</td>'
									_html += '<td>'
										_html += '<select class="tbl_select" name="CD_CONT_DOC_TYPE">'
											_html += '<option value="1" '+(item.CD_CONT_DOC_TYPE == '1' ? 'selected' : '')+'>계약서</option>'
											_html += '<option value="2" '+(item.CD_CONT_DOC_TYPE == '2' ? 'selected' : '')+'>시설설치신고필증</option>'
											_html += '<option value="3" '+(item.CD_CONT_DOC_TYPE == '3' ? 'selected' : '')+'>등급판정서</option>'
											_html += '<option value="4" '+(item.CD_CONT_DOC_TYPE == '4' ? 'selected' : '')+'>기타</option>'
										_html += '</select>'
									_html += '</td>'
									_html += '<td>'
										_html += '<ul class="file_form">'
											_html += '<li class="filesText" id="subAgencyContractDocumentFiles_text_'+fileNo+'">'
												if(item.ID_PK != null && item.ID_PK != '') {
													_html += '<a href="javascript:void(0);" class="file_down getFileDown" data-original_file_name="'+item.ORIGINAL_FILE_NAME+'" data-server_file_name="'+item.SERVER_FILE_NAME+'">'+item.ORIGINAL_FILE_NAME+'</a>'
												}
											_html += '</li>'
										_html += '</ul>'
									_html += '</td>'
									_html += '<td>'
										_html += '<input type="text" class="tbl_input" name="CONT_DOC_NOTE" value="'+item.CONT_DOC_NOTE+'"/>'
									_html += '</td>'
								_html += '</tr>'
							});
							$('#subAgencyContractDocumentList .filter').after(_html);
							
							$('.subAgencyContractDocumentFileDown').data('cd_table', 'SUB_AGENCY_CONTRACT_DOCUMENT');
							$('.subAgencyContractDocumentFileDown').data('id_pks', id_pks);
							$('.subAgencyContractDocumentFileDown').show();
						}
						
						$('#SAGC_NOTE').val(subAgencyDetail.SAGC_NOTE);
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
					<span class="nav">연계실습기관</span>
					<span class="nav">변경이력 상세</span>
				</div>
				<div class="sub_box">
					<div class="sub_menu">
						<div class="sub_title">교육기관</div>
						<div class="sub_list">
							<ul>
								<li><a href="">기관정보</a></li>
								<li><a href="">교수요원</a></li>
								<li class="sub_on"><a href="">연계실습기관</a></li>
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
										<col width="400px"/>
										<col width="160px"/>
										<col width="200px"/>
									</colgroup>
									<tr>
										<td class="t_head over_hide pdt5">
											<span class="star">*</span>시설구분
										</td>
										<td class="pdl15 pdr15">
											<select class="tbl_select wd150" id="CD_FACILITY_LEV1" name="CD_FACILITY_LEV1">
											</select>
											<select class="tbl_select wd210" id="CD_FACILITY_LEV2" name="CD_FACILITY_LEV2">
											</select>
										</td>
										<td class="t_head">
											<span class="star">*</span>시설명
										</td>
										<td class="pdl15 pdr5">
											<input type="text" class="tbl_input" id="SAGC_NAME" name="SAGC_NAME"/>
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
										<td class="t_head over_hide pdt5">
											<span class="star">*</span>우편번호
										</td>
										<td class="pdl15 pdr15">
											<input type="text" class="tbl_input" id="SAGC_ZIP" name="SAGC_ZIP" maxLength="5"/>
										</td>
										<td class="t_head">
											<span class="star">*</span>설치신고일
										</td >
										<td class="pdl15 pdr5">
											<input type="date" class="tbl_date" id="INSTALL_DATE" name="INSTALL_DATE"/>
										</td>
									</tr>
									<tr>
										<td class="t_head over_hide pdt5"><span class="star">*</span>소재지 주소(도로명)</td>
										<td class="pdl15 pdr15">
											<input type="text" class="tbl_input" id="SAGC_ADDRESS" name="SAGC_ADDRESS"/>
										</td>
										<td class="t_head">최초신청일자</td>
										<td id="REQUEST_DATE"><!-- 2020년 10월 01일 --></td>
									</tr>
									<tr>
										<td class="t_head over_hide pdt5"><span class="star">*</span>시설장</td>
										<td class="pdl15 pdr15">
											<input type="text" class="tbl_input" id="SAGC_BOSS_NAME" name="SAGC_BOSS_NAME"/>
										</td>
										<td class="t_head">최초승인일자</td>
										<td id="APPLY_DATE"></td>
									</tr>
									<tr>
										<td class="t_head over_hide pdt5"><span class="star">*</span>전화번호</td>
										<td class="pdl15 pdr15">
											<input type="text" class="tbl_input" id="SAGC_BOSS_TEL" name="SAGC_BOSS_TEL"/>
										</td>
										<td class="t_head">최종승인일자</td>
										<td id="FINAL_APL_DATE"></td>
									</tr>
									<tr>
										<td class="t_head over_hide pdt5"><span class="star">*</span>실습계약기간</td>
										<td class="pdl15 pdr15">
											<input type="date" class="tbl_date wd170" id="CONTRACT_BEGIN_DATE" name="CONTRACT_BEGIN_DATE"/> ~ <input type="date" class="tbl_date wd170" id="CONTRACT_END_DATE" name="CONTRACT_END_DATE"/>
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
							<div class="con_title">시설용량 및 평가정보</div>
							<div class="con_form">
								<table class="tbl_ty1">
									<colgroup>
										<col width="160px"/>
										<col width="295px"/>
										<col width="160px"/>
										<col width="295px"/>
									</colgroup>
									<tr>
										<td class="t_head">
											입소자 정원
										</td>
										<td class="pdl15 pdr15">
											<input type="text" class="tbl_input wd245" id="MEMBER_TOTAL_COUNT" name="MEMBER_TOTAL_COUNT"/> 명
										</td>
										<td class="t_head">평가등급</td>
										<td class="pdl15 pdr15">
											<select class="tbl_select" id="EVALUATION_RANK" name="EVALUATION_RANK">
												<option value="A">A</option>
												<option value="B">B</option>
												<option value="C">C</option>
												<option value="D">D</option>
												<option value="E">E</option>
												<option value="">신설</option>
											</select>
										</td>
									</tr>
									<tr>
										<td class="t_head">
											입소자 현원
										</td>
										<td class="pdl15 pdr15">
											<input type="text" class="tbl_input wd245" id="MEMBER_CURRENT_COUNT" name="MEMBER_CURRENT_COUNT"> 명
										</td>
										<td class="t_head">
											등급판정년도
										</td>
										<td class="pdl15 pdr15 evaluationYear">
											<input type="text" class="tbl_input wd245" id="EVALUATION_YEAR" name="EVALUATION_YEAR" maxLength="4"/> 년
										</td>
									</tr>
									<tr>
										<td class="t_head">
											실습 총 인원
										</td>
										<td class="pdl15 pdr15">
											<input type="text" class="tbl_input wd245" id="STUDENT_TOTAL_COUNT" name="STUDENT_TOTAL_COUNT"/> 명
										</td>
										<td class="t_head">
											1일 실습 인원
										</td>
										<td class="pdl15 pdr15">
											<input type="text" class="tbl_input wd245" id="STUDENT_DAILY_COUNT" name="STUDENT_DAILY_COUNT"/> 명
										</td>
									</tr>
									<tr>
										<td class="t_head">
											1일 실습비(1인당)
										</td>
										<td class="pdl15 pdr15" colspan="3">
											<input type="text" class="tbl_input wd245" id="STUDENT_DAILY_COST" name="STUDENT_DAILY_COST"/> 명
										</td>
									</tr>
									
								</table>
							</div>
						</div>
						<!--conBox end-->
						
						<!--conBox-->
						<div class="conBox">
							<div class="con_title">첨부서류<a href="javascript:void(0);" style="diplay:none;" class="title_btn wd160 mgr5 getFilesDown subAgencyContractDocumentFileDown">첨부서류 전체 다운로드</a></div>
							<div class="con_form mgt10">
								<table class="tbl_ty3" id="subAgencyContractDocumentList">
									<colgroup>
										<col width="110px"/>
										<col width="145px"/>
										<col width="180px"/>
										<col width="425px"/>
									</colgroup>
									<tr class="filter">
										<td>순번</td>
										<td>구분</td>
										<td>첨부파일</td>
										<td>설명</td>
									</tr>
									<tr class="none"><td colspan="4">등록된 데이터가 없습니다.</td></tr>
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
											<textarea class="tbl_area" id="SAGC_NOTE" name="SAGC_NOTE"></textarea>
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
