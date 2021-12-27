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
		getPracticeChangeList();	


		$('#gridList').on('click', '.setGridFn', function() {
			location.href = '/begin/practiceChangeList?CHNG_ID='+$(this).data('chng_id');
		});
			
    });

	

	//search param
	var _CLASS_ID = "";
	
	function getPracticeChangeList(index) {

		_CLASS_ID = "${CLASS_ID}";

		var params = {
				'class' : 'service.BeginService',
				'method' : 'getPracticeChangeList',
				'param' : {
					'CLASS_ID' : _CLASS_ID
				},
				'callback' : function(data){
					if(data.success){
						loadingStop();
												
						$('#gridList .items').remove();
						
						var _html = '';
						if(data.list.length > 0) {
							$.each(data.list, function(index, item) {

								_html += '<tr class="items" data-chng_id="'+item.CHNG_ID+'">'+
								'<td>'+item.NO+'</td>'+
								'<td>'+item.CD_CHNG_STATE+'</td>'+
								'<td>'+item.CHNG_DATE+'</td>'+
								
								'<td><a href="javascript:void(0);" class="reply_btn setGridFn" data-class_id="'+item.CLASS_ID+'">보기</a></td>'+
								'<td class="t_left">'+item.CLASS_NOTE+'</td>'+
							'</tr>';

							});
						} else {
							_html += '<tr class="items"><td colspan="5">등록된 데이터가 없습니다.</td></tr>';
						}

						//console.log(_html);

						$('#gridList').append(_html);
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
					<span class="nav">개강보고</span>
					<span class="nav">실습</span>
					<span class="nav">변경이력</span>
				</div>
				<div class="sub_box">
					<div class="sub_menu">
						<div class="sub_title">개강보고</div>
						<div class="sub_list">
							<ul>
								<li><a href="/begin/logicList">이론/실기</a></li>
								<li class="sub_on"><a href="/begin/practiceList">실습</a></li>
								<li><a href="/begin/subPracticeList">대체실습</a></li>
							</ul>
						</div>
					</div>
					<div class="sub_con">
						<!--conBox-->
						<div class="conBox">
							<div class="con_title">
								${sessionScope.userInfo.AGC_NAME} / 
								<span class="con_sub_title_ty2"><span>${CLASS_TITLE}</span> 정보 변경 이력</span>
							</div>
							<div class="con_form">
								<table class="tbl_ty2" id="gridList">
									<colgroup>
										<col width="80px"/>
										<col width="150px"/>
										<col width="150px"/>
										<col width="150px"/>
										<col width="430px"/>
									</colgroup>
									<tr>
										<td>순번</td>
										<td>구분</td>
										<td>일자</td>
										<td>정보 보기</td>
										<td>비고</td>
									</tr>
								</table>
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
