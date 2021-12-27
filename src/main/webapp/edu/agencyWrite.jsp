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
		
		$('.saveAgency').on('click', function() {
			var AGC_ID = $('#AGC_ID').val();
			
			if($('#AGC_SERIAL').val() == '') {
				alert('교육기관 지정코드를 입력하세요.');
				$('#AGC_SERIAL').focus();
				return false;
			}
			
			if($('#AGC_NAME').val() == '') {
				alert('교육기관 명칭을 입력하세요.');
				$('#AGC_NAME').focus();
				return false;
			}

			if($('#AGC_BOSS_NAME').val() == '') {
				alert('기관장을 입력하세요.');
				$('#AGC_BOSS_NAME').focus();
				return false;
			}
			
			if($('#AGC_BOSS_TEL').val() == '') {
				alert('기관장 연락처를 입력하세요.');
				$('#AGC_BOSS_TEL').focus();
				return false;
			}
			
			if($('#AGC_CORP').val() == '') {
				alert('법인명을 입력하세요.');
				$('#AGC_CORP').focus();
				return false;
			}
			
			if($('#AGC_CORP_SERIAL').val() == '') {
				alert('법인등록번호를 입력하세요.');
				$('#AGC_CORP_SERIAL').focus();
				return false;
			}
			
			if($('#AGC_CORP_BOSS_NAME').val() == '') {
				alert('대표명을 입력하세요.');
				$('#AGC_CORP_BOSS_NAME').focus();
				return false;
			}
			
			if($('#AGC_CORP_BOSS_TEL').val() == '') {
				alert('대표 연락처를 입력하세요.');
				$('#AGC_CORP_BOSS_TEL').focus();
				return false;
			}

			if($('#AGC_ZIP').val() == '') {
				alert('우편번호를 입력하세요.');
				$('#AGC_ZIP').focus();
				return false;
			}
			
			if($('#AGC_ADDRESS').val() == '') {
				alert('소재지 주소(도로명)를 입력하세요.');
				$('#AGC_ADDRESS').focus();
				return false;
			}
			
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
			
			var param = {
					'AGC_ID' : $('#AGC_ID').val()
					, 'AGC_SERIAL' : $('#AGC_SERIAL').val()
					, 'AGC_NAME' : $('#AGC_NAME').val()
					, 'AGC_BOSS_NAME' : $('#AGC_BOSS_NAME').val()
					, 'AGC_BOSS_TEL' : $('#AGC_BOSS_TEL').val()
					, 'AGC_CORP' : $('#AGC_CORP').val()
					, 'AGC_CORP_SERIAL' : $('#AGC_CORP_SERIAL').val()
					, 'AGC_CORP_BOSS_NAME' : $('#AGC_CORP_BOSS_NAME').val()
					, 'AGC_CORP_BOSS_TEL' : $('#AGC_CORP_BOSS_TEL').val()
					, 'AGC_ZIP' : $('#AGC_ZIP').val()
					, 'AGC_ADDRESS' : $('#AGC_ADDRESS').val()
					, 'USE_YN' : $('#USE_YN').val()
					, 'CD_AREA' : $('#CD_AREA').val()
					, 'CD_ADD_STATE' : (AGC_ID != null && AGC_ID != '' ? 2 : 1) //1:등록, 2:변경, 3:삭제
					, 'AGC_NOTE' : $('#AGC_NOTE').val()
					, 'saveAgencyWorkerList' : JSON.stringify(saveAgencyWorkerList)
					, 'workerIds' : JSON.stringify(workerIds)
				};
			
			if($('#AGC_ID').val() == null || $('#AGC_ID').val() == '') {
				var params = {
						'class' : 'eduMapper',
						'method' : 'countAgencyByAgcSerial',
						'param' : {
							'AGC_SERIAL' : $('#AGC_SERIAL').val()
						},
						'callback' : function(data){
							if(data.success){
								loadingStop();
								if(data.count > 0) {
									alert('교육기관 지정코드가 존재합니다.');
									return false;
								} else {
									saveAgency(param);
								}
							}
						}
				};
				apiCall(params);
			} else {
				saveAgency(param);
			}
		});
    });
	
	function saveAgency(param) {
		var params = {
				'class' : 'service.EduService',
				'method' : 'saveAgency',
				'param' : param,
				'callback' : function(data){
					if(data.success){
						loadingStop();
						alert('저장 되었습니다.');
						location.href='/edu/agencyList';
					} else {
						alert('저장 실패 하였습니다.');
					}
				}
		};
		apiCall(params);
	}
	
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
						$('#USE_YN').val(view.USE_YN);
						$('#AGC_SERIAL').val(view.AGC_SERIAL);
						$('#AGC_NAME').val(view.AGC_NAME);
						$('#AGC_BOSS_NAME').val(view.AGC_BOSS_NAME);
						$('#AGC_BOSS_TEL').val(view.AGC_BOSS_TEL);
						$('#AGC_CORP').val(view.AGC_CORP);
						$('#AGC_CORP_SERIAL').val(view.AGC_CORP_SERIAL);
						$('#AGC_CORP_BOSS_NAME').val(view.AGC_CORP_BOSS_NAME);
						$('#AGC_CORP_BOSS_TEL').val(view.AGC_CORP_BOSS_TEL);
						$('#AGC_ZIP').val(view.AGC_ZIP);
						$('#AGC_ADDRESS').val(view.AGC_ADDRESS);
						$('#USER_NAME').val(view.USER_NAME);
						$('#CD_AREA').val(view.CD_AREA);
						$('#ADD_DATE').text(view.ADD_DATE);
						$('#CHNG_DATE').text(view.CHNG_DATE);
						$('.agencyDate').show();
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
	
	function jusoSearch() {
		new daum.Postcode({ 
			oncomplete : function(data) {
				var addr = ''; // 주소 변수
				var extraAddr = ''; // 참고항목 변수
				
				//console.log(data);
				if (data.userSelectedType === 'R') addr = data.roadAddress;
				else addr = data.roadAddress;
				//else addr = data.jibunAddress;
				var zonecode = data.zonecode;

				document.getElementById("AGC_ZIP").value = zonecode;
				document.getElementById("AGC_ADDRESS").value = addr;
				//document.getElementById("address2").focus();
				//	getLocation();
			}
		}).open();
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
						<input type="hidden" name="AGC_ID" id="AGC_ID" value="${AGC_ID}"/>
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
										<td class="t_head over_hide pdt5">사용여부</td>
										<td class="pdl15 pdr15">
											<select class="tbl_select" id="USE_YN" name="USE_YN">
												<option value="Y">사용</option>
												<option value="N">미사용</option>
											</select>
										</td>
										<td></td>
										<td></td>
									</tr>
									<tr>
										<td class="t_head over_hide pdt5">교육기관 지정코드</td>
										<td class="pdl15 pdr15">
											<input type="text" class="tbl_input" id="AGC_SERIAL" name="AGC_SERIAL" />
										</td>
										<td class="t_head over_hide pdt5">교육기관 명칭</td>
										<td class="pdl15 pdr15">
											<input type="text" class="tbl_input" id="AGC_NAME" name="AGC_NAME" />
										</td>
									</tr>
									<tr>
										<td class="t_head over_hide pdt5">기관장</td>
										<td class="pdl15 pdr15">
											<input type="text" class="tbl_input" id="AGC_BOSS_NAME" name="AGC_BOSS_NAME" />
										</td>
										<td class="t_head over_hide pdt5">기관장 연락처</td>
										<td class="pdl15 pdr15">
											<input type="text" class="tbl_input" id="AGC_BOSS_TEL" name="AGC_BOSS_TEL" />
										</td>
									</tr>
									<tr>
										<td class="t_head over_hide pdt5">법인명</td>
										<td class="pdl15 pdr15">
											<input type="text" class="tbl_input" id="AGC_CORP" name="AGC_CORP" />
										</td>
										<td class="t_head over_hide pdt5">법인등록번호</td>
										<td class="pdl15 pdr15">
											<input type="text" class="tbl_input" id="AGC_CORP_SERIAL" name="AGC_CORP_SERIAL" />
										</td>
									</tr>
									<tr>
										<td class="t_head over_hide pdt5">대표명</td>
										<td class="pdl15 pdr15">
											<input type="text" class="tbl_input" id="AGC_CORP_BOSS_NAME" name="AGC_CORP_BOSS_NAME" />
										</td>
										<td class="t_head over_hide pdt5">대표 연락처</td>
										<td class="pdl15 pdr15">
											<input type="text" class="tbl_input" id="AGC_CORP_BOSS_TEL" name="AGC_CORP_BOSS_TEL" />
										</td>
									</tr>
									<tr>
										<td class="t_head over_hide pdt5">우편번호</td>
										<td class="pdl15 pdr15">
											<input type="text" class="tbl_input" onClick="jusoSearch();" id="AGC_ZIP" name="AGC_ZIP" readOnly/>
										</td>
										<td></td>
										<td></td>
									</tr>
									<tr>
										<td class="t_head over_hide pdt5">소재지 주소(도로명)</td>
										<td class="pdl15 pdr15" colspan="3">
											<input type="text" class="tbl_input" onClick="jusoSearch();" id="AGC_ADDRESS" name="AGC_ADDRESS" readOnly/>
										</td>
									</tr>
									<tr>
										<td class="t_head over_hide pdt5">도청 담당자</td>
										<td class="pdl15 pdr15">
											<input type="text" class="tbl_input" id="USER_NAME" name="USER_NAME" value="${empty AGC_ID ? sessionScope.userInfo.USER_NAME : ''}" disabled/>
										</td>
										<td class="t_head over_hide pdt5">지역구분</td>
										<td class="pdl15 pdr15">
											<select class="tbl_select" id="CD_AREA" name="CD_AREA">
												<c:forEach var="item" items="${cdAreaList}">
													<option value="${item.CODE}">${item.NAME}</option>
												</c:forEach>
											</select>
										</td>
									</tr>
									<tr class="agencyDate" style="display:none;">
										<td class="t_head">등록일자</td>
										<td id="ADD_DATE"></td>
										<td class="t_head">최종변경일자</td>
										<td id="CHNG_DATE"></td>
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
								<li class="page_back mgr5"><a href="javascript:history.back();">취소</a></li>
								<li class="page_ok"><a href="javascript:void(0);" class="saveAgency">저장</a></li>
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
