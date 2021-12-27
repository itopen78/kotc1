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
		getAgentDetail();
		/********************************************************
		* 담당교육
		********************************************************/
		$('#agentClassList').on('change', 'select[name=CD_CLS_LEV1]', function() {
			var $items = $(this).closest('tr.items');
			var CD_MIDDLE = $(this).val();
			var params = {
					'class' : 'commonMapper',
					'method' : 'getCommonListByBottom',
					'param' : {'CD_TOP' : '4'
								, 'CD_MIDDLE' : CD_MIDDLE
					},
					'callback' : function(data){
						if(data.success){
							loadingStop();
							$items.find('select[name=CD_CLS_LEV2]').empty();
							var _html = '';
							$.each(data.list, function(index, item) {
								_html += '<option value="'+(item.CODE)+'">'+(item.NAME)+'</option>'
							});
							$items.find('select[name=CD_CLS_LEV2]').append(_html);
						}
					}
			};
			apiCall(params);
		});
		
		$('.addAgentClass').on('click', function() {
			var params = {
					'class' : 'service.CommonService',
					'method' : 'getAgentClassCdClsLev',
					'param' : {'CD_TOP' : '4'},
					'callback' : function(data){
						if(data.success){
							loadingStop();
							$('#agentClassList .none').remove();
							
							var _html = '';
							_html += '<tr class="items" data-cls_id="">'
								_html += '<input type="hidden" name="CLS_ID" value=""/>'
								_html += '<td class="no"></td>'
								_html += '<td>'
									_html += '<select class="tbl_select" name="CD_CLS_LEV1">'
									$.each(data.cdClasLev1List, function(index, item) {
										_html += '<option value="'+(item.CODE)+'">'+(item.NAME)+'</option>'
									});
									_html += '</select>'
								_html += '</td>'
								_html += '<td>'
									_html += '<select class="tbl_select" name="CD_CLS_LEV2">'
										$.each(data.cdClasLev2List, function(index, item) {
											_html += '<option value="'+(item.CODE)+'">'+(item.NAME)+'</option>'
										});
									_html += '</select>'
								_html += '</td>'
								_html += '<td><div class="delete_icon removeAgentClass" data-cls_id=""></div></td>'
							_html += '</tr>'
							
							$('#agentClassList .filter').after(_html);
							
							$('#agentClassList tr.items:visible').each(function(i) {
								$(this).find('.no').text((i+1));
							});
						}
					}
			};
			apiCall(params);
		});
		
		$('#agentClassList').on('click', '.removeAgentClass', function() {
			var CLS_ID = $(this).data('cls_id');
			if(CLS_ID != null && CLS_ID != '') {
				$(this).closest('tr.items').hide();
			} else {
				$(this).closest('tr.items').remove();
			}
			
			$('#agentClassList tr.items:visible').each(function(i) {
				$(this).find('.no').text((i+1));
			});
			
			if($('#agentClassList tr.items:visible').length <= 0) {
				$('#agentClassList .filter').after('<tr class="none"><td colspan="4">등록된 데이터가 없습니다.</td></tr>');
			}
		});
		
		/********************************************************
		* 자격사항
		********************************************************/
		$('#agentLicenseList').on('change', 'input[name=agentLicenseFiles]', function() {
			var fileNo = $(this).closest('tr.items').data('file_no');
			var fileName = '';
			if($(this)[0].files.length > 0) {
				fileName = $(this)[0].files[0].name;
			}
			$('#agentLicenseList #agentLicenseFiles_text_'+fileNo).text(fileName);
		});
		
		$('.addAgentLicense').on('click', function() {
			$('#agentLicenseList .none').remove();
			
			var fileNo = 1;
			if($('#agentLicenseList tr.items').length > 0) {
				$('#agentLicenseList tr.items').each(function() {
					if(fileNo < parseInt($(this).data('file_no'))) {
						fileNo = parseInt($(this).data('file_no'));
					}
				});
				fileNo += 1;
			}
			
			var _html = '';
			_html += '<tr class="items" data-lcns_id="" data-file_no="'+fileNo+'">'
				_html += '<input type="hidden" name="LCNS_ID" value=""/>'
				_html += '<td class="no"></td>'
				_html += '<td><input type="text" class="tbl_input" name="LCNS_NAME"/></td>'
				_html += '<td>'
					_html += '<ul class="file_form">'
						_html += '<li>'
							_html += '<div class="file_box">'
								_html += '<input type="text" readonly onclick="$(\'#agentLicenseFiles_'+fileNo+'\').trigger(\'click\')" />'
								_html += '<input type="file" name="agentLicenseFiles" id="agentLicenseFiles_'+fileNo+'"/>'
							_html += '</div>'
						_html += '</li>'
						//_html += '<li><a href="javascript:void(0);" class="file_down getFileDown">자격증.pdf</a></li>'
						_html += '<li class="filesText" id="agentLicenseFiles_text_'+fileNo+'"></li>'
					_html += '</ul>'
				_html += '</td>'
				_html += '<td><input type="date" class="tbl_date" name="LCNS_OBTAIN_DATE"/></td>'
				_html += '<td class="t_left pdl20"><input type="text" class="tbl_input" name="LCNS_NOTE" value=""/></td>'
				_html += '<td><div class="delete_icon removeAgentClass" data-lcns_id=""></div></td>'
			_html += '</tr>'
		
			$('#agentLicenseList .filter').after(_html);
			
			$('#agentLicenseList tr.items:visible').each(function(i) {
				$(this).find('.no').text((i+1));
			});
		});
		
		$('#agentLicenseList').on('click', '.removeAgentClass', function() {
			var LCNS_ID = $(this).data('lcns_id');
			if(LCNS_ID != null && LCNS_ID != '') {
				$(this).closest('tr.items').hide();
			} else {
				$(this).closest('tr.items').remove();
			}
			
			$('#agentLicenseList tr.items:visible').each(function(i) {
				$(this).find('.no').text((i+1));
			});
			
			if($('#agentLicenseList tr.items:visible').length <= 0) {
				$('#agentLicenseList .filter').after('<tr class="none"><td colspan="6">등록된 데이터가 없습니다.</td></tr>');
			}
		});
		
		/********************************************************
		* 경력사항
		********************************************************/
		$('#agentCareerList').on('change', 'input[name=agentCareerFiles]', function() {
			var fileNo = $(this).closest('tr.items').data('file_no');
			var fileName = '';
			if($(this)[0].files.length > 0) {
				fileName = $(this)[0].files[0].name;
			}
			$('#agentCareerList #agentCareerFiles_text_'+fileNo).text(fileName);
		});
		
		$('.addAgentCareer').on('click', function() {
			$('#agentCareerList .none').remove();
			
			var fileNo = 1;
			if($('#agentCareerList tr.items').length > 0) {
				$('#agentCareerList tr.items').each(function() {
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
				_html += '<td><input type="text" class="tbl_input" name="CRR_NAME"/></td>'
				_html += '<td>'
					_html += '<ul class="file_form">'
						_html += '<li>'
							_html += '<div class="file_box">'
								_html += '<input type="text" readonly onclick="$(\'#agentCareerFiles_'+fileNo+'\').trigger(\'click\')" />'
								_html += '<input type="file" name="agentCareerFiles" id="agentCareerFiles_'+fileNo+'"/>'
							_html += '</div>'
						_html += '</li>'
						//_html += '<li><a href="javascript:void(0);" class="file_down getFileDown">경력증명서.pdf</a></li>'
						_html += '<li class="filesText" id="agentCareerFiles_text_'+fileNo+'"></li>'
					_html += '</ul>'
				_html += '</td>'
				_html += '<td><input type="date" class="tbl_date wd150" name="CRR_BEGIN_DATE"/>~<input type="date" class="tbl_date wd150" name="CRR_END_DATE"/></td>'
				_html += '<td class="t_left pdl20"><input type="text" class="tbl_input" name="CRR_NOTE"/></td>'
				_html += '<td><div class="delete_icon removeAgentCareer" data-crr_id=""></div></td>'
			_html += '</tr>'
		
			$('#agentCareerList .filter').after(_html);
			
			$('#agentCareerList tr.items:visible').each(function(i) {
				$(this).find('.no').text((i+1));
			});
		});
		

		$('#agentCareerList').on('click', '.removeAgentCareer', function() {
			var CRR_ID = $(this).data('crr_id');
			if(CRR_ID != null && CRR_ID != '') {
				$(this).closest('tr.items').hide();
			} else {
				$(this).closest('tr.items').remove();
			}
			
			$('#agentCareerList tr.items:visible').each(function(i) {
				$(this).find('.no').text((i+1));
			});
			
			if($('#agentCareerList tr.items:visible').length <= 0) {
				$('#agentCareerList .filter').after('<tr class="none"><td colspan="6">등록된 데이터가 없습니다.</td></tr>');
			}
		});
		
		/********************************************************
		* 타 기관 출강여부
		********************************************************/
		$('.addAgentOutsideLecture').on('click', function() {
			$('#agentOutsideLectureList .none').remove();
			
			var _html = '';
			_html += '<tr class="items" data-lctr_id="">'
				_html += '<input type="hidden" name="LCTR_ID" value=""/>'
				_html += '<td class="no"></td>'
				_html += '<td><input type="text" class="tbl_input" name="LCTR_NAME"/></td>'
				_html += '<td><input type="text" class="tbl_input" name="LCTR_NOTE"/></td>'
				_html += '<td><div class="delete_icon removeAgentOutsideLecture" data-lctr_id=""></div></td>'
			_html += '</tr>'
		
			$('#agentOutsideLectureList .filter').after(_html);
			
			$('#agentOutsideLectureList tr.items:visible').each(function(i) {
				$(this).find('.no').text((i+1));
			});
		});

		$('#agentOutsideLectureList').on('click', '.removeAgentOutsideLecture', function() {
			var LCTR_ID = $(this).data('lctr_id');
			if(LCTR_ID != null && LCTR_ID != '') {
				$(this).closest('tr.items').hide();
			} else {
				$(this).closest('tr.items').remove();
			}
			
			$('#agentOutsideLectureList tr.items:visible').each(function(i) {
				$(this).find('.no').text((i+1));
			});
			
			if($('#agentOutsideLectureList tr.items:visible').length <= 0) {
				$('#agentOutsideLectureList .filter').after('<tr class="none"><td colspan="6">등록된 데이터가 없습니다.</td></tr>');
			}
		});
		
		/********************************************************
		* 저장
		********************************************************/
		$('.agentSave').on('click', function() {
			if($('#AGT_NAME').val() == '') {
				alert('성명을 입력해주세요.');
				$('#AGT_NAME').focus();
				return false;	
			}
			
			if($('#AGT_BIRTHDAY').val() == '') {
				alert('생년월일 입력해주세요.');
				$('#AGT_BIRTHDAY').focus();
				return false;	
			}
			
			if($('#AGT_TEL').val() == '') {
				alert('연락처를 입력해주세요.');
				$('#AGT_TEL').focus();
				return false;	
			}
			
			/********************************************************
			* 자격사항 유효성 검사
			********************************************************/
			var LCNS_NAME_FLAG = true;
			var LCNS_FILE_FLAG = true;
			var LCNS_OBTAIN_DATE_FLAG = true;
			$('#agentLicenseList tr.items:visible').each(function() {
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
			$('#agentCareerList tr.items:visible').each(function() {
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
			

			/********************************************************
			* 타 기관 출강여부 유효성 검사
			********************************************************/
			var LCTR_NAME_FLAG = true;
			if($('#agentOutsideLectureList tr.items:visible').length <= 0) {
				if($(this).find('input[name=LCTR_NAME]').val() == '') {
					LCTR_NAME_FLAG = false;
				}
			}
			
			if(!LCTR_NAME_FLAG) {
				alert('타 기관명을 입력해주세요.');
				return false;	
			}
			
			if(!confirm('신청 하시겠습니까?')) {
				return false;
			}
			
			$('#frm input[name=clsIds]').remove();
			$('#frm input[name=lcnsIds]').remove();
			$('#frm input[name=crrIds]').remove();
			
			//담당교육 삭제데이터 생성 및 hide 데이터 삭제
			$('#agentClassList tr.items:not(:visible)').each(function(i) {
				$('#frm').append('<input type="hidden" name="clsIds" value="'+$(this).data('cls_id')+'"/>');
			});
			$('#agentClassList tr.items:not(:visible)').remove(); //hide 데이터 삭제
			
			//자격사항 삭제데이터 생성 및 삭제
			$('#agentLicenseList tr.items:not(:visible)').each(function(i) {
				$('#frm').append('<input type="hidden" name="lcnsIds" value="'+$(this).data('lcns_id')+'"/>');
			});
			$('#agentLicenseList tr.items:not(:visible)').remove(); //hide 데이터 삭제
			
			//경력사항 삭제데이터 생성 및 삭제
			$('#agentCareerList tr.items:not(:visible)').each(function(i) {
				$('#frm').append('<input type="hidden" name="crrIds" value="'+$(this).data('crr_id')+'"/>');
			});
			$('#agentCareerList tr.items:not(:visible)').remove(); //hide 데이터 삭제
			
			if($('#AGT_ID').val() == null || $('#AGT_ID').val() == '') {
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
	            url : '/edu/agentSave',
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
	            		location.href='/edu/agentList';
	            	}
	            },
	            error:function(request,status,error){
	                alert("code : " + request.status + "\n" + "error:" + error);
	            }
	        });
		});
    });
	
	function getAgentDetail() {
		if($('#AGT_ID').val() == null || $('#AGT_ID').val() == '') {
			return false;
		}
		
		var params = {
				'class' : 'service.EduService',
				'method' : 'getAgentDetail',
				'param' : {'AGT_ID' : $('#AGT_ID').val()},
				'callback' : function(data){
					if(data.success){
						loadingStop();
						var agentDetail = data.agentDetail;	//교수요원 조회
						var agentClassList = data.agentClassList; //담당과목 목록 조회
						var agentLicenseList = data.agentLicenseList; //자격사항 목록 조회
						var agentCareerList = data.agentCareerList; //경력사항 목록 조회
						var agentOutsideLectureList = data.agentOutsideLectureList; //타 기관 출강여부 목록 조회
						
						//교수요원
						$('#CD_ADD_STATE').val(agentDetail.CD_ADD_STATE);
						$('#CD_CHNG_STATE').val(agentDetail.CD_CHNG_STATE);
						$('#CD_AGT_TYPE').val(agentDetail.CD_AGT_TYPE);
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
										$.each(data.cdClasLev1List, function(i, cdClasLev1) {
											_html += '<option value="'+cdClasLev1.CODE+'" '+(cdClasLev1.CODE == item.CD_CLS_LEV1 ? 'selected' : '')+'>'+(cdClasLev1.NAME)+'</option>'
										});
										_html += '</select>'
									_html += '</td>'
									_html += '<td>'
										_html += '<select class="tbl_select" name="CD_CLS_LEV2">'
											$.each(data.cdClasLev2List, function(i, cdClasLev2) {
												if(cdClasLev2.CD_MIDDLE == item.CD_CLS_LEV1) {
													_html += '<option value="'+cdClasLev2.CD_BOTTOM+'">'+(cdClasLev2.CD_BOTTOM_KR)+'</option>'
												}
											});
										_html += '</select>'
									_html += '</td>'
									_html += '<td><div class="delete_icon removeAgentClass" data-cls_id="'+item.CLS_ID+'"></div></td>'
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
											_html += '<li>'
												_html += '<div class="file_box">'
													_html += '<input type="text" readonly onclick="$(\'#agentLicenseFiles_'+fileNo+'\').trigger(\'click\')" />'
													_html += '<input type="file" name="agentLicenseFiles" id="agentLicenseFiles_'+fileNo+'"/>'
												_html += '</div>'
											_html += '</li>'
											_html += '<li class="filesText" id="agentLicenseFiles_text_'+fileNo+'">'
												if(item.ID_PK != null && item.ID_PK != '') {
													_html += '<a href="javascript:void(0);" class="file_down getFileDown" data-original_file_name="'+item.ORIGINAL_FILE_NAME+'" data-server_file_name="'+item.SERVER_FILE_NAME+'">'+item.ORIGINAL_FILE_NAME+'</a>'
												}
											_html += '</li>'
										_html += '</ul>'
									_html += '</td>'
									_html += '<td><input type="date" class="tbl_date" name="LCNS_OBTAIN_DATE" value="'+item.LCNS_OBTAIN_DATE+'"/></td>'
									_html += '<td class="t_left pdl20"><input type="text" class="tbl_input" name="LCNS_NOTE" value="'+item.LCNS_NOTE+'"/></td>'
									_html += '<td><div class="delete_icon removeAgentClass" data-lcns_id="'+item.LCNS_ID+'"></div></td>'
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
											_html += '<li>'
												_html += '<div class="file_box">'
													_html += '<input type="text" readonly onclick="$(\'#agentCareerFiles_'+fileNo+'\').trigger(\'click\')" />'
													_html += '<input type="file" name="agentCareerFiles" id="agentCareerFiles_'+fileNo+'"/>'
												_html += '</div>'
											_html += '</li>'
											_html += '<li class="filesText" id="agentCareerFiles_text_'+fileNo+'">'
												if(item.ID_PK != null && item.ID_PK != '') {
													_html += '<a href="javascript:void(0);" class="file_down getFileDown" data-original_file_name="'+item.ORIGINAL_FILE_NAME+'" data-server_file_name="'+item.SERVER_FILE_NAME+'">'+item.ORIGINAL_FILE_NAME+'</a>'
												}
											_html += '</li>'
										_html += '</ul>'
									_html += '</td>'
									_html += '<td><input type="date" class="tbl_date wd150" name="CRR_BEGIN_DATE" value="'+item.CRR_BEGIN_DATE+'"/>~<input type="date" class="tbl_date wd150" name="CRR_END_DATE" value="'+item.CRR_END_DATE+'"/></td>'
									_html += '<td class="t_left pdl20"><input type="text" class="tbl_input" name="CRR_NOTE" value="'+item.CRR_NOTE+'"/></td>'
									_html += '<td><div class="delete_icon removeAgentCareer" data-crr_id="'+item.CRR_ID+'"></div></td>'
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
					<span class="nav">교수요원 상세</span>
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
						<form id="frm" name="frm" method="post" enctype="multipart/form-data">
						<input type="hidden" name="AGT_ID" id="AGT_ID" value="${AGT_ID}"/>
						<input type="hidden" name="CD_ADD_STATE" id="CD_ADD_STATE" value=""/>
						<input type="hidden" name="CD_CHNG_STATE" id="CD_CHNG_STATE" value=""/>
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
												<c:forEach var="item" items="${cdAgtTypeList}">
													<option value="${item.CODE}">${item.NAME}</option>
												</c:forEach>
											</select>
										</td>
										<td class="t_head">최초신청일자</td>
										<td id="REQUEST_DATE"><!-- 2020년 10월 03일 --></td>
									</tr>
									<tr>
										<td class="t_head over_hide pdt5"><span class="star">*</span>성명</td>
										<td class="pdl15 pdr15">
											<input type="text" class="tbl_input" id="AGT_NAME" name="AGT_NAME" />
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
											<input type="text" class="tbl_input" id="AGT_TEL" name="AGT_TEL" />
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
							<div class="con_title">담당교육<a href="javascript:void(0);" class="title_btn wd115 addAgentClass">담당교육 추가</a></div>
							<div class="con_form mgt10">
								<table class="tbl_ty3" id="agentClassList">
									<colgroup>
										<col width="110px"/>
										<col width="315"/>
										<col width="425px"/>
										<col width="110px"/>
									</colgroup>
									<tr class="filter">
										<td>순번</td>
										<td>대과목</td>
										<td>중과목</td>
										<td>삭제</td>
									</tr>
									<tr class="none"><td colspan="4">등록된 데이터가 없습니다.</td></tr>
								</table>
								
								<div class="btn_box mgt15"><a href="javascript:void(0);" class="btn_center wd115 addAgentClass">담당교육 추가</a></div>
							</div>
						</div>
						<!--conBox end-->
						
						<!--conBox-->
						<div class="conBox">
							<div class="con_title">자격사항<a href="javascript:void(0);" class="title_btn wd115 addAgentLicense">자격사항 추가</a><a href="javascript:void(0);" style="diplay:none;" class="title_btn wd160 mgr5 getFilesDown agentLicenseFileDown">자격사항 전체 다운로드</a></div>
							<div class="con_form mgt10">
								<table class="tbl_ty3" id="agentLicenseList">
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
								
								<div class="btn_box mgt15"><a href="javascript:void(0);" class="btn_center wd115 addAgentLicense">자격사항 추가</a></div>
							</div>
						</div>
						<!--conBox end-->
						
						<!--conBox-->
						<div class="conBox">
							<div class="con_title">경력사항<a href="javascript:void(0);" class="title_btn wd115 addAgentCareer">경력사항 추가</a><a href="javascript:void(0);" style="display:none;" class="title_btn wd160 mgr5 getFilesDown agentCareerFileDown">경력사항 전체 다운로드</a></div>
							<div class="con_form mgt10">
								<table class="tbl_ty3" id="agentCareerList">
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
								</table>
								
								<div class="btn_box mgt15"><a href="javascript:void(0);" class="btn_center wd115 addAgentCareer">경력사항 추가</a></div>
							</div>
						</div>
						<!--conBox end-->
						
						<!--conBox-->
						<div class="conBox">
							<div class="con_title">타 기관 출강여부<a href="javascript:void(0);" class="title_btn wd150 addAgentOutsideLecture">타 기관 출강여부 추가</a></div>
							<div class="con_form mgt10">
								<table class="tbl_ty3" id="agentOutsideLectureList">
									<colgroup>
										<col width="110px"/>
										<col width="225px"/>
										<col width="515px"/>
										<col width="110px"/>
									</colgroup>
									<tr class="filter">
										<td>순번</td>
										<td>타 기관명</td>
										<td>비고</td>
										<td>삭제</td>
									</tr>
									<tr class="none"><td colspan="4">등록된 데이터가 없습니다.</td></tr>
									
								</table>
								
								<div class="btn_box mgt15"><a href="javascript:void(0);" class="btn_center wd150 addAgentOutsideLecture">타 기관 출강여부 추가</a></div>
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
						</form>
						<div class="main_btn">
							<ul>
								<li class="page_back mgr5"><a href="javascript:history.back();">취소</a></li>
								<li class="page_ok"><a href="javascript:void(0);" class="agentSave">${empty AGT_ID ? '등록' : '변경'} 신청</a></li>
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
