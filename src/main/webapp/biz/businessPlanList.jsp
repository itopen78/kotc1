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
		getBusinessPlanList(1);
		
		$('#pageSize').on('change', function() {
			getBusinessPlanList(1);
		});
		
		$('.searchBusinessPlanBtn').on('click', function() {
			getBusinessPlanList(1);
		});
		
		$('#businessPlanList').on('click', '.setBusinessPlanBtn', function() {
			location.href = '/biz/businessPlanWrite?PLAN_ID='+$(this).data('plan_id');
		});
		
		$('#businessPlanList').on('click', '.removebusinessPlanBtn', function() {
			if(!confirm('해당 교육기관정보를 삭제 하시겠습니까?')) {
				return false;
			}
			
			var params = {
					'class' : 'service.BizService',
					'method' : 'removebusinessPlan',
					'param' : {'PLAN_ID' : $(this).data('plan_id')},
					'callback' : function(data){
						if(data.success){
							loadingStop();
							getbusinessPlanList(1);
						}
					}
			};
			apiCall(params);
		});
		
		$('#businessPlanList').on('dblclick', '.items', function() {
			location.href = '/biz/hisBusinessPlanList?PLAN_ID='+$(this).data('plan_id');
		});
	});
	
	var _page_index = 1;
	var _page_size = 20;
	var _page_total = 1;
	var _navigation = null;
	var _click_first = false;
	
	function getBusinessPlanList(index) {
		_page_index = index;
		_page_size = parseInt($('#pageSize').val());
		var params = {
				'class' : 'service.BizService',
				'method' : 'getBusinessPlanList',
				'param' : {
					'START_REQUEST_DATE' : $('#START_REQUEST_DATE').val(),
					'END_REQUEST_DATE' : $('#END_REQUEST_DATE').val(),
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
										getBusinessPlanList(page);
							    	}
							    }
							});
						} else {
							$(".pagination").twbsPagination('changeTotalPages', _page_total, _page_index);
						}
						
						$('#businessPlanList .items').remove();
						var _html = '';
						if(data.list.length > 0) {
							$.each(data.list, function(index, item) {
								_html += '<tr class="items" data-plan_id="'+item.PLAN_ID+'">'
									_html += '<td>'+item.NO+'</td>'
									_html += '<td>'+item.REQUEST_DATE+'</td>'
									_html += '<td>'+item.PLAN_TITLE+'</td>'
									_html += '<td>'+item.USER_NAME+'</td>'
									_html += '<td>'+item.CD_ADD_STATE_NAME+'</td>'
									_html += '<td>'+item.CD_CHNG_STATE_NAME+'</td>'
									_html += '<td>'+item.FINAL_APL_DATE+'</td>'
									_html += '<td>'
										_html += '<ul class="tbl_btn">'
											_html += '<li><a href="javascript:void(0);" class="reply_btn setBusinessPlanBtn" data-plan_id="'+item.PLAN_ID+'">변경</a></li>'
											//_html += '<li><div class="btn_off">변경</div></li>'
											_html += '<li><a href="javascript:void(0);" class="delete_btn removeBusinessPlanBtn" data-plan_id="'+item.PLAN_ID+'">삭제</a></li>'
										_html += '</ul>'
									_html += '</td>'
								_html += '</tr>'
							});
						} else {
							_html += '<tr class="items"><td colspan="8">등록된 데이터가 없습니다.</td></tr>'
						}

						$('#businessPlanList').append(_html);
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
					<span class="nav">사업계획서</span>
					<span class="nav">사업계획서 제출</span>
				</div>
				<div class="sub_box">
					<div class="sub_menu">
						<div class="sub_title">사업계획서</div>
						<div class="sub_list">
							<ul>
								<li class="sub_on"><a href="/biz/businessPlanList">사업계획서 제출</a></li>
							</ul>
						</div>
					</div>
					<div class="sub_con">
						<!--conBox-->
						<div class="conBox">
							<div class="con_title">검색조건</div>
							<div class="con_form">
								<table class="tbl_ty3">
									<tr>
										<td colspan="2">작성일자</td>
										<td>등록상태</td>
										<td>변경상태</td>
										<td colspan="2">최종승인</td>
									</tr>
									<tr>
										<td>
											<input type="date" class="tbl_date wd130" id="START_REQUEST_DATE" name="START_REQUEST_DATE"/>
										</td>
										<td>
											<input type="date" class="tbl_date wd130" id="END_REQUEST_DATE" name="END_REQUEST_DATE"/>
										</td>
										<td>
											<select class="tbl_select wd175" id="CD_ADD_STATE" name="CD_ADD_STATE">
												<option value="">전체</option>
												<c:forEach var="item" items="${cdAddStateList}">
													<option value="${item.CODE}">${item.NAME}</option>
												</c:forEach>
											</select>
										</td>
										<td>
											<select class="tbl_select wd170" id="CD_CHNG_STATE" name="CD_CHNG_STATE">
												<option value="">전체</option>
												<c:forEach var="item" items="${cdChngStateList}">
													<option value="${item.CODE}">${item.NAME}</option>
												</c:forEach>
											</select>
										</td>
										<td>
											<input type="date" class="tbl_date wd130" id="START_FINAL_APL_DATE" name="START_FINAL_APL_DATE"/>
										</td>
										<td>
											<input type="date" class="tbl_date wd130" id="END_FINAL_APL_DATE" name="END_FINAL_APL_DATE"/>
										</td>
									</tr>
									
								</table>
								
								<div class="btn_box mgt15"><a href="javascript:void(0);" class="btn_center wd100 searchBusinessPlanBtn">검색</a></div>
							</div>
						</div>
						<!--conBox end-->
						
						<!--conBox-->
						<div class="conBox">
							<div class="con_title pdr10">
								사업계획서
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
								<table class="tbl_ty2" id="businessPlanList">
									<colgroup>
										<col width="70px"/>
										<col width="130px"/>
										<col width="200px"/>
										<col width="110px"/>
										<col width="110px"/>
										<col width="110px"/>
										<col width="130px"/>
										<col width="110px"/>
									</colgroup>
									<tr>
										<td>순번</td>
										<td>작성일자</td>
										<td>제목</td>
										<td>작성자</td>
										<td>등록상태</td>
										<td>변경상태</td>
										<td>최종처리일자</td>
										<td>변경 및 삭제</td>
									</tr>
								</table>
								<div class="btn_box">
									<a href="javascript:void(0);" class="btn_left wd130">파일로 내보내기</a>
									<a href="/biz/businessPlanWrite" class="btn_right wd100">신규등록</a>									
								</div>
								
								<div class="paging_form">
									<div class="paging">
										<ul class="pagination">
										</ul>
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
