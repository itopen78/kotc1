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
					<li class="step_list">
						<div class="step_check"><img src="/assets/images/step_check.png"/></div>
						<div class="step_txt">약관동의</div>
					</li>
					<li class="step_list">
						<div class="step_check"><img src="/assets/images/step_check.png"/></div>
						<div class="step_txt">정보입력</div>
					</li>
					<li class="step_list step_on">
						<div class="step_num">3</div>
						<div class="step_txt">가입완료</div>
					</li>
				</ul>
			</div>
			<div class="join_ok_form">
				<div class="join_ok_box">
					<ul class="ok_text">
						<li><span>${USER_NAME}</span>님 경기도요양보호사양성관리시스템의</li>
						<li>회원에 가입되셨습니다.</li>
					</ul>
					<div class="login_btn"><a href="/user/login">로그인</a></div>
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