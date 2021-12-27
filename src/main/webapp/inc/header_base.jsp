<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!--page_up 공통-->
<div class="upBtn">
	<img src="/assets/images/up_btn.png"/>
</div>
<!--header 공통-->
<div class="header">
	<div class="hd_form">
		<ul class="hd_con">
			<li class="bi_box">
				<ul class="bi_fl">
					<li class="bi_img">
						<img src="/assets/images/bi.png"/>
					</li>
					<li class="user_info">
						<span class="header_star">*</span>
						<span class="user_name">${sessionScope.userInfo.USER_NAME}</span>
						<span class="info_txt">님 환영합니다</span>
					</li>
				</ul>
			</li>
			<li class="logo_box">
				<a href="/"><img src="/assets/images/logo.png"/></a>
			</li>
			<li class="info_box">
				<ul>
					<li>
						<a href="/">HOME</a>
					</li>
					<li>
						<a href="/logout.do">로그아웃</a>
					</li>
					<li>
						<a href="/user/myPage">마이페이지</a>
					</li>
				</ul>
			</li>
		</ul>
	</div>
	<div class="gnav">
		<div class="gnav_con">
			<ul class="gnav_list">
				<li><a>교육기관</a></li>
				<li><a>사업계획서</a></li>
				<li><a>개강보고</a></li>
				<li><a>수료보고</a></li>
				<li><a>합격자</a></li>
			</ul>
		</div>
		<div class="menu_form">
			<ul class="menu_con">
				<li class="menu_box">
					<ul>
						<li>
							<c:choose>
								<c:when test="${sessionScope.userInfo.ADMIN_YN eq 'Y'}">
									<a href="/edu/agencyList">기관정보</a>
								</c:when>
								<c:otherwise>
									<a href="/edu/agencyWrite?AGC_ID=${sessionScope.userInfo.AGC_ID}">기관정보</a>
								</c:otherwise>
							</c:choose>
						</li>
						<li><a href="/edu/agentList">교수요원</a></li>
						<li><a href="/edu/subAgencyList">연계실습기관</a></li>
						<li><a href="/edu/subAgentList">실습지도자</a></li>
						<li><a href="/edu/studentList">교육생</a></li>
						<li><a href="/edu/selfCheckList">자체점검</a></li>
					</ul>
				</li>
				<li class="menu_box">
					<ul>
						<li><a href="/biz/businessPlanList">사업계획서 제출</a></li>
					</ul>
				</li>
				<li class="menu_box">
					<ul>
						<li><a href="/begin/logicList">이론/실기</a></li>
						<li><a href="/begin/practiceList">실습</a></li>
						<li><a href="/begin/subPracticeList">대체실습</a></li>
					</ul>
				</li>
				<li class="menu_box">
					<ul>
						<li><a href="/end/endClassList">수료보고</a></li>
					</ul>
				</li>
				<li class="menu_box">
					<ul>
						<li><a href="/license/studentList">대상자 조회</a></li>
					</ul>
				</li>
			</ul>
		</div>
	</div>
</div>
<!--header 공통 종료-->