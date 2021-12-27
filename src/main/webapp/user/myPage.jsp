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
    	
    });	
    
    function changeInfo() {
    	var pwRule = /^(?=.*[a-zA-Z])((?=.*\d)|(?=.*\W)).{6,20}$/;
		var newPw = $('#USER_PASSWORD');
		var newPwConfirm = $('#USER_PASSWORD_CONFIRM');
		
		/* if(newPw.val() == '') {
			alert('비밀번호를 입력해주세요.');
			return;
		}else if(!pwRule.test(newPw.val())) {
			newPw.focus();
			alert('비밀번호는 영문, 숫자, 특수문자를 혼합하여 8 ~ 20자리 이내로 입력해주세요.');
			return;
		}else if(newPw.val() != newPwConfirm.val()){
			newPwConfirm.focus();
			alert('비밀번호가 일치하지 않습니다.');
			return;
		} */
    	
    	var params = {
				'class' : 'service.UserService',
				'method' : 'setUserInfo',
				'param' : {
					'USER_PASSWORD' : $('#USER_PASSWORD').val(),
					'USER_TEL' 		: $('#USER_TEL').val(),
					'USER_ID' 		: '${sessionScope.userInfo.USER_ID}'
				},
				'callback' : function(data){
					loadingStop();
					
					if(data.success){
						location.href = '/';
					}else{
						
					}
				}
		};
		apiCall(params);
    }
    
    $(document).on("keyup", "#USER_TEL", function() {
    	$(this).val($(this).val().replace(/[^0-9]/g, "").replace(/(^02|^0505|^1[0-9]{3}|^0[0-9]{2})([0-9]+)?([0-9]{4})/, "$1-$2-$3").replace("--", "-"));
    })
    </script>
    
    <style>
		input {
		  border: 1px solid gray;
		}    

		input:read-only {
		  background-color: #E5E5E5;
		}    
    </style>
    
</head>
<body>
	<div id="wrap">
		<!--page_up 공통-->
		<div class="upBtn">
			<img src="/assets/images/up_btn.png"/>
		</div>
		<!--header 공통-->
		<c:import url="/inc/header_base.jsp" />
		<!--header 공통 종료-->
		
		<div class="contents">
			<div class="sub_form">
				<div class="sub_navi">
					<span class="home_navi"><img src="/assets/images/home_icon.png"/></span>
					<span class="nav">마이페이지</span>
				</div>
				<div class="sub_box">
					<div class="sub_menu">
						<div class="sub_title">마이페이지</div>
						<div class="sub_list">
							<ul>
								<li class="sub_on"><a href="">마이페이지</a></li>
								<li><a href="">회원정보</a></li>
							</ul>
						</div>
					</div>
					<div class="sub_con">
						<!--conBox-->
						<div class="conBox">
							<div class="con_title">마이페이지</div>
							<div class="con_form">
								<table class="tbl_ty1">
									<colgroup>
										<col width="180px"/>
										<col width="780px"/>
									</colgroup>
									<tr>
										<td class="t_head">
											<span class="star">*</span>교육기관 지정코드
										</td>
										<td>${sessionScope.userInfo.AGC_SERIAL}</td>
									</tr>
									<tr>
										<td class="t_head">
											<span class="star">*</span>아이디
										</td>
										<td>${sessionScope.userInfo.USER_ID}</td>
									</tr>
									<tr>
										<td class="t_head">
											<span class="star">*</span>비밀번호
										</td>
										<td class="pdl15 pdr15 ">
											<input type="password" class="tbl_pass wd300" id="USER_PASSWORD" name="USER_PASSWORD"/>
										</td>
									</tr>
									<tr>
										<td class="t_head">
											<span class="star">*</span>비밀번호 확인
										</td>
										<td class="pdl15 pdr15 ">
											<input type="password" class="tbl_pass wd300" id="USER_PASSWORD_CONFIRM" name="USER_PASSWORD_CONFIRM"/>
										</td>
									</tr>
									<tr>
										<td class="t_head">
											<span class="star">*</span>이름
										</td>
										<td>${sessionScope.userInfo.USER_NAME}</td>
									</tr>
									<tr>
										<td class="t_head">
											<span class="star">*</span>휴대전화번호
										</td>
										<td class="pdl15 pdr15 ">
											<input type="text" class="tbl_input wd300" value="${sessionScope.userInfo.USER_TEL}" id="USER_TEL" name="USER_TEL" maxlength="13"/>
										</td>
									</tr>
								</table>
								
								<div class="main_btn">
									<ul class="wd285 pdb210">
										<li class="page_back mgr5 wd140"><a href="/">취소</a></li>
										<li class="page_ok wd140"><a href="javascript:void(0)" onclick="changeInfo();">저장</a></li>
									</ul>
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
