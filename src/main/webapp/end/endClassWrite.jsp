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
    var _AGC_ID = '${sessionScope.userInfo.AGC_ID}';
    var _CLASS_ID = '${CLASS_ID}';
    
	$(document).ready(function() {
		
		//스텝 이동
		$('.move').on('click', function() {
			if($('#CLASS_TITLE').val() == '') {
				alert("수료과정명을 입력하세요.");
				$('#CLASS_TITLE').focus();
				return false;
			}
			
			if($("input[name=chk3]:checked").length == 0) {
				alert('교육생을 선택하세요.')
				return false;
			}
			
			$('.sub_con').hide();
			$('.step_'+$(this).data('move')).show();
		});
		
		if(_AGC_ID != null && _AGC_ID != '') {
			//getStudentList();
			getEndClassDetail();
		}
		
		//1 교육생 필터조회 : 순번 
	    $("#sch_no").on("keyup", function(key) {
	    	if(key.keyCode == 13) {
	    		fn_fillter();
	    	}
	    });

		//2 교육생 필터조회 : 구분 
	    $("#sch_class_name").change(function() {
	    		fn_fillter();
	    });

		//3 교육생 필터조회 : 성명 
	    $("#sch_stu_name").on("keyup", function(key) {
	    	if(key.keyCode == 13) {
	    		fn_fillter();
	    	}
	    });

		//4 교육생 필터조회 : 주민등록번호 
	    $("#sch_stu_id_number").on("keyup", function(key) {
	    	if(key.keyCode == 13) {
	    		fn_fillter();
	    	}
	    });

		//5 교육생 필터조회 : 연락처 
	    $("#sch_stu_tel").on("keyup", function(key) {
	    	if(key.keyCode == 13) {
	    		fn_fillter();
	    	}
	    });

		//6 교육생 필터조회 : 선택여부 
	    $("#sch_yn").change(function() {
	    	fn_fillter();				 
	    });

		
		// 체크박스 모두선택		
		$("#all_check_time").click(function(){
			 if($("#all_check_time").prop("checked")){			 
				 $('#studentList tr.items:visible').each(function() {

					 $(this).children().find("input[name=chk3]").prop("checked",true);
					 $(this).children("td").css({"background":"#ebf0f9"});
					 addStudent();
				 });			 
				 //$("input[name=chk3]").prop("checked",true);
				//$(".tbl_list02").children("td").css({"background":"#ebf0f9"});
	        }else{        	
	        	 $('#studentList tr.items:visible').each(function() {

					 $(this).children().find("input[name=chk3]").prop("checked",false);
					 $(this).children("td").css({"background":"#fff"});
					 addStudent();
				 });
	            //$("input[name=chk3]").prop("checked",false);
				//$(".tbl_list02").children("td").css({"background":"#fff"});
	        }
		});
		
		
		// 교육생 체크박스 선택
		$('#studentList').on('click', '.tbl_check', function() {
			addStudent();
		});
		
		//이수시간 작성
		$('#enterStudentList').on('keyup', '.items input', function() {
			//console.log($(this).data('time_id') + '<<<');
			//$('#fixStudentList .'+$(this).data('time_id')).text($(this).val());
			
			$('#enterStudentList .items').each(function(i) {
				var SUM = 0;
				var P_TIME1 = $(this).find('input[name=P_TIME1]').val();
				var P_TIME2 = $(this).find('input[name=P_TIME2]').val();
				var S_TIME = $(this).find('input[name=S_TIME]').val();
				if(P_TIME1 == '' && P_TIME2 == '' && S_TIME == '') {
					SUM = '';
				} else {
					if(P_TIME1 != '') {
						SUM += parseInt(P_TIME1);
					}
					if(P_TIME2 != '') {
						SUM += parseInt(P_TIME2);
					}
					if(S_TIME != '') {
						SUM += parseInt(S_TIME);
					}
				}
				$('#fixStudentList .items:eq('+i+')').find('td:eq(4)').text(SUM);
				$('#fixStudentList .items:eq('+i+')').find('td:eq(6)').text(SUM);
			});
		});

		
		//저장
		$('.saveEndClass').on('click', function() {
			var CD_ADD_STATE = $(this).data('cd_add_state');
			
			if(_CLASS_ID != '' && CD_ADD_STATE != '4') {
				CD_ADD_STATE = '2';
			}
			
			var endClassDetail = {
				'CLASS_ID' : _CLASS_ID
				, 'AGC_ID' : _AGC_ID
				, 'CLASS_TITLE' : $('#CLASS_TITLE').val()
				, 'STUDENT_TOTAL_COUNT' : $('#STUDENT_TOTAL_COUNT').val()
				, 'CLASS_NOTE' : $('#CLASS_NOTE').val()
				, 'CD_ADD_STATE' : CD_ADD_STATE
			};
			

			var stuIds = new Array();
			$('#fixStudentList .items').each(function() {
				stuIds.push($(this).closest('.items').data('stu_id'));
			});
			
			var studentList = new Array();
			$('#enterStudentList .items').each(function() {
				var STU_ID = $(this).closest('.items').data('stu_id');
				//var L_TIME =
				var P_TIME1 = $(this).find('input[name=P_TIME1]').val();
				var P_TIME2 = $(this).find('input[name=P_TIME2]').val();
				var S_TIME = $(this).find('input[name=S_TIME]').val();
				
				studentList.push({'STU_ID' : STU_ID, 'P_TIME1' : P_TIME1, 'P_TIME2' : P_TIME2, 'S_TIME' : S_TIME});
				
			});
			
			if(!confirm('저장하시겠습니까?')) {
				return false;
			}
			
			var params = {
				'class' : 'service.EndService',
				'method' : 'saveEndClass',
				'param' : {
						'endClassDetail' : JSON.stringify(endClassDetail)
						, 'stuIds' : JSON.stringify(stuIds)
						, 'studentList' : JSON.stringify(studentList)
						, 'PAGE_INDEX' : 0
						, 'AGC_ID' : _AGC_ID
				},
				'callback' : function(data){
					if(data.success){
						loadingStop();
						
						alert('저장 되었습니다.');
						location.href='/end/endClassList';
					}
				}
			};
			apiCall(params);
		});
	});
	
	function getEndClassDetail() {
		if(_CLASS_ID == null || _CLASS_ID == '') {
			var params = {
					'class' : 'endMapper',
					'method' : 'getStudentList',
					'param' : {					
						'AGC_ID' : _AGC_ID
					},
					'callback' : function(data){
						if(data.success){
							loadingStop();
							
							var _html = '';
							if(data.list.length > 0) {
								$('#studentList .none').remove();
								$.each(data.list, function(index, item) {
									var str_checked="";
									if (item.CLASS_ID!="") { var str_checked = "checked";}
									
									_html += '<tr class="tbl_list02 items" data-stu_id="'+item.STU_ID+'" data-cd_class_type="'+item.CD_CLASS_TYPE+'" data-stu_note="'+item.STU_NOTE+'">'+
												'<td>'+item.NO+'</td>'+
												'<td>'+item.CD_CLASS_TYPE_NAME+'</td>'+
												'<td>'+item.STU_NAME+'</td>'+
												'<td>'+item.STU_ID_NUMBER+'</td>'+
												'<td>'+item.STU_TEL+'</td>'+
												'<td  class="check_form">'+
													'<input type="checkbox" id=list_check_'+ index+' name="chk3" value="'+item.STU_ID+'"' + str_checked +' class="tbl_check"/>'+
													'<label for=list_check_'+ index+'><span></span></label>'+
												'</td>'+
											'</tr>';
								});
								$('#studentList').append(_html);
								addStudent();
							}
						}
					}
				};
			apiCall(params);
		}else {
			var params = {
				'class' : 'service.EndService',
				'method' : 'getEndClassDetail',
				'param' : {
					'CLASS_ID' : _CLASS_ID,
					'AGC_ID' : _AGC_ID,
					'PAGE_SIZE' : 1,
					'PAGE_INDEX' : 0
				},
				'callback' : function(data) {
					if(data.success) {
						loadingStop();
						
						var endClassDetail = data.endClassDetail;	//수료 개요
						var studentList = data.studentList;			//교육생 명부
						
						console.log(data);
						
						//수료 개요
						$('#CLASS_TITLE').val(endClassDetail.CLASS_TITLE);
						$('#STUDENT_TOTAL_COUNT').val(endClassDetail.STUDENT_TOTAL_COUNT);
						
						
						//교육생 명부
						var _html = '';
						if(studentList.length > 0) {
							$('#studentList .none').remove();
							$.each(studentList, function(index, item) {
								
								var str_checked="";
								if (item.CLASS_ID == _CLASS_ID) { var str_checked = "checked";}
								
								_html += '<tr class="tbl_list02 items" data-stu_id="'+item.STU_ID+'" data-cd_class_type="'+item.CD_CLASS_TYPE+'" data-stu_note="'+item.STU_NOTE+'">'+
											'<td>'+item.NO+'</td>'+
											'<td>'+item.CD_CLASS_TYPE_NAME+'</td>'+
											'<td>'+item.STU_NAME+'</td>'+
											'<td>'+item.STU_ID_NUMBER+'</td>'+
											'<td>'+item.STU_TEL+'</td>'+
											'<td  class="check_form">'+
												'<input type="checkbox" id=list_check_'+ index+' name="chk3" value="'+item.STU_ID+'"' + str_checked +' class="tbl_check"/>'+
												'<label for=list_check_'+ index+'><span></span></label>'+
											'</td>'+
										'</tr>';
							});
							$('#studentList').append(_html);
							addStudent();
						}
					}
				}
			}
			apiCall(params);
		}
	}
	
		
	function getStudentList() {


		
	}
	
    function fn_fillter()
    {

    	var sch_no = $("#sch_no").val().toLowerCase();
    	var sch_class_name = $("#sch_class_name").find(":selected").text();
    	var sch_stu_name = $("#sch_stu_name").val().toLowerCase();
    	
    	var sch_stu_id_number = $("#sch_stu_id_number").val().toLowerCase();
    	var sch_stu_tel = $("#sch_stu_tel").val().toLowerCase();
    	var sch_yn = $("#sch_yn").find(":selected").text();

    	$('#studentList tr.items').hide();
        $('#studentList tr.items').each(function(i) {
        	var sch_no_flag = false;
        	var sch_class_name_flag = false;
	    	var sch_stu_name_flag = false;
	    	
	    	var sch_stu_id_number_flag = false;
	    	var sch_stu_tel_flag = false;
	    	var sch_yn_flag = false;
	    	
        	var td_no = $(this).find('td:eq(0)').text().toLowerCase();
        	var td_class_name = $(this).find('td:eq(1)').text().toLowerCase();
	        var td_stu_name = $(this).find('td:eq(2)').text().toLowerCase();

        	var td_stu_id_number = $(this).find('td:eq(3)').text().toLowerCase();
        	var td_stu_tel = $(this).find('td:eq(4)').text().toLowerCase();				
	        var td_yn = $(this).children().find('input[type="checkbox"]').is(':checked');
	        
			
	        if (td_yn)
		    {
	        	td_yn= "Y";
			}
	        else
		    {
	        	td_yn= "N";
			}
			
	        
	        //1
	        if(sch_no == '' || (sch_no != '' && sch_no == td_no)){
		        sch_no_flag = true;
		    }

	        //2
	        if(sch_class_name == '전체' || (sch_class_name != '' && td_class_name === sch_class_name)){
	        	sch_class_name_flag = true;
		    }

	        //3
	        if(sch_stu_name == '' || (sch_stu_name != '' && td_stu_name.indexOf(sch_stu_name) > -1)){
		    	sch_stu_name_flag = true;
		    }

	        //4
	        if(sch_stu_id_number == '' || (sch_stu_id_number != '' && td_stu_id_number.indexOf(sch_stu_id_number) > -1)){
	        	sch_stu_id_number_flag = true;
		    }

	        //5
	        if(sch_stu_tel == '' || (sch_stu_tel != '' && td_stu_tel.indexOf(sch_stu_tel) > -1)){
	        	sch_stu_tel_flag = true;
		    }

	        //6
	        if(sch_yn == '전체' || (sch_yn != '' && td_yn.indexOf(sch_yn) > -1)){
	        	sch_yn_flag = true;
		    }
		    
			if(sch_no_flag && sch_class_name_flag && sch_stu_name_flag 
					&& sch_stu_id_number_flag && sch_stu_tel_flag && sch_yn_flag) {
				$(this).show();
			}
		});
	}

    function addStudent() {
    	var _html = '';
    	
    	$('#STUDENT_TOTAL_COUNT').val($("input[name=chk3]:checked").length);
    	$('#selectList .items').remove();
    	$('#enterStudentList .items').remove();
    	$('#fixStudentList .items').remove();
    	$('#studentList .items input:checkbox:checked').each(function(i) {
    	    var stu_id = $(this).closest('.items').data('stu_id');
    	    var cd_class_type = $(this).closest('.items').data('cd_class_type');
    	    var field0 = i+1; //순번
    	    var field1 = $(this).closest('.items').find('td:eq(1)').text(); //구분
    	    var field2 = $(this).closest('.items').find('td:eq(2)').text(); //성명
    	    var field3 = $(this).closest('.items').find('td:eq(3)').text(); //주민등록번호
    	    var field4 = $(this).closest('.items').find('td:eq(4)').text(); //연락처
    	    var field5 = $(this).closest('.items').data('stu_note');		//비고
    	    
    		
    		_html = '';
			_html += '<tr class="items" data-stu_id='+stu_id+' data-cd_class_type="'+cd_class_type+'">'+
						'<td >'+field2+'</td>'+
						'<td width=0px style=visibility:hidden;>'+stu_id+'</td>'+
					'</tr>';	
			$('#selectList').append(_html);
			
			_html = '';
			_html += '<tr class="tbl_focus items" data-stu_id='+stu_id+' data-cd_class_type="'+cd_class_type+'">'
				_html += '<td>'+field0+'</td>'
				_html += '<td>'+field1+'</td>'
				_html += '<td>'+field2+'</td>'
				_html += '<td>'+field3+'</td>'
				_html += '<td>'+field4+'</td>'
				_html += '<td><input type="text" class="tbl_input wd65 t_center" data-time_id="P_TIME1_'+stu_id+'" name="P_TIME1" id="P_TIME1"/></td>'
				_html += '<td><input type="text" class="tbl_input wd65 t_center" data-time_id="P_TIME2_'+stu_id+'" name="P_TIME2" id="P_TIME2"/></td>'
				_html += '<td><input type="text" class="tbl_input wd65 t_center" data-time_id="S_TIME_'+stu_id+'" name="S_TIME" id="S_TIME"/></td>'
			_html += '</tr>'
			$('#enterStudentList').append(_html);
			
			_html = '';
			_html += '<tr class="tbl_ty2 items" data-stu_id='+stu_id+' data-cd_class_type="'+cd_class_type+'">'
				_html += '<td>'+field0+'</td>'
				_html += '<td>'+field1+'</td>'
				_html += '<td>'+field2+'</td>'
				_html += '<td>'+field3+'</td>'
				_html += '<td></td>'
				_html += '<td></td>'
				_html += '<td></td>'
				_html += '<td>'+field5+'</td>'
				_html += '<td width=0px style=visibility:hidden;>'+field4+'</td>'
			_html += '</tr>'
			$('#fixStudentList').append(_html);
    	});
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
					<span class="nav">수료보고</span>
					<span class="nav">수료보고</span>
					<span class="nav">상세정보</span>
				</div>
				<form name="frm" id="frm" method="post">
				<input type="hidden" name="CLASS_ID" id="CLASS_ID" value="${CLASS_ID}"/>
				<div class="sub_box">
					<div class="sub_menu">
						<div class="sub_title">수료보고</div>
						<div class="sub_list">
							<ul>
								<li class="sub_on"><a href="/end/endClassWrite">수료보고</a></li>
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
										<div class="step_txt">수료 개요</div>
									</li>
									<li class="step_list">
										<div class="step_num">2</div>
										<!--<div class="step_check"><img src="/assets/images/step_check.png"/></div>-->
										<div class="step_txt">실습이수시간 작성</div>
									</li>
									<li class="step_list">
										<div class="step_num">3</div>
										<div class="step_txt">교육생 명부</div>
									</li>
								</ul>
							</div>
						</div>
						<!--conBox-->
						<div class="conBox mgt40">
							<div class="con_title">수료 개요</div>
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
											수료과정명
										</td>
										<td class="pdl15 pdr15">
											<input type="text" class="tbl_input wd250" id="CLASS_TITLE" name="CLASS_TITLE"/>
										</td>
										<td class="t_head">
											교육인원
										</td>
										<td>
											<input type="text" class="tbl_input wd250" id="STUDENT_TOTAL_COUNT" name="STUDENT_TOTAL_COUNT"/>
										</td>
									</tr>
								</table>
							</div>
							
						</div>
						<!--conBox end-->		
						
						<!--conBox-->
						<div class="conBox">
							<div class="con_title">
								교육생 명부 등록
							</div>
							<div class="con_form over_y mhi417">
								<table class="tbl_ty5 wd755 float_l" id="studentList">
									<colgroup>
										<col width="60px"/>
										<col width="155px"/>
										<col width="90px"/>
										<col width="140px"/>
										<col width="140px"/>
										<col width="60px"/>
									</colgroup>
									<tr>
										<td>순번</td>
										<td>구분</td>
										<td>성명</td>
										<td>주민등록번호</td>
										<td>연락처</td>
										<td class="check_form over_hide">
											<div class="float_l">선택</div>
											<input type="checkbox" id="all_check_time" class="all_check"/>
											<label for="all_check_time" class="float_l mgl15"><span></span></label>
										</td>
									</tr>
									
									<tr class="tb_header">
										<td>
											<input type="text" class="tbl_input wd60" id="sch_no"/>
										</td>
										<td>
											<select class="tbl_select" id="sch_class_name">
												<option>전체</option>
												<c:forEach items="${cdClassTypeList}" var="item">
													<option value="${item.CODE}">${item.NAME}</option>
												</c:forEach>
											</select>
										</td>
										<td>
											<input type="text" class="tbl_input" id="sch_stu_name" value=""/>
										</td>
										<td>
											<input type="text" class="tbl_input" id="sch_stu_id_number"/>
										</td>
										<td>
											<input type="text" class="tbl_input" id="sch_stu_tel"/>
										</td>
										<td>
											<select class="tbl_select wd60" id="sch_yn">
												<option>전체</option>
												<option>Y</option>
												<option>N</option>
											</select>
										</td>
									</tr>
								</table>
								
								<table class="tbl_ty2 wd130 float_r" id="selectList">
									<colgroup>
										<col width="130px"/>
									</colgroup>
									<tr>
										<td>선택된 교육생 명부</td>
									</tr>
								</table>
							</div>
						</div>
						<!--conBox end-->
					
						
						<div class="main_btn">
							<ul class="wd295">
								<li class="page_back mgr5"><a href="javascript:history.back();">취소</a></li>
								<li class="page_back mgr5"><a href="javascript:void(0);" class="saveEndClass" data-cd_add_state="4">임시저장</a></li>
								<li class="page_ok"><a href="javascript:void(0);" class="move" data-move="02">다음</a></li>
							</ul>
						</div>
					</div>
					<!--sub con end / step_01 end-->
					<div class="sub_con step_02">
						<!--conBox-->
						<div class="conBox">
							<div class="sub_step">
								<ul class="page02_step">
									<li class="step_list ">
										<div class="step_check"><img src="/assets/images/step_check2.png"/></div>
										<div class="step_txt">수료 개요</div>
									</li>
									<li class="step_list step_on">
										<div class="step_num">2</div>
										<!--<div class="step_check"><img src="/assets/images/step_check.png"/></div>-->
										<div class="step_txt">실습이수시간 작성</div>
									</li>
									<li class="step_list">
										<div class="step_num">3</div>
										<div class="step_txt">교육생 명부</div>
									</li>
								</ul>
							</div>
						</div>
					
						<!--conBox-->
						<div class="conBox mgt40">
							<div class="con_title">실습이수시간 작성</div>
							
							<div class="con_form mgt10">
								<table class="tbl_ty3" id="enterStudentList">
									<colgroup>
										<col width="80px"/>
										<col width="130px"/>
										<col width="130px"/>
										<col width="200px"/>
										<col width="180px"/>
										<col width="80px"/>
										<col width="80px"/>
										<col width="80px"/>
									</colgroup>
									<tr>
										<td>순번</td>
										<td>과정구분</td>
										<td>이름</td>
										<td>주민등록번호</td>
										<td>연락처</td>
										<td>요양</td>
										<td>재가</td>
										<td>대체</td>
									</tr>
									
								</table>
							</div>
						</div>
						<!--conBox end-->
						
						<div class="main_btn">
							<ul class="wd295">
								<li class="page_back mgr5"><a href="javascript:void(0);" class="move" data-move="01">취소</a></li>
								<li class="page_back mgr5"><a href="javascript:void(0);" class="saveEndClass" data-cd_add_state="4">임시저장</a></li>
								<li class="page_ok"><a href="javascript:void(0);" class="move" data-move="03" id="calc">다음</a></li>
							</ul>
						</div>
					</div>
					<!--sub con end / step_02 end-->
					
					<div class="sub_con step_03">
						<!--conBox-->
						<div class="conBox mgt40">
							<div class="sub_step">
								<ul class="page02_step">
									<li class="step_list ">
										<div class="step_check"><img src="/assets/images/step_check2.png"/></div>
										<div class="step_txt">수료 개요</div>
									</li>
									<li class="step_list ">
										<div class="step_check"><img src="/assets/images/step_check2.png"/></div>
										<div class="step_txt">실습이수시간 작성</div>
									</li>
									<li class="step_list step_on">
										<div class="step_num">3</div>
										<div class="step_txt">교육생 명부</div>
									</li>
								</ul>
							</div>
						</div>
						
						<!--conBox-->
						<div class="conBox mgt40">
							<div class="con_title">교육생 명부</div>
							<div class="con_form">
								<table class="tbl_ty2" id="fixStudentList">
									<colgroup>
										<col width="80px"/>
										<col width="120px"/>
										<col width="100px"/>
										<col width="190px"/>
										<col width="120px"/>
										<col width="100px"/>
										<col width="100px"/>
										<col width="150px"/>
									</colgroup>
									<tr>
										<td>순번</td>
										<td>과정구분</td>
										<td>이름</td>
										<td>주민등록번호</td>
										<td>실습 이수 시간</td>
										<td>이론</td>
										<td>총</td>
										<td>비고</td>
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
											<textarea class="tbl_area" id="CLASS_NOTE" name="CLASS_NOTE"></textarea>
										</td>
									</tr>			
								</table>
							</div>
						</div>
						<!--conBox end-->
						
						<div class="main_btn">
							<ul class="wd295">
								<li class="page_back mgr5"><a href="javascript:void(0);" class="move" data-move="02">취소</a></li>
								<li class="page_back mgr5"><a href="javascript:void(0);" class="saveEndClass" data-cd_add_state="4">임시저장</a></li>
								<li class="page_ok"><a href="javascript:void(0);" class="saveEndClass" data-cd_add_state="1">제출</a></li>
							</ul>
						</div>
					</div>
					<!--sub con end / step_03 end-->
				</div>
				</form>
			</div>
		</div>
		
		<c:import url="/inc/footer_base.jsp" />
	</div>
</body>
</html>
