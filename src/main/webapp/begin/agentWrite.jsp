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
					<span class="nav">교수요원 상세</span>
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
							<div class="con_title">기본정보</div>
							<div class="con_form">
								<table class="tbl_ty1">
									<colgroup>
										<col width="160px"/>
										<col width="295px"/>
										<col width="160px"/>
										<col width="295px"/>
									</colgroup>
									<tr>
										<td class="t_head over_hide pdt5">
											<span class="star">*</span>인력구분</td>
											
										</td>
										<td class="pdl15 pdr15">
											<select class="tbl_select">
												<option>기관장</option>
												<option>전임</option>
												<option>왜래</option>
											</select>
										</td>
										<td class="t_head">최초신청일자</td>
										<td>2020년 10월 03일</td>
									</tr>
									<tr>
										<td class="t_head over_hide pdt5"><span class="star">*</span>성명</td>
										<td class="pdl15 pdr15">
											<input type="text" class="tbl_input" value="김기관장" />
										</td>
										<td class="t_head">최초승인일자</td>
										<td>2020년 10월 03일</td>
									</tr>
									<tr>
										<td class="t_head over_hide pdt5"><span class="star">*</span>생년월일</td>
										<td class="pdl15 pdr15">
											<input type="text" class="tbl_input" value="1950년 08월 01일" />
										</td>
										<td class="t_head">최종승인일자</td>
										<td>2020년 10월 04일</td>
									</tr>
									<tr>
										<td class="t_head over_hide pdt5"><span class="star">*</span>연락처</td>
										<td class="pdl15 pdr15">
											<input type="text" class="tbl_input" value="010-1234-0000" />
										</td>
										<td class="t_head">등록 상태</td>
										<td>등록 신청</td>
									</tr>
									<tr>
										<td class="t_head">변경 상태</td>
										<td colspan="3"></td>
									</tr>
								</table>
							</div>
						</div>
						<!--conBox end-->
						
						<!--conBox-->
						<div class="conBox">
							<div class="con_title">담당교육<a href="" class="title_btn wd115">담당교육 추가</a></div>
							<div class="con_form mgt10">
								<table class="tbl_ty3">
									<colgroup>
										<col width="110px"/>
										<col width="315"/>
										<col width="425px"/>
										<col width="110px"/>
									</colgroup>
									<tr>
										<td>순번</td>
										<td>대과목</td>
										<td>중과목</td>
										<td>삭제</td>
									</tr>
									<tr>
										<td>
											1
										</td>
										<td>
											<select class="tbl_select">
												<option>요양보호개론</option>
												<option>요양보호개론</option>
												<option>요양보호개론</option>
												<option>요양보호개론</option>
												<option>요양보호관련 기초지식</option>
												<option>요양보호각론</option>
												<option>요양보호각론</option>
												<option>요양보호각론</option>
												<option>요양보호각론</option>
												<option>요양보호각론</option>
												<option>특수요양보호각론</option>
												<option>특수요양보호각론</option>
												<option>특수요양보호각론</option>
											</select>
										</td>
										<td>
											<select class="tbl_select">
												<option>요양보호 관련 제도 및 서비스</option>
												<option>요양보호 업무의 목적 및 기능</option>
												<option>요양보호사의 직업윤리와 자세</option>
												<option>요양보호대상자 이해</option>
												<option>의학적ㆍ간호학적 기초지식</option>
												<option>기본 요양보호 기술</option>
												<option>가사 및 일상 생활 지원</option>
												<option>의사소통 및 여가지원</option>
												<option>서비스 이용지원</option>
												<option>요양보호 업무 기록 및 보고</option>
												<option>치매요양보호기술</option>
												<option>임종 및 호스피스 요양보호기술</option>
												<option>응급처치기술</option>
											</select>
										</td>
										<td>
											<div class="delete_icon"></div>
										</td>
									</tr>
									<tr>
										<td>
											2
										</td>
										<td>
											<select class="tbl_select">
												<option>요양보호개론</option>
												<option>요양보호개론</option>
												<option>요양보호개론</option>
												<option>요양보호개론</option>
												<option>요양보호관련 기초지식</option>
												<option>요양보호각론</option>
												<option>요양보호각론</option>
												<option>요양보호각론</option>
												<option>요양보호각론</option>
												<option>요양보호각론</option>
												<option>특수요양보호각론</option>
												<option>특수요양보호각론</option>
												<option>특수요양보호각론</option>
											</select>
										</td>
										<td>
											<select class="tbl_select">
												<option>요양보호 관련 제도 및 서비스</option>
												<option>요양보호 업무의 목적 및 기능</option>
												<option>요양보호사의 직업윤리와 자세</option>
												<option>요양보호대상자 이해</option>
												<option>의학적ㆍ간호학적 기초지식</option>
												<option>기본 요양보호 기술</option>
												<option>가사 및 일상 생활 지원</option>
												<option>의사소통 및 여가지원</option>
												<option>서비스 이용지원</option>
												<option>요양보호 업무 기록 및 보고</option>
												<option>치매요양보호기술</option>
												<option>임종 및 호스피스 요양보호기술</option>
												<option>응급처치기술</option>
											</select>
										</td>
										<td>
											<div class="delete_icon"></div>
										</td>
									</tr>
									<tr>
										<td>
											3
										</td>
										<td>
											<select class="tbl_select">
												<option>요양보호개론</option>
												<option>요양보호개론</option>
												<option>요양보호개론</option>
												<option>요양보호개론</option>
												<option>요양보호관련 기초지식</option>
												<option>요양보호각론</option>
												<option>요양보호각론</option>
												<option>요양보호각론</option>
												<option>요양보호각론</option>
												<option>요양보호각론</option>
												<option>특수요양보호각론</option>
												<option>특수요양보호각론</option>
												<option>특수요양보호각론</option>
											</select>
										</td>
										<td>
											<select class="tbl_select">
												<option>요양보호 관련 제도 및 서비스</option>
												<option>요양보호 업무의 목적 및 기능</option>
												<option>요양보호사의 직업윤리와 자세</option>
												<option>요양보호대상자 이해</option>
												<option>의학적ㆍ간호학적 기초지식</option>
												<option>기본 요양보호 기술</option>
												<option>가사 및 일상 생활 지원</option>
												<option>의사소통 및 여가지원</option>
												<option>서비스 이용지원</option>
												<option>요양보호 업무 기록 및 보고</option>
												<option>치매요양보호기술</option>
												<option>임종 및 호스피스 요양보호기술</option>
												<option>응급처치기술</option>
											</select>
										</td>
										<td>
											<div class="delete_icon"></div>
										</td>
									</tr>
									
								</table>
								
								<div class="btn_box mgt15"><a href="" class="btn_center wd115">담당교육 추가</a></div>
							</div>
						</div>
						<!--conBox end-->
						
						<!--conBox-->
						<div class="conBox">
							<div class="con_title">자격사항<a href="" class="title_btn wd115">자격사항 추가</a><a href="" class="title_btn wd160 mgr5">자격사항 전체 다운로드</a></div>
							<div class="con_form mgt10">
								<table class="tbl_ty3">
									<colgroup>
										<col width="110px"/>
										<col width="145px"/>
										<col width="180px"/>
										<col width="135px"/>
										<col width="290px"/>
										<col width="110px"/>
									</colgroup>
									<tr>
										<td>순번</td>
										<td>자격사항</td>
										<td>첨부파일</td>
										<td>자격 취득일</td>
										<td>비고</td>
										<td>삭제</td>
									</tr>
									<tr>
										<td>
											1
										</td>
										<td>
											<input type="text" class="tbl_input" value="사회복지사 2급" />
										</td>
										<td>
											<ul class="file_form">
												<li>
													<div class="file_box">
														<input type="text" readonly onclick="$('#upload_file').trigger('click')" id="upload_text" value="" />
														<input type="file" name="upload_file" id="upload_file"/>
													</div>
												</li>
												<li><a href="" class="file_down">자격증.pdf</a></li>
											</ul>
										</td>
										<td>
											<input type="text" class="tbl_input" value="2019-01-05" />
										</td>
										<td class="t_left pdl20">2020년 10월 01일 자격 취득</td>
										<td>
											<div class="delete_icon"></div>
										</td>
									</tr>
									<tr>
										<td>
											2
										</td>
										<td>
											<input type="text" class="tbl_input" value="사회복지학 박사" />
										</td>
										<td>
											<ul class="file_form">
												<li>
													<div class="file_box">
														<input type="text" readonly onclick="$('#upload_file').trigger('click')" id="upload_text" value="" />
														<input type="file" name="upload_file" id="upload_file"/>
													</div>
												</li>
												<li><a href="" class="file_down">학력증명서.pdf</a></li>
											</ul>
										</td>
										<td>
											<input type="text" class="tbl_input" value="2019-01-05" />
										</td>
										<td class="t_left pdl20">ㅇㅇㅇㅇ 대학교</td>
										<td>
											<div class="delete_icon"></div>
										</td>
									</tr>
									
								</table>
								
								<div class="btn_box mgt15"><a href="" class="btn_center wd115">자격사항 추가</a></div>
							</div>
						</div>
						<!--conBox end-->
						
						<!--conBox-->
						<div class="conBox">
							<div class="con_title">경력사항<a href="" class="title_btn wd115">경력사항 추가</a><a href="" class="title_btn wd160 mgr5">경력사항 전체 다운로드</a></div>
							<div class="con_form mgt10">
								<table class="tbl_ty3">
									<colgroup>
										<col width="110px"/>
										<col width="145px"/>
										<col width="180px"/>
										<col width="295px"/>
										<col width="120px"/>
										<col width="110px"/>
									</colgroup>
									<tr>
										<td>순번</td>
										<td>경력사항</td>
										<td>첨부파일</td>
										<td>경력</td>
										<td>비고</td>
										<td>삭제</td>
									</tr>
									<tr>
										<td>
											1
										</td>
										<td>
											<input type="text" class="tbl_input" value="ㅇㅇㅇ 기관장" />
										</td>
										<td>
											<ul class="file_form">
												<li>
													<div class="file_box">
														<input type="text" readonly onclick="$('#upload_file').trigger('click')" id="upload_text" value="" />
														<input type="file" name="upload_file" id="upload_file"/>
													</div>
												</li>
												<li><a href="" class="file_down">경력증명서.pdf</a></li>
											</ul>
										</td>
										<td>
											<input type="text" class="tbl_input wd130" value="2008-01-05" />
											~
											<input type="text" class="tbl_input wd130" value="2012-12-12" />
										</td>
										<td>59개월</td>
										<td>
											<div class="delete_icon"></div>
										</td>
									</tr>
									<tr>
										<td>
											2
										</td>
										<td>
											<input type="text" class="tbl_input" value="ㅇㅇㅇ 기관장" />
										</td>
										<td>
											<ul class="file_form">
												<li>
													<div class="file_box">
														<input type="text" readonly onclick="$('#upload_file').trigger('click')" id="upload_text" value="" />
														<input type="file" name="upload_file" id="upload_file"/>
													</div>
												</li>
												<li><a href="" class="file_down">경력증명서.pdf</a></li>
											</ul>
										</td>
										<td>
											<input type="text" class="tbl_input wd130" value="2013-02-01" />
											~
											<input type="text" class="tbl_input wd130" value="2016-01-31" />
										</td>
										<td>59개월</td>
										<td>
											<div class="delete_icon"></div>
										</td>
									</tr>
									
								</table>
								
								<div class="btn_box mgt15"><a href="" class="btn_center wd115">경력사항 추가</a></div>
							</div>
						</div>
						<!--conBox end-->
						
						<!--conBox-->
						<div class="conBox">
							<div class="con_title">타 기관 출강여부<a href="" class="title_btn wd150">타 기관 출강여부 추가</a></div>
							<div class="con_form mgt10">
								<table class="tbl_ty3">
									<colgroup>
										<col width="110px"/>
										<col width="225px"/>
										<col width="515px"/>
										<col width="110px"/>
									</colgroup>
									<tr>
										<td>순번</td>
										<td>타 기관명</td>
										<td>비고</td>
										<td>삭제</td>
									</tr>
									<tr>
										<td>
											1
										</td>
										<td>
											<input type="text" class="tbl_input" value="화면설계 타 교육기관" />
										</td>
										<td>
											<input type="text" class="tbl_input" value="2020년 12월 30일까지 출강" />
										</td>
										<td>
											<div class="delete_icon"></div>
										</td>
									</tr>
									
								</table>
								
								<div class="btn_box mgt15"><a href="" class="btn_center wd150">타 기관 출강여부 추가</a></div>
							</div>
						</div>
						<!--conBox end-->
						
						<!--conBox-->
						<div class="conBox">
							<div class="con_form mgt10">
								<table class="tbl_ty1">
									<colgroup>
										<col width="160px"/>
										<col width="800px"/>
									</colgroup>
									<tr>
										<td class="t_head">비고</td>
										<td class="pdr10 pdl10 pdt7 pdb7">
											<textarea class="tbl_area">2020년 12월 30일까지 출강</textarea>
										</td>
									</tr>			
								</table>
							</div>
						</div>
						<!--conBox end-->
						
						<div class="main_btn">
							<ul>
								<li class="page_back mgr5"><a>취소</a></li>
								<li class="page_ok"><a>등록 신청</a></li>
							</ul>
						</div>
					</div>
				</div>
			</div>
		</div>
		
		<c:import url="/inc/footer_base.jsp" />
	</div>
</body>
</html>
