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
		getStudentList(1);
		
		$('#pageSize').on('change', function() {
			getStudentList(1);
		});
		
		$('.searchStudentBtn').on('click', function() {
			getStudentList(1);
		});
		
		$('#studentList').on('click', '.setStudentBtn', function() {
    		location.href='/edu/studentWrite?STU_ID='+$(this).data('stu_id');
    	});
		
		$('#studentList').on('dblclick', '.items', function() {
			location.href = '/edu/hisStudentList?STU_ID='+$(this).data('stu_id');
		});
		
		$('#studentList').on('click', '.removeStudentBtn', function() {
			if(!confirm('해당 교육생을 삭제 하시겠습니까?')) {
				return false;
			}
			
			var params = {
					'class' : 'service.EduService',
					'method' : 'removeStudent',
					'param' : {
							'STU_ID' : $(this).data('stu_id')
							, 'CD_ADD_STATE' : '3'
							, 'STU_NOTE' : '교육생 정보를 삭제합니다.'
					},
					'callback' : function(data){
						if(data.success){
							loadingStop();
							getStudentList(1);
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
	
	function getStudentList(index) {
		_page_index = index;
		_page_size = parseInt($('#pageSize').val());
		var params = {
				'class' : 'service.EduService',
				'method' : 'getStudentList',
				'param' : {
					'CD_CLASS_TYPE' : $('#CD_CLASS_TYPE').val(),
					'L_LECTURE_TITLE' : $('#L_LECTURE_TITLE').val(),
					'P_LECTURE_TITLE' : $('#P_LECTURE_TITLE').val(),
					'S_LECTURE_TITLE' : $('#S_LECTURE_TITLE').val(),
					'COMPLETE_REPORT_TITLE' : $('#COMPLETE_REPORT_TITLE').val(),
					'STU_NAME' : $('#STU_NAME').val(),
					'STU_ID_NUMBER' : $('#STU_ID_NUMBER').val(),
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
							    		getStudentList(page);
							    	}
							    }
							});
						} else {
							$(".pagination").twbsPagination('changeTotalPages', _page_total, _page_index);
						}
						
						$('#studentList .items').remove();
						var _html = '';
						if(data.list.length > 0) {
							$.each(data.list, function(index, item) {
								_html += '<tr class="items" data-stu_id="'+item.STU_ID+'">'
									_html += '<td>'+item.NO+'</td>'
									_html += '<td>'+item.CD_CLASS_TYPE_NAME+'</td>'
									_html += '<td>'+item.L_LECTURE_TITLE+'</td>'
									_html += '<td>'+item.P_LECTURE_TITLE+'</td>'
									_html += '<td>'+item.S_LECTURE_TITLE+'</td>'
									_html += '<td>'+item.COMPLETE_REPORT_TITLE+'</td>'
									_html += '<td>'+item.STU_NAME+'</td>'
									_html += '<td>'+item.STU_ID_NUMBER+'</td>'
									_html += '<td>'+item.STU_NOTE+'</td>'
									_html += '<td>'
										_html += '<ul class="tbl_btn">'
											_html += '<li><a href="javascript:void(0);" class="reply_btn setStudentBtn" data-stu_id="'+item.STU_ID+'">변경</a></li>'
											_html += '<li><a href="javascript:void(0);" class="delete_btn removeStudentBtn" data-stu_id="'+item.STU_ID+'">삭제</a></li>'
										_html += '</ul>'
									_html += '</td>'
								_html += '</tr>'
							});
						} else {
							_html += '<tr class="items"><td colspan="10">등록된 데이터가 없습니다.</td></tr>'
						}

						$('#studentList').append(_html);
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
					<span class="nav">교육생</span>
				</div>
				<div class="sub_box">
					<div class="sub_menu">
						<div class="sub_title">교육기관</div>
						<div class="sub_list">
							<ul>
								<li ><a href="">기관정보</a></li>
								<li><a href="">교수요원</a></li>
								<li ><a href="">연계실습기관</a></li>
								<li><a href="">실습지도자</a></li>
								<li class="sub_on"><a href="">교육생</a></li>
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
									<tr>
										<td>과정구분</td>
										<td>이론/실습</td>
										<td>실습</td>
										<td>대체실습</td>
										<td>수료</td>
										<td>이름</td>
										<td>주민등록번호</td>
									</tr>
									<tr>
										<td>
											<select class="tbl_select wd120" id="CD_CLASS_TYPE" name="CD_CLASS_TYPE">
												<option value="" selected>전체</option>
												<c:forEach var="item" items="${cdClassTypeList}">
													<option value="${item.CODE}">${item.NAME}</option>
												</c:forEach>
											</select>
										</td>
										<td>
											<input type="text" class="tbl_input wd120" id="L_LECTURE_TITLE" name="L_LECTURE_TITLE"/>
										</td>
										<td>
											<input type="text" class="tbl_input wd120" id="P_LECTURE_TITLE" name="P_LECTURE_TITLE"/>
										</td>
										<td>
											<input type="text" class="tbl_input wd120" id="S_LECTURE_TITLE" name="S_LECTURE_TITLE"/>
										</td>
										<td>
											<input type="text" class="tbl_input wd120" id="COMPLETE_REPORT_TITLE" name="COMPLETE_REPORT_TITLE"/>
										</td>
										<td>
											<input type="text" class="tbl_input wd100" id="STU_NAME" name="STU_NAME"/>
										</td>
										<td>
											<input type="text" class="tbl_input wd160" id="STU_ID_NUMBER" name="STU_ID_NUMBER"/>
										</td>
									</tr>
									
								</table>
								
								<div class="btn_box mgt15"><a href="javascript:void(0);" class="btn_center wd100 searchStudentBtn">검색</a></div>
							</div>
						</div>
						<!--conBox end-->
						
						<!--conBox-->
						<div class="conBox">
							<div class="con_title pdr10">
								교육생
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
								<table class="tbl_ty2" id="studentList">
									<colgroup>
										<col width="70px"/>
										<col width="100px"/>
										<col width="100px"/>
										<col width="100px"/>
										<col width="100px"/>
										<col width="100px"/>
										<col width="80px"/>
										<col width="130px"/>
										<col width="80px"/>
										<col width="110px"/>
									</colgroup>
									<tr>
										<td>순번</td>
										<td>과정구분</td>
										<td>이론/실습</td>
										<td>실습</td>
										<td>대체실습</td>
										<td>수료</td>
										<td>이름</td>
										<td>주민등록번호</td>
										<td>비고</td>
										<td>변경 및 삭제</td>
									</tr>
								</table>
								<div class="btn_box">
									<a href="javascript:void(0);" class="btn_left wd130">파일로 내보내기</a>
									<a href="/edu/studentWrite" class="btn_right wd100">신규등록</a>									
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