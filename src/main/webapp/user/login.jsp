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
		var SAVED_LOGIN_ID = "SAVED_LOGIN_ID";
		var SAVED_LOGIN_PASSWORD = "SAVED_LOGIN_PASSWORD";
	
		$(document).ready(function() {
			console.log(Args);
			if(localStorage[SAVED_LOGIN_ID]){
				$("#user_id").val(localStorage[SAVED_LOGIN_ID]);
				document.getElementById('remember_id').checked = true;
			}
			
			if(sessionStorage['MENU_LIST']){
				sessionStorage.removeItem('MENU_LIST');
			}
			
			if(Args.type){																			// 푸시메세지를 클릭해서 왔을 경우 정보를 입력 
				$("#type").val(Args.type);
			}
			if(Args.target){
				$("#target").val(Args.target);
			}
			
			if(Args.x == "locked"){
				alert('해당 계정은 관리자에 의해 접근이 금지되었습니다.\r\n관리자에게 문의해주세요.');
			}else if(Args.x == "denied"){
				alert('해당 IP는 관리자에 의해 접근이 금지되었습니다.\r\n관리자에게 문의해주세요.');
			}else if(Args.x == "denied"){
				alert('해당 IP는 관리자에 의해 접근이 금지되었습니다.\r\n관리자에게 문의해주세요.');
			}else if(Args.x == 'none' || Args.x == 'password' || Args.x == 'unknown'){
				alert('계정정보가 일치하지 않습니다.\r\n다시한번 확인해주세요.');
			}else{
				if(Args.is_auto == '1' && 														// 자동로그인이 설정되어 있고, 저장된 로그인정보가 있으면
						localStorage[SAVED_LOGIN_ID] && localStorage[SAVED_LOGIN_PASSWORD]){
					$("#user_id").val(localStorage[SAVED_LOGIN_ID]);							// 로그인정보 넣어주고
					$("#passwd").val(localStorage[SAVED_LOGIN_PASSWORD]);
					$("#loginForm").submit();
				}
			}
			
			$("#passwd").keyup(function(e) {
				if (e.keyCode == 13) {
					login();
				}
			});
		});
		
		function login(){
			if($("#user_id").val().length == 0){
				alert("아이디를 입력해주세요.");
			}else if($("#passwd").val().length == 0){
				alert("비밀번호를 입력해주세요.");
			}else{
				/* if(document.getElementById('remember_id').checked){
					localStorage[SAVED_LOGIN_ID] = $("#user_id").val();
				}else if(localStorage[SAVED_LOGIN_ID]){
					localStorage.removeItem(SAVED_LOGIN_ID);
				} */
				
				$("#app_login").val("1");															// 앱으로 로그인 했음을 설정
				if(Args.is_auto == '1'){															// 폰에서 자동로그인이 설정되어 있을 경우 id/pwd를 localStorage에 저장한다.
					localStorage[SAVED_LOGIN_ID] = $("#user_id").val();
					localStorage[SAVED_LOGIN_PASSWORD] = $("#passwd").val();
				}else{
					localStorage.removeItem(SAVED_LOGIN_ID);										// 자동로그인 정보 삭제
					localStorage.removeItem(SAVED_LOGIN_PASSWORD);
				}
				
				$("#loginForm").submit();
			}
		}

		function getRndKey(kinds){
			if(kinds == 'ID') var formName = 'findIdForm';
			else var formName = 'findPwForm';
			
			var name = $('#'+ formName +' #name').val();
			var email1 = $('#'+ formName +' #email1').val();
			var email2 = $('#'+ formName +' #email2').val();
			var userId = $('#'+ formName +' #userId').val();
			
			if(kinds == 'PW' && userId == ''){
				alertW("아이디를 입력해주세요.");
				return;
			}
			
			if(name == ''){
				alertW("이름을 입력해주세요.");
				return;
			}else if(email1 == '' || email2 == ''){
				alertW("이메일을 입력해주세요.");
				return;
			}
			
			var email = email1 + '@' + email2;
			var data = {
				"user_id" : userId,
				"name" : name,
				"email" : email
			};
			
			ajaxCall('/setRndKey', data , function(data){
				if (data.result == 'Y') {
   					alert('입력하신 메일로 인증번호를 발송하였습니다.');
   				}else {
   					alertW('존재하지 않는 정보입니다.');
   				}
   			});
		}
		
		function closeBtn(){
    		$('#findIdForm input, #findPwForm input').val("");
    		$('#find_idpw').modal('hide');
    	}
		
		function clickModal(){
			$('#result_id,#result_pw').hide();
			$('#findIdForm input, #findPwForm input').val("");
    	}
		
		function findInfo(kinds){
			if(kinds == 'ID') var formName = 'findIdForm';
			else var formName = 'findPwForm';

			var email1 = $('#'+ formName +' #email1').val();
			var email2 = $('#'+ formName +' #email2').val();
			var email = email1 + '@' + email2;
			
			var data = {
				"user_id" : $('#'+ formName +' #userId').val(),
				"name" : $('#'+ formName +' #name').val(),
				"email" : email,
				"cert_no" : $('#'+ formName +' #certKey').val()
			};
			
			if($('#'+ formName +' #certKey').val() == ''){
				alertW('인증번호를 입력해주세요.');
				return;
			}
			
			ajaxCall('/user/findInfo', data , function(data){
				if (data.result == 'Y' && data.type == 'identity') {
					$('#findId').text(data.userId);
					$('#result_id').show();
					$('.find_id .tbl-btm').hide();
   				}else if(data.result == 'Y' && data.type == 'passwd'){
   					$('#updateForm #userId').val(data.userId);
   					$('#rndKey1').text(data.rndKey);
   					$('#result_pw').show();
					$('.find_pw .tbl-btm').hide();
   				}else {
   					alertW(data.content);
   				}
   			});
		} 
		
		function updatePwBtn(){
			if($('#newPasswd').val() == ''){
				alertW('새 패스워드를 입력해주세요.');
				return;
			}else if($('#newPasswd').val() != $('#newPasswd1').val()){
				alertW('패스워드가 일치하지 않습니다.');
				return;
			}else if(chkPW() != true){
				return;
			}else if($('#rndKey1').text() != $('#rndKey').val()){
				alertW('보안코드가 일치하지 않습니다.');
				return;
			}
			
			var data = {
				"user_id" : $('#updateForm #userId').val(),
				"name" : $('#findPwForm #name').val(),
				"passwd": $('#updateForm #newPasswd').val()
 			}
			
			ajaxCall('/user/updateUser', data , function(data){
				if (data.result == 'Y') {
					alertW('비밀번호가 변경 되었습니다.');
					closeBtn();
   				}
   			});
		}
		
		function chkPW(){
	   		 var pw = $("#newPasswd").val();
	   		 var num = pw.search(/[0-9]/g);
	   		 var eng = pw.search(/[a-z]/ig);
	   		 var spe = pw.search(/[`~!@@#$%^&*|₩₩₩'₩";:₩/?]/gi);
	
	   		 if(pw.length < 8 || pw.length > 20){
	   			alertW("8자리 ~ 20자리 이내로 입력해주세요.");
	   		 	return false;
	   		 }else if(pw.search(/\s/) != -1){
	   			alertW("비밀번호는 공백 없이 입력해주세요.");
	   		  	return false;
	   		 }else if(num < 0 || eng < 0 || spe < 0 ){
	   			alertW("영문,숫자,특수문자를 혼합하여 입력해주세요.");
	   		  	return false;
	   		 }else {
	   		    return true;
	   		 }
  		}
	</script>
</head>

<body>
	<div id="wrap">
		<div class="login_logo">
			<img src="/assets/images/logo.png"/>
		</div>
		<div class="contents">
			<div class="login_title">통합 로그인 시스템</div>
			
				<form id="loginForm" action="/user/process" method="post">
		            <input type="hidden" id="${_csrf.parameterName}" name="${_csrf.parameterName}" value="${_csrf.token}" />
		            <input type="hidden" id="type" name="type" />
		            <input type="hidden" id="target" name="target" />
		            <input type="hidden" id="app_login" name="app_login" />
					<div class="login_form">
						<div class="login_id">
							<input type="text" placeholder="아이디"/ id="user_id" name="user_id" minlength="4" maxlength="25">
						</div>
						<div class="login_pass">
							<input type="password" placeholder="비밀번호"/ id="passwd" name="passwd" onEnter="login();">
						</div>
						<div class="login_btn">
							<a href="javascript:void(0);" onclick="login();">로그인하기</a>
						</div>
					</div>
				</form>	
					
					<div class="join_form">
						<div class="join_box">
							<ul class="join_con">
								<li class="join_txt">
									아이디가 없으신 분은 회원가입을 해주세요.
								</li>
								<li class="join_btn">
									<a href="/user/joinTerms">회원가입</a>
								</li>
							</ul>
							<ul class="join_con">
								<li class="join_txt">
									아이디 또는 비밀번호 찾기로 이동합니다.
								</li>
								<li class="join_btn">
									<a href="/user/find">아이디/비밀번호 찾기</a>
								</li>
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