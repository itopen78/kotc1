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
	$(document).ready(function() {
		getSubAgentDeatil();
		
		//자격 리스트
		$('#subAgentLicenseList').on('change', 'input[name=subAgentLicenseFiles]', function() {
			var fileNo = $(this).closest('tr.items').data('file_no');
			var fileName = '';
			if($(this)[0].files.length > 0) {
				fileName = $(this)[0].files[0].name;
			}
			$('#subAgentLicenseList #subAgentLicenseFiles_text_'+fileNo).text(fileName);
		});
		
		
		$('.addSubAgentLicense').on('click', function() {
			$('#subAgentLicenseList .none').remove();

			var fileNo = 1;
			if($('#subAgentLicenseList tr.items').length > 0) {
				$('#subAgentLicenseList tr.items').each(function() {
					if(fileNo < parseInt($(this).data('file_no'))) {
						fileNo = parseInt($(this).data('file_no'));
					}
				});
				fileNo += 1;
			}
			
			var _html = '';
			_html += '<tr class="items" data-worker_id="" data-file_no="'+fileNo+'">'
				_html += '<input type="hidden" name="LCNS_ID" value=""/>'
				_html += '<td class="no"></td>'
				_html += '<td><input type="text" class="tbl_input" id="LCNS_NAME" name="LCNS_NAME"/></td>'
				_html += '<td>'
					_html += '<ul class="file_form">'
						_html += '<li>'
							_html += '<div class="file_box">'
								_html += '<input type="text" readonly onclick="$(\'#subAgentLicenseFiles_'+fileNo+'\').trigger(\'click\')" />'
								_html += '<input type="file" name="subAgentLicenseFiles" id="subAgentLicenseFiles_'+fileNo+'"/>'
							_html += '</div>'
						_html += '</li>'
						_html += '<li class="filesText" id="subAgentLicenseFiles_text_'+fileNo+'"></li>'
					_html += '</ul>'
				_html += '</td>'
				_html += '<td><input type="date" class="tbl_input" name="LCNS_OBTAIN_DATE" /></td>'
				_html += '<td class="t_left pd120"><input type="text" class="tbl_input" name="LCNS_NOTE" value=""/></td>'
				_html += '<td><div class="delete_icon removeSubAgentLicense" data-lcns_id=""></div></td>'
			_html += '</tr>'
			
			$('#subAgentLicenseList .filter').after(_html);
			
			$('#subAgentLicenseList tr.items:visible').each(function(i) {
				$(this).find('.no').text((i+1));
			});
		});
		
		$('#subAgentLicenseList').on('click', '.removeSubAgentLicense', function() {
			var LCNS_ID = $(this).data('lcns_id');
			if(LCNS_ID != null && LCNS_ID != '') {
				$(this).closest('tr.items').hide();
			} else {
				$(this).closest('tr.items').remove();
			}
			
			$('#subAgentLicenseList tr.items:visible').each(function(i) {
				$(this).find('.no').text((i+1));
			});
			
			if($('#subAgentLicenseList tr.items:visible').length <= 0) {
				$('#subAgentLicenseList .filter').after('<tr class="none"><td colspan="6">등록된 데이터가 없습니다.</td></tr>');
			}
		});
		
		//경력 리스트
		$('#subAgentCareerList').on('change', 'input[name=subAgentCareerFiles]', function() {
			var fileNo = $(this).closest('tr.items').data('file_no');
			var fileName = '';
			if($(this)[0].files.length > 0) {
				fileName = $(this)[0].files[0].name;
			}
			$('#subAgentCareerList #subAgentCareerFiles_text_'+fileNo).text(fileName);
		});
		
		$('.addSubAgentCareer').on('click', function() {
			$('#subAgentCareerList .none').remove();
			
			var fileNo = 1;
			if($('#subAgentCareerList tr.items').length > 0) {
				$('#subAgentCareerList tr.items').each(function() {
					if(fileNo < parseInt($(this).data('file_no'))) {
						fileNo = parseInt($(this).data('file_no'));
					}
				});
				fileNo += 1;
			}
			
			var _html = '';
			_html += '<tr class="items" data-crr_id="" data-file_no="'+fileNo+'">'
				_html += '<input type="hidden" name="CRR_ID" value=""/>'
				_html += '<td class="no"></td>'
				_html += '<td><input type="text" class="tbl_input" name="CRR_NAME" /></td>'
				_html += '<td>'
					_html += '<ul class="file_form">'
						_html += '<li>'
							_html += '<div class="file_box">'
								_html += '<input type="text" readonly onclick="$(\'#subAgentCareerFiles_'+fileNo+'\').trigger(\'click\')" />'
								_html += '<input type="file" name="subAgentCareerFiles" id="subAgentCareerFiles_'+fileNo+'"/>'
							_html += '</div>'
						_html += '</li>'
						_html += '<li class="filesText" id="subAgentCareerFiles_text_'+fileNo+'"></li>'
					_html += '</ul>'
				_html += '</td>'
				_html += '<td><input type="date" class="tbl_input wd150" name="CRR_BEGIN_DATE" />~<input type="date" class="tbl_input wd150" name="CRR_END_DATE" /></td>'
				_html += '<td class=""><input type="text" class="tbl_input" name="CRR_NOTE"/></td>'
				_html += '<td><div class="delete_icon removeSubAgentCareer" data-crr_id=""></div></td>'
			_html += '</tr>'
			
			$('#subAgentCareerList .filter').after(_html);
			
			$('#subAgentCareerList tr.items:visible').each(function(i) {
				$(this).find('.no').text((i+1));
			});
		});
		
		$('#subAgentCareerList').on('click', '.removeSubAgentCareer', function() {
			var CRR_ID = $(this).data('crr_id');
			if(CRR_ID != null && CRR_ID != '') {
				$(this).closest('tr.items').hide();
			} else {
				$(this).closest('tr.items').remove();
			}
			
			$('#subAgentCareerList tr.items:visible').each(function(i) {
				$(this).find('.no').text((i+1));
			});
			
			if($('#subAgentCareerList tr.items:visible').length <= 0) {
				$('#subAgentCareerList .filter').after('<tr class="none"><td colspan="6">등록된 데이터가 없습니다.</td></tr>');
			}
		});
		
		/********************************************************
		* 저장
		********************************************************/
		$('.saveSubAgent').on('click', function() {
			if($('#SAGT_NAME').val() == '') {
				alert('성명을 입력해주세요.');
				$('#SAGT_NAME').focus();
				return false;	
			}
			
			if($('#SAGT_BIRTHDAY').val() == '') {
				alert('생년월일 입력해주세요.');
				$('#SAGT_BIRTHDAY').focus();
				return false;	
			}
			
			if($('#SAGT_TEL').val() == '') {
				alert('연락처를 입력해주세요.');
				$('#SAGT_TEL').focus();
				return false;	
			}
		
			/********************************************************
			* 자격사항 유효성 검사
			********************************************************/
			var LCNS_NAME_FLAG = true;
			var LCNS_FILE_FLAG = true;
			var LCNS_OBTAIN_DATE_FLAG = true;
			$('#subAgentLicenseList tr.items:visible').each(function() {
				if($(this).find('input[name=LCNS_NAME]').val() == '') {
					LCNS_NAME_FLAG = false;
				}
				if($(this).find('.filesText').text() == null || $(this).find('.filesText').text() == '') {
					LCNS_FILE_FLAG = false;
				}
				if($(this).find('input[name=LCNS_OBTAIN_DATE]').val() == '') {
					LCNS_OBTAIN_DATE_FLAG = false;
				}
			});
			
			if(!LCNS_NAME_FLAG) {
				alert('자격사항을 입력해주세요.');
				return false;	
			}
			
			if(!LCNS_FILE_FLAG) {
				alert('자격사항 첨부파일을 등록해주세요.');
				return false;	
			}
			
			if(!LCNS_OBTAIN_DATE_FLAG) {
				alert('자격 취득일을 선택해주세요.');
				return false;	
			}

			/********************************************************
			* 경력사항 유효성 검사
			********************************************************/
			var CRR_NAME_FLAG = true;
			var CRR_FILE_FLAG = true;
			var CRR_DATE_FLAG = true;
			$('#subAgentCareerList tr.items:visible').each(function() {
				if($(this).find('input[name=CRR_NAME]').val() == '') {
					CRR_NAME_FLAG = false;
				}
				if($(this).find('.filesText').text() == null || $(this).find('.filesText').text() == '') {
					CRR_FILE_FLAG = false;
				}
				if($(this).find('input[name=CRR_BEGIN_DATE]').val() == '' || $(this).find('input[name=CRR_END_DATE]').val() == '') {
					CRR_DATE_FLAG = false;
				}
			});
			
			if(!CRR_NAME_FLAG) {
				alert('경력사항을 입력해주세요.');
				return false;	
			}
			
			if(!CRR_FILE_FLAG) {
				alert('경력사항 첨부파일을 등록해주세요.');
				return false;	
			}
			
			if(!CRR_DATE_FLAG) {
				alert('경력일을 선택해주세요.');
				return false;	
			}
			
			//자격사항 삭제데이터 생성 및 삭제
			$('#subAgentLicenseList tr.items:not(:visible)').each(function(i) {
				$('#frm').append('<input type="hidden" name="lcnsIds" value="'+$(this).data('lcns_id')+'"/>');
			});
			$('#subAgentLicenseList tr.items:not(:visible)').remove(); //hide 데이터 삭제
			
			//경력사항 삭제데이터 생성 및 삭제
			$('#subAgentCareerList tr.items:not(:visible)').each(function(i) {
				$('#frm').append('<input type="hidden" name="crrIds" value="'+$(this).data('crr_id')+'"/>');
			});
			$('#subAgentCareerList tr.items:not(:visible)').remove(); //hide 데이터 삭제
			
			if($('#SAGT_ID').val() == null || $('#SAGT_ID').val() == '') {
				$('#CD_ADD_STATE').val('1');
			} else {
				//등록상태, 변경상태
				if($('#CD_ADD_STATE').val() == '3') {
					$('#CD_CHNG_STATE').val('1');
				}else {
					$('#CD_CHNG_STATE').val('1');
				}
			}

			var formData = new FormData($('#frm')[0]);
			
			$.ajax({
	            url : '/edu/saveSubAgent',
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
	            		alert('저장되었습니다.');
	            		location.href='/edu/subAgentList';
	            	}
	            },
	            error:function(request,status,error){
	                alert("code : " + request.status + "\n" + "error:" + error);
	            }
	        });
		});	
	});
		
 	function getSubAgentDeatil() {
		if($('#SAGT_ID').val() == null || $('#SAGT_ID').val() == '') {
			return false;
		}
		
		var params = {
			'class' : 'service.EduService',
			'method' : 'getSubAgentDetail',
			'param' : {'SAGT_ID' : $('#SAGT_ID').val()},
			'callback' : function(data){
				
				console.log(data);
				
				if(data.success){
					loadingStop();
					var subAgentDetail = data.subAgentDetail;	//실습지도자 조회
					var subAgentLicenseList = data.subAgentLicenseList; //자격사항 목록 조회
					var subAgentCareerList = data.subAgentCareerList; //경력사항 목록 조회
					
					//기본 정보
					$('#CD_SAGT_TYPE').val(subAgentDetail.CD_SAGT_TYPE);
					$('#SAGT_NAME').val(subAgentDetail.SAGT_NAME);
					$('#SAGT_BIRTHDAY').val(subAgentDetail.SAGT_BIRTHDAY);
					$('#SAGT_TEL').val(subAgentDetail.SAGT_TEL);
					$('#REQUEST_DATE').text(subAgentDetail.REQUEST_DATE);
					$('#APPLY_DATE').text(subAgentDetail.APPLY_DATE);
					$('#FINAL_APL_DATE').text(subAgentDetail.FINAL_APL_DATE);
					$('#CD_ADD_STATE').val(subAgentDetail.CD_ADD_STATE);
					$('#CD_CHNG_STATE').val(subAgentDetail.CD_CHNG_STATE);
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
										_html += '<li>'
											_html += '<div class="file_box">'
												_html += '<input type="text" readonly onclick="$(\'subAgentLicenseFiles_'+fileNo+'\').trigger(\'click\')" />'
												_html += '<input type="file" name="subAgentLicenseFiles" id="subAgentLicenseFiles_'+fileNo+'"/>'
											_html += '</div>'
										_html += '</li>'
										_html += '<li class="filesText" id="subAgentLicenseFiles_text_'+fileNo+'">'
											if(item.ID_PK != null && item.ID_PK != '') {
												_html += '<a href="javascript:void(0);" class="file_down getFileDown" data-original_file_name="'+item.ORIGINAL_FILE_NAME+'" data-server_file_name="'+item.SERVER_FILE_NAME+'">'+item.ORIGINAL_FILE_NAME+'</a>'
											}
										_html += '</li>'
									_html += '</ul>'
								_html += '</td>'
								_html += '<td><input type="date" class="tbl_date" name="LCNS_OBTAIN_DATE" value="'+item.LCNS_OBTAIN_DATE+'"/></td>'
								_html += '<td class="t_left pdl20"><input type="text" class="tbl_input" name="LCNS_NOTE" value="'+item.LCNS_NOTE+'"/></td>'
								_html += '<td><div class="delete_icon removeSubAgentLicense" data-lcns_id="'+item.LCNS_ID+'"></div></td>'
							_html += '</tr>'
						});
						$('#subAgentLicenseList .filter').after(_html);
						
						$('.subAgentLicenseFileDown').data('cd_table', 'SUB_AGENT_LICENSE');
						$('.subAgentLicenseFileDown').data('id_pks', id_pks);
						$('.subAgentLicenseFileDown').show();
						
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
											_html += '<li>'
												_html += '<div class="file_box">'
													_html += '<input type="text" readonly onclick="$(\'#subAgentCareerFiles_'+fileNo+'\').trigger(\'click\')" />'
													_html += '<input type="file" name="subAgentCareerFiles" id="subAgentCareerFiles_'+fileNo+'"/>'
												_html += '</div>'
											_html += '</li>'
											_html += '<li class="filesText" id="subAgentCareerFiles_text_'+fileNo+'">'
												if(item.ID_PK != null && item.ID_PK != '') {
													_html += '<a href="javascript:void(0);" class="file_down getFileDown" data-original_file_name="'+item.ORIGINAL_FILE_NAME+'" data-server_file_name="'+item.SERVER_FILE_NAME+'">'+item.ORIGINAL_FILE_NAME+'</a>'
												}
											_html += '</li>'
										_html += '</ul>'
									_html += '</td>'
									_html += '<td><input type="date" class="tbl_date wd150" name="CRR_BEGIN_DATE" value="'+item.CRR_BEGIN_DATE+'"/>~<input type="date" class="tbl_date wd150" name="CRR_END_DATE" value="'+item.CRR_END_DATE+'"/></td>'
									_html += '<td class="t_left pdl20"><input type="text" class="tbl_input" name="CRR_NOTE" value="'+item.CRR_NOTE+'"/></td>'
									_html += '<td><div class="delete_icon removeSubAgentCareer" data-crr_id="'+item.CRR_ID+'"></div></td>'
								_html += '</tr>'
							});
							$('#subAgentCareerList .filter').after(_html);
							
							$('.subAgentCareerFileDown').data('cd_table', 'SUB_AGENT_CAREER');
							$('.subAgentCareerFileDown').data('id_pks', id_pks);
							$('.subAgentCareerFileDown').show();
						}
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
						<form name="frm" id="frm" method="post" enctype="multipart/form-data">
							<input type="hidden" name="SAGT_ID" id="SAGT_ID" value="${SAGT_ID}"/>
							<input type="hidden" name="CD_ADD_STATE" id="CD_ADD_STATE" value=""/>
							<input type="hidden" name="CD_CHNG_STATE" id="CD_CHNG_STATE" value=""/>
							<div class="conBox">
								<div class="con_title">기본 정보</div>
								<div class="con_form">
									<table class="tbl_ty1">
										<colgroup>
											<col width="160px"/>
											<col width="320px"/>
											<col width="160px"/>
											<col width="320px"/>
										</colgroup>
										<tr>
											<td class="t_head">직무</td>
											<td class="pdl15 pdr15">
												<select class="tbl_select" id="CD_SAGT_TYPE" name="CD_SAGT_TYPE">
													<c:forEach items="${cdSagtTypeList}" var="item">
													<option value="${item.CODE}">${item.NAME}</option>
													</c:forEach>
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
								<a href="javascript:void(0);" class="title_btn wd115 addSubAgentLicense">자격사항 추가</a>
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
										<col width="110px"/>
									</colgroup>
									<tr class="filter">
										<td>순번</td>
										<td>자격사항</td>
										<td>첨부파일</td>
										<td>자격 취득일</td>
										<td>비고</td>
										<td>삭제</td>
									</tr>
									<tr class="none"><td colspan="6">등록된 데이터가 없습니다.</td></tr>
								</table>

								<div class="btn_box mgt15"><a href="javascript:void(0);" class="btn_center wd115 addSubAgentLicense">자격사항 추가</a></div>
							</div>
						</div>
						<!--conBox end-->
						
						<!--conBox-->
						<div class="conBox">
							<div class="con_title">
								경력사항 
								<a href="javascript:void(0);" class="title_btn wd115 addSubAgentCareer">경력사항 추가</a>
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
										<col width="110px"/>
									</colgroup>
									<tr class="filter">
										<td>순번</td>
										<td>경력사항</td>
										<td>첨부파일</td>
										<td>경력</td>
										<td>비고</td>
										<td>삭제</td>
									</tr>
									<tr class="none"><td colspan="6">등록된 데이터가 없습니다.</td></tr>
								</table>

								<div class="btn_box mgt15"><a href="javascript:void(0);" class="btn_center wd115 addSubAgentCareer">경력사항 추가</a></div>
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
						</form>
						<div class="main_btn">
							<ul>
								<li class="page_back mgr5"><a href="javascript:history.back();">취소</a></li>
								<li class="page_ok"><a href="javascript:void(0);" class="saveSubAgent">${empty SAGT_ID ? '등록' : '변경'} 신청</a></li>
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