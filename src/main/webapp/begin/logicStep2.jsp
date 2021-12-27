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

    //초기 변수 
	var _USER_INFO = '${sessionScope.userInfo}';
	
	//search param
	var _CLASS_ID = '${CLASS_ID}';  //개강과목 코드
	var _AGC_ID = '${sessionScope.userInfo.AGC_ID}';  //세션 교육기관 코드

	var P_AGC_ID = '${AGC_ID}';  // 교유기관 코드
	var _CD_ADD_STATE = ""; //등록상태 : 등록 1 , 변경 2 , 삭제 3 , 임시저장 4
	
	if (_AGC_ID =="1") // 경기도청인 경우 
	{
		_AGC_ID = P_AGC_ID;
	}

	$(document).ready(function() {
		
		/********************************************************
		* 담당교육
		********************************************************/
		
		$('#agentClassList').on('change', 'select[name=CD_CLS_LEV1]', function() {
			var $items = $(this).closest('tr.items');
			var CD_MIDDLE = $(this).val();
			var params = {
					'class' : 'commonMapper',
					'method' : 'getCommonListByBottom',
					'param' : {'CD_TOP' : '4'
								, 'CD_MIDDLE' : CD_MIDDLE
					},
					'callback' : function(data){
						if(data.success){
							loadingStop();
							$items.find('select[name=CD_CLS_LEV2]').empty();
							var _html = '';
							$.each(data.list, function(index, item) {
								_html += '<option value="'+(item.CODE)+'">'+(item.NAME)+'</option>'
							});
							$items.find('select[name=CD_CLS_LEV2]').append(_html);
						}
					}
			};
			apiCall(params);
		});

		

		$('#agentClassList').on('change', 'select[name=CD_CLS_LEV2]', function() {
			var $items = $(this).closest('tr.items');
			var CD_CLS_LEV2 = $(this).val();
			var CD_CLS_LEV1 = $items.find('select[name=CD_CLS_LEV1]').val();
			
			var params = {
					'class' : 'beginMapper',
					'method' : 'getAgentList',										
					'param' : { 'AGC_ID' : _AGC_ID ,
								'CD_CLS_LEV1' : CD_CLS_LEV1 , 
								'CD_CLS_LEV2' : CD_CLS_LEV2 
					},
					'callback' : function(data){
						if(data.success){
							loadingStop();
							$items.find('select[name=AGT_ID]').empty();
							var _html = '';
							$.each(data.list, function(index, item) {
								_html += '<option value="'+(item.CODE)+'">'+(item.NAME)+'</option>'
							});
							$items.find('select[name=AGT_ID]').append(_html);
						}
					}
			};
			apiCall(params);
		});

		
		$('.addAgentClass').on('click', function() {
			var params = {
					'class' : 'service.CommonService',
					'method' : 'getAgentClassCdClsLev',
					'param' : {'CD_TOP' : '4'},
					'callback' : function(data){
						if(data.success){
							loadingStop();
							$('#agentClassList .none').remove();
							
							var _html = '';
							_html += '<tr class="items" data-cls_id="">'
								_html += '<input type="hidden" name="CLS_ID" value=""/>'
								_html += '<td class="lecture_date"><input type="date" class="tbl_date wd150" name="lecture_date" /></td>'
								_html += '<td class="time">'
								_html += '	<input type="text" class="tbl_input wd65" name="begin_time" value="09:00" />'
								_html += '	<input type="text" class="tbl_input wd65" name="end_time" value="10:00" />'
								_html += '</td>'
								_html += '<td>'
									_html += '<select class="tbl_select" name="CD_CLS_LEV1">'
									$.each(data.cdClasLev1List, function(index, item) {
										_html += '<option value="'+(item.CODE)+'">'+(item.NAME)+'</option>'
									});
									_html += '</select>'
								_html += '</td>'
								_html += '<td>'
									_html += '<select class="tbl_select" name="CD_CLS_LEV2">'
										$.each(data.cdClasLev2List, function(index, item) {
											_html += '<option value="'+(item.CODE)+'">'+(item.NAME)+'</option>'
										});
									_html += '</select>'
								_html += '</td>'

								_html += '<td>'
									_html += '<select class="tbl_select" name="AGT_ID">'
										$.each(data.cdClasLev2List, function(index, item) {
											_html += '<option value="'+(item.CODE)+'">'+(item.CODE)+'</option>'
										});
									_html += '</select>'
								_html += '</td>'
								_html += '<td>작성자</td>'
									
								_html += '<td><div class="delete_icon removeAgentClass" data-cls_id=""></div></td>'
							_html += '</tr>'
							
							$('#agentClassList .filter').after(_html);
							
							/* $('#agentClassList tr.items:visible').each(function(i) {
								$(this).find('.no').text((i+1));
							}); */
						}
					}
			};
			apiCall(params);
		});


		$('#agentClassList').on('click', '.removeAgentClass', function() {
			var CLS_ID = $(this).data('cls_id');
			if(CLS_ID != null && CLS_ID != '') {
				$(this).closest('tr.items').hide();
			} else {
				$(this).closest('tr.items').remove();
			}
			
			/* $('#agentClassList tr.items:visible').each(function(i) {
				$(this).find('.no').text((i+1));
			}); */
			
			if($('#agentClassList tr.items:visible').length <= 0) {
				$('#agentClassList .filter').after('<tr class="none"><td colspan="7">등록된 데이터가 없습니다.</td></tr>');
			}
		});
		
		


		
		/*
		//과목정보 조회
		if (_CLASS_ID!="")
		{
			getClass();
		}

		//교육생목록
		if (_AGC_ID!="")
		{
			getStudentList();	
		}		

		// 임시저장
		$('.tempSave').on('click', function() {
			_CD_ADD_STATE = "4";
			saveLogic();
	    });
	    
		// 다음 저장
		$('.nextSave').on('click', function() {
			_CD_ADD_STATE = "";
			saveLogic();
	    });

		*/

	});


	function aaa()
	{

	}
	
	function saveLogic()
	{

			if($('#CLASS_TITLE').val() == '') {
				alert('교육과정명을 입력하세요.');
				$('#CLASS_TITLE').focus();
				return false;
			}
			if($('#CLASS_BEGIN_DATE').val() == '') {
				alert('교육기간 시작일자를 입력하세요.');
				$('#CLASS_BEGIN_DATE').focus();
				return false;
			}
			if($('#CLASS_END_DATE').val() == '') {
				alert('교육기간 종료일자를 입력하세요.');
				$('#CLASS_END_DATE').focus();
				return false;
			}
	
			var saveStudentList = new Array();
			var str_stu_id = "";
			$('#selectList tr:not(:first)').each(function() {
				var $table = $(this);
				var stu_id = $table.find("td").eq(1).text();
				str_stu_id += stu_id + ',';
				
				saveStudentList.push({'stu_id' : stu_id
									});
			});
			str_stu_id = str_stu_id.substring(0,str_stu_id.length-1);
			
			//console.log("str_stu_id:"+str_stu_id);
			//console.log(saveStudentList);
						
			var params = {
					'class' : 'service.BeginService',
					'method' : 'saveLogic',
					'param' : {
						'AGC_ID' : _AGC_ID,
						'CLASS_ID' : _CLASS_ID,
						'CLASS_TITLE' : $('#CLASS_TITLE').val(),
						'CLASS_BEGIN_DATE' : $('#CLASS_BEGIN_DATE').val(),
						'CLASS_END_DATE' : $('#CLASS_END_DATE').val(),
						'STUDENT_TOTAL_COUNT' : $('#STUDENT_TOTAL_COUNT').val(),
						'CD_ADD_STATE' : _CD_ADD_STATE,
						'STU_ID' : str_stu_id,
						'saveStudentList' : JSON.stringify(saveStudentList)
					},
					'callback' : function(data){
						if(data.success){
							loadingStop();
							alert('저장 되었습니다.');
							//CLASS_ID 를 받아온다.
							location.href ="/begin/logicStep2?AGC_ID="+_AGC_ID+"&CLASS_ID="+data.CLASS_ID;
							//saveStudent();
						} else {
							alert('저장 실패 하였습니다.');
						}
					}
			};			
			
			apiCall(params);

	}

	
	function getClass() {

		var params = {
				'class' : 'service.BeginService',
				'method' : 'getLogicList',
				'param' : {
					'CLASS_ID' : _CLASS_ID,
					'PAGE_SIZE' : 1,
					'PAGE_INDEX' : 0
				},
				'callback' : function(data){
					if(data.success){
						loadingStop();
						if(data.list.length > 0) {
							$.each(data.list, function(index, item) {
								
								$('#CLASS_TITLE').val(item.CLASS_TITLE);
								$('#STUDENT_TOTAL_COUNT').val(item.STUDENT_TOTAL_COUNT);
								$('#CLASS_BEGIN_DATE').val(item.CLASS_BEGIN_DATE);
								$('#CLASS_END_DATE').val(item.CLASS_END_DATE);

							});
						} else {

							$('#CLASS_TITLE').val("");
							$('#STUDENT_TOTAL_COUNT').val("");
							$('#CLASS_BEGIN_DATE').val("");
							$('#CLASS_END_DATE').val("");
							
						}
					}
				}
		};
		apiCall(params);
	}

	
	function getStudentList() {

		var params = {
				'class' : 'service.BeginService',
				'method' : 'getStudentList',
				'param' : {					
					'AGC_ID' : _AGC_ID,
					'CLASS_ID' : _CLASS_ID
				},
				'callback' : function(data){
					if(data.success){
						loadingStop();
												
						$('#gridList .items').remove();
						
						var _html = '';
						if(data.list.length > 0) {
							$.each(data.list, function(index, item) {
								//console.log(item.CLASS_ID);
								var str_checked="";
								if (item.CLASS_ID!="") { var str_checked = "checked";}
								
								_html += '<tr class="tbl_list02 items" data-stu_id="'+item.STU_ID+'">'+
								'<td>'+item.NO+'</td>'+
								'<td>'+item.CLASS_NAME+'</td>'+
								'<td class>'+item.STU_NAME+'</td>'+
								'<td>'+item.STU_ID_NUMBER+'</td>'+
								'<td>'+item.STU_TEL+'</td>'+
								'<td  class="check_form">'+
									'<input type="checkbox" id=list_check_'+ index+' name="chk3" value="'+item.STU_ID+'"' + str_checked +' class="tbl_check"/>'+
									'<label for=list_check_'+ index+'><span></span></label>'+
								'</td>'+
							'</tr>';

							});
						} else {
							_html += '<tr class="items"><td colspan="6">등록된 데이터가 없습니다.</td></tr>';
						}

						//console.log(_html);

						$('#gridList').append(_html);
						addRow();
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
					<div class="sub_con">
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
										<!--<div class="step_check"><img src="/assets/images/step_check.png"/></div>-->
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
							<div class="con_title">시간표 작성 <a href="javascript:void(0);" class="title_btn wd115 addAgentClass">시간표 추가</a></div>

							<div class="con_form mgt10">
								<table class="tbl_ty3" id="agentClassList">
									<colgroup>
										<col width="160px"/>
										<col width="140"/>
										<col width="180px"/>
										<col width="180px"/>
										<col width="100px"/>
										<col width="100px"/>		
										<col width="50px"/>									
									</colgroup>
									<tr class="filter">
										<td>날짜</td>
										<td>시간</td>
										<td>대과목</td>
										<td>소과목</td>
										<td>교수</td>
										<td>작성자</td>
										<td>삭제</td>
									</tr>
									<tr class="none"><td colspan="7">등록된 데이터가 없습니다.</td></tr>
									
									
									
									<!-- 
									<tr>
										<td class="tbl_focus">
											<input type="date" class="tbl_date wd120"/>
										</td>
										<td>
											<input type="text" class="tbl_input wd65" value="09:00" />
											<input type="text" class="tbl_input wd65" value="09:50" />
										</td>
										<td>
											<select class="tbl_select wd140">
												<option>요양보호개론</option>
												<option>요양보호관련 기초지식</option>
												<option>요양보호각론</option>
												<option>특수요양보호각론</option>
											</select>
										</td>
										<td>
											<select class="tbl_select wd230">
												<option>요양보호 관련 제도 및 서비스</option>
												<option>요양보호 업무의 목적 및 기능</option>
												<option>요양보호사의 직업윤리와 자세</option>
												<option>요양보호대상자 이해</option>
												<option>의학적 · 간호학적 기초지식</option>
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
											<select class="tbl_select wd100">
												<option>김전임</option>
											</select>
										</td>
										<td>
											김사무원
										</td>
									</tr>
									<tr>
										<td class="tbl_focus">
											<input type="date" class="tbl_date wd120"/>
										</td>
										<td>
											<input type="text" class="tbl_input wd65" value="10:00" />
											<input type="text" class="tbl_input wd65" value="10:50" />
										</td>
										<td>
											<select class="tbl_select wd140">
												<option>요양보호개론</option>
												<option>요양보호관련 기초지식</option>
												<option>요양보호각론</option>
												<option>특수요양보호각론</option>
											</select>
										</td>
										<td>
											<select class="tbl_select wd230">
												<option>요양보호 관련 제도 및 서비스</option>
												<option>요양보호 업무의 목적 및 기능</option>
												<option>요양보호사의 직업윤리와 자세</option>
												<option>요양보호대상자 이해</option>
												<option>의학적 · 간호학적 기초지식</option>
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
											<select class="tbl_select wd100">
												<option>김전임</option>
											</select>
										</td>
										<td>
											김사무원
										</td>
									</tr>
									<tr>
										<td class="tbl_focus">
											<input type="date" class="tbl_date wd120"/>
										</td>
										<td>
											<input type="text" class="tbl_input wd65" value="11:00" />
											<input type="text" class="tbl_input wd65" value="11:50" />
										</td>
										<td>
											<select class="tbl_select wd140">
												<option>요양보호개론</option>
												<option>요양보호관련 기초지식</option>
												<option>요양보호각론</option>
												<option>특수요양보호각론</option>
											</select>
										</td>
										<td>
											<select class="tbl_select wd230">
												<option>요양보호 관련 제도 및 서비스</option>
												<option>요양보호 업무의 목적 및 기능</option>
												<option>요양보호사의 직업윤리와 자세</option>
												<option>요양보호대상자 이해</option>
												<option>의학적 · 간호학적 기초지식</option>
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
											<select class="tbl_select wd100">
												<option>김전임</option>
											</select>
										</td>
										<td>
											김사무원
										</td>
									</tr>
									<tr>
										<td class="tbl_focus">
											<input type="date" class="tbl_date wd120"/>
										</td>
										<td>
											<input type="text" class="tbl_input wd65" value="12:00" />
											<input type="text" class="tbl_input wd65" value="12:50" />
										</td>
										<td>
											<select class="tbl_select wd140">
												<option>요양보호개론</option>
												<option>요양보호관련 기초지식</option>
												<option>요양보호각론</option>
												<option>특수요양보호각론</option>
											</select>
										</td>
										<td>
											<select class="tbl_select wd230">
												<option>요양보호 관련 제도 및 서비스</option>
												<option>요양보호 업무의 목적 및 기능</option>
												<option>요양보호사의 직업윤리와 자세</option>
												<option>요양보호대상자 이해</option>
												<option>의학적 · 간호학적 기초지식</option>
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
											<select class="tbl_select wd100">
												<option>김전임</option>
											</select>
										</td>
										<td>
											김사무원
										</td>
									</tr> -->
								</table>
								
								<div class="btn_box"><a href="" class="btn_center wd100">시간표 추가</a></div>
							</div>
						</div>
						<!--conBox end-->		
						
						
						<div class="text_btn t_right mgt15">
							<span href="javascript:void(0)" onclick="$('#w01').window('open')">지난 시간표 불러오기</span>
						</div>
						
						
						<div class="main_btn">
							<ul class="wd295">
								<li class="page_back mgr5"><a>취소</a></li>
								<li class="page_back mgr5 tempSave"><a>임시저장</a></li>
								<li class="page_ok"><a>다음</a></li>
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
