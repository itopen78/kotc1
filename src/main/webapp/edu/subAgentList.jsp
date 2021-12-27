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
		getSubAgentList(1);
		
		$('#pageSize').on('change', function() {
			getSubAgentList(1);
		});
		
		$('#CD_FACILITY_LEV1').on('change', function() {
			var CD_MIDDLE = $(this).val();
			if(CD_MIDDLE == '') {
				$('#CD_FACILITY_LEV2').empty();
				$('#CD_FACILITY_LEV2').append('<option value="">전체</>');
			}else {
				var params = {
						'class' : 'commonMapper',
						'method' : 'getCommonListByBottom',
						'param' : {'CD_TOP' : '6'
									, 'CD_MIDDLE' : CD_MIDDLE
						},
						'callback' : function(data){
							if(data.success){
								loadingStop();
								
								$('#CD_FACILITY_LEV2').empty();
								$('#CD_FACILITY_LEV2').append('<option value="">전체</>');
								$.each(data.list, function(index, item) {
									$('#CD_FACILITY_LEV2').append('<option value="'+(item.CODE)+'">'+(item.NAME)+'</option>');
								});
							}
						}
				};
				apiCall(params);
			}
		});
		
		$('.searchSubAgentBtn').on('click', function() {
			getSubAgentList(1);
		});
		
		//실습지도자 변경 이력 페이지
		$('#subAgentList').on('dblclick', '.items', function() {
    		location.href='/edu/hisSubAgentList?SAGT_ID='+$(this).data('sagt_id');
    	});
		
		//실습지도자 변경신청 리스트 이동
		$('#subAgentList').on('click', '.setSubAgentBtn', function() {
			location.href = "/edu/subAgentWrite?SAGT_ID=" + $(this).data('sagt_id');
		});
		
		//실습지도자 삭제
		$('#subAgentList').on('click', '.removeApplySubAgentBtn', function() {
			if(!confirm('해당 실습지도자 정보를 삭제 신청 하시겠습니까?')) {
				return false;
			}
			
			var params = {
					'class' : 'service.EduService',
					'method' : 'removeApplySubAgent',
					'param' : {
							'SAGT_ID' : $(this).data('sagt_id')
							, 'CD_CHNG_STATE' : '2'
							, 'SAGT_NOTE' : '삭제 신청합니다.'
					},
					'callback' : function(data) {
						if(data.success) {
							loadingStop();
							getSubAgentList(1);
						}
					}
			};
			apiCall(params);
		});
	});
	
	var _page_index = 1;
	var _page_size = 20;
	var _page_total = 1;
	var _navigation = null;
	var _click_first = false;
	
	function getSubAgentList(index) {
		_page_index = index;
		_page_size = parseInt($('#pageSize').val());
		var params = {
			'class' : 'service.EduService',
			'method' : 'getSubAgentList',
			'param' : {
				'SAGC_NAME' : $('#SAGC_NAME').val(),
				'CD_FACILITY_LEV1' : $('#CD_FACILITY_LEV1').val(),
				'CD_FACILITY_LEV2' : $('#CD_FACILITY_LEV2').val(),
				'CD_SAGT_TYPE' : $('#CD_SAGT_TYPE').val(),
				'SAGT_NAME' : $('#SAGT_NAME').val(),
				'CD_ADD_STATE' : $('#CD_ADD_STATE').val(),
				'CD_CHNG_STATE' : $('#CD_CHNG_STATE').val(),
				'START_FINAL_APL_DATE' : $('#START_FINAL_APL_DATE').val(),
				'END_FINAL_APL_DATE' : $('#END_FINAL_APL_DATE').val(),
				'PAGE_SIZE' : _page_size,
				'PAGE_INDEX' : (_page_index -1) * _page_size
			},
			'callback' : function(data){
				if(data.success){
					loadingStop();
					_page_total = data.count == 0 ? 1 : (data.count / _page_size) + (data.count%_page_size > 0 ? 1 : 0);
					if(_navigation == null){
						_navigation = $(".pagination").twbsPagination({
							totalPages: _page_total,	// 총 페이지 번호 수
						    visiblePages: _page_size,	// 하단에서 한번에 보여지는 페이지 번호 수
						    startPage : 1, // 시작시 표시되는 현재 페이지
						    initiateStartPageClick: false,	// 플러그인이 시작시 페이지 버튼 클릭 여부 (default : true)
						    first : '<img src="/assets/images/page_first.png"/>',	// 페이지네이션 버튼중 처음으로 돌아가는 버튼에 쓰여 있는 텍스트
						    prev : '<img src="/assets/images/page_prev.png"/>',	// 이전 페이지 버튼에 쓰여있는 텍스트
						    next : '<img src="/assets/images/page_next.png"/>',	// 다음 페이지 버튼에 쓰여있는 텍스트
						    last : '<img src="/assets/images/page_last.png"/>',	// 페이지네이션 버튼중 마지막으로 가는 버튼에 쓰여있는 텍스트
						    nextClass : "next_page page_btn",	// 이전 페이지 CSS class
						    prevClass : "prev_page page_btn",	// 다음 페이지 CSS class
						    lastClass : "last_page page_btn",	// 마지막 페이지 CSS calss
						    firstClass : "first_page page_btn",	// 첫 페이지 CSS class
						    pageClass : "page_num",	// 페이지 버튼의 CSS class
						    activeClass : "page_on",	// 클릭된 페이지 버튼의 CSS class
						    disabledClass : "page_num",	// 클릭 안된 페이지 버튼의 CSS class
						    anchorClass : "",	//버튼 안의 앵커에 대한 CSS class
						    onPageClick: function (event, page) {
						    	_click_first = !_click_first;
						    	if(_click_first){
									getSubAgentList(page);
						    	}
						    }
						});
					} else {
						$(".pagination").twbsPagination('changeTotalPages', _page_total, _page_index);
					}
					
					$('#subAgentList .items').remove();
					var _html = '';
					if(data.list.length > 0) {
						$.each(data.list, function(index, item) {
							_html += '<tr class="items" data-sagt_id="'+item.SAGT_ID+'">'
								_html += '<td rowspan="2">'+item.NO+'</td>'
								_html += '<td>'+item.SAGC_NAME+'</td>'
								_html += '<td>'+item.CD_FACILITY_LEV2_NAME+'</td>'
								_html += '<td>'+item.SAGT_NAME+'</td>'
								_html += '<td>'+item.CD_ADD_STATE_NAME+'</td>'
								_html += '<td rowspan="2">'+item.REQUEST_DATE+'</td>'
								_html += '<td rowspan="2">'
									_html += '<ul class="tbl_btn">'
										_html += '<li><a href="javascript:void(0);" class="reply_btn setSubAgentBtn" data-sagt_id="'+item.SAGT_ID+'">변경</a></li>'
										_html += '<li><a href="javascript:void(0);" class="delete_btn removeApplySubAgentBtn" data-sagt_id="'+item.SAGT_ID+'">삭제</a></li>'
									_html += '</ul>'
								_html += '</td>'
								_html += '<td rowspan="2"><a href="javascript:void(0);" class="setSubAgencyBtn" data-sagt_id="">다운로드</a></td>'
							_html += '</tr>'
							_html += '<tr class="items">'
								_html += '<td>'+item.CD_FACILITY_LEV1_NAME+'</td>'
								_html += '<td>'+item.CD_SAGT_TYPE_NAME+'</td>'
								_html += '<td>'+item.SAGT_TEL+'</td>'
								_html += '<td>'+item.CD_CHNG_STATE_NAME+'</td>'
							_html += '</tr>'
						});
					} else {
						_html += '<tr class="items"><td colspan="8">등록된 데이터가 없습니다.</td></tr>'
					}

					$('#subAgentList').append(_html);
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
				</div>
				<div class="sub_box">
					<div class="sub_menu">
						<div class="sub_title">교육기관</div>
						<div class="sub_list">
							<ul>
								<li><a href="">기관정보</a></li>
								<li><a href="">교수요원</a></li>
								<li><a href="">연계실습기관</a></li>
								<li class="sub_on"><a href="/edu/subAgentList">실습지도자</a></li>
								<li><a href="">교육생</a></li>
								<li><a href="">자체점검</a></li>
							</ul>
						</div>
					</div>
					<div class="sub_con">
						<!--conBox-->
						<div class="conBox">
							<div class="con_title">검색조건</div>
							<div class="con_form">
								<table class="tbl_ty3" id="searchList">
									<colgroup>
										<col width="100px"/>
										<col width="100px"/>
										<col width="140px"/>
										<col width="130px"/>
										<col width="130px"/>
										<col width="130px"/>
										<col width="130px"/>
										<col width="130px"/>
										<col width="130px"/>
									</colgroup>
									<tr>
										<td>시설명</td>
										<td>시설구분</td>
										<td>시설구분(세)</td>
										<td>직무</td>
										<td>성명</td>
										<td>등록상태</td>
										<td>변경상태</td>
										<td colspan="2">최종처리일자</td>
									</tr>
									<tr class="items">
										<td>
											<input type="text" class="tbl_input wd70" id="SAGC_NAME" name="SAGC_NAME"/>
										</td>
										<td>
											<select class="tbl_select wd70" id="CD_FACILITY_LEV1" name="CD_FACILITY_LEV1">
												<option value="">전체</option>
												<c:forEach items="${cdFaclLev1List}" var="item">
													<option value="${item.CODE}">${item.NAME}</option>
												</c:forEach>
											</select>
										</td>
										<td>
											<select class="tbl_select wd135" id="CD_FACILITY_LEV2" name="CD_FACILITY_LEV2">
												<option value="">전체</option>
											</select>
										</td>
										<td>
											<select class="tbl_select wd110" id="CD_SAGT_TYPE" name="CD_SAGT_TYPE">
												<option value="">전체</option>
												<c:forEach items="${cdSagtTypeList}" var="item">
													<option value="${item.CODE}">${item.NAME}</option>
												</c:forEach>
											</select>
										</td>
										<td>
											<input type="text" class="tbl_input wd86" id="SAGT_NAME" name="SAGT_NAME"/>
										</td>
										<td>
											<select class="tbl_select wd100" id="CD_ADD_STATE" name="CD_ADD_STATE">
												<option value="">전체</option>
												<c:forEach items="${cdAddStateList}" var="item">
													<option value="${item.CODE}">${item.NAME}</option>
												</c:forEach>
											</select>
										</td>
										<td>
											<select class="tbl_select wd100" ID="CD_CHNG_STATE" name="CD_CHNG_STATE">
												<option value="">전체</option>
												<c:forEach items="${cdChngStateList}" var="item">
													<option value="${item.CODE}">${item.NAME}</option>
												</c:forEach>
											</select>
										</td>
										<td>
											<input type="date" class="tbl_date wd90" id="START_FINAL_APL_DATE" name="START_FINAL_APL_DATE"/>
										</td>
										<td>
											<input type="date" class="tbl_date wd90" id="END_FINAL_APL_DATE" name="END_FINAL_APL_DATE"/>
										</td>										
									</tr>
									
								</table>
								
								<div class="btn_box mgt15"><a href="javascript:void(0);" class="btn_center wd100 searchSubAgentBtn">검색</a></div>
							</div>
						</div>
						<!--conBox end-->
						
						<!--conBox-->
						<div class="conBox">
							<div class="con_title pdr10">
								실습지도자
								<select class="title_select wd130 float_r" id="pageSize">
									<option value="10">10개씩 보기</option>
									<option value="20" selected>20개씩 보기</option>
									<option value="30">30개씩 보기</option>
									<option value="40">40개씩 보기</option>
									<option value="50">50개씩 보기</option>
									<option value="60">60개씩 보기</option>
									<option value="70">70개씩 보기</option>
									<option value="80">80개씩 보기</option>
									<option value="90">90개씩 보기</option>
									<option value="100">100개씩 보기</option>
								</select>
							</div>

							<div class="con_form mgt10">
								<table class="tbl_ty4" id="subAgentList">
									<colgroup>
										<col width="64px"/>
										<col width="111px"/>
										<col width="160px"/>
										<col width="130px"/>
										<col width="98px"/>
										<col width="112px"/>
										<col width="140px"/>
										<col width="95px"/>
									</colgroup>
									<tr class="t_head">
										<td rowspan="2">순번</td>
										<td>시설명</td>
										<td>시설구분(세)</td>
										<td>성명</td>
										<td>등록상태</td>
										<td rowspan="2">최종처리일자</td>
										<td rowspan="2">변경 및 삭제</td>
										<td rowspan="2">공문</td>
									</tr>
									<tr class="t_head">
										<td>시설구분</td>
										<td>직무</td>
										<td>연락처</td>
										<td>변경상태</td>
									</tr>
								</table>
								<div class="btn_box">
									<a href="" class="btn_left wd130">파일로 내보내기</a>
									<a href="/edu/subAgentWrite" class="btn_right wd100">신규등록</a>									
								</div>
								
								<div class="paging_form">
									<div class="paging">
										<ul class="pagination"></ul>
									</div>
								</div>
							</div>
						</div>
						<!--conBox end-->
					</div>
				</div>
			</div>
		</div>
		
		<c:import url="/inc/footer_base.jsp" />
	</div>
</body>
</html>