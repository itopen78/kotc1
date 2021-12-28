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
		getAgencyList(1);
		
		$('#pageSize').on('change', function() {
			getAgencyList(1);
		});
		
		$('.searchAgencyBtn').on('click', function() {
			getAgencyList(1);
		});
		
		$('#agencyList').on('click', '.setAgencyBtn', function() {
			location.href = '/edu/agencyWrite?AGC_ID='+$(this).data('agc_id');
		});
		
		$('#agencyList').on('click', '.removeAgencyBtn', function() {
			if(!confirm('해당 교육기관정보를 삭제 하시겠습니까?')) {
				return false;
			}
			
			var params = {
					'class' : 'service.EduService',
					'method' : 'removeAgency',
					'param' : {'AGC_ID' : $(this).data('agc_id')},
					'callback' : function(data){
						if(data.success){
							loadingStop();
							getAgencyList(1);
						}
					}
			};
			apiCall(params);
		});
		
		$('#agencyList').on('dblclick', '.items', function() {
			location.href = '/edu/hisAgencyList?AGC_ID='+$(this).data('agc_id');
		});
    });
	
	var _page_index = 1;
	var _page_size = 20;
	var _page_total = 1;
	var _navigation = null;
	var _click_first = false;
	
	function getAgencyList(index) {
		_page_index = index;
		_page_size = parseInt($('#pageSize').val());
		var params = {
				'class' : 'service.EduService',
				'method' : 'getAgencyList',
				'param' : {
					'AGC_NAME' : $('#AGC_NAME').val(),
					'AGC_SERIAL' : $('#AGC_SERIAL').val(),
					'CD_AREA' : $('#CD_AREA').val(),
					'USER_NAME' : $('#USER_NAME').val(),
					'AGC_CORP_BOSS_NAME' : $('#AGC_CORP_BOSS_NAME').val(),
					'AGC_CORP_BOSS_TEL' : $('#AGC_CORP_BOSS_TEL').val(),
					'USE_YN' : $('#USE_YN').val(),
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
										getAgencyList(page);
							    	}
							    }
							});
						} else {
							$(".pagination").twbsPagination('changeTotalPages', _page_total, _page_index);
						}
						
						$('#agencyList .items').remove();
						var _html = '';
						if(data.list.length > 0) {
							$.each(data.list, function(index, item) {
								_html += '<tr class="items" data-agc_id="'+item.AGC_ID+'">'
									_html += '<td>'+item.NO+'</td>'
									_html += '<td><a href="javascript:void(0);" class="setAgencyBtn" data-agc_id="'+item.AGC_ID+'">'+item.AGC_NAME+'</a></td>'
									_html += '<td>'+item.AGC_SERIAL+'</td>'
									_html += '<td>'+item.CD_AREA_NAME+'</td>'
									_html += '<td>'+item.USER_NAME+'</td>'
									_html += '<td>'+item.AGC_CORP_BOSS_NAME+'</td>'
									_html += '<td>'+item.AGC_CORP_BOSS_TEL+'</td>'
									_html += '<td>'+(item.USE_YN == 'Y' ? '사용' : '미사용')+'</td>'
									_html += '<td><a href="javascript:void(0);" class="delete_btn removeAgencyBtn" data-agc_id="'+item.AGC_ID+'">삭제</a></td>'
								_html += '</tr>'
							});
						} else {
							_html += '<tr class="items"><td colspan="9">등록된 데이터가 없습니다.</td></tr>'
						}

						$('#agencyList').append(_html);
					}
				}
		};
		apiCall(params);
	}
	
	function excelDown() {
		var excelData = {
				'flag' 			: 'agencyList',
				'AGC_NAME' 		: $('#AGC_NAME').val(),
				'AGC_SERIAL' 	: $('#AGC_SERIAL').val(),
				'CD_AREA' 		: $('#CD_AREA').val(),
				'USER_NAME' 	: $('#USER_NAME').val(),
				'AGC_CORP_BOSS_NAME' : $('#AGC_CORP_BOSS_NAME').val(),
				'AGC_CORP_BOSS_TEL' : $('#AGC_CORP_BOSS_TEL').val(),
				'USE_YN' 		: $('#USE_YN').val()
		}
		submitForm('/edu/excelDown.do', excelData);
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
						<div class="conBox">
							<div class="con_title">검색조건</div>
							<div class="con_form">
								<table class="tbl_ty3">
									<colgroup>
										<col width="130px"/>
										<col width="140px"/>
										<col width="100px"/>
										<col width="100px"/>
										<col width="100px"/>
										<col width="140px"/>
										<col width="100px"/>
									</colgroup>
									<tr>
										<td>교육기관 명칭</td>
										<td>교육기관 지정코드</td>
										<td>지역구분</td>
										<td>담당자</td>
										<td>대표자</td>
										<td>대표자 연락처</td>
										<td>사용여부</td>
									</tr>
									<tr>
										<td>
											<input type="text" class="tbl_input" id="AGC_NAME" name="AGC_NAME"/>
										</td>
										<td>
											<input type="text" class="tbl_input" id="AGC_SERIAL" name="AGC_SERIAL"/>
										</td>
										<td>
											<select class="tbl_select" id="CD_AREA" name="CD_AREA">
												<option value="">전체</option>
												<c:forEach var="item" items="${cdAreaList}">
													<option value="${item.CODE}">${item.NAME}</option>
												</c:forEach>
											</select>
										</td>
										<td>
											<input type="text" class="tbl_input" id="USER_NAME" name="USER_NAME"/>
										</td>
										<td>
											<input type="text" class="tbl_input" id="AGC_CORP_BOSS_NAME" name="AGC_CORP_BOSS_NAME"/>
										</td>
										<td>
											<input type="text" class="tbl_input" id="AGC_CORP_BOSS_TEL" name="AGC_CORP_BOSS_TEL"/>
										</td>
										<td>
											<select class="tbl_select" id="USE_YN" name="USE_YN">
												<option value="">전체</option>
												<option value="Y">사용</option>
												<option value="N">미사용</option>
											</select>
										</td>
									</tr>
									
								</table>
								
								<div class="btn_box mgt15"><a href="javascript:void(0);" class="btn_center wd100 searchAgencyBtn">검색</a></div>
							</div>
						</div>
						<!--conBox end-->
						
						<!--conBox-->
						<div class="conBox">
							<div class="con_title pdr10">
								기관정보
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
								<table class="tbl_ty2" id="agencyList">
									<colgroup>
										<col width="80px"/>
										<col width="110px"/>
										<col width="130px"/>
										<col width="80px"/>
										<col width="95px"/>
										<col width="95px"/>
										<col width="120px"/>
										<col width="80px"/>
										<col width="80px"/>
									</colgroup>
									<tr>
										<td>순번</td>
										<td>교육기관 명칭</td>
										<td>교육기관 지정코드</td>
										<td>지역구분</td>
										<td>담당자</td>
										<td>대표자</td>
										<td>대표자 연락처</td>
										<td>사용여부</td>
										<td>삭제</td>
									</tr>
								</table>
								<div class="btn_box">
									<a href="javascript:void(0);" onclick="excelDown();" class="btn_left wd130">파일로 내보내기</a>
									<a href="/edu/agencyWrite" class="btn_right wd100">신규등록</a>									
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
