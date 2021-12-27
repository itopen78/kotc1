<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
	<c:import url="/inc/assets_base.jsp" />
	
	<script type="text/javascript">
	$(document).ready(function() {
		getSubAgencyDeatil();
		
		$('#EVALUATION_RANK').on('change', function() {
			if($(this).val() == '') {
				$('.evaluationYear').hide();
				$('#EVALUATION_YEAR').val('');
			} else {
				$('.evaluationYear').show();
			}
		});
		
		$('#CD_FACILITY_LEV1').on('change', function() {
			var CD_MIDDLE = $(this).val();
			var params = {
					'class' : 'commonMapper',
					'method' : 'getCommonListByBottom',
					'param' : {'CD_TOP' : '6', 'CD_MIDDLE' : CD_MIDDLE},
					'callback' : function(data){
						if(data.success){
							loadingStop();
							$('#CD_FACILITY_LEV2').empty();
							$.each(data.list, function(i, item) {
								$('#CD_FACILITY_LEV2').append('<option value="'+item.CODE+'">'+item.NAME+'</>');
							});
						}
					}
			};
			apiCall(params);
		});
		
		/********************************************************
		* 첨부서류
		********************************************************/
		$('#subAgencyContractDocumentList').on('change', 'input[name=subAgencyContractDocumentFiles]', function() {
			var fileNo = $(this).closest('tr.items').data('file_no');
			var fileName = '';
			if($(this)[0].files.length > 0) {
				fileName = $(this)[0].files[0].name;
			}
			$('#subAgencyContractDocumentList #subAgencyContractDocumentFiles_text_'+fileNo).text(fileName);
		});
		
		$('#frm').on('click', '.addSubAgencyContractDocument', function() {
			$('#subAgencyContractDocumentList .none').remove();
			
			var fileNo = 1;
			if($('#subAgencyContractDocumentList tr.items').length > 0) {
				$('#subAgencyContractDocumentList tr.items').each(function() {
					if(fileNo < parseInt($(this).data('file_no'))) {
						fileNo = parseInt($(this).data('file_no'));
					}
				});
				fileNo += 1;
			}
			
			var _html = '';
			_html += '<tr class="items" data-cont_doc_id="" data-file_no="'+fileNo+'">'
				_html += '<input type="hidden" name="CONT_DOC_ID" value=""/>'
				_html += '<td class="no"></td>'
				_html += '<td>'
					_html += '<select class="tbl_select" name="CD_CONT_DOC_TYPE">'
						_html += '<option value="1">계약서</option>'
						_html += '<option value="2">시설설치신고필증</option>'
						_html += '<option value="3">등급판정서</option>'
						_html += '<option value="4">기타</option>'
					_html += '</select>'
				_html += '</td>'
				_html += '<td>'
					_html += '<ul class="file_form">'
						_html += '<li>'
							_html += '<div class="file_box">'
								_html += '<input type="text" readonly onclick="$(\'#subAgencyContractDocumentFiles_'+fileNo+'\').trigger(\'click\')" />'
								_html += '<input type="file" name="subAgencyContractDocumentFiles" id="subAgencyContractDocumentFiles_'+fileNo+'"/>'
							_html += '</div>'
						_html += '</li>'
						_html += '<li class="filesText" id="subAgencyContractDocumentFiles_text_'+fileNo+'"></li>'
					_html += '</ul>'
				_html += '</td>'
				_html += '<td>'
					_html += '<input type="text" class="tbl_input" name="CONT_DOC_NOTE" />'
				_html += '</td>'
				_html += '<td><div class="delete_icon removeSubAgencyContractDocument" data-cont_doc_id=""></div></td>'
			_html += '</tr>'
		
			$('#subAgencyContractDocumentList .filter').after(_html);
			
			$('#subAgencyContractDocumentList tr.items:visible').each(function(i) {
				$(this).find('.no').text((i+1));
			});
		});
		
		$('#subAgencyContractDocumentList').on('click', '.removeSubAgencyContractDocument', function() {
			var CONT_DOC_ID = $(this).data('cont_doc_id');
			if(CONT_DOC_ID != null && CONT_DOC_ID != '') {
				$(this).closest('tr.items').hide();
			} else {
				$(this).closest('tr.items').remove();
			}
			
			$('#subAgencyContractDocumentList tr.items:visible').each(function(i) {
				$(this).find('.no').text((i+1));
			});
			
			if($('#subAgencyContractDocumentList tr.items:visible').length <= 0) {
				$('#subAgencyContractDocumentList .filter').after('<tr class="none"><td colspan="5">등록된 데이터가 없습니다.</td></tr>');
			}
		});
		
		$('.saveSubAgency').on('click', function() {
			if($('#CD_FACILITY_LEV1').val() == '') {
				alert('시설구분(대)를 선택하세요.');
				$('#CD_FACILITY_LEV1').focus();
				return false;
			}
			
			if($('#CD_FACILITY_LEV2').val() == '') {
				alert('시설구분(중)를 선택하세요.');
				$('#CD_FACILITY_LEV2').focus();
				return false;
			}
			
			if($('#SAGC_NAME').val() == '') {
				alert('시설명을 입력하세요.');
				$('#SAGC_NAME').focus();
				return false;
			}
			
			if($('#SAGC_ZIP').val() == '') {
				alert('우편번호를 입력하세요.');
				$('#SAGC_ZIP').focus();
				return false;
			}
			
			if($('#SAGC_ADDRESS').val() == '') {
				alert('소재주 주소(도로명)를 입력하세요.');
				$('#SAGC_ADDRESS').focus();
				return false;
			}
			
			if($('#SAGC_BOSS_NAME').val() == '') {
				alert('시설장을 입력하세요.');
				$('#SAGC_BOSS_NAME').focus();
				return false;
			}
			
			if($('#SAGC_BOSS_TEL').val() == '') {
				alert('전화번호를 입력하세요.');
				$('#SAGC_BOSS_TEL').focus();
				return false;
			}
			
			if($('#CONTRACT_BEGIN_DATE').val() == '') {
				alert('실습계약기간(시작일)을 선택하세요.');
				$('#CONTRACT_BEGIN_DATE').focus();
				return false;
			}
			
			if($('#CONTRACT_END_DATE').val() == '') {
				alert('실습계약기간(종료일)을 선택하세요.');
				$('#CONTRACT_END_DATE').focus();
				return false;
			}
			
			var startDate = $('#CONTRACT_BEGIN_DATE').val();
	        var startDateArr = startDate.split('-');
	         
	        var endDate = $('#CONTRACT_END_DATE').val();
	        var endDateArr = endDate.split('-');
	                 
	        var startDateCompare = new Date(startDateArr[0], parseInt(startDateArr[1])-1, startDateArr[2]);
	        var endDateCompare = new Date(endDateArr[0], parseInt(endDateArr[1])-1, endDateArr[2]);
	         
	        if(startDateCompare.getTime() > endDateCompare.getTime()) {
	            alert("시작날짜와 종료날짜를 확인해 주세요.");
	            return;
	        }
			
			if(!confirm("신청하시겠습니까?")) {
				return false;
			}
			
			$('#frm input[name=contDocIds]').remove();

			//첨부서류 삭제데이터 생성 및 hide 데이터 삭제
			$('#subAgencyContractDocumentList tr.items:not(:visible)').each(function(i) {
				$('#frm').append('<input type="hidden" name="contDocIds" value="'+$(this).data('cont_doc_id')+'"/>');
			});
			$('#subAgencyContractDocumentList tr.items:not(:visible)').remove(); //hide 데이터 삭제
			
			if($('#SAGC_ID').val() == null || $('#SAGC_ID').val() == '') {
				$('#CD_ADD_STATE').val('1');
			} else {
				if($('#CD_ADD_STATE').val() == '3') { //등록 승인 상태
					//클릭 버튼에 의해 변경 상태 신청
					$('#CD_CHNG_STATE').val('1');
				} else {
					//클릭 버튼에 의해 변경 상태 변경
					$('#CD_ADD_STATE').val('1');
				}
			}
			
			var formData = new FormData($('#frm')[0]);
			
			$.ajax({
	            url : '/edu/subAgencySave',
	            dataType : "json",
	            cache : false,
	            processData : false,
	            contentType : false,
	            type : "post",
	            data : formData,
	            beforeSend: function(xhr) {
	                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
	            },
	            success: function(data) {
	            	if(data.success) {
	            		alert('신청되었습니다.');
	            		location.href='/edu/subAgencyList';
	            	}
	            },
	            error:function(request,status,error){
	                alert("code : " + request.status + "\n" + "error:" + error);
	            }
	        });
		});
	});
		
	function getSubAgencyDeatil() {
		if($('#SAGC_ID').val() == null || $('#SAGC_ID').val() == '') {
			return false;
		}
		
		var params = {
				'class' : 'service.EduService',
				'method' : 'getSubAgencyDetail',
				'param' : {'SAGC_ID' : $('#SAGC_ID').val()},
				'callback' : function(data){
					if(data.success){
						loadingStop();
						var subAgencyDetail = data.subAgencyDetail;
						var subAgencyContractDocumentList = data.subAgencyContractDocumentList;
						
						$('#CD_ADD_STATE').val(subAgencyDetail.CD_ADD_STATE);
						$('#CD_CHNG_STATE').val(subAgencyDetail.CD_CHNG_STATE);
						$('#CD_FACILITY_LEV1').val(subAgencyDetail.CD_FACILITY_LEV1);
						$('#CD_FACILITY_LEV2').val(subAgencyDetail.CD_FACILITY_LEV2);
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
											_html += '<li>'
												_html += '<div class="file_box">'
													_html += '<input type="text" readonly onclick="$(\'#subAgencyContractDocumentFiles_'+fileNo+'\').trigger(\'click\')" />'
													_html += '<input type="file" name="subAgencyContractDocumentFiles" id="subAgencyContractDocumentFiles_'+fileNo+'"/>'
												_html += '</div>'
											_html += '</li>'
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
									_html += '<td><div class="delete_icon removeSubAgencyContractDocument" data-cont_doc_id="'+item.CONT_DOC_ID+'"></div></td>'
								_html += '</tr>'
							});
							$('#subAgencyContractDocumentList .filter').after(_html);
							
							$('.subAgencyContractDocumentFileDown').data('cd_table', 'SUB_AGENCY_CONTRACT_DOCUMENT');
							$('.subAgencyContractDocumentFileDown').data('id_pks', id_pks);
							$('.subAgencyContractDocumentFileDown').show();
						}
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
					<span class="nav">연계실습기관 상세</span>
				</div>
				<div class="sub_box">
					<div class="sub_menu">
						<div class="sub_title">교육기관</div>
						<div class="sub_list">
							<ul>
								<li><a href="">기관정보</a></li>
								<li ><a href="">교수요원</a></li>
								<li class="sub_on"><a href="">연계실습기관</a></li>
								<li><a href="">실습지도자</a></li>
								<li><a href="">교육생</a></li>
								<li><a href="">자체점검</a></li>
							</ul>
						</div>
					</div>
					<div class="sub_con">
						<!--conBox-->
						<form id="frm" name="frm" method="post" enctype="multipart/form-data">
						<input type="hidden" name="SAGC_ID" id="SAGC_ID" value="${SAGC_ID}"/>
						<input type="hidden" name="CD_ADD_STATE" id="CD_ADD_STATE" value=""/>
						<input type="hidden" name="CD_CHNG_STATE" id="CD_CHNG_STATE" value=""/>
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
												<c:forEach var="item" items="${cdFacilityLev1List}">
													<option value="${item.CODE}">${item.NAME}</option>
												</c:forEach>
											</select>
											<select class="tbl_select wd210" id="CD_FACILITY_LEV2" name="CD_FACILITY_LEV2">
												<c:forEach var="item" items="${cdFacilityLev2List}">
													<option value="${item.CODE}">${item.NAME}</option>
												</c:forEach>
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
											<input type="text" class="tbl_input" id="SAGC_BOSS_NAME" name="SAGC_BOSS_NAME" />
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
							<div class="con_title">첨부서류<a href="javascript:void(0);" class="title_btn wd115 addSubAgencyContractDocument">첨부서류 추가</a><a href="javascript:void(0);" style="diplay:none;" class="title_btn wd160 mgr5 getFilesDown subAgencyContractDocumentFileDown">첨부서류 전체 다운로드</a></div>
							<div class="con_form mgt10">
								<table class="tbl_ty3" id="subAgencyContractDocumentList">
									<colgroup>
										<col width="110px"/>
										<col width="145px"/>
										<col width="180px"/>
										<col width="425px"/>
										<col width="110px"/>
									</colgroup>
									<tr class="filter">
										<td>순번</td>
										<td>구분</td>
										<td>첨부파일</td>
										<td>설명</td>
										<td>삭제</td>
									</tr>
									<tr class="none"><td colspan="5">등록된 데이터가 없습니다.</td></tr>
								</table>
								
								<div class="btn_box mgt15"><a href="javascript:void(0);" class="btn_center wd115 addSubAgencyContractDocument">첨부서류 추가</a></div>
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
						</form>
						<div class="main_btn">
							<ul>
								<li class="page_back mgr5"><a href="javascript:history.back();">취소</a></li>
								<li class="page_ok"><a href="javascript:void(0);" class="saveSubAgency">신청</a></li>
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