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

		//https://www.tablefilter.com/custom-checkbox-selection.html

		//1 교육생 필터조회 : NO 
	    $("#sch_no").on("keyup", function() {
	    	fn_fillter();
		    /* 
	        var value = $(this).val().toLowerCase();
	        //$("#gridList tr").filter(function() {
	        //    $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
	        //});
	         $("#gridList > tbody > tr:not(.tb_header)").hide();
	         var temp = $("#gridList > tbody > tr > td:nth-child(6n+1):contains('" + value + "')");
	         $(temp).parent().show(); */
	    });


		//2 교육생 필터조회 : 구분 
	    $("#sch_class_name").change(function() {
	    	fn_fillter();
	    });

		//3 교육생 필터조회 : 성명 
	    $("#sch_stu_name").on("keyup", function() {
	    	fn_fillter();
	    });


		//4 교육생 필터조회 : 주민등록번호 
	    $("#sch_stu_id_number").on("keyup", function() {
	    	fn_fillter();
	    });

		//5 교육생 필터조회 : 연락처 
	    $("#sch_stu_tel").on("keyup", function() {
	    	fn_fillter();
	    });

		//6 교육생 필터조회 : 선택여부 
	    $("#sch_yn").change(function() {
	    	fn_fillter();				 
	    });


		// 체크박스 모두선택		
		$("#all_check03").click(function(){
			addRow();
		});
		

		// 교육생 체크박스 선택
		$('#gridList').on('click', '.tbl_check', function() {

	        addRow();
		});


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


	});
	
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

    function fn_fillter()
    {
	    
    	var sch_no = $("#sch_no").val().toLowerCase();
    	var sch_class_name = $("#sch_class_name").find(":selected").text();
    	var sch_stu_name = $("#sch_stu_name").val().toLowerCase();
    	
    	var sch_stu_id_number = $("#sch_stu_id_number").val().toLowerCase();
    	var sch_stu_tel = $("#sch_stu_tel").val().toLowerCase();
    	var sch_yn = $("#sch_yn").find(":selected").text();

    	//console.log(sch_class_name);
    	$('#gridList tr.items').hide();
        $('#gridList tr.items').each(function(i) {
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

	        
			//console.log("td_yn: "+td_yn);
			
	        if (td_yn)
		    {
	        	td_yn= "Y";
			}
	        else
		    {
	        	td_yn= "N";
			}
			
	        //console.log("i: "+i + ":" +td_yn);
	        
	        //1
	        if(sch_no == '' || (sch_no != '' && sch_no == td_no)){
		        sch_no_flag = true;
		    }

	        //2
	        if(sch_class_name == '' || (sch_class_name != '' && td_class_name.indexOf(sch_class_name) > -1)){
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
	        if(sch_yn == '' || (sch_yn != '' && td_yn.indexOf(sch_yn) > -1)){
	        	sch_yn_flag = true;
		    }
		    
		    //console.log(sch_no_flag +'|'+ sch_class_name_flag +'|'+ sch_stu_name_flag);
		    
			if(sch_no_flag && sch_class_name_flag && sch_stu_name_flag 
			  && sch_stu_tel_flag && sch_stu_tel_flag && sch_yn_flag) {
				$(this).show();
			}
		});

		/* 
        var sch_no = $("#sch_no").val().toLowerCase();
        var sch_stu_name = $("#sch_stu_name").val().toLowerCase();

        console.log(sch_no);
        
        //$("#gridList tr").filter(function() {
        //    $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
        //});
         $("#gridList > tbody > tr:not(.tb_header)").hide();

		 var temp = $("#gridList > tbody > tr > td:nth-child");
			         
         temp = temp(6n+1):contains('" + sch_no + "')");
         temp = $("#gridList > tbody > tr > td:nth-child(6n+3):contains('" + sch_stu_name + "')");

         
         $(temp).parent().show();
          */
	}

	function addRow()
	{
		//console.log("addRow : ");
		var rowData = new Array();
		var tdArr = new Array();
		var checkbox = $("input[name=chk3]:checked");
		$('#STUDENT_TOTAL_COUNT').val(checkbox.length);
				 
		console.log("checkbox length : " + checkbox.length );
		// 체크된 체크박스 값을 가져온다
		checkbox.each(function(i) {
			//console.log("i : " + i);
			// checkbox.parent() : checkbox의 부모는 <td>이다.
			// checkbox.parent().parent() : <td>의 부모이므로 <tr>이다.
			var tr = checkbox.parent().parent().eq(i);
			var td = tr.children();
			
			// 체크된 row의 모든 값을 배열에 담는다.			
			var STU_NAME = td.eq(2).text();
			var STU_ID = checkbox.eq(i).val();
			//console.log("STU_NAME : " + STU_NAME);
			//console.log("STU_ID : " + STU_ID);

			var isAdd = true;
			
		    $('#selectList tr:not(:first)').each(function(index, item) {

				var $table = $(this);
				var td_stu_id = $table.find("td").eq(1).text();
				//같은게 있으면 추가 하지 않는다
				if (STU_ID == td_stu_id)
				{
					isAdd = false;
				}
		    	//console.log("** stu_id : " + STU_ID );
		    	//console.log("** td_stu_id : " + STU_ID );	
		    });

		    if (isAdd)
			{
				var _html = '';	
				_html += '<tr id=stu_id_'+STU_ID+'>'+
							'<td >'+STU_NAME+'</td>'+
							'<td width=0px style=visibility:hidden;>'+STU_ID+'</td>'+
						'</tr>';	
				$('#selectList').append(_html);
			}		      
			
		});

		var uncheckbox = $("input[name=chk3]:not(:checked)");
		uncheckbox.each(function(i) {
			//console.log("@@aaaa : " + i);
			var tr = uncheckbox.parent().parent().eq(i);
			var td = tr.children();

			var STU_NAME = td.eq(1).text();
			var STU_ID = uncheckbox.eq(i).val();
			//console.log("@@STU_NAME : " + STU_NAME);
			//console.log("@@STU_ID : " + STU_ID);
			
		});
		

		// 체크된 체크박스 값을 가져온다
		uncheckbox.each(function(i) {
			//console.log("i : " + i);
			// checkbox.parent() : checkbox의 부모는 <td>이다.
			// checkbox.parent().parent() : <td>의 부모이므로 <tr>이다.
			var tr = uncheckbox.parent().parent().eq(i);
			var td = tr.children();
			
			// 체크된 row의 모든 값을 배열에 담는다.			
			var STU_NAME = td.eq(1).text();
			var STU_ID = uncheckbox.eq(i).val();
			//console.log("STU_NAME : " + STU_NAME);
			//console.log("STU_ID : " + STU_ID);

			var isRemove = false;
			var idx = 0;
		    $('#selectList tr:not(:first)').each(function(index, item) {

				var $table = $(this);
				var td_stu_id = $table.find("td").eq(1).text();
				//같은게 있으면 제거한다.
				if (STU_ID == td_stu_id)
				{
					isRemove = true;
					idx = index;
				}
		    	//console.log("*********** stu_id : " + STU_ID );
		    	//console.log("*********** td_stu_id : " + STU_ID );	
		    });

		    if (isRemove)
			{
				
				//$('#selectList tr:not(:first):eq(0)').remove();
		    	$('#selectList tr:not(:first):eq('+idx+')').remove();
			}		      
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
											<input type="text" class="tbl_input" name="CLASS_TITLE" id="CLASS_TITLE"/>
										</td>
										<td class="t_head">
											교육인원
										</td>
										<td>
											<!-- <span name="STUDENT_TOTAL_COUNT" id="STUDENT_TOTAL_COUNT" ></span> -->
											<input class="wd130" name="STUDENT_TOTAL_COUNT" id="STUDENT_TOTAL_COUNT"/> 명
										</td>
									</tr>
									<tr>
										<td class="t_head">
											교육기간
										</td>
										<td class="pdl15 pdr15" colspan="3">
											<input type="date" class="tbl_date wd150" name="CLASS_BEGIN_DATE" id="CLASS_BEGIN_DATE"/>
											~
											<input type="date" class="tbl_date wd150" name="CLASS_END_DATE" id="CLASS_END_DATE"/>
										</td>
									</tr>
								</table>
							</div>
							
						</div>
						<!--conBox end-->		
						
						<!--conBox-->
						<div class="conBox mgt40">
							<div class="con_title">
								교육생 명부 등록
							</div>
							<div class="con_form over_y mhi417 ">
								<table class="tbl_ty5 wd755 float_l" id="gridList">
									<colgroup>
										<col width="60px"/>
										<col width="155px"/>
										<col width="90px"/>
										<col width="140px"/>
										<col width="140px"/>
										<col width="60px"/>
									</colgroup>
									<tr class="tb_header">
										<td>순번</td>
										<td>구분</td>
										<td>성명</td>
										<td>주민등록번호</td>
										<td>연락처</td>
										<td class="check_form over_hide">
											<div class="float_l">선택</div>
											<input type="checkbox" id="all_check03" class="all_check"/>
											<label for="all_check03" class="float_l mgl15"><span></span></label>
										</td>
									</tr>
									
									<tr class="tb_header">
										<td>
											<input type="text" class="tbl_input wd60" value="" id="sch_no" />
										</td>
										<td>
											<select class="tbl_select"  id="sch_class_name" >
												<option></option>
												<option>표준</option>
												<option>경력자</option>
											</select>
										</td>
										<td>
											<input type="text" class="tbl_input" value="" id="sch_stu_name" />
										</td>
										<td>
											<input type="text" class="tbl_input" value="" id="sch_stu_id_number" />
										</td>
										<td>
											<input type="text" class="tbl_input" value="" id="sch_stu_tel" />
										</td>
										<td>
											<select class="tbl_select wd60" id="sch_yn" >
												<option></option>
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
