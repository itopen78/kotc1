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
							<div class="con_title">교육기관정보</div>
							<div class="con_form">
								<table class="tbl_ty1">
									<colgroup>
										<col width="160px"/>
										<col width="295px"/>
										<col width="160px"/>
										<col width="295px"/>
									</colgroup>
									<tr>
										<td class="t_head">교육기관 명칭</td>
										<td>화면설계 교육기관</td>
										<td class="t_head">대표명</td>
										<td>김대표</td>
									</tr>
									<tr>
										<td class="t_head">법인명</td>
										<td>화면설계 법인</td>
										<td class="t_head">기관장</td>
										<td>김기관장</td>
									</tr>
									<tr>
										<td class="t_head">등록일자</td>
										<td>2020-08-10 17:23:22</td>
										<td class="t_head">대표 연락처</td>
										<td>010-0000-0001</td>
									</tr>
									<tr>
										<td class="t_head">최종변경일자</td>
										<td>2020-08-10 17:23:22</td>
										<td class="t_head">기관장 연락처</td>
										<td>010-0000-0001</td>
									</tr>
									<tr>
										<td class="t_head">교육기관 지정코드</td>
										<td>AAA-BBB-000000</td>
										<td class="t_head">도청 담당자</td>
										<td>김도청</td>
									</tr>
									<tr>
										<td class="t_head">법인등록번호</td>
										<td>111111-1111111</td>
										<td class="t_head">지역구분</td>
										<td>남부</td>
									</tr>
									<tr>
										<td class="t_head">소재지 주소(도로명)</td>
										<td colspan="3">경기도 수원시 팔달구 000로 1A동 101호</td>
									</tr>
									<tr>
										<td class="t_head">우편번호</td>
										<td colspan="3">000-000</td>
									</tr>
								</table>
							</div>
						</div>
						<!--conBox end-->
						
						<!--conBox-->
						<div class="conBox">
							<div class="con_title">교육기관정보 <a href="" class="title_btn wd100">사무원 추가</a></div>

							<div class="con_form mgt10">
								<table class="tbl_ty2">
									<colgroup>
										<col width="80px"/>
										<col width="120px"/>
										<col width="120px"/>
										<col width="180px"/>
										<col width="310px"/>
										<col width="100px"/>
									</colgroup>
									<tr>
										<td>순번</td>
										<td>직책</td>
										<td>이름</td>
										<td>전화번호</td>
										<td>비고</td>
										<td>삭제</td>
									</tr>
									<tr>
										<td>1</td>
										<td>과장</td>
										<td>김과장</td>
										<td>010-0000-0000</td>
										<td class="t_left pdl50">- 김과장 비고</td>
										<td>
											<a href="#" class="delete_btn">삭제</a>
										</td>
									</tr>
									<tr>
										<td>2</td>
										<td>대리</td>
										<td>김대리</td>
										<td>010-0000-0000</td>
										<td class="t_left pdl50">- 김대리 비고</td>
										<td>
											<a href="#" class="delete_btn">삭제</a>
										</td>
									</tr>
								</table>

								<div class="btn_box"><a href="" class="btn_center wd100">사무원 추가</a></div>
								
								
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
