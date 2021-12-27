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
		getAgentList(1);
		
		$('#pageSize').on('change', function() {
			getAgentList(1);
		});
		
    	$('.searchAgentBtn').on('click', function() {
    		getAgentList(1);
    	});
    	
    	$('#agentList').on('dblclick', '.items', function() {
    		location.href='/edu/hisAgentList?AGT_ID='+$(this).data('agt_id');
    	});
    	
    	$('#agentList').on('click', '.setAgentBtn', function() {
    		location.href='/edu/agentWrite?AGT_ID='+$(this).data('agt_id');
    	});
    	
    	$('#agentList').on('click', '.removeApplyAgentBtn', function() {
    		if(!confirm('해당 교수요원을 삭제 신청 하시겠습니까?')) {
				return false;
			}
			
			var params = {
					'class' : 'service.EduService',
					'method' : 'removeApplyAgent',
					'param' : {
							'AGT_ID' : $(this).data('agt_id')
							, 'CD_CHNG_STATE' : '2'
							, 'AGT_NOTE' : '삭제 신청합니다.'
					},
					'callback' : function(data){
						if(data.success){
							loadingStop();
							getAgentList(1);
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
	
	function getAgentList(index) {
		_page_index = index;
		_page_size = parseInt($('#pageSize').val());
		var params = {
				'class' : 'service.EduService',
				'method' : 'getAgentList',
				'param' : {
					'AGC_NAME' : $('#AGC_NAME').val(),
					'CD_AGT_TYPE' : $('#CD_AGT_TYPE').val(),
					'AGT_NAME' : $('#AGT_NAME').val(),
					'AGT_TEL' : $('#AGT_TEL').val(),
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
										getAgentList(page);
							    	}
							    }
							});
						} else {
							$(".pagination").twbsPagination('changeTotalPages', _page_total, _page_index);
						}
						
						$('#agentList .items').remove();
						var _html = '';
						if(data.list.length > 0) {
							$.each(data.list, function(index, item) {
								_html += '<tr class="items" data-agt_id="'+item.AGT_ID+'">'
									_html += '<td>'+item.NO+'</td>'
									_html += '<td>'+item.AGC_NAME+'</td>'
									_html += '<td>'+item.CD_AGT_TYPE_NAME+'</td>'
									_html += '<td>'+item.AGT_NAME+'</td>'
									_html += '<td>'+item.AGT_TEL+'</td>'
									_html += '<td>'+item.CD_ADD_STATE_NAME+'</td>'
									_html += '<td>'+item.CD_CHNG_STATE_NAME+'</td>'
									_html += '<td>'+item.FINAL_APL_DATE+'</td>'
									_html += '<td>'
										_html += '<ul class="tbl_btn">'
											_html += '<li><a href="javascript:void(0);" class="reply_btn setAgentBtn" data-agt_id="'+item.AGT_ID+'">변경</a></li>'
											_html += '<li><a href="javascript:void(0);" class="delete_btn removeApplyAgentBtn" data-agt_id="'+item.AGT_ID+'">삭제</a></li>'
										_html += '</ul>'
									_html += '</td>'
									_html += '<td><a class="down_btn">다운로드</a></td>'
								_html += '</tr>'
							});
						} else {
							_html += '<tr class="items"><td colspan="10">등록된 데이터가 없습니다.</td></tr>'
						}

						$('#agentList').append(_html);
					}
				}
		};
		apiCall(params);
	}
	
	function exportExcel() {
		var excelData = {
				'flag' : 'agentList',
				'AGC_NAME' : $('#AGC_NAME').val(),
				'CD_AGT_TYPE_NAME' : $('#CD_AGT_TYPE_NAME').val(),
				'AGT_NAME' : $('#AGT_NAME').val(),
				'AGT_TEL' : $('#AGT_TEL').val(),
				'CD_ADD_STATE_NAME' : $('#CD_ADD_STATE_NAME').val(),
				'CD_CHNG_STATE_NAME' : $('#CD_CHNG_STATE_NAME').val(),
				'FINAL_APL_DATE' : $('#FINAL_APL_DATE').val()
		}
		submitForm('/edu/agentToExcel', excelData);
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
						<!--conBox-->
						<div class="conBox">
							<div class="con_title">검색조건</div>
							<div class="con_form">
								<table class="tbl_ty3">
									<colgroup>
										<col width="130px"/>
										<col width="100px"/>
										<col width="100px"/>
										<col width="140px"/>
										<col width="130px"/>
										<col width="130px"/>
										<col width="130px"/>
										<col width="130px"/>
									</colgroup>
									<tr>
										<td>교육기관</td>
										<td>구분</td>
										<td>성명</td>
										<td>연락처</td>
										<td>등록상태</td>
										<td>변경상태</td>
										<td colspan="2">최종승인</td>
									</tr>
									<tr>
										<td>
											<input type="text" class="tbl_input" id="AGC_NAME" name="AGC_NAME"/>
										</td>
										<td>
											<select class="tbl_select" id="CD_AGT_TYPE" NAME="CD_AGT_TYPE">
												<option value="">전체</option>
												<c:forEach var="item" items="${cdAgtTypeList}">
													<option value="${item.CODE}">${item.NAME}</option>
												</c:forEach>
											</select>
										</td>
										<td>
											<input type="text" class="tbl_input" id="AGT_NAME" name="AGT_NAME"/>
										</td>
										<td>
											<input type="text" class="tbl_input" id="AGT_TEL" name="AGT_TEL"/>
										</td>
										<td>
											<select class="tbl_select"id="CD_ADD_STATE" name="CD_ADD_STATE">
												<option value="">전체</option>
												<c:forEach var="item" items="${cdAddStateList}">
													<option value="${item.CODE}">${item.NAME}</option>
												</c:forEach>
											</select>
										</td>
										<td>
											<select class="tbl_select"id="CD_CHNG_STATE" name="CD_CHNG_STATE">
												<option value="">전체</option>
												<c:forEach var="item" items="${cdChngStateList}">
													<option value="${item.CODE}">${item.NAME}</option>
												</c:forEach>
											</select>
										</td>
										<td>
											<input type="date" class="tbl_date" id="START_FINAL_APL_DATE" name="START_FINAL_APL_DATE"/>
										</td>
										<td>
											<input type="date" class="tbl_date" id="END_FINAL_APL_DATE" name="END_FINAL_APL_DATE"/>
										</td>
									</tr>
									
								</table>
								
								<div class="btn_box mgt15"><a href="javascript:void(0);" class="btn_center wd100 searchAgentBtn">검색</a></div>
							</div>
						</div>
						<!--conBox end-->
						
						<!--conBox-->
						<div class="conBox">
							<div class="con_title pdr10">
								교수요원
								<select class="title_select wd130 float_r" id="pageSize">
									<option>10개씩 보기</option>
									<option selected>20개씩 보기</option>
									<option>30개씩 보기</option>
									<option>40개씩 보기</option>
									<option>50개씩 보기</option>
									<option>60개씩 보기</option>
									<option>70개씩 보기</option>
									<option>80개씩 보기</option>
									<option>90개씩 보기</option>
									<option>100개씩 보기</option>
								</select>
							</div>

							<div class="con_form mgt10">
								<table class="tbl_ty2" id="agentList">
									<colgroup>
										<col width="80px"/>
										<col width="110px"/>
										<col width="90px"/>
										<col width="90px"/>
										<col width="140px"/>
										<col width="95px"/>
										<col width="95px"/>
										<col width="130px"/>
										<col width="130px"/>
										<col width="110px"/>
									</colgroup>
									<tr>
										<td>순번</td>
										<td>교육기관</td>
										<td>구분</td>
										<td>성명</td>
										<td>연락처</td>
										<td>등록상태</td>
										<td>변경상태</td>
										<td>최종승인일자</td>
										<td>변경 및 삭제</td>
										<td>공문</td>
									</tr>
								</table>
								<div class="btn_box">
									<a href="javascript:void(0);" onclick="exportExcel();" class="btn_left wd130">파일로 내보내기</a>
									<a href="/edu/agentWrite" class="btn_right wd100">신규등록</a>									
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
