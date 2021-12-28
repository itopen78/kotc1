<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="en">
<head>
	<link rel="stylesheet" type="text/css" href="/assets/css/easyui.css">
    <c:import url="/inc/assets_base.jsp" />    
	<script type="text/javascript" src="/assets/js/jquery.easyui.min.js"></script>
    <script type="text/javascript">

	/**********************************************************************
	** search param
	***********************************************************************/


    var CHNG_ID = '${CHNG_ID}';
    
	$(document).ready(function() {
		getHisLogicStepDetail();
		
		/************************************************************************
		* 취소, 다음
		************************************************************************/
		$('.move').on('click', function() {
			$('.sub_con').hide();
			$('.step_'+$(this).data('move')).show();
		});




		//STEP1 에서 다음버튼 클릭
		$(".btn_step_next02").click(function(){
			$(".step_01").hide();
			$(".step_02").show();
		});
		//STEP2 에서 다음버튼 클릭
		$(".btn_step_next03").click(function(){
			$(".step_03").show();
			$(".step_02").hide();
			//$(".step_03").show();
		});
		
		$(".btn_step_back00").click(function(){
			history.back();
		});
		$(".btn_step_back01").click(function(){
			$(".step_02").hide();
			$(".step_01").show();
		});
		$(".btn_step_back02").click(function(){
			$(".step_03").hide();
			$(".step_02").show();
		});

				
	});
	
	function getHisLogicStepDetail() {
		if(CHNG_ID == null || CHNG_ID == '') {
			return false;
		}
		
		var params = {
				'class' : 'service.BeginService',
				'method' : 'getHisLogicStepDetail',
				'param' : {'CHNG_ID' : CHNG_ID},
				'callback' : function(data){
					if(data.success){
						loadingStop();
						var logicDetail = data.logicDetail;
						
						$('#CLASS_TITLE').text(logicDetail.CLASS_TITLE);
						$('#STUDENT_TOTAL_COUNT').text(logicDetail.STUDENT_TOTAL_COUNT);
						$('#CLASS_BEGIN_DATE').text(logicDetail.CLASS_BEGIN_DATE);
						$('#CLASS_END_DATE').text(logicDetail.CLASS_END_DATE);

						$('#CLASS_NOTE').text(logicDetail.CLASS_NOTE);
						
						var _html = '';
						if(data.logicStudentList.length > 0) {
							$(data.logicStudentList).each(function(i, item) {
								_html += '<tr class="tbl_list items">'
									_html += '<td>'+(i+1)+'</td>'
									_html += '<td>'+item.CLASS_NAME+'</td>'
									_html += '<td>'+item.STU_NAME+'</td>'
									_html += '<td>'+item.STU_ID_NUMBER+'</td>'
									_html += '<td>'+item.STU_TEL+'</td>'
								_html += '</tr>'
							});
						} else {
							_html += '<tr class="none"><td colspan="5">등록된 데이터가 없습니다.</td></tr>'
						}
						$('#logicStudentList').append(_html);


						
						_html = '';
						if(data.logicTimeTableList.length > 0) {
							$(data.logicTimeTableList).each(function(i, item) {
								_html += '<tr class="tbl_list02 items">'
									_html += '<td>'+item.LECTURE_DATE+'</td>'
									_html += '<td>'+item.BEGIN_TIME+' ~ '+item.END_TIME+'</td>'
									_html += '<td>'+item.CD_CLS_LEV1_NAME+'</td>'
									_html += '<td>'+item.CD_CLS_LEV2_NAME+'</td>'
									_html += '<td>'+item.AGT_NAME+'</td>'
								_html += '</tr>'
							
								
							});
						} else {
							_html += '<tr class="none"><td colspan="5">등록된 데이터가 없습니다.</td></tr>'
						}
						$('#logicTimeTableList').append(_html);

						
						_html = '';
						if(data.logicClassList.length > 0) {
							$(data.logicClassList).each(function(i, item) {
								_html += '<tr class="tbl_list03 items">'
									_html += '<td>'+item.CD_CLS_LEV1_NAME+'</td>'
									_html += '<td>'+item.CD_CLS_LEV2_NAME+'</td>'
									_html += '<td>'+item.AGT_ID_NAME1+'</td>'
									_html += '<td>'+item.AGT_ID_NAME2+'</td>'
								_html += '</tr>'
							});
						} else {
							_html += '<tr class="none"><td colspan="5">등록된 데이터가 없습니다.</td></tr>'
						}
						$('#logicClassList').append(_html);


						
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
					<span class="nav">개강보고</span>
					<span class="nav">이론/실기</span>
					<span class="nav">상세정보</span>
				</div>
		

				<form id="frm" name="frm" method="post" >
								
				<div class="sub_box">
					<div class="sub_menu">
						<div class="sub_title">개강보고</div>
						<div class="sub_list">
							<ul>
								<li class="sub_on"><a href="/begin/logicList">이론/실기</a></li>
								<li><a href="/begin/practiceList">실습</a></li>
								<li><a href="/begin/subPracticeList">대체실습</a></li>
							</ul>
						</div>
					</div>
					
					
					<div class="sub_con step_01">
						<!--conBox-->
						<div class="conBox">
							<div class="sub_step">
								<ul class="page02_step">
									<li class="step_list step_on">
										<div class="step_num">1</div>
										<div class="step_txt">개강개요</div>
									</li>
									<li class="step_list">
										<div class="step_num">2</div>
										<!--<div class="step_check"><img src="../images/step_check.png"/></div>-->
										<div class="step_txt">이론/실기 시간표 작성</div>
									</li>
									<li class="step_list">
										<div class="step_num">3</div>
										<div class="step_txt">과목별 교수요원 등록</div>
									</li>
								</ul>
							</div>
						</div>
						<!--conBox-->
						
																		
						<div class="conBox mgt40">
							<div class="con_title">개강 개요</div>
							<div class="con_form">
								<table class="tbl_ty1">
									<colgroup>
										<col width="160px"/>
										<col width="300px"/>
										<col width="160px"/>
										<col width="300px"/>
									</colgroup>
									<tr>
										<td class="t_head">
											교육과정명
										</td>
										<td class="pdl15 pdr15">
											<span  id="CLASS_TITLE"></span>
										</td>
										<td class="t_head">
											교육인원
										</td>
										<td>
											<!-- <span name="STUDENT_TOTAL_COUNT" id="STUDENT_TOTAL_COUNT" ></span> -->
											<span  id="STUDENT_TOTAL_COUNT"></span> 명
										</td>
									</tr>
									<tr>
										<td class="t_head">
											교육기간
										</td>
										<td class="pdl15 pdr15" colspan="3">
											<span  id="CLASS_BEGIN_DATE"></span>
											~
											<span  id="CLASS_END_DATE"></span>											
										</td>
									</tr>
								</table>
							</div>
							
						</div>
						<!--conBox end-->		
						
						<!--conBox 교육생 -->
						<div class="conBox mgt40">
							<div class="con_title">
								교육생 명부 등록
							</div>
							<div class="con_form over_y mhi417 ">
								<table class="tbl_ty3" id="logicStudentList">
									<colgroup>
										<col width="60px"/>
										<col width="155px"/>
										<col width="90px"/>
										<col width="140px"/>
										<col width="140px"/>
									</colgroup>
									<tr class="tb_header">
										<td>순번</td>
										<td>구분</td>
										<td>성명</td>
										<td>주민등록번호</td>
										<td>연락처</td>
									</tr>
								</table>
								
							</div>
						</div>
						<!--conBox end-->
						
						<div class="main_btn">
							<ul class="wd295">
								<li class="page_back mgr5 btn_step_back00"><a>취소</a></li>
								<li class="page_ok btn_step_next02"><a>다음</a></li>
							</ul>
						</div>
					</div>
					<!--step_01 end-->
					
					
					<div class="sub_con step_02">
						<!--conBox-->
						<div class="conBox">
							<div class="sub_step">
								<ul class="page02_step">
									<li class="step_list ">
										<div class="step_check"><img src="/assets/images/step_check2.png"/></div>
										<div class="step_txt">개강개요</div>
									</li>
									<li class="step_list step_on">
										<div class="step_num">2</div>
										<!--<div class="step_check"><img src="../images/step_check.png"/></div>-->
										<div class="step_txt">이론/실기 시간표 작성</div>
									</li>
									<li class="step_list">
										<div class="step_num">3</div>
										<div class="step_txt">과목별 교수요원 등록</div>
									</li>
									
									
								</ul>
							</div>
						</div>
						
						<!--conBox 시간표 -->
						<div class="conBox mgt40">						
							<div class="con_form mgt10">
								<table class="tbl_ty3" id="logicTimeTableList">
									<colgroup>
										<col width="120px"/>
										<col width="180"/>
										<col width="200px"/>
										<col width="200px"/>
										<col width="100px"/>						
									</colgroup>
									<tr class="filter">
										<td>날짜</td>
										<td>시간</td>
										<td>대과목</td>
										<td>소과목</td>
										<td>교수</td>
									</tr>
								</table>
							</div>
						</div>
						
						<div class="main_btn">
							<ul class="wd295">
								<li class="page_back mgr5 btn_step_back01"><a>취소</a></li>
								<li class="page_ok btn_step_next03"><a>다음</a></li>
							</ul>
						</div>
					</div>
					<!--step_02 end-->
									
						<!--conBox end-->		
						
						
					<div class="sub_con step_03"> 
						<!--conBox-->
						<div class="conBox">
							<div class="sub_step">
								<ul class="page02_step">
									<li class="step_list ">
										<div class="step_check"><img src="/assets/images/step_check2.png"/></div>
										<div class="step_txt">개강개요</div>
									</li>
									<li class="step_list">
										<div class="step_check"><img src="/assets/images/step_check2.png"/></div>
										<div class="step_txt">이론/실기 시간표 작성</div>
									</li>
									<li class="step_list step_on">
										<div class="step_num">3</div>
										<div class="step_txt">과목별 교수요원 등록</div>
									</li>
								</ul>
							</div>
						</div>
												
						<!--conBox 교수요원 -->
						<div class="conBox mgt40">
							<div class="con_title">
								과목별 교수요원
							</div>
							<div class="con_form">
								<table class="tbl_ty2" id="logicClassList">
									<colgroup>
										<col width="175px"/>
										<col width="285px"/>
										<col width="250px"/>
										<col width="250px"/>
									</colgroup>
									<tr class="filter">
										<td>대과목</td>
										<td>중과목</td>
										<td>이론교수</td>
										<td>실기교수</td>
									</tr>
								</table>
								
							</div>
						</div>
						<!--conBox end-->
						
						<!--conBox 비고 -->
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
											<textarea class="tbl_area" name="CLASS_NOTE" id="CLASS_NOTE" ></textarea>
										</td>
									</tr>			
								</table>
							</div>
						</div>
						<!--conBox end-->
												
						<div class="main_btn">
							<ul class="">
								<li class="page_back mgr5 btn_step_back02"><a>취소</a></li>
								<!-- <li class="page_ok sendSave"><a>제출</a></li> -->
							</ul>
						</div>
					</div>
					<!--step_03 end-->
										
						
						<!-- <div class="main_btn">
							<ul class="wd295">
								<li class="page_back mgr5 back1"><a>취소</a></li>
								<li class="page_back mgr5 tempSave"><a>임시저장</a></li>
								<li class="page_ok step1"><a>다음</a></li>	
								<li class="page_ok step2"><a>다음2</a></li>		
							</ul>
						</div> 
						
					</div>-->
				</div>
				
				</form>
			</div>
		</div>
		
		
		
		
		<c:import url="/inc/footer_base.jsp" />
	</div>
</body>
</html>
