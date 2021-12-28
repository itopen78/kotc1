<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <c:import url="/inc/main_base.jsp" />

	<script type="text/javascript">
	$(document).ready(function() {
		
	});
	</script>
</head>
<body>
	<div id="wrap">
		<!--page_up 공통-->
		<div class="upBtn">
			<img src="/assets/images/up_btn.png"/>
		</div>
		<c:import url="/inc/header_base.jsp" />
		
		<!--contents 영역-->
		<div class="contents">
			<div class="banner_form">
				<div class="banner_box">
					<div class="banner_con">
						<ul>
							<li class="banner_txt">경기도 요양보호사 합격자 바로가기</li>
							<li class="banner_sub">Care worker Educate Management System</li>
							<li class="banner_btn">
								<a href="#">바로가기</a>
							</li>
						</ul>
					</div>
				</div>
			</div>
			
			<div class="main_notice">
				<div class="notice_form">
					<div class="con_title">주요알림</div>
					<ul class="notice_con">
						<a href="" class="notice_box">
							<div class="notice_title">교수등원 등록 및 변경 신청</div>
							<div class="notice_total">
								<ul>
									<li>
										<span class="total_num">7</span>
										<span class="total_txt">신청</span>
									</li>
									<li>
										<span class="total_num">58</span>
										<span class="total_txt">처리중</span>
									</li>
									<li>
										<span class="total_num">29</span>
										<span class="total_txt">완료</span>
									</li>
								</ul>
								
							</div>
						</a>
						<a href="" class="notice_box">
							<div class="notice_title">실습지도자 등록 및 변경 신청</div>
							<div class="notice_total">
								<ul>
									<li>
										<span class="total_num">12</span>
										<span class="total_txt">신청</span>
									</li>
									<li>
										<span class="total_num">27</span>
										<span class="total_txt">처리중</span>
									</li>
									<li>
										<span class="total_num">25</span>
										<span class="total_txt">완료</span>
									</li>
								</ul>
							</div>
						</a>
						<a href="" class="notice_box">
							<div class="notice_title">사업계획서 제출</div>
							<div class="notice_total">
								<ul>
									<li>
										<span class="total_num">9</span>
										<span class="total_txt">승인</span>
									</li>
									<li>
										<span class="total_num">0</span>
										<span class="total_txt">반려</span>
									</li>
								</ul>
							</div>
						</a>
						<a href="" class="notice_box">
							<div class="notice_title">개강보고</div>
							<div class="notice_total">
								<ul>
									<li>
										<span class="total_num">16</span>
										<span class="total_txt">신청</span>
									</li>
									<li>
										<span class="total_num">56</span>
										<span class="total_txt">처리중</span>
									</li>
									<li>
										<span class="total_num">15</span>
										<span class="total_txt">완료</span>
									</li>
								</ul>
							</div>
						</a>
						<a href="" class="notice_box">
							<div class="notice_title">자격증 신청</div>
							<div class="notice_total">
								<ul>
									<li>
										<span class="total_num">99</span>
										<span class="total_txt">신청</span>
									</li>
									<li>
										<span class="total_num">99</span>
										<span class="total_txt">처리중</span>
									</li>
									<li>
										<span class="total_num">99</span>
										<span class="total_txt">완료</span>
									</li>
								</ul>
							</div>
						</a>
						<a href="" class="notice_box">
							<div class="notice_title">연계실습기관 등록 및 변경 신청</div>
							<div class="notice_total">
								<ul>
									<li>
										<span class="total_num">6</span>
										<span class="total_txt">신청</span>
									</li>
									<li>
										<span class="total_num">65</span>
										<span class="total_txt">처리중</span>
									</li>
									<li>
										<span class="total_num">60</span>
										<span class="total_txt">완료</span>
									</li>
								</ul>
							</div>
						</a>
						<a href="" class="notice_box">
							<div class="notice_title">자체점검</div>
							<div class="notice_total">
								<ul>
									<li>
										<span class="total_num">56</span>
										<span class="total_txt">신청</span>
									</li>
									<li>
										<span class="total_num">24</span>
										<span class="total_txt">처리중</span>
									</li>
									<li>
										<span class="total_num">60</span>
										<span class="total_txt">완료</span>
									</li>
								</ul>
							</div>
						</a>
						<a href="" class="notice_box">
							<div class="notice_title">수료보고</div>
							<div class="notice_total">
								<ul>
									<li>
										<span class="total_num">9</span>
										<span class="total_txt">신청</span>
									</li>
									<li>
										<span class="total_num">30</span>
										<span class="total_txt">처리중</span>
									</li>
									<li>
										<span class="total_num">50</span>
										<span class="total_txt">완료</span>
									</li>
								</ul>
							</div>
						</a>
					</ul>
				</div>
			</div>
			
			<div class="sub_notice">
				<div class="notice_form">
					<div class="con_title">공지사항</div>
					
					<div class="notice_con">
						<ul class="notice_box">
							<a href="" class="notice_tbl new_type">
								<div class="notice_row">
									<div class="notice_cell">
										<span class="notice_title">관리시스템 오픈 및 이용안내</span>
										<span class="notice_new">New</span>
									</div>
									<div class="notice_cell"><span class="sub_title">관리시스템 오픈 및 이용안내</span></div>
									<div class="notice_cell"><span class="notice_date">2020.08.10</span></div>
								</div>
							</a>
							
							<a href="" class="notice_tbl new_type">
								<div class="notice_row">
									<div class="notice_cell">
										<span class="notice_title">사업계획서 제출 방법</span>
										<span class="notice_new">New</span>
									</div>
									<div class="notice_cell"><span class="sub_title">사업계획서 제출 방법</span></div>
									<div class="notice_cell"><span class="notice_date">2020.08.10</span></div>
								</div>
							</a>
							
							<a href="" class="notice_tbl">
								<div class="notice_row">
									<div class="notice_cell">
										<span class="notice_title">교육기관 관리자 등록 방법</span>
										
									</div>
									<div class="notice_cell"><span class="sub_title">교육기관 관리자 등록 방법</span></div>
									<div class="notice_cell"><span class="notice_date">2020.08.10</span></div>
								</div>
							</a>
							
							<a href="" class="notice_tbl">
								<div class="notice_row">
									<div class="notice_cell">
										<span class="notice_title">담당자 연락처</span>
									</div>
									<div class="notice_cell"><span class="sub_title">담당자 연락처</span></div>
									<div class="notice_cell"><span class="notice_date">2020.08.10</span></div>
								</div>
							</a>
						</ul>
						
						<div class="notice_btn"><a href="">신규등록</a></div>
					</div>
				</div>	
			</div>
			
			
		</div>
		<!--contents 영역 종료-->
		
		<!--main pop up-->
		<div id="w01" class="easyui-window" title="공지사항" data-options="modal:true,iconCls:'icon-save'" style="width:970px;height:601px;padding:0px;display:block;">
			<div class="pop_con">
				<table class="pop_tbl">
					<colgroup>
						<col width="160px"/>
						<col width="295px"/>
						<col width="160px"/>
						<col width="295px"/>
					</colgroup>
					<tr>
						<td class="t_head">작성자</td>
						<td>홍길동</td>
						<td class="t_head">작성일자</td>
						<td>YYYY-MM-DD HH24:MI:SS</td>
					</tr>
					<tr>
						<td class="t_head">연락처</td>
						<td colspan="3">010-0000-0000</td>
					</tr>
					<tr>
						<td class="t_head">제목 *</td>
						<td colspan="3">관리시스템 오픈 및 이용안내</td>
					</tr>
					<tr>
						<td class="t_head hi175">내용 *</td>
						<td class="hi175" colspan="3">관리시스템 오픈 및 이용안내</td>
					</tr>
					<tr>
						<td class="t_head">파일첨부</td>
						<td colspan="3"><a href="" class="pop_down" >사용설명서.pdf</a></td>
					</tr>
					<tr>
						<td class="t_head"></td>
						<td colspan="3"></td>
					</tr>
				</table>
				<div class="main_pop_close">
					닫기
				</div>
			</div>
		</div>
		<c:import url="/inc/footer_base.jsp" />
	</div>
</body>
</html>