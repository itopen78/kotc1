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
		getAgencyDeatil();

		$('.addAgencyWorker').on('click', function() {
			$('#agencyWorkerList .none').remove();
			
			var _html = '';
			_html += '<tr class="items" data-worker_id="">'
				_html += '<td class="no"></td>'
				_html += '<td><input type="text" class="tbl_input" id="WORKER_RANK" name="WORKER_RANK"/></td>'
				_html += '<td><input type="text" class="tbl_input" id="WORKER_NAME" name="WORKER_NAME"/></td>'
				_html += '<td><input type="text" class="tbl_input" id="WORKER_TEL" name="WORKER_TEL"/></td>'
				_html += '<td class="t_left pdl50"><input type="text" class="tbl_input" id="AGT_NOTE" name="AGT_NOTE"/></td>'
				_html += '<td><a href="javascript:void(0);" class="delete_btn removeAgencyWorker" data-worker_id="">삭제</a></td>'
			_html += '</tr>'
			
			$('#agencyWorkerList .filter').after(_html);
			
			$('#agencyWorkerList tr.items:visible').each(function(i) {
				$(this).find('.no').text((i+1));
			});
		});
		
		$('#agencyWorkerList').on('click', '.removeAgencyWorker', function() {
			var WORKER_ID = $(this).data('worker_id');
			if(WORKER_ID != null && WORKER_ID != '') {
				$(this).closest('tr.items').hide();
			} else {
				$(this).closest('tr.items').remove();
			}
			
			$('#agencyWorkerList tr.items:visible').each(function(i) {
				$(this).find('.no').text((i+1));
			});
			
			if($('#agencyWorkerList tr.items:visible').length <= 0) {
				$('#agencyWorkerList .filter').after('<tr class="none"><td colspan="6">등록된 데이터가 없습니다.</td></tr>');
			}
		});
		
		$('.saveAgencyWorker').on('click', function() {
			var AGC_ID = $('#AGC_ID').val();
			
			//사무원 마스터 저장 목록
			var saveAgencyWorkerList = new Array();
			var FLAG_WORKER_RANK = true;
			var FLAG_WORKER_NAME = true;
			var FLAG_WORKER_TEL = true;
			$('#agencyWorkerList .items:visible').each(function() {
				var WORKER_ID = $(this).data('worker_id');
				var WORKER_RANK = $(this).find('#WORKER_RANK').val();
				var WORKER_NAME = $(this).find('#WORKER_NAME').val();
				var WORKER_TEL = $(this).find('#WORKER_TEL').val();
				var AGT_NOTE = $(this).find('#AGT_NOTE').val();
				if(WORKER_RANK == '') {
					FLAG_WORKER_RANK = false;
				}
				if(WORKER_NAME == '') {
					FLAG_WORKER_NAME = false;
				}
				if(WORKER_TEL == '') {
					FLAG_WORKER_TEL = false;
				}
				
				saveAgencyWorkerList.push({'WORKER_ID' : WORKER_ID
									, 'WORKER_RANK' : WORKER_RANK
									, 'WORKER_NAME' : WORKER_NAME
									, 'WORKER_TEL' : WORKER_TEL
									, 'AGT_NOTE' : AGT_NOTE
									});
			});
			
			if(!FLAG_WORKER_RANK) {
				alert('직책을 입력해주세요.');
				return false;
			}
			
			if(!FLAG_WORKER_NAME) {
				alert('이름을 입력해주세요.');
				return false;
			}
			
			if(!FLAG_WORKER_TEL) {
				alert('전화번호를 입력해주세요.');
				return false;
			}
			
			//사무원 마스터 삭제 목록
			var workerIds = new Array();
			$('#agencyWorkerList .items:not(:visible)').each(function() {
				workerIds.push($(this).data('worker_id'));
			});
			
			if($('#AGC_NOTE').val() == '') {
				alert('비고를 입력해주세요.');
				return false;
			}
			
			if(!confirm("저장하시겠습니까?")) {
				return false;
			}
			
			var params = {
					'class' : 'service.EduService',
					'method' : 'saveAgencyWorker',
					'param' : {
						'AGC_ID' : $('#AGC_ID').val()
						, 'CD_ADD_STATE' : (AGC_ID != null && AGC_ID != '' ? 2 : 1) //1:등록, 2:변경, 3:삭제
						, 'AGC_NOTE' : $('#AGC_NOTE').val()
						, 'saveAgencyWorkerList' : JSON.stringify(saveAgencyWorkerList)
						, 'workerIds' : JSON.stringify(workerIds)
					},
					'callback' : function(data){
						if(data.success){
							loadingStop();
							alert('저장 되었습니다.');
							$('#AGC_NOTE').val('');
							getAgencyWorkerList();
						}
					}
			};
			apiCall(params);
		});
    });
	
	function getAgencyDeatil() {
		if($('#AGC_ID').val() == null || $('#AGC_ID').val() == '') {
			return false;
		}
		
		var params = {
				'class' : 'eduMapper',
				'method' : 'getAgencyDetail',
				'param' : {'AGC_ID' : $('#AGC_ID').val()},
				'callback' : function(data){
					if(data.success){
						loadingStop();
						var view = data.view;
						$('#AGC_SERIAL').text(view.AGC_SERIAL);
						$('#AGC_NAME').text(view.AGC_NAME);
						$('#AGC_BOSS_NAME').text(view.AGC_BOSS_NAME);
						$('#AGC_BOSS_TEL').text(view.AGC_BOSS_TEL);
						$('#AGC_CORP').text(view.AGC_CORP);
						$('#AGC_CORP_SERIAL').text(view.AGC_CORP_SERIAL);
						$('#AGC_CORP_BOSS_NAME').text(view.AGC_CORP_BOSS_NAME);
						$('#AGC_CORP_BOSS_TEL').text(view.AGC_CORP_BOSS_TEL);
						$('#AGC_ZIP').text(view.AGC_ZIP);
						$('#AGC_ADDRESS').text(view.AGC_ADDRESS);
						$('#USER_NAME').text(view.USER_NAME);
						$('#CD_AREA_NAME').text(view.CD_AREA_NAME);
						getAgencyWorkerList();
					}
				}
		};
		apiCall(params);
	}
	
	function getAgencyWorkerList() {
		if($('#AGC_ID').val() == null || $('#AGC_ID').val() == '') {
			return false;
		}
		
		var params = {
				'class' : 'eduMapper',
				'method' : 'getAgencyWorkerList',
				'param' : {'AGC_ID' : $('#AGC_ID').val()},
				'callback' : function(data){
					if(data.success){
						loadingStop();
						var view = data.view;
						
						$('#agencyWorkerList .none').remove();
						$('#agencyWorkerList .items').remove();
						var _html = '';
						if(data.list.length > 0) {
							$.each(data.list, function(i, item) {
								_html += '<tr class="items" data-worker_id="'+item.WORKER_ID+'">'
									_html += '<td class="no">'+(i+1)+'</td>'
									_html += '<td><input type="text" class="tbl_input" id="WORKER_RANK" name="WORKER_RANK" value="'+item.WORKER_RANK+'"/></td>'
									_html += '<td><input type="text" class="tbl_input" id="WORKER_NAME" name="WORKER_NAME" value="'+item.WORKER_NAME+'"/></td>'
									_html += '<td><input type="text" class="tbl_input" id="WORKER_TEL" name="WORKER_TEL" value="'+item.WORKER_TEL+'"/></td>'
									_html += '<td class="t_left pdl50"><input type="text" class="tbl_input" id="AGT_NOTE" name="AGT_NOTE" value="'+item.AGT_NOTE+'"/></td>'
									_html += '<td><a href="javascript:void(0);" class="delete_btn removeAgencyWorker" data-worker_id="'+item.WORKER_ID+'">삭제</a></td>'
								_html += '</tr>'
							});
						} else {
							_html += '<tr class="none"><td colspan="6">등록된 데이터가 없습니다.</td></tr>'
						}

						$('#agencyWorkerList').append(_html);
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
					<span class="nav">기관정보</span>
				</div>
				<div class="sub_box">
					<div class="sub_menu">
						<div class="sub_title">교육기관</div>
						<div class="sub_list">
							<ul>
								<li class="sub_on"><a href="">기관정보</a></li>
								<li><a href="">교수요원</a></li>
								<li><a href="">연계실습기관</a></li>
								<li><a href="">실습지도자</a></li>
								<li><a href="">교육생</a></li>
								<li><a href="">자체점검</a></li>
							</ul>
						</div>
					</div>
					<div class="sub_con">
						<!--conBox-->
						<form name="frm" id="frm" method="post">
						<input type="hidden" name="AGC_ID" id="AGC_ID" value="${sessionScope.userInfo.AGC_ID}"/>
						<div class="conBox">
							<div class="con_title">교육기관정보</div>
							<div class="con_form">
								<table class="tbl_ty1">
									<colgroup>
										<col width="160px"/>
										<col width="295px"/>
										<col width="160px"/>
										<col width="295px"/>
									</colgroup>
									<tr>
										<td class="t_head">교육기관 지정코드</td>
										<td id="AGC_SERIAL"></td>
										<td class="t_head">교육기관 명칭</td>
										<td id="AGC_NAME"></td>
									</tr>
									<tr>
										<td class="t_head">기관장</td>
										<td id="AGC_BOSS_NAME"></td>
										<td class="t_head">기관장 연락처</td>
										<td id="AGC_BOSS_TEL"></td>
									</tr>
									<tr>
										<td class="t_head">법인명</td>
										<td id="AGC_CORP"></td>
										<td class="t_head">법인등록번호</td>
										<td id="AGC_CORP_SERIAL"></td>
									</tr>
									<tr>
										<td class="t_head">대표명</td>
										<td id="AGC_CORP_BOSS_NAME"></td>
										<td class="t_head">대표 연락처</td>
										<td id="AGC_CORP_BOSS_TEL"></td>
									</tr>
									<tr>
										<td class="t_head">우편번호</td>
										<td colspan="3" id="AGC_ZIP"></td>
									</tr>
									<tr>
										<td class="t_head">소재지 주소(도로명)</td>
										<td colspan="3" id="AGC_ADDRESS"></td>
									</tr>
									<tr>
										<td class="t_head">도청 담당자</td>
										<td id="USER_NAME"></td>
										<td class="t_head">지역구분</td>
										<td id="CD_AREA_NAME"></td>
									</tr>
								</table>
							</div>
						</div>
						</form>
						<!--conBox end-->
						
						<!--conBox-->
						<div class="conBox">
							<div class="con_title">교육기관 사무원 정보 <a href="javascript:void(0);" class="title_btn wd100 addAgencyWorker">사무원 추가</a></div>

							<div class="con_form mgt10">
								<table class="tbl_ty2" id="agencyWorkerList">
									<colgroup>
										<col width="80px"/>
										<col width="120px"/>
										<col width="120px"/>
										<col width="180px"/>
										<col width="310px"/>
										<col width="100px"/>
									</colgroup>
									<tr class="filter">
										<td>순번</td>
										<td>직책</td>
										<td>이름</td>
										<td>전화번호</td>
										<td>비고</td>
										<td>삭제</td>
									</tr>
									<tr class="none"><td colspan="6">등록된 데이터가 없습니다.</td></tr>
								</table>

								<div class="btn_box"><a href="javascript:void(0);" class="btn_center wd100 addAgencyWorker">사무원 추가</a></div>
								
								
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
											<textarea class="tbl_area" id="AGC_NOTE" name="AGC_NOTE"></textarea>
										</td>
									</tr>			
								</table>
							</div>
						</div>
						<!--conBox end-->
						
						<div class="main_btn">
							<ul>
								<li class="page_ok"><a href="javascript:void(0);" class="saveAgencyWorker">저장</a></li>
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
