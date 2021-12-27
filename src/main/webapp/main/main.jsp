<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <c:import url="/inc/main_base.jsp" />

	<script type="text/javascript">
	$(document).ready(function() {
		getNoticeList(1);
		
		$('#w01').on('change', 'input[name=noticeFile]', function() {
			var fileName = '';
			if($(this)[0].files.length > 0) {
				fileName = $(this)[0].files[0].name;
			}
			$('#w01 #noticeFile_text').text(fileName);
		});
		
		$('.notice_btn').on('click', function() {
			var date = new Date();
			var writedDate = date.getFullYear() + '-' + ('0'+(date.getMonth()+1)).slice(-2) + '-' + ('0'+date.getDate()).slice(-2) + ' ' + date.getHours() + ':' + date.getMinutes() + ':' + date.getSeconds();
			$('.writedDate').text(writedDate);
			$('#USER_TEL').val('${sessionScope.userInfo.USER_TEL}');
			$('#NOTICE_TITLE').val('');
			$('#NOTICE_TEXT').val('');
			$('.file_form').empty();
			var _html = '';
				_html += '<li>'
					_html += '<div class="file_box">'
						_html += '<input type="text" readonly onclick="$(\'#noticeFile\').trigger(\'click\')" />'
						_html += '<input type="file" name="noticeFile" id="noticeFile"/>'
					_html += '</div>'
				_html += '</li>'
				_html += '<li id="noticeFile_text"></li>';
			$('.file_form').append(_html);
			$('#w01').window('open');
		});
		
		$('.saveNotice').on('click', function() {
			if($('#NOTICE_TITLE').val() == '') {
				alert('제목을 입력해 주세요.');
				$('#NOTICE_TITLE').focus();
				return false;
			}
			
			if($('#NOTICE_TEXT').val() == '') {
				alert('내용을 입력해 주세요.');
				$('#NOTICE_TEXT').focus();
				return false;
			}
			
			var formData = new FormData($('#frm')[0]);
			
			$.ajax({
	            url : '/main/saveNotice',
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
	            		$('#w01').window('close');
	            		getNoticeList(1);
	            	}
	            },
	            error:function(request,status,error){
	                alert("code : " + request.status + "\n" + "error:" + error);
	            }
	        });
		});
	});
	
	var _page_index = 1;
	var _page_size = 10;
	var _page_total = 1;
	var _navigation = null;
	var _click_first = false;
	
	function getNoticeList(index) {
		_page_index = index;
		_page_size = parseInt(_page_size);
		var params = {
				'class' : 'service.MainService',
				'method' : 'getNoticeList',
				'param' : {
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
							    		getNoticeList(page);
							    	}
							    }
							});
						} else {
							//$(".pagination").twbsPagination('changeTotalPages', _page_total, _page_index);
						}
						
						$('#noticeList').empty();
						var _html = '';
						if(data.list.length > 0) {
							$.each(data.list, function(index, item) {
								_html += '<a href="javascript:void(0);" class="notice_tbl new_type">'
									_html += '<div class="notice_row">'
										_html += '<div class="notice_cell">'
											_html += '<span class="notice_title">'+item.NOTICE_TITLE+'</span>'
											_html += '<span class="notice_new">New</span>'
										_html += '</div>'
										_html += '<div class="notice_cell"><span class="sub_title">'+item.NOTICE_TEXT+'</span></div>'
										_html += '<div class="notice_cell"><span class="notice_date">'+item.WRITED_DATE+'</span></div>'
									_html += '</div>'
								_html += '</a>'
							});
						} else {
							//_html += '<div class="notice_row">등록된 데이터가 없습니다.</div>'
						}

						$('#noticeList').append(_html);
					}
				}
		};
		apiCall(params);
	}
	</script>
</head>
<body>
	<div id="wrap">
		<!--page_up 공통-->
		<div class="upBtn">
			<img src="/assets/images/up_btn.png"/>
		</div>
		<c:import url="/inc/header_base.jsp" />
		
		<!--contents 영역-->
		<div class="contents">
			<div class="banner_form">
				<div class="banner_box">
					<div class="banner_con">
						<ul>
							<li class="banner_txt">경기도 요양보호사 합격자 바로가기</li>
							<li class="banner_sub">Care worker Educate Management System</li>
							<li class="banner_btn">
								<a href="#">바로가기</a>
							</li>
						</ul>
					</div>
				</div>
			</div>
			
			<div class="main_notice">
				<div class="notice_form">
					<div class="con_title">주요알림</div>
					<ul class="notice_con">
						<a href="" class="notice_box">
							<div class="notice_title">교수등원 등록 및 변경 신청</div>
							<div class="notice_total">
								<ul>
									<li>
										<span class="total_num">7</span>
										<span class="total_txt">신청</span>
									</li>
									<li>
										<span class="total_num">58</span>
										<span class="total_txt">처리중</span>
									</li>
									<li>
										<span class="total_num">29</span>
										<span class="total_txt">완료</span>
									</li>
								</ul>
								
							</div>
						</a>
						<a href="" class="notice_box">
							<div class="notice_title">실습지도자 등록 및 변경 신청</div>
							<div class="notice_total">
								<ul>
									<li>
										<span class="total_num">12</span>
										<span class="total_txt">신청</span>
									</li>
									<li>
										<span class="total_num">27</span>
										<span class="total_txt">처리중</span>
									</li>
									<li>
										<span class="total_num">25</span>
										<span class="total_txt">완료</span>
									</li>
								</ul>
							</div>
						</a>
						<a href="" class="notice_box">
							<div class="notice_title">사업계획서 제출</div>
							<div class="notice_total">
								<ul>
									<li>
										<span class="total_num">9</span>
										<span class="total_txt">승인</span>
									</li>
									<li>
										<span class="total_num">0</span>
										<span class="total_txt">반려</span>
									</li>
								</ul>
							</div>
						</a>
						<a href="" class="notice_box">
							<div class="notice_title">개강보고</div>
							<div class="notice_total">
								<ul>
									<li>
										<span class="total_num">16</span>
										<span class="total_txt">신청</span>
									</li>
									<li>
										<span class="total_num">56</span>
										<span class="total_txt">처리중</span>
									</li>
									<li>
										<span class="total_num">15</span>
										<span class="total_txt">완료</span>
									</li>
								</ul>
							</div>
						</a>
						<a href="" class="notice_box">
							<div class="notice_title">자격증 신청</div>
							<div class="notice_total">
								<ul>
									<li>
										<span class="total_num">99</span>
										<span class="total_txt">신청</span>
									</li>
									<li>
										<span class="total_num">99</span>
										<span class="total_txt">처리중</span>
									</li>
									<li>
										<span class="total_num">99</span>
										<span class="total_txt">완료</span>
									</li>
								</ul>
							</div>
						</a>
						<a href="" class="notice_box">
							<div class="notice_title">연계실습기관 등록 및 변경 신청</div>
							<div class="notice_total">
								<ul>
									<li>
										<span class="total_num">6</span>
										<span class="total_txt">신청</span>
									</li>
									<li>
										<span class="total_num">65</span>
										<span class="total_txt">처리중</span>
									</li>
									<li>
										<span class="total_num">60</span>
										<span class="total_txt">완료</span>
									</li>
								</ul>
							</div>
						</a>
						<a href="" class="notice_box">
							<div class="notice_title">자체점검</div>
							<div class="notice_total">
								<ul>
									<li>
										<span class="total_num">56</span>
										<span class="total_txt">신청</span>
									</li>
									<li>
										<span class="total_num">24</span>
										<span class="total_txt">처리중</span>
									</li>
									<li>
										<span class="total_num">60</span>
										<span class="total_txt">완료</span>
									</li>
								</ul>
							</div>
						</a>
						<a href="" class="notice_box">
							<div class="notice_title">수료보고</div>
							<div class="notice_total">
								<ul>
									<li>
										<span class="total_num">9</span>
										<span class="total_txt">신청</span>
									</li>
									<li>
										<span class="total_num">30</span>
										<span class="total_txt">처리중</span>
									</li>
									<li>
										<span class="total_num">50</span>
										<span class="total_txt">완료</span>
									</li>
								</ul>
							</div>
						</a>
					</ul>
				</div>
			</div>
			
			<div class="sub_notice">
				<div class="notice_form">
					<div class="con_title">공지사항</div>
					
					<div class="notice_con">
						<ul class="notice_box" id="noticeList">
						</ul>
						<!-- 
						<div class="paging_form">
							<div class="paging">
								<ul class="pagination">
								</ul>
							</div>
						</div>
						 -->
						<div class="notice_btn"><a href="javascript:void(0)">신규등록</a></div>
					</div>
				</div>	
			</div>
			
			
		</div>
		<!--contents 영역 종료-->
		
		<!--main pop up-->
		<div id="w01" class="easyui-window" title="공지사항" data-options="modal:true,closed:true,iconCls:'icon-save'" style="width:970px;height:601px;padding:0px;display:block;">
			<div class="pop_con">
				<form name="frm" id="frm" method="post" enctype="multipart/form-data">
				<table class="pop_tbl">
					<colgroup>
						<col width="160px"/>
						<col width="295px"/>
						<col width="160px"/>
						<col width="295px"/>
					</colgroup>
					<tr>
						<td class="t_head">작성자</td>
						<td>${sessionScope.userInfo.USER_NAME}</td>
						<td class="t_head">작성일자</td>
						<td class="writedDate"></td>
					</tr>
					<tr>
						<td class="t_head">연락처</td>
						<td colspan="3" class="pdl15">
							<input type="text" class="tbl_input" name="USER_TEL" id="USER_TEL"/>
						</td>
					</tr>
					<tr>
						<td class="t_head">제목 *</td>
						<td colspan="3" class="pdl15">
							<input type="text" class="tbl_input" placeholder="제목을 입력해 주세요." name="NOTICE_TITLE" id="NOTICE_TITLE"/>
						</td>
					</tr>
					<tr>
						<td class="t_head hi175">내용 *</td>
						<td class="hi175 pdl15" colspan="3" >
							<textarea class="tbl_area" placeholder="내용을 입력해 주세요." name="NOTICE_TEXT" id="NOTICE_TEXT"></textarea>
						</td>
					</tr>
					<tr>
						<td class="t_head">파일첨부</td>
						<td colspan="3" class="pdl15">
							<ul class="file_form">
							</ul>
						</td>
					</tr>
					<tr>
						<td class="t_head"></td>
						<td colspan="3"></td>
					</tr>
				</table>
				</form>
				<div class="btn_box over_hide mgt20 mgb30 wd205">
					<a href="javascript:void(0);" class="main_pop_close wd100 float_l mgr5 mgt0">취소</a>
					<a href="javascript:void(0);" class="pop_choice wd100 float_l saveNotice">저장하기</a>
				</div>
			</div>
		</div>
		<c:import url="/inc/footer_base.jsp" />
	</div>
</body>
</html>