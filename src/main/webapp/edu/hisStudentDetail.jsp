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
    var CHNG_ID = '${CHNG_ID}';
	$(document).ready(function() {
		fnFieldDisabled();
		
		getStudentDetail();
    });
	
	function getStudentDetail() {
		if(CHNG_ID == null || CHNG_ID == '') {
			return false;
		}
		
		var params = {
				'class' : 'service.EduService',
				'method' : 'getHisStudentDetail',
				'param' : {'CHNG_ID' : CHNG_ID},
				'callback' : function(data){
					if(data.success){
						loadingStop();
						var _html = '';
						var studentDetail = data.studentDetail;
						
						$('#CD_CLASS_TYPE').append('<option>'+studentDetail.CD_CLASS_TYPE_NAME+'</option>');
						$('#LICENSE_SERIAL').val(studentDetail.LICENSE_SERIAL);
						$('#STU_NAME').val(studentDetail.STU_NAME);
						$('#ADD_DATE').text(studentDetail.ADD_DATE);
						$('#STU_ID_NUMBER').val(studentDetail.STU_ID_NUMBER);
						$('#CHNG_DATE').text(studentDetail.CHNG_DATE);
						$('#STU_TEL').val(studentDetail.STU_TEL);
						$('#COMPLETE_DATE').text(studentDetail.COMPLETE_DATE);
						$('#STU_ZIP').val(studentDetail.STU_ZIP);
						$('#TEST_NAME').text(studentDetail.TEST_NAME);
						$('#STU_ADDRESS').val(studentDetail.STU_ADDRESS);
						$('#TEST_DATE').text(studentDetail.TEST_DATE);
						if(studentDetail.L_LECTURE_ID != '') {
							_html = '';
							_html += '<a class="tbl_link float_l" href="#">'+studentDetail.L_LECTURE_TITLE+'</a>'
							_html += '<div class="float_r pdt2">'
								_html += '<a class="reply_btn wd90 t_center status_view" href="javascript:void(0)" onclick="$("#w01").window("open")">출석부 보기</a>'
							_html += '</div>'
							$('.L_LECTURE_POSITION').append(_html);
							$('.L_LECTURE_POSITION').show();
						}
						$('#PASS_DATE').text(studentDetail.PASS_DATE);
						if(studentDetail.P_LECTURE_ID != '') {
							_html = '';
							_html += '<a class="tbl_link" href="#">'+studentDetail.P_LECTURE_TITLE+'</a>'
							$('.P_LECTURE_POSITION').append(_html);
							$('.P_LECTURE_POSITION').show();
						}
						$('#PASS_NUMBER').val(studentDetail.PASS_NUMBER);
						if(studentDetail.S_LECTURE_ID != '') {
							_html = '';
							_html += '<a class="tbl_link" href="#">'+studentDetail.S_LECTURE_TITLE+'</a>'
							$('.S_LECTURE_POSITION').append(_html);
							$('.S_LECTURE_POSITION').show();
						}
						$('#DISQUALIFICATION_YN').text(studentDetail.DISQUALIFICATION_YN);
						$('#DISQUALIFICATION_DATE').text(studentDetail.DISQUALIFICATION_DATE);
						
						$('#STU_NOTE').val(studentDetail.STU_NOTE);
					}
				}
		};
		apiCall(params);
	}
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
					<span class="nav">교육생</span>
					<span class="nav">교육생 상세</span>
				</div>
				<div class="sub_box">
					<div class="sub_menu">
						<div class="sub_title">교육기관</div>
						<div class="sub_list">
							<ul>
								<li><a href="">기관정보</a></li>
								<li><a href="">교수요원</a></li>
								<li><a href="">연계실습기관</a></li>
								<li><a href="">실습지도자</a></li>
								<li class="sub_on"><a href="">교육생</a></li>
								<li><a href="">자체점검</a></li>
							</ul>
						</div>
					</div>
					<div class="sub_con">
						<form id="frm" name="frm" method="post">
						<input type="hidden" name="CD_ADD_STATE" id="CD_ADD_STATE"/>
						<!--conBox-->
						<div class="conBox">
							<div class="con_title">교육생 정보</div>	
							<div class="con_form">
								<table class="tbl_ty1">
									<colgroup>
										<col width="160px"/>
										<col width="400px"/>
										<col width="160px"/>
										<col width="200px"/>
									</colgroup>
									<tr>
										<td class="t_head">
											과정구분
										</td>
										<td class="pdl15 pdr15">
											<select class="tbl_select" id="CD_CLASS_TYPE" name="CD_CLASS_TYPE">
											</select>
										</td>
										<td class="t_head">
											자격번호
										</td>
										<td class="pdl15 pdr5">
											<input type="text" class="tbl_input" id="LICENSE_SERIAL" name="LICENSE_SERIAL"/>
										</td>
									</tr>
									<tr>
										<td class="t_head ">성명</td>
										<td class="pdl15 pdr15">
											<input type="text" class="tbl_input" id="STU_NAME" name="STU_NAME"/>
										</td>
										<td class="t_head">등록일자</td>
										<td id="ADD_DATE"><!-- 2020-10-04 --></td>
									</tr>
									<tr>
										<td class="t_head ">주민등록번호</td>
										<td class="pdl15 pdr15">
											<input type="text" class="tbl_input" id="STU_ID_NUMBER" name="STU_ID_NUMBER"/>
										</td>
										<td class="t_head">최종변경일자</td>
										<td id="CHNG_DATE"><!-- 2020-10-04 --></td>
									</tr>
									<tr>
										<td class="t_head ">연락처</td>
										<td class="pdl15 pdr15">
											<input type="text" class="tbl_input" id="STU_TEL" name="STU_TEL"/>
										</td>
										<td class="t_head">수료일자</td>
										<td id="COMPLETE_DATE"></td>
									</tr>
									<tr>
										<td class="t_head ">우편번호</td>
										<td class="pdl15 pdr15">
											<input type="text" class="tbl_input" id="STU_ZIP" name="STU_ZIP"/>
										</td>
										<td class="t_head">시험명</td>
										<td id="TEST_NAME"></td>
									</tr>
									<tr>
										<td class="t_head ">소재지 주소(도로명)</td>
										<td class="pdl15 pdr15">
											<input type="text" class="tbl_input" id="STU_ADDRESS" name="STU_ADDRESS"/>
										</td>
										<td class="t_head">시험일자</td>
										<td id="TEST_DATE"></td>
									</tr>
									<tr>
										<td class="t_head ">이론/실기</td>
										<td class="pdl15 pdr15 over_hide L_LECTURE_POSITION">
										</td>
										<td class="t_head">합격일자</td>
										<td id="PASS_DATE"></td>
									</tr>
									<tr>
										<td class="t_head ">실습</td>
										<td class="pdl15 pdr15 P_LECTURE_POSITION">
										</td>
										<td class="t_head">합격번호</td>
										<td id="PASS_NUMBER"></td>
									</tr>
									<tr>
										<td class="t_head ">대체실습</td>
										<td class="pdl15 pdr15 S_LECTURE_POSITION">
										</td>
										<td class="t_head">결격유무</td>
										<td id="DISQUALIFICATION_YN"></td>
									</tr>
									
									<tr>
										<td class="t_head">결격기간</td>
										<td colspan="3" id="DISQUALIFICATION_DATE"></td>
									</tr>
								</table>
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
											<textarea class="tbl_area" id="STU_NOTE" name="STU_NOTE"></textarea>
										</td>
									</tr>			
								</table>
							</div>
						</div>
						<!--conBox end-->
						</form>
						<div class="main_btn">
							<ul>
								<li class="page_back mgr5"><a href="javascript:history.back();">취소</a></li>
							</ul>
						</div>
					</div>
				</div>
			</div>
		</div>
		
		<!--교육생 팝업-->
		<div id="w01" class="easyui-window" title="김교육 출석부" data-options="modal:true,closed:true,iconCls:'icon-save'" style="width:610px;height:747px;padding:0px;">
			<div class="pop_con">
				<div class="sub_pop_title">2020년 주간 01기 - 표준교육과정</div>
				
				<table class="tbl_ty2 mgt25">
					<colgroup>
						<col width="80px"/>
						<col width="150px"/>
						<col width="150px"/>
						<col width="150px"/>
					</colgroup>
					<tr>
						<td>순번</td>
						<td>수업일자</td>
						<td>수업시간</td>
						<td>정보 보기</td>
					</tr>
					<tr>
						<td>1</td>
						<td>2020-10-01</td>
						<td>09:00 ~ 09:50</td>
						<td>
							<select class="tbl_select wd120">
								<option>출석</option>
								<option>결석</option>
								<option>지각</option>
								<option>조퇴</option>
							</select>
						</td>
					</tr>
					<tr>
						<td>2</td>
						<td>2020-10-01</td>
						<td>10:00 ~ 10:50</td>
						<td>
							<select class="tbl_select wd120">
								<option>출석</option>
								<option>결석</option>
								<option>지각</option>
								<option>조퇴</option>
							</select>
						</td>
					</tr>
					<tr>
						<td>3</td>
						<td>2020-10-01</td>
						<td>11:00 ~ 11:50</td>
						<td>
							<select class="tbl_select wd120">
								<option>출석</option>
								<option>결석</option>
								<option>지각</option>
								<option>조퇴</option>
							</select>
						</td>
					</tr>
					<tr>
						<td>4</td>
						<td>2020-10-01</td>
						<td>13:00 ~ 13:50</td>
						<td>
							<select class="tbl_select wd120">
								<option>출석</option>
								<option>결석</option>
								<option>지각</option>
								<option>조퇴</option>
							</select>
						</td>
					</tr>
					<tr>
						<td>5</td>
						<td>2020-10-01</td>
						<td>14:00 ~ 14:50</td>
						<td>
							<select class="tbl_select wd120">
								<option>출석</option>
								<option>결석</option>
								<option>지각</option>
								<option>조퇴</option>
							</select>
						</td>
					</tr>
					<tr>
						<td>6</td>
						<td>2020-10-01</td>
						<td>15:00 ~ 15:50</td>
						<td>
							<select class="tbl_select wd120">
								<option>출석</option>
								<option>결석</option>
								<option>지각</option>
								<option>조퇴</option>
							</select>
						</td>
					</tr>
					<tr>
						<td>7</td>
						<td>2020-10-01</td>
						<td>16:00 ~ 16:50</td>
						<td>
							<select class="tbl_select wd120">
								<option>출석</option>
								<option>결석</option>
								<option>지각</option>
								<option>조퇴</option>
							</select>
						</td>
					</tr>
					<tr>
						<td>8</td>
						<td>2020-10-01</td>
						<td>17:00 ~ 17:50</td>
						<td>
							<select class="tbl_select wd120">
								<option>출석</option>
								<option>결석</option>
								<option>지각</option>
								<option>조퇴</option>
							</select>
						</td>
					</tr>
				
				</table>
				
				<div class="paging_form mgt45">
					<div class="paging">
						<ul>
							<li class="first_page page_btn"><img src="../images/page_first.png"/></li>
							<li class="prev_page page_btn"><img src="../images/page_prev.png"/></li>
							<li class="page_num page_on">1</li>
							<li class="page_num">2</li>
							<li class="page_num">3</li>
							<li class="page_num">4</li>
							<li class="page_num">5</li>
							<li class="page_num">6</li>
							<li class="page_num">7</li>
							<li class="page_num">8</li>
							<li class="next_page page_btn"><img src="../images/page_next.png"/></li>
							<li class="last_page page_btn"><img src="../images/page_last.png"/></li>
						</ul>
					</div>
				</div>
				
				<div class="btn_box mgt20 mgb30"><a href="" class="btn_center wd100">닫기</a></div>
			</div>
		</div>
		
		<c:import url="/inc/footer_base.jsp" />
	</div>
</body>
</html>
