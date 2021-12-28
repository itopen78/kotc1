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
					<span class="nav">교수요원</span>
					<span class="nav">변경이력</span>
				</div>
				<div class="sub_box">
					<div class="sub_menu">
						<div class="sub_title">교육기관</div>
						<div class="sub_list">
							<ul>
								<li><a href="">기관정보</a></li>
								<li class="sub_on"><a href="">교수요원</a></li>
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
								화면설계 교육기관 / 
								<span class="con_sub_title_ty2"><span>김기관장</span> 정보 변경 이력</span>
							</div>
							<div class="con_form">
								<table class="tbl_ty2">
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
									<tr>
										<td>1</td>
										<td>등록 신청</td>
										<td>2020-10-01</td>
										<td><a href="#" class="reply_btn">보기</a></td>
										<td class="t_left">신규 채용으로 교수요원 등록 신청합니다.</td>
									</tr>
									<tr>
										<td>2</td>
										<td>등록 반려</td>
										<td>2020-10-02</td>
										<td><a href="#" class="reply_btn">보기</a></td>
										<td class="t_left">자격증이 잘 못된 파일입니다.</td>
									</tr>
									<tr>
										<td>3</td>
										<td>등록 신청</td>
										<td>2020-10-03</td>
										<td><a href="#" class="reply_btn">보기</a></td>
										<td class="t_left">정상적인 자격증 파일을 업로드 했습니다.</td>
									</tr>
									<tr>
										<td>4</td>
										<td>등록 승인</td>
										<td>2020-10-04</td>
										<td><a href="#" class="reply_btn">보기</a></td>
										<td class="t_left">승인이 완료 되었습니다.</td>
									</tr>
									<tr>
										<td>5</td>
										<td>변경 신청</td>
										<td>2020-10-05</td>
										<td><a href="#" class="reply_btn">보기</a></td>
										<td class="t_left">담당과목 변경으로 변경신청 합니다.</td>
									</tr>
									<tr>
										<td>6</td>
										<td>변경 반려</td>
										<td>2020-10-06</td>
										<td><a href="#" class="reply_btn">보기</a></td>
										<td class="t_left">해당 담당과목을 강의 할 자격이 불충분합니다.</td>
									</tr>
									<tr>
										<td>7</td>
										<td>변경 신청</td>
										<td>2020-10-07</td>
										<td><a href="#" class="reply_btn">보기</a></td>
										<td class="t_left">자격요건 충족하여 변경신청 합니다.</td>
									</tr>
									<tr>
										<td>8</td>
										<td>변경 승인</td>
										<td>2020-10-08</td>
										<td><a href="#" class="reply_btn">보기</a></td>
										<td class="t_left">승인이 완료 되었습니다.</td>
									</tr>
									<tr>
										<td>9</td>
										<td>삭제 신청</td>
										<td>2020-10-09</td>
										<td><a href="#" class="reply_btn">보기</a></td>
										<td class="t_left">퇴사로 삭제합니다.</td>
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
