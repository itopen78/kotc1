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
    var CLASS_ID = '${CLASS_ID}';
    
	$(document).ready(function() {
		getSubAgencyDeatil();
    });
	
	function getSubAgencyDeatil() {
		if(CLASS_ID == null || CLASS_ID == '') {
			return false;
		}
		
		var params = {
				'class' : 'endMapper',
				'method' : 'getEndClassDetail',
				'param' : {'CLASS_ID' : CLASS_ID},
				'callback' : function(data){
					if(data.success){
						loadingStop();
						var view = data.view;
						
						$('#CLASS_TITLE').text(view.CLASS_TITLE);
						getHisEndClassList();
					}
				}
		};
		apiCall(params);
	}

	//search param
	
	function getHisEndClassList(index) {
		if(CLASS_ID == null || CLASS_ID == '') {
			return false;
		}
		
		var params = {
				'class' : 'endMapper',
				'method' : 'getHisEndClassList',
				'param' : {
					'CLASS_ID' : CLASS_ID
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
								
											'<td><a href="/end/hisEndClassDetail?CHNG_ID='+item.CHNG_ID+'&CLASS_ID='+item.CLASS_ID+'" class="reply_btn">보기</a></td>'+
											'<td class="t_left">'+item.CLASS_NOTE+'</td>'+
										'</tr>';

							});
						} else {
							_html += '<tr class="items"><td colspan="5">등록된 데이터가 없습니다.</td></tr>';
						}

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
					<span class="nav">수료보고</span>
					<span class="nav">수료보고</span>
					<span class="nav">변경 이력</span>
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
							<div class="con_title">
								${sessionScope.userInfo.AGC_NAME} / 
								<span class="con_sub_title_ty2"><span ID="CLASS_TITLE"></span> 정보 변경 이력</span>
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
