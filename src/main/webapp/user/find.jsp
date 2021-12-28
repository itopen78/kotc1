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
    <link rel="stylesheet" type="text/css" href="/assets/css/easyui.css">
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
	<script type="text/javascript" src="/assets/js/login.js"></script>
	<script type="text/javascript" src="/assets/js/jquery.easyui.min.js"></script>
		
    <!-- ================== END BASE JS ================== -->
	
	<script>
	
	$(document).ready(function() {
		$('.tab_list li').click(function(){
			if($(this).text() == '아이디 찾기'){
				$('#con2 input').val('');
			}else if($(this).text() == '비밀번호 찾기'){
				$('#con1 input').val('');
			}
		});
    });
	
	
	function findId() {
		$('#changePw input').val('');
		
		var params = {
				'session' : false,
				'class'	: 'service.UserService',
				'method': 'findId',
				'param' : {
					'AGC_SERIAL' : $('#AGC_SERIAL1').val(),
					'USER_NAME'	 : $('#USER_NAME1').val(),
					'USER_TEL' 	 : $('#USER_TEL1').val()
				},
				'callback' : function(data){
					loadingStop();
					
					if(data.success && data.userInfo != "NoData"){
						var str = '입력하신 정보와 일치하는 아이디는<br>' + '[' + data.userId + '] 입니다.';
						$('#findId .resultTxt').html(str);
						$('#findId').window('open');
					}else if(data.success && data.userInfo == "NoData"){
						var str = '입력하신 정보와 일치하는 아이디가 없습니다.';
						$('#findId .resultTxt').html(str);
						$('#findId').window('open');
					}
				}
			};
		apiCall(params);
	}
	
	function findPw() {
		$('#changePw input').val('');
		
		var params = {
				'session' : false,
				'class'	: 'service.UserService',
				'method': 'findPw',
				'param' : {
					'AGC_SERIAL' : $('#AGC_SERIAL2').val(),
					'USER_ID'	 : $('#USER_ID2').val(),
					'USER_NAME'	 : $('#USER_NAME2').val(),
					'USER_TEL' 	 : $('#USER_TEL2').val()
				},
				'callback' : function(data){
					loadingStop();
					
					if(data.success && data.userInfo != "NoData"){
						$('#changePw').window('open');
					}else if(data.success && data.userInfo == "NoData"){
						var str = '입력하신 정보와 일치하는 계정이 없습니다.';
						$('#findPw .resultTxt').html(str);
						$('#findPw').window('open');
					}
				}
			};
		apiCall(params);
	}	
	
	function changePw() {
		var pwRule = /^(?=.*[a-zA-Z])((?=.*\d)|(?=.*\W)).{6,20}$/;
		var newPw = $('#newPw');
		var newPwConfirm = $('#newPwConfirm');
		
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
				'session' : false,
				'class'	: 'service.UserService',
				'method': 'setUserInfo',
				'param' : {
					'USER_PASSWORD' : $('#newPw').val(),
					'USER_ID'		: $('#USER_ID2').val()
				},
				'callback' : function(data){
					loadingStop();
					
					if(data.success){
						$('#changePw').window('close');
						var str = '비밀번호가 변경되었습니다.';
						$('#findPw .resultTxt').html(str);
						$('#findPw').window('open');
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
		<div class="login_logo">
			<img src="/assets/images/logo.png"/>
		</div>
		<div class="contents">
			<div class="login_title">아이디/비밀번호 찾기</div>
			<div class="find_form">
				<div class="tab-contents">
					<ul class="tab_list">
						<li data-id="con1" class="on">아이디 찾기</li>
						<li data-id="con2">비밀번호 찾기</li>
					</ul>
					<div id="con1" class="conBox on">
						<div class="find_input">
							<input type="text" class="code_box" placeholder="*교육기관 지정코드" id="AGC_SERIAL1" name="AGC_SERIAL"/>
							<input type="text" class="name_box" placeholder="*이름" id="USER_NAME1" name="USER_NAME"/>
							<input type="number" class="phone_box" placeholder="*휴대전화번호" id="USER_TEL1" name="USER_TEL" maxlength="11" oninput="numberMaxLength(this)"/>
						</div>
						<div class="id_btn">
							<div class="id_find" onclick="findId();">아이디 찾기</div>
							<div class="login_btn"><a href="/user/login">로그인하기</a></div>
						</div>
					</div>
					<div id="con2" class="conBox ">
						<div class="find_input">
							<input type="text" class="code_box" placeholder="*교육기관 지정코드" id="AGC_SERIAL2" name="AGC_SERIAL"/>
							<input type="text" class="id_box" placeholder="*아이디" id="USER_ID2" name="USER_ID"/>
							<input type="text" class="name_box" placeholder="*이름" id="USER_NAME2" name="USER_NAME"/>
							<input type="number" class="phone_box" placeholder="*휴대전화번호" id="USER_TEL2" name="USER_TEL" maxlength="11" oninput="numberMaxLength(this)"/>
						</div>
						<div class="pass_btn">
							<div class="pass_find" onclick="findPw();">비밀번호 찾기</div>
							<div class="login_btn"><a href="/user/login">로그인하기</a></div>
						</div>
					</div>
				</div>
			</div>
		</div>
		
		<!--아이디 찾기 팝업-->
		<div id="findId" class="easyui-window" title="아이디 찾기" data-options="modal:true,closed:true,iconCls:'icon-save'" style="width:540px;height:312px;padding:0px;">
			<div class="pop_con">
				<div class="pop_txt resultTxt">
				</div>
			</div>
		</div>
		
		<!--비밀번호 변경 팝업-->
		<div id="changePw" class="easyui-window" title="비밀번호 변경" data-options="modal:true,closed:true,iconCls:'icon-save'" style="width:540px;height:312px;padding:0px;">
			<div class="pop_con">
				<div class="pass_input">
					<input type="password" placeholder="*비밀번호" id="newPw" name="newPw"/>
					<input type="password" placeholder="*비밀번호 확인" id="newPwConfirm"/>
				</div>
				<div class="pass_change"><a href="javascript:void(0)" onclick="changePw();">비밀번호 변경</a></div>
			</div>
		</div>
		<div id="findPw" class="easyui-window" title="비밀번호  변경" data-options="modal:true,closed:true,iconCls:'icon-save'" style="width:540px;height:312px;padding:0px;">
			<div class="pop_con">
				<div class="pop_txt resultTxt">
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