<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8" />
	<meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=yes'>
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<title>경기도 요양관리사 양성 관리시스템 로그인</title>
    <meta name="_csrf" content="${_csrf.token}"/>
	<meta name="_csrf_header" content="${_csrf.headerName}"/>
	
	<!-- styles -->
    <link rel="stylesheet" href="/assets/css/common.css">
	<link rel="stylesheet" href="/assets/css/login.css">
    
    <!-- ================== BEGIN BASE JS ================== -->
    <script src="/assets/plugins/jquery/jquery-1.9.1.min.js"></script>
	<script src="/assets/plugins/jquery/jquery-migrate-1.1.0.min.js"></script>
	<script src="/assets/plugins/jquery-ui/ui/minified/jquery-ui.min.js"></script>
	<script src="/assets/plugins/bootstrap/js/bootstrap.min.js"></script>
    <script src="/assets/plugins/pace/pace.min.js"></script>
    <script src="/assets/plugins/slimscroll/jquery.slimscroll.min.js"></script>
	<script src="/assets/plugins/jquery-cookie/jquery.cookie.js"></script>
	<script src="/assets/js/kotc.js"></script>
	<script src="/assets/js/login.js"></script>
		
    <!-- ================== END BASE JS ================== -->

	<script>
		var _checked_id = null;
	
		function lookup() {
			if($('#USER_ID').val() == ''){
				$('#USER_ID').focus();
    			alert('아이디를 입력해주세요.');
			}else{
				var params = {
						'session' : false,
						'class'	: 'service.UserService',
						'method': 'lookup',
						'param' : {'USER_ID' : $('#USER_ID').val()},
						'callback' : function(data){
							if(data.success){
								
								console.log(data);
								
								loadingStop();
								if(data.result > 0){
									alert("이미 사용중인 아이디입니다.");
								}else{
									_checked_id = $('#USER_ID').val();
									alert("사용할 수 있는 아이디입니다.");
								}
							}else{
								alert("메세지 : " + data.message);
							}
						}
					};
				console.log(params);
				
				apiCall(params);
			}
		}
		
		function signup(){
			
    		var pw = $("#USER_PASSWORD").val();
  	   		var pwRule = /^(?=.*[a-zA-Z])((?=.*\d)|(?=.*\W)).{6,20}$/;
    		
  	   		if($('#AGC_SERIAL').val() == ''){
	  	   		$('#AGC_SERIAL').focus();
	  	   		alert('교육기관 지정코드를 입력해주세요.');
	  	   		return;
		   	}
  	   		
  	   		if($('#USER_ID').val() == ''){
	   			$('#USER_ID').focus();
	   			alert('아이디를 입력해주세요.');
	   			return;
	   		}
  	   		
	  	   	if(pw == ''){
	   			$('#USER_PASSWORD').focus();
		   		alert('비밀번호를 입력해주세요.');
		   		return;
		   	}else if(!pwRule.test(pw)){
	  	   		$('#USER_PASSWORD').focus();
	  	   		alert('비밀번호는 영문, 숫자, 특수문자를 혼합하여 8 ~ 20자리 이내로 입력해주세요.');
	  	   		return;
  	   		}else if(pw != $('#USER_PASSWORD_CONFIRM').val()){
	   			$('#USER_PASSWORD_CONFIRM').focus();
	   			alert('비밀번호를 확인하십시오.');
	   			return;
		   	}
	  	   	
  	   		if($('#USER_NAME').val() == ''){
	   			$('#USER_NAME').focus();
	   			alert('이름을 입력해주세요.');
	   			return;
		   	}
  	   		
  	   		if($('#USER_TEL').val() == ''){
	   			$('#USER_TEL').focus();
	   			alert('휴대전화번호를 입력해주세요.');
	   			return;
  	   		}
  	   		
	  	   	if(_checked_id != $('#USER_ID').val()){
	   			alert('아이디 중복확인이 필요합니다.');
	   			return;
	   		}
  	   		
 			var params = {
  	   				'session' : false,
					'class' : 'service.UserService',
					'method' : 'signup',
					'param' : {
						'AGC_SERIAL' 	: $('#AGC_SERIAL').val(),
						'USER_ID' 		: $('#USER_ID').val(),
						'USER_PASSWORD' : $('#USER_PASSWORD').val(),
						'USER_NAME' 	: $('#USER_NAME').val(),
						'USER_TEL' 		: $('#USER_TEL').val()
					},
					'callback' : function(data){
						if(data.success){
							loadingStop();
							location.href = '/user/joinComplete?USER_NAME='+ $('#USER_NAME').val();
						}else{
							alert("메세지 : " + data.message);
						}
					}
			};
				
 			apiCall(params);
		} 
		
		function numberMaxLength(obj) {
			if(obj.value.length > obj.maxLength) {
				obj.value = obj.value.slice(0, obj.maxLength);
			}
		}
		
	</script>
</head>

<body>
	<div id="wrap">
		<div class="login_logo mgt40">
			<img src="/assets/images/logo.png"/>
		</div>
		<div class="contents">
			<div class="step_box">
				<ul>
					<li class="step_list ">
						<div class="step_check"><img src="/assets/images/step_check.png"/></div>
						<div class="step_txt">약관동의</div>
					</li>
					<li class="step_list step_on">
						<div class="step_num">2</div>
						<div class="step_txt">정보입력</div>
					</li>
					<li class="step_list">
						<div class="step_num">3</div>
						<div class="step_txt">가입완료</div>
					</li>
				</ul>
			</div>
			<div class="join_insert">
				<div class="insert_box">
					<div class="code_box">
						<input type="text" placeholder="*교육기관 지정코드" id="AGC_SERIAL" name="AGC_SERIAL"/>
					</div>
					<div class="id_box">
						<input type="hidden" id="chkd_id" name="chkd_id">
						<ul>
							<li class="id_insert"><input type="text" placeholder="*아이디" id="USER_ID" name="USER_ID"/></li>
							<li class="id_check"><div class="id_check_btn" onclick="lookup();">중복확인</div></li>
						</ul>
					</div>
					<div class="pass_box">
						<input type="password" placeholder="*비밀번호" id="USER_PASSWORD" name="USER_PASSWORD"/>
					</div>
					<div class="pass_box">
						<input type="password" placeholder="*비밀번호 확인" id="USER_PASSWORD_CONFIRM"/>
					</div>
					<div class="name_box">
						<input type="text" placeholder="*이름" id="USER_NAME" name="USER_NAME"/>
					</div>
					<div class="phone_box">
						<input type="number" placeholder="*휴대전화번호" id="USER_TEL" name="USER_TEL" maxlength="11" oninput="numberMaxLength(this)"/>
					</div>
				</div>
				
				<div class="terms_btn">
					<ul>
						<li class="prev_btn"><a href="/user/joinTerms">취소</a></li>
						<li class="next_btn"><a href="javascript:void(0)" onclick="signup();">다음</a></li>
					</ul>
				</div>
			</div>
		</div>
		
		<div class="footer_ty2">
			<div class="footer_form">
				<div class="footer_logo">
					<img src="/assets/images/footer_logo02.jpg"/>
				</div>
				<div class="footer_info">
					<ul>
						<li>경기도청 16444 수원구 팔달구 효원로1(매산로3가)  북부청사 11780 의정부 청사로 1</li>
						<li>Copyright© 2020 BY Care worker Educate Management System. ALL RIGHTS RESERVED. </li>
					</ul>
				</div>
			</div>
		</div>
	</div>
</body>
</html>