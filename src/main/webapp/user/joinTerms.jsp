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
	
		function checkTerms(){
			if($('#terms_check1').is(':checked') == false) {
				alert("이용약관에 동의해주십시오.");
				return;
			}
			if($('#terms_check2').is(':checked') == false) {
				alert("개인정보처리방침에 동의해주십시오.");
				return;
			}
			location.href = '/user/joinUs';
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
					<li class="step_list step_on">
						<div class="step_num">1</div>
						<div class="step_txt">약관동의</div>
					</li>
					<li class="step_list">
						<div class="step_num">2</div>
						<!--<div class="step_check"><img src="../images/step_check.png"/></div>-->
						<div class="step_txt">정보입력</div>
					</li>
					<li class="step_list">
						<div class="step_num">3</div>
						<div class="step_txt">가입완료</div>
					</li>
				</ul>
			</div>
			<div class="terms_form">
				<div class="terms_con">
					<div class="terms_title">서비스 약관</div>
					<div class="terms_box">
						<div class="terms_txt">
							<div class="con_t">제1조 – 목적</div>
							<div class="con_s">
								① 경기도요양보호사양성관리시스템 서비스 약관(이하 “본 약관”이라 합니다)은 이용자가 경기도청 노인복지과 (이하 “노인복지과”라 합니다)에서 제공하는 인터넷 
							관련 서비스(이하 “서비스”라 합니다)를 이용함에 있어 이용자와 “노인복지과”의 권리·의무 및 책임사항을 규정함을 목적으로 합니다.<br>
							② 이용자가 되고자 하는 자가 “노인복지과”가 정한 소정의 절차를 거쳐서 “확인” 단추를 누르면 본 약관에 동의하는 것으로 간주합니다.
							</div>
						</div>
						
						<div class="terms_txt">
							<div class="con_t">제1조 – 목적</div>
							<div class="con_s">
								① 경기도요양보호사양성관리시스템 서비스 약관(이하 “본 약관”이라 합니다)은 이용자가 경기도청 노인복지과 (이하 “노인복지과”라 합니다)에서 제공하는 인터넷 
							관련 서비스(이하 “서비스”라 합니다)를 이용함에 있어 이용자와 “노인복지과”의 권리·의무 및 책임사항을 규정함을 목적으로 합니다.<br>
							② 이용자가 되고자 하는 자가 “노인복지과”가 정한 소정의 절차를 거쳐서 “확인” 단추를 누르면 본 약관에 동의하는 것으로 간주합니다.
							</div>
						</div>
						
						<div class="terms_txt">
							<div class="con_t">제1조 – 목적</div>
							<div class="con_s">
								① 경기도요양보호사양성관리시스템 서비스 약관(이하 “본 약관”이라 합니다)은 이용자가 경기도청 노인복지과 (이하 “노인복지과”라 합니다)에서 제공하는 인터넷 
							관련 서비스(이하 “서비스”라 합니다)를 이용함에 있어 이용자와 “노인복지과”의 권리·의무 및 책임사항을 규정함을 목적으로 합니다.<br>
							② 이용자가 되고자 하는 자가 “노인복지과”가 정한 소정의 절차를 거쳐서 “확인” 단추를 누르면 본 약관에 동의하는 것으로 간주합니다.
							</div>
						</div>
						

					</div>
					<div class="terms_check ">
						<input type="checkbox" id="terms_check1"/><label for="terms_check1">이용약관에 동의합니다.</label>
					</div>
				</div>
				
				<div class="terms_con">
					<div class="terms_title">개인정보처리방침</div>
					<div class="terms_box">
						<div class="terms_txt">
							<div class="con_t">제1조 – 목적</div>
							<div class="con_s">
								① 경기도요양보호사양성관리시스템 서비스 약관(이하 “본 약관”이라 합니다)은 이용자가 경기도청 노인복지과 (이하 “노인복지과”라 합니다)에서 제공하는 인터넷 
							관련 서비스(이하 “서비스”라 합니다)를 이용함에 있어 이용자와 “노인복지과”의 권리·의무 및 책임사항을 규정함을 목적으로 합니다.<br>
							② 이용자가 되고자 하는 자가 “노인복지과”가 정한 소정의 절차를 거쳐서 “확인” 단추를 누르면 본 약관에 동의하는 것으로 간주합니다.
							</div>
						</div>
						
						<div class="terms_txt">
							<div class="con_t">제1조 – 목적</div>
							<div class="con_s">
								① 경기도요양보호사양성관리시스템 서비스 약관(이하 “본 약관”이라 합니다)은 이용자가 경기도청 노인복지과 (이하 “노인복지과”라 합니다)에서 제공하는 인터넷 
							관련 서비스(이하 “서비스”라 합니다)를 이용함에 있어 이용자와 “노인복지과”의 권리·의무 및 책임사항을 규정함을 목적으로 합니다.<br>
							② 이용자가 되고자 하는 자가 “노인복지과”가 정한 소정의 절차를 거쳐서 “확인” 단추를 누르면 본 약관에 동의하는 것으로 간주합니다.
							</div>
						</div>
						
						<div class="terms_txt">
							<div class="con_t">제1조 – 목적</div>
							<div class="con_s">
								① 경기도요양보호사양성관리시스템 서비스 약관(이하 “본 약관”이라 합니다)은 이용자가 경기도청 노인복지과 (이하 “노인복지과”라 합니다)에서 제공하는 인터넷 
							관련 서비스(이하 “서비스”라 합니다)를 이용함에 있어 이용자와 “노인복지과”의 권리·의무 및 책임사항을 규정함을 목적으로 합니다.<br>
							② 이용자가 되고자 하는 자가 “노인복지과”가 정한 소정의 절차를 거쳐서 “확인” 단추를 누르면 본 약관에 동의하는 것으로 간주합니다.
							</div>
						</div>
						

					</div>
					<div class="terms_check ">
						<input type="checkbox" id="terms_check2"/><label for="terms_check2">이용약관에 동의합니다.</label>
					</div>
				</div>
				
				<div class="terms_btn">
					<ul>
						<li class="prev_btn"><a href="/user/login">취소</a></li>
						<li class="next_btn"><a href="javascript:void(0)" onclick="checkTerms();">다음</a></li>
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