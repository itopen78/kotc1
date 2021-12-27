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
							<div class="con_title">검색조건</div>
							<div class="con_form">
								<table class="tbl_ty3">
									<colgroup>
										<col width="100px"/>
										<col width="100px"/>
										<col width="140px"/>
										<col width="130px"/>
										<col width="130px"/>
										<col width="130px"/>
										<col width="130px"/>
									</colgroup>
									<tr>
										<td>구분</td>
										<td>성명</td>
										<td>연락처</td>
										<td>등록상태</td>
										<td>변경상태</td>
										<td colspan="2">최종승인</td>
									</tr>
									<tr>
										<td>
											<select class="tbl_select">
												<option>기관장</option>
												<option>전임</option>
												<option>왜래</option>
											</select>
										</td>
										<td>
											<input type="text" class="tbl_input" />
										</td>
										<td>
											<input type="text" class="tbl_input" />
										</td>
										<td>
											<select class="tbl_select">
												<option>등록 신청</option>
												<option>처리 중</option>
												<option>등록 승인</option>
												<option>등록 반려</option>
												<option>승인해제</option>
											</select>
										</td>
										<td>
											<select class="tbl_select">
												<option>변경신청</option>
												<option>삭제신청</option>
												<option>처리 중</option>
												<option>변경 승인</option>
												<option>변경 반려</option>
												<option>삭제</option>
											</select>
										</td>
										<td>
											<input type="date" class="tbl_date" />
										</td>
										<td>
											<input type="date" class="tbl_date" />
										</td>
									</tr>
									
								</table>
								
								<div class="btn_box mgt15"><a href="" class="btn_center wd100">검색</a></div>
							</div>
						</div>
						<!--conBox end-->
						
						<!--conBox-->
						<div class="conBox">
							<div class="con_title pdr10">
								교수요원
								<span class="con_sub_title">(총 : <span>00<span>명, 전임 : <span>00<span>명, 외래 : <span>00<span>명, 기타 : <span>00<span>명, )</span>
								<select class="title_select wd130 float_r">
									<option>10개씩 보기</option>
									<option>20개씩 보기</option>
									<option>30개씩 보기</option>
									<option>40개씩 보기</option>
									<option>50개씩 보기</option>
									<option>60개씩 보기</option>
									<option>70개씩 보기</option>
									<option>80개씩 보기</option>
									<option>90개씩 보기</option>
									<option>100개씩 보기</option>
								</select>
							</div>

							<div class="con_form mgt10">
								<table class="tbl_ty2">
									<colgroup>
										<col width="80px"/>
										<col width="90px"/>
										<col width="90px"/>
										<col width="140px"/>
										<col width="95px"/>
										<col width="95px"/>
										<col width="130px"/>
										<col width="130px"/>
										<col width="110px"/>
									</colgroup>
									<tr>
										<td>순번</td>
										<td>구분</td>
										<td>성명</td>
										<td>연락처</td>
										<td>등록상태</td>
										<td>변경상태</td>
										<td>최종승인일자</td>
										<td>변경 및 삭제</td>
										<td>공문</td>
									</tr>
									<tr>
										<td>1</td>
										<td>기관장</td>
										<td>김과장</td>
										<td>010-0000-0001</td>
										<td>등록 승인</td>
										<td>-</td>
										<td>2020-10-01</td>
										<td>
											<ul class="tbl_btn">
												<li><a href="#" class="reply_btn">변경</a></li>
												<li><a href="#" class="delete_btn">삭제</a></li>
											</ul>
										</td>
										<td>
											<a class="down_btn">다운로드</a>
										</td>
									</tr>
									<tr>
										<td>2</td>
										<td>전임</td>
										<td>김전임</td>
										<td>010-0000-0002</td>
										<td>처리 중</td>
										<td>-</td>
										<td>2020-10-02</td>
										<td>
											<ul class="tbl_btn">
												<li><div class="btn_off">변경</div></li>
												<li><a href="#" class="delete_btn">삭제</a></li>
											</ul>
										</td>
										<td>
											<a class="down_btn">다운로드</a>
										</td>
									</tr>
									<tr>
										<td>3</td>
										<td>외래</td>
										<td>김외래</td>
										<td>010-0000-0003</td>
										<td>등록 승인</td>
										<td>변경 신청</td>
										<td>2020-10-03</td>
										<td>
											<ul class="tbl_btn">
												<li><a href="#" class="reply_btn">변경</a></li>
												<li><a href="#" class="delete_btn">삭제</a></li>
											</ul>
										</td>
										<td>
											
										</td>
									</tr>
									<tr>
										<td>4</td>
										<td>전임</td>
										<td>김전임</td>
										<td>010-0000-0004</td>
										<td>등록 승인</td>
										<td>변경 승인</td>
										<td>2020-10-04</td>
										<td>
											<ul class="tbl_btn">
												<li><a href="#" class="reply_btn">변경</a></li>
												<li><a href="#" class="delete_btn">삭제</a></li>
											</ul>
										</td>
										<td>
											<a class="down_btn">다운로드</a>
										</td>
									</tr>
									<tr>
										<td>5</td>
										<td>전임</td>
										<td>김전임</td>
										<td>010-0000-0005</td>
										<td>반려</td>
										<td>-</td>
										<td>2020-10-05</td>
										<td>
											<ul class="tbl_btn">
												<li><a href="#" class="reply_btn">변경</a></li>
												<li><a href="#" class="delete_btn">삭제</a></li>
											</ul>
										</td>
										<td>
											
										</td>
									</tr>
									<tr>
										<td>6</td>
										<td>전임</td>
										<td>김전임</td>
										<td>010-0000-0006</td>
										<td>등록 승인</td>
										<td>변경 반려</td>
										<td>2020-10-06</td>
										<td>
											<ul class="tbl_btn">
												<li><a href="#" class="reply_btn">변경</a></li>
												<li><a href="#" class="delete_btn">삭제</a></li>
											</ul>
										</td>
										<td>
											<a class="down_btn">다운로드</a>
										</td>
									</tr>
									<tr>
										<td>7</td>
										<td>외래</td>
										<td>김외래</td>
										<td>010-0000-0007</td>
										<td>등록 승인</td>
										<td>변경 승인</td>
										<td>2020-10-07</td>
										<td>
											<ul class="tbl_btn">
												<li><a href="#" class="reply_btn">변경</a></li>
												<li><a href="#" class="delete_btn">삭제</a></li>
											</ul>
										</td>
										<td>
											
										</td>
									</tr>
									<tr>
										<td>8</td>
										<td>외래</td>
										<td>김외래</td>
										<td>010-0000-0008</td>
										<td>등록 승인</td>
										<td>변경 반려</td>
										<td>2020-10-08</td>
										<td>
											<ul class="tbl_btn">
												<li><a href="#" class="reply_btn">변경</a></li>
												<li><a href="#" class="delete_btn">삭제</a></li>
											</ul>
										</td>
										<td>
											
										</td>
									</tr>
								
								</table>
								<div class="btn_box">
									<a href="" class="btn_left wd130">파일로 내보내기</a>
									<a href="" class="btn_right wd100">신규등록</a>									
								</div>
								
								<div class="paging_form">
									<div class="paging">
										<ul>
											<li class="first_page page_btn"><img src="/assets/images/page_first.png"/></li>
											<li class="prev_page page_btn"><img src="/assets/images/page_prev.png"/></li>
											<li class="page_num page_on">1</li>
											<li class="page_num">2</li>
											<li class="page_num">3</li>
											<li class="page_num">4</li>
											<li class="page_num">5</li>
											<li class="page_num">6</li>
											<li class="page_num">7</li>
											<li class="page_num">8</li>
											<li class="page_num">9</li>
											<li class="page_num">10</li>
											<li class="next_page page_btn"><img src="/assets/images/page_next.png"/></li>
											<li class="last_page page_btn"><img src="/assets/images/page_last.png"/></li>
										</ul>
									</div>
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
