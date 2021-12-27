<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>테스트페이지</title>
	<sec:csrfMetaTags />
	<script src='/assets/js/jquery-3.4.1.min.js'></script>
	<script src='/assets/js/kotc.js'></script>
	<script src="/assets/js/jquery.twbsPagination.js"></script>
	<script type="text/javascript">
	$(document).ready(function() {
		getSubAgencyList(1);
		
		//연계실습기관 변경신청 리스트 이동
		$('#subAgency_list').on('dblclick', 'tr', function() {
			
		});
		
		$('#subAgency_list').on('click', '.setSubAgencyBtn', function() {
			location.href = '/edu/subAgencyWrite?SUB_AGC_ID='+$(this).data('sub_agc_id');
		});
		
		$('#subAgency_list').on('click', '.removeSubAgencyBtn', function() {
			if(!confirm('해당 연계실습기관정보를 삭제 하시겠습니까?')) {
				return false;
			}
			
			var params = {
					'class' : 'eduMapper',
					'method' : 'removeSubAgency',
					'param' : {'SUB_AGC_ID' : $(this).data('sub_agc_id')},
					'callback' : function(data){
						if(data.success){
							loadingStop();
							getSubAgencyList(1);
						}
					}
			};
			apiCall(params);
		});
	});
	
	var _page_index = 1;
	var _page_size = 10;
	var _page_total = 1;
	var _navigation = null;
	var _click_first = false;
	
	function getSubAgencyList(index) {
		_page_index = index;
		var params = {
				'class' : 'service.EduService',
				'method' : 'getSubAgencyList',
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
							    first : "&laquo;",	// 페이지네이션 버튼중 처음으로 돌아가는 버튼에 쓰여 있는 텍스트
							    prev : "&lsaquo;",	// 이전 페이지 버튼에 쓰여있는 텍스트
							    next : "&rsaquo;",	// 다음 페이지 버튼에 쓰여있는 텍스트
							    last : "&raquo;",	// 페이지네이션 버튼중 마지막으로 가는 버튼에 쓰여있는 텍스트
							    nextClass : "page-item next",	// 이전 페이지 CSS class
							    prevClass : "page-item prev",	// 다음 페이지 CSS class
							    lastClass : "page-item last",	// 마지막 페이지 CSS calss
							    firstClass : "page-item first",	// 첫 페이지 CSS class
							    pageClass : "page-item",	// 페이지 버튼의 CSS class
							    activeClass : "active",	// 클릭된 페이지 버튼의 CSS class
							    disabledClass : "disabled",	// 클릭 안된 페이지 버튼의 CSS class
							    anchorClass : "page-link",	//버튼 안의 앵커에 대한 CSS class
							    onPageClick: function (event, page) {
							    	_click_first = !_click_first;
							    	if(_click_first){
										getSubAgencyList(page);
							    	}
							    }
							});
						} else {
							$(".pagination").twbsPagination('changeTotalPages', _page_total, _page_index);
						}
						
						$('#subAgency_list').empty();
						var _html = '';
						if(data.list.length > 0) {
							$.each(data.list, function(index, item) {
								_html += '<tr data-sub_agc_id="'+item.SUB_AGC_ID+'">'
									_html += '<td>'+item.NO+'</td>'
									_html += '<td>'+item.SUB_AGC_ROLE_CODE_NAME+'</td>'
									_html += '<td>'+item.SUB_AGC_NAME+'</td>'
									_html += '<td>'+item.SUB_AGC_BOSS_TEL+'</td>'
									_html += '<td>'+item.TERM_SDATE+' ~ '+item.TERM_EDATE+'</td>'
									_html += '<td>'+item.SUB_AGC_STATUS_NAME+'</td>'
									_html += '<td>'+(item.CHNG_SUB_AGC_STATUS_NAME != null ? item.CHNG_SUB_AGC_STATUS_NAME : '-')+'</td>'
									_html += '<td>'+item.LAST_APPROVE_DATE+'</td>'
									_html += '<td>'
										_html += '<a href="javascript:void(0);" class="setSubAgencyBtn" data-sub_agc_id="'+item.SUB_AGC_ID+'">변경</a>'
										_html += '&nbsp;&nbsp;&nbsp;'
										_html += '<a href="javascript:void(0);" class="removeSubAgencyBtn" data-sub_agc_id="'+item.SUB_AGC_ID+'">삭제</a>'
									_html += '</td>'
								_html += '</tr>'
							});
						} else {
							_html += '<tr><td colspan="9">등록된 데이터가 없습니다.</td></tr>'
						}

						$('#subAgency_list').append(_html);
					}
				}
		};
		apiCall(params);
	}
	</script>
</head>
<body>
	<table>
		<thead>
			<tr>
				<th>순번</th>
				<th>시설구분</th>
				<th>시설명</th>
				<th>대표전화</th>
				<th>계약기간</th>
				<th>등록처리상태</th>
				<th>변경처리상태</th>
				<th>최종처리일자</th>
				<th>변경및삭제</th>
			</tr>
		</thead>
		<tbody id="subAgency_list">
		</tbody>
	</table>
	
	<nav aria-label="Page navigation">
		<ul class="pagination justify-content-center"></ul>
	</nav>

<a href="/edu/subAgencyWrite">신규등록</a>
</body>
</html>