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
    var _AGC_ID = '${sessionScope.userInfo.AGC_ID}';  //세션 교육기관 코드
    
	$(document).ready(function() {
		initPage();
		
		getEndClassList(1);
		
		$('#pageSize').on('change', function() {
			getEndClassList(1);
		});
		
		$('.searchBtn').on('click', function() {
			getEndClassList(1);
		});
		
		//수료보고 변경 이력 페이지
		$('#endClassList').on('dblclick', '.items', function() {
    		location.href='/end/hisEndClassList?CLASS_ID='+$(this).data('class_id');
    	});
		
		//변경
		$('#endClassList').on('click', '.changeBtn', function() {
			location.href = '/end/endClassWrite?CLASS_ID='+$(this).data('class_id')+'&AGC_ID='+$(this).data('agc_id');
		});
		
		//삭제
		$('#endClassList').on('click', '.removeBtn', function() {
			if(!confirm('해당 수료보고를 삭제 요청 하시겠습니까?')) {
				return false;
			}
			
			var params = {
					'class' : 'service.EndService',
					'method' : 'removeEndClass',
					'param' : {'CLASS_ID' : $(this).data('class_id')},
					'callback' : function(data){
						if(data.success){
							loadingStop();
							getEndClassList(1);
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

	function initPage()
	{
		//경기도청 인 경우  : 교육기관 검색조건 추가
		if ( _AGC_ID !="1")
		{
			$('.schTb tr > *:nth-child(1)').hide();
		} 
		// 아닌경우

	}

	var gRowId = null;
	var gAgcId = "";
	
	function SetBackgroundColor(rowId) 
	{		
	   	if ( gRowId != null && $(gRowId).css("background-color")=="rgb(235, 240, 249)")
	  	{
	   		$(gRowId).css("background-color", "rgba(0, 0, 0, 0)");
		}

   		$(rowId).css("background-color", "rgb(235, 240, 249)");
   		gAgcId = $(rowId).data('agc_id');
   		
	   	gRowId = rowId;
	   
	}
	
	function getEndClassList(index) {

		_AGC_NAME = $('#AGC_NAME').val();
		_S_WRITED_DATE = $('#S_WRITED_DATE').val();
		_E_WRITED_DATE = $('#E_WRITED_DATE').val();
		_CLASS_TITLE = $('#CLASS_TITLE').val();
		_S_CHNG_DATE = $('#S_CHNG_DATE').val();
		_E_CHNG_DATE = $('#E_CHNG_DATE').val();
				
		_page_index = index;
		_page_size = parseInt($('#pageSize').val());
		var params = {
				'class' : 'service.EndService',
				'method' : 'getEndClassList',
				'param' : {
					'AGC_NAME' : _AGC_NAME,
					'S_WRITED_DATE' : _S_WRITED_DATE,
					'E_WRITED_DATE' : _E_WRITED_DATE,
					'CLASS_TITLE' : _CLASS_TITLE,
					'S_CHNG_DATE' : _S_CHNG_DATE,
					'E_CHNG_DATE' : _E_CHNG_DATE,
					
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
							    		getEndClassList(page);
							    	}
							    }
							});
						} else {
							$(".pagination").twbsPagination('changeTotalPages', _page_total, _page_index);
						}
						
						$('#endClassList .items').remove();
						var _html = '';
						if(data.list.length > 0) {
							$.each(data.list, function(index, item) {
								_html += '<tr class="items" data-class_id="'+item.CLASS_ID+'"  data-agc_id="'+item.AGC_ID+'" onclick="SetBackgroundColor(this)">'+
											'<td>'+item.NO+'</td>'+
											'<td>'+item.AGC_NAME+'</td>'+
											'<td>'+item.WRITED_DATE+'</td>'+
											'<td class="t_left" data-class_title="'+item.CLASS_TITLE+'">'+item.CLASS_TITLE+'</td>'+
											'<td>'+item.USER_NAME+'</td>'+
											'<td>'+item.CHNG_DATE+'</td>'+
											'<td>'+
												'<ul class="tbl_btn">'+
													'<li><a href="javascript:void(0);" class="reply_btn changeBtn" data-class_id="'+item.CLASS_ID+'"  data-agc_id="'+item.AGC_ID+'" >변경</a></li>'+
													'<li><a href="javascript:void(0);" class="delete_btn removeBtn" data-class_id="'+item.CLASS_ID+'">삭제</a></li>'+
												'</ul>'+
											'</td>'+
										'</tr>';
							});
						} else {
							_html += '<tr class="items"><td colspan="7">등록된 데이터가 없습니다.</td></tr>';
						}

						$('#endClassList').append(_html);
						
						if ( _AGC_ID !="1")
						{
							$('#endClassList tr > *:nth-child(2)').hide();	
							$('#endClassList tr > *:nth-child(5)').css("width","300px");
						} 
						
					}
				}
		};
		apiCall(params);
	}
	
	function exportExcel() {
		var excelData = {
				'flag' : 'endClassList',
				'WRITED_DATE' : $('#WRITED_DATE').val(),
				'CLASS_TITLE' : $('#CLASS_TITLE').val(),
				'USER_NAME' : $('#USER_NAME').val(),
				'CHNG_DATE' : $('#CHNG_DATE').val()
		}
		submitForm('/end/endClassToExcel', excelData);
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
					<span class="nav">수료보고</span>
					<span class="nav">수료보고</span>
				</div>
				<div class="sub_box">
					<div class="sub_menu">
						<div class="sub_title">수료보고</div>
						<div class="sub_list">
							<ul>
								<li class="sub_on"><a href="/end/endClassList">수료보고</a></li>
							</ul>
						</div>
					</div>
					<div class="sub_con">
						<!--conBox-->
						<div class="conBox">
							<div class="con_title">검색조건</div>
							<div class="con_form">
								<table class="tbl_ty3 schTb">
									<tr>
										<td>교육기관</td>
										<td colspan="2">작성일자</td>
										<td>제목</td>
										<td colspan="2">최종변경일자</td>
									</tr>
									<tr>
										<td>
											<input type="text" class="tbl_input wd80" id="AGC_NAME" name="AGC_NAME"/>
										</td>
										<td>
											<input type="date" class="tbl_date wd145" id="S_WRITED_DATE" name="S_WRITED_DATE"/>
										</td>
										<td>
											<input type="date" class="tbl_date wd145" id="E_WRITED_DATE" name="E_WRITED_DATE"/>
										</td>
										<td>
											<input type="text" class="tbl_input wd130" id="CLASS_TITLE" name="CLASS_TITLE"/>
										</td>
										<td>
											<input type="date" class="tbl_date wd145" id="S_CHNG_DATE" name="S_CHNG_DATE"/>
										</td>
										<td>
											<input type="date" class="tbl_date wd145" id="E_CHNG_DATE" name="E_CHNG_DATE"/>
										</td>
									</tr>
									
								</table>
								
								<div class="btn_box mgt15"><a href="javascript:void(0);" class="btn_center wd100 searchBtn">검색</a></div>
							</div>
						</div>
						<!--conBox end-->
						
						<!--conBox-->
						<div class="conBox">
							<div class="con_title pdr10">
								수료 보고
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
								<table class="tbl_ty2" id="endClassList">
									<colgroup>
										<col width="70px"/>
										<col width="140px"/>
										<col width="290px"/>
										<col width="140px"/>
										<col width="110px"/>
										<col width="120px"/>
										<col width="110px"/>
									</colgroup>
									<tr>
										<td>순번</td>
										<td>교육기관</td>
										<td>작성일자</td>
										<td>제목</td>
										<td>작성자</td>
										<td>최종변경일자</td>
										<td>변경 및 삭제</td>
									</tr>
								</table>
								<div class="btn_box">
									<a href="javascript:void(0);" onclick="exportExcel();" class="btn_left wd130">파일로 내보내기</a>
									<a href="/end/endClassWrite" class="btn_right wd100 regBtn">신규등록</a>									
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
