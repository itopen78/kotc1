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
    var AGC_ID = '${AGC_ID}';
    $(document).ready(function() {
    	getAgencyDeatil();
    });
    
    function getAgencyDeatil() {
		if(AGC_ID == null || AGC_ID == '') {
			return false;
		}
		
		var params = {
				'class' : 'eduMapper',
				'method' : 'getAgencyDetail',
				'param' : {'AGC_ID' : AGC_ID},
				'callback' : function(data){
					if(data.success){
						loadingStop();
						var view = data.view;
						$('#AGC_NAME').text(view.AGC_NAME);
						getHisAgencyList();
					}
				}
		};
		apiCall(params);
	}
    
    function getHisAgencyList() {
		if(AGC_ID == null || AGC_ID == '') {
			return false;
		}
		
		var params = {
				'class' : 'eduMapper',
				'method' : 'getHisAgencyList',
				'param' : {'AGC_ID' : AGC_ID},
				'callback' : function(data){
					if(data.success){
						loadingStop();
						
						$('#hisAgencyList .items').remove();
						var _html = '';
						if(data.list.length > 0) {
							$.each(data.list, function(index, item) {
								_html += '<tr class="items" data-chng_id="'+item.CHNG_ID+'">'
									_html += '<td>'+(index+1)+'</td>'
									_html += '<td>'+item.CD_CHNG_STATE_NAME+'</td>'
									_html += '<td>'+item.CHNG_DATE+'</td>'
									_html += '<td><a href="/edu/hisAgencyDetail?CHNG_ID='+item.CHNG_ID+'" class="reply_btn">보기</a></td>'
									_html += '<td class="t_left">'+item.AGC_NOTE+'</td>'
								_html += '</tr>'
							});
						} else {
							_html += '<tr class="items"><td colspan="5">등록된 데이터가 없습니다.</td></tr>'
						}

						$('#hisAgencyList').append(_html);
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
					<span class="nav">기관정보</span>
					<span class="nav">변경이력</span>
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
							<div class="con_title">
								기관정보 / 
								<span class="con_sub_title_ty2"><span id="AGC_NAME"></span> 정보 변경 이력</span>
							</div>
							<div class="con_form">
								<table class="tbl_ty2" id="hisAgencyList">
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
