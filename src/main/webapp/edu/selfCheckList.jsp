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
		getSelfCheckList(1);
		
		$('#pageSize').on('change', function() {
			getSelfCheckList(1);
		});
		
		$('.searchSelfCheckBtn').on('click', function() {
			getSelfCheckList(1);
		});
		
		$('#frm').on('change', 'input[name=selfCheckFile]', function() {
			var fileName = '';
			if($(this)[0].files.length > 0) {
				fileName = $(this)[0].files[0].name;
			}
			$('#frm #selfCheckFile_text').text(fileName);
		});
		
		$('.addSelfCheck').on('click', function() {
			var date = new Date();
			var WRITED_DATE = date.getFullYear() + '-' + ('0'+(date.getMonth()+1)).slice(-2) + '-' + ('0'+date.getDate()).slice(-2);
			$('#WRITED_DATE').text(WRITED_DATE);
			
			$('.file_form').empty();
			var _html = '';
			_html += '<li>'
				_html += '<div class="file_box">'
					_html += '<input type="text" readonly onclick="$(\'#selfCheckFile\').trigger(\'click\')" />'
					_html += '<input type="file" name="selfCheckFile" id="selfCheckFile"/>'
				_html += '</div>'
			_html += '</li>'
			_html += '<li class="filesText" id="selfCheckFile_text"></li>'
			$('.file_form').append(_html);
			
			$('#w01').window('open');
		});
		
		$('#selfCheckList').on('click', '.removeSelfCheckBtn', function() {
			var CHECK_ID = $(this).data('check_id');
			
			if(!confirm('삭제 하시겠습니까?')) {
				return false;
			}
			
			var params = {
					'class' : 'eduMapper',
					'method' : 'removeSelfCheck',
					'param' : {'CHECK_ID' : CHECK_ID
					},
					'callback' : function(data){
						if(data.success){
							loadingStop();
							getSelfCheckList(1);
						}
					}
			};
			apiCall(params);
		});
		
		$('.selfCheckSave').on('click', function() {
			if($('input[name=CHECK_TITLE]').val() == '') {
				alert('성명을 입력해주세요.');
				$('input[name=CHECK_TITLE]').focus();
				return false;	
			}
			
			if(!confirm('저장 하시겠습니까?')) {
				return false;
			}
			
			var formData = new FormData($('#frm')[0]);
			
			$.ajax({
	            url : '/edu/selfCheckSave',
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
	            		getSelfCheckList(1);
	            	}
	            },
	            error:function(request,status,error){
	                alert("code : " + request.status + "\n" + "error:" + error);
	            }
	        });
		});
	});
	
	var _page_index = 1;
	var _page_size = 20;
	var _page_total = 1;
	var _navigation = null;
	var _click_first = false;
	
	function getSelfCheckList(index) {
		_page_index = index;
		_page_size = parseInt($('#pageSize').val());
		var params = {
				'class' : 'service.EduService',
				'method' : 'getSelfCheckList',
				'param' : {
					'CHECK_TITLE' : $('#CHECK_TITLE').val(),
					'START_WRITED_DATE' : $('#START_WRITED_DATE').val(),
					'END_WRITED_DATE' : $('#END_WRITED_DATE').val(),
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
							    		getSelfCheckList(page);
							    	}
							    }
							});
						} else {
							$(".pagination").twbsPagination('changeTotalPages', _page_total, _page_index);
						}
						
						$('#selfCheckList .items').remove();
						var _html = '';
						if(data.list.length > 0) {
							$.each(data.list, function(index, item) {
								_html += '<tr class="items" data-check_id="'+item.CHECK_ID+'">'
									_html += '<td>'+item.NO+'</td>'
									_html += '<td>'+item.AGC_NAME+'</td>'
									_html += '<td>'+item.WRITED_DATE+'</td>'
									_html += '<td>'
										if(item.ID_PK != null && item.ID_PK != '') {
											_html += '<a href="javascript:void(0);" class="tbl_link getFileDown" data-original_file_name="'+item.ORIGINAL_FILE_NAME+'" data-server_file_name="'+item.SERVER_FILE_NAME+'">'+item.ORIGINAL_FILE_NAME+'</a>'
										}
									_html += '</td>'
									_html += '<td>'+item.CHECK_TITLE+'</td>'
									_html += '<td>'+item.USER_NAME+'</td>'
									_html += '<td><a href="javascript:void(0);" class="delete_btn removeSelfCheckBtn" data-check_id="'+item.CHECK_ID+'">삭제</a></td>'
								_html += '</tr>'
							});
						} else {
							_html += '<tr class="items"><td colspan="7">등록된 데이터가 없습니다.</td></tr>'
						}

						$('#selfCheckList').append(_html);
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
					<span class="nav">자체점검</span>
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
								<li><a href="">교육생</a></li>
								<li class="sub_on"><a href="">자체점검</a></li>
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
										<col width="445px"/>
										<col width="225px"/>
										<col width="230px"/>
									</colgroup>
									<tr>
										<td>교육기관명</td>
										<td colspan="2">작성일자</td>
									</tr>
									<tr>
										<td>
											<input type="text" class="tbl_input" id="CHECK_TITLE" />
										</td>
										<td>
											<input type="date" class="tbl_date" id="START_WRITED_DATE"/>
										</td>
										<td>
											<input type="date" class="tbl_date" id="END_WRITED_DATE"/>
										</td>
									</tr>
									
								</table>
								
								<div class="btn_box mgt15"><a href="javascript:void(0);" class="btn_center wd100 searchSelfCheckBtn">검색</a></div>
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
								<table class="tbl_ty2" id="selfCheckList">
									<colgroup>
										<col width="90px"/>
										<col width="120px"/>
										<col width="120px"/>
										<col width="200px"/>
										<col width="200px"/>
										<col width="110px"/>
										<col width="100px"/>
									</colgroup>
									<tr>
										<td>순번</td>
										<td>교육기관명</td>
										<td>작성일자</td>
										<td>첨부파일</td>
										<td>제목</td>
										<td>작성자</td>
										<td>삭제</td>
									</tr>
								</table>
								<div class="btn_box">
									<a class="btn_right wd100 addSelfCheck" href="javascript:void(0)">신규등록</a>									
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
		
		<!--자체점검표 등록 팝업-->
		<div id="w01" class="easyui-window" title="자체점검표 등록" data-options="modal:true,closed:true,iconCls:'icon-save'" style="width:610px;height:374px;padding:0px;">
			<div class="pop_con">	
				<form id="frm" name="frm" method="post" enctype="multipart/form-data"> 
				<table class="tbl_ty1">
					<colgroup>
						<col width="160px"/>
						<col width="390px"/>
					</colgroup>
					<tr>
						<td class="t_head">교육기관명</td>
						<td class="pdl20">${sessionScope.userInfo.AGC_NAME}</td>
					</tr>
					<tr>
						<td class="t_head">작성일자</td>
						<td class="pdl20" id="WRITED_DATE"></td>
					</tr>
					<tr>
						<td class="t_head">첨부파일</td>
						<td class="pdl20">
							<ul class="file_form pdl0">
							</ul>
						</td>
					</tr>
					<tr>
						<td class="t_head">제목</td>
						<td class="pdl15"><input type="text" class="tbl_input" name="CHECK_TITLE"/></td>
					</tr>
				</table>
				</form>
				<div class="btn_box mgb30">
					<a href="javascript:void(0);" class="btn_center wd100" onclick="$('#w01').window('close');">닫기</a>
					<a href="javascript:void(0);" class="btn_center wd100 selfCheckSave">저장</a>
				</div>
			</div>
		</div>
		
		<c:import url="/inc/footer_base.jsp" />
	</div>
</body>
</html>