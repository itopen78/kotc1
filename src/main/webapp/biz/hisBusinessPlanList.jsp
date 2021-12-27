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
    var PLAN_ID = '${PLAN_ID}';
	$(document).ready(function() {
		getBusinessPlanDetail();
	});
	
	function getBusinessPlanDetail() {
		if(PLAN_ID == null || PLAN_ID == '') {
			return false;
		}

		var params = {
				'class' : 'bizMapper',
				'method' : 'getBusinessPlanDetail',
				'param' : {'PLAN_ID' : PLAN_ID},
				'callback' : function(data){
					if(data.success){
						loadingStop();
						var view = data.view;
						$('#PLAN_TITLE').text(view.PLAN_TITLE);
						getHisBusinessPlanList();
					}
				}
		};
		apiCall(params);
	}
	
	function getHisBusinessPlanList() {
		if(PLAN_ID == null || PLAN_ID == '') {
			return false;
		}
		
		var params = {
				'class' : 'bizMapper',
				'method' : 'getHisBusinessPlanList',
				'param' : {'PLAN_ID' : PLAN_ID},
				'callback' : function(data){
					if(data.success){
						loadingStop();
						$('#hisBusinessPlanList .items').remove();
						var _html = '';
						if(data.list.length > 0) {
							$.each(data.list, function(index, item) {
								_html += '<tr class="items" data-chng_id="'+item.CHNG_ID+'">'
									_html += '<td>'+(index+1)+'</td>'
									_html += '<td>'+item.CD_CHNG_STATE_NAME+'</td>'
									_html += '<td>'+item.CHNG_DATE+'</td>'
									_html += '<td><a href="/biz/hisBusinessPlanDetail?CHNG_ID='+item.CHNG_ID+'" class="reply_btn">보기</a></td>'
									_html += '<td class="t_left">'+item.PLAN_NOTE+'</td>'
								_html += '</tr>'
							});
						} else {
							_html += '<tr class="items"><td colspan="5">등록된 데이터가 없습니다.</td></tr>'
						}

						$('#hisBusinessPlanList').append(_html);
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
					<span class="nav">변경이력</span>
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
							<div class="con_title">
								화면설계 교육기관 / 
								<span class="con_sub_title_ty2"><span id="PLAN_TITLE"></span> 정보 변경 이력</span>
							</div>
							<div class="con_form">
								<table class="tbl_ty2" id="hisBusinessPlanList">
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
