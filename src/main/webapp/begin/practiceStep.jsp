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
	
	var _CLASS_ID = '${CLASS_ID}';  //개강과목 코드
	var _AGC_ID = '${sessionScope.userInfo.AGC_ID}';  //세션 교육기관 코드
	var _ACC_ID = '${sessionScope.userInfo.ACC_ID}';  //세션 교육기관 코드
	
	var P_AGC_ID = '${AGC_ID}';  // 교유기관 코드
	var _CD_ADD_STATE = ""; //등록상태 : 등록 1 , 변경 2 , 삭제 3 , 임시저장 4
	
	if (_AGC_ID =="1") // 경기도청인 경우 
	{
		_AGC_ID = P_AGC_ID;
	}

	var $gRow = null;
	var gLev = 1;
	var gAGC_NAME = "";

	/**********************************************************************
	** ready 
	***********************************************************************/
		    
	$(document).ready(function() {
		getPracticeDetail();
		/********************************************************
		* 교육생 목록
		********************************************************/
		//1 교육생 필터조회 : NO 
	    $("#sch_no").on("keyup", function(key) {	 
	    	if (key.keyCode == 13) {
	    		fn_fillter();
	        }	    	
	    });
		//2 교육생 필터조회 : 구분 
	    $("#sch_class_name").change(function() {
	    	fn_fillter();
	    });
		//3 교육생 필터조회 : 성명 
	    $("#sch_stu_name").on("keyup", function(key) {
	    	if (key.keyCode == 13) {
	    		fn_fillter();
	        }	    
	    });
		//4 교육생 필터조회 : 주민등록번호 
	    $("#sch_stu_id_number").on("keyup", function(key) {
	    	if (key.keyCode == 13) {
	    		fn_fillter();
	        }	    
	    });
		//5 교육생 필터조회 : 연락처 
	    $("#sch_stu_tel").on("keyup", function(key) {
	    	if (key.keyCode == 13) {
	    		fn_fillter();
	        }	    
	    });
		//6 교육생 필터조회 : 선택여부 
	    $("#sch_yn").change(function() {
	    	fn_fillter();				 
	    });
		// 체크박스 모두선택		
		$("#all_check_time").click(function(){
			addRow();
		});
		// 교육생 체크박스 선택
		$('#practiceStudentList').on('click', '.tbl_check', function() {

	        addRow();
		});
		/********************************************************
		* 실습 계획표 
		********************************************************/
		// 구분 선택
		$('#practiceTimeTableList').on('change', 'select[name=CD_FACILITY_LEV1]', function() {
			var $items = $(this).closest('tr.items');
			var CD_MIDDLE = $(this).val();
			var params = {
					//'class' : 'commonMapper',
					//'method' : 'getCommonListByBottom',
					
					'class' : 'service.CommonService',
					'method' : 'getPracticeAdd',
										
					'param' : {'CD_TOP' : '6'
								, 'CD_MIDDLE' : CD_MIDDLE 
								, 'AGC_ID' : _AGC_ID
					},
					'callback' : function(data){
						if(data.success){
							loadingStop();
							$items.find('select[name=CD_FACILITY_LEV2]').empty();
							var _html = '';
							$.each(data.cdFacilityLev2List, function(index, item) {
								_html += '<option value="'+(item.CODE)+'">'+(item.NAME)+'</option>'
							});
							$items.find('select[name=CD_FACILITY_LEV2]').append(_html);


							$items.find('select[name=SAGC_ID]').empty();
							_html = '';
							$.each(data.cdSubAgencyList, function(index, item) {
								_html += '<option value="'+(item.SAGC_ID)+'"  >'+(item.SAGC_NAME)+'</option>'
							});
							
							
							$items.find('select[name=SAGC_ID]').append(_html);
								
							//fn_agent($items);
						}
					}
			};
			apiCall(params);

			fn_sub_agency();
		});

		
		//구분(세) 선택
		$('#practiceTimeTableList').on('change', 'select[name=CD_FACILITY_LEV2]', function() {
			var $items = $(this).closest('tr.items');
			var CD_FACILITY_LEV2 = $(this).val();
			var CD_FACILITY_LEV1 = $items.find('select[name=CD_FACILITY_LEV1]>option:selected').val();

			//result.put("cdSubAgencyList", beginMapper.getSubAgencyList(param));
			
			var params = {
					'class' : 'beginMapper',
					'method' : 'getSubAgencyList',										
					'param' : { 'AGC_ID' : _AGC_ID ,
								'CD_FACILITY_LEV1' : CD_FACILITY_LEV1 , 
								'CD_FACILITY_LEV2' : CD_FACILITY_LEV2 
					},
					'callback' : function(data){
						if(data.success){
							loadingStop();
							$items.find('select[name=SAGC_ID]').empty();
							var _html = '';
							$.each(data.list, function(index, item) {
								_html += '<option value="'+(item.SAGC_ID)+'">'+(item.SAGC_NAME)+'</option>'
							});
							$items.find('select[name=SAGC_ID]').append(_html);
						}
					}
			};
			apiCall(params);
		});
		

		// 교육생  체크박스 ALL
		$("#all_check_time").click(function(){
			 if($("#all_check_time").prop("checked")){			 
				 $('#practiceStudentList tr.items:visible').each(function() {

					 $(this).children().find("input[name=chk3]").prop("checked",true);
					 $(this).children("td").css({"background":"#ebf0f9"});
				 });			 
	        }else{        	
	        	 $('#practiceStudentList tr.items:visible').each(function() {
					 $(this).children().find("input[name=chk3]").prop("checked",false);
					 $(this).children("td").css({"background":"#fff"});
				 });
	        }
		});

		//지난 시간표 오픈 --> 삭제
		/* $('#wView1').on('click', function() {
			//$('#w01').window('open'); 
			fn_pop_time();
		}); */


		//과목별 교수요원 선택 버튼 클릭  --> 교육생 선택화면으로
		$('#practiceTimeTableList').on('click', '.stu_pop', function() {
			$gRow = $(this);
			gLev = 1;
			fn_pop_student($(this),gLev);
		});

		//교수요원 선택
		$('.choiceStudent').on('click', function() {
			$('#w01').window('close');
			
			var checkbox = $("input[name=STU_ID]:checked");
			var STU_NAMES = "";
			var STU_IDS = "";
			checkbox.each(function(i) {
				var tr = checkbox.parent().parent().eq(i);
				var td = tr.children();
				
				// 체크된 row의 모든 값을 배열에 담는다.			
				var STU_NAME = td.eq(1).text();
				var STU_ID = checkbox.eq(i).val();
				
				console.log("STU_NAME : " + STU_NAME);
				console.log("STU_ID : " + STU_ID);

				STU_NAMES += STU_NAME +",";
				STU_IDS += STU_ID +",";
				
			});


			//var $gRow = null;
			//var gLev = 1;

			STU_NAMES = STU_NAMES.substring(0,STU_NAMES.length-1);
			STU_IDS = STU_IDS.substring(0,STU_IDS.length-1);

			console.log("STU_NAMES.length : " + STU_NAMES.length);
			
			$gRow.closest('tr.items').find('.stu_count').text(checkbox.length);
			$gRow.closest('tr.items').find('input[name=STU_IDS]').val(STU_IDS);
			
		});

			
		
		// 계획표 추가 
		$('.addAgentClass').on('click', function() {
			
			//바로 위에 행 값 알아오기
			var _CD_FACILITY_LEV1 = "";
			var _CD_FACILITY_LEV2 = "";
			var _BEGIN_DATE = "";
			var _END_DATE = "";
			var _SAGC_ID = "";
			var _STU_IDS = "";
			var _STU_COUNT = "0";
			
			if ( $('#practiceTimeTableList .items:visible').length > 0 )
			{
				var _CD_FACILITY_LEV1 = $('#practiceTimeTableList .items:visible:last').find('select[name=CD_FACILITY_LEV1]>option:selected').val();
				var _CD_FACILITY_LEV2 = $('#practiceTimeTableList .items:visible:last').find('select[name=CD_FACILITY_LEV2]>option:selected').val();
				var _SAGC_ID = $('#practiceTimeTableList .items:visible:last').find('select[name=SAGC_ID]>option:selected').val();


				var _BEGIN_DATE = $('#practiceTimeTableList .items:visible:last').find('input[name=BEGIN_DATE]').val();
				var _END_DATE = $('#practiceTimeTableList .items:visible:last').find('input[name=END_DATE]').val();

				var _STU_IDS = $('#practiceTimeTableList .items:visible:last').find('input[name=STU_IDS]').val();
				var _STU_COUNT = $('#practiceTimeTableList .items:visible:last').find('.stu_count').text();
				
				//var _STUDENT_COUNT = $('#practiceTimeTableList .items:visible:last').find('input[name=STUDENT_COUNT]').val();
				
			}
			
			var params = {
					'class' : 'service.CommonService',
					'method' : 'getPracticeAdd',
					'param' : {
						'AGC_ID' : _AGC_ID ,
						'CD_TOP' : '6',
						'CD_MIDDLE' : _CD_FACILITY_LEV1
						},
					'callback' : function(data){
						if(data.success){
							loadingStop();
							$('#practiceTimeTableList .none').remove();
							
							var _html = '';
							_html += '<tr class="items" data-mapper_id="">'
								_html += '<input type="hidden" name="MAPPER_ID" value=""/>'
								_html += '<input type="hidden" name="STU_IDS" value="'+ _STU_IDS +'"/>'

								_html += '<td></td>'
										
								_html += '<td>'
									_html += '<select class="tbl_select wd150" name="CD_FACILITY_LEV1">'
									$.each(data.cdFacilityLev1List, function(index, item) {
										_html += '<option value="'+(item.CODE)+'"   '+(_CD_FACILITY_LEV1 == item.CODE ? 'selected' : '')+'  >'+(item.NAME)+'</option>'
									});
									_html += '</select>'
								_html += '</td>'

									
								_html += '<td>'
									_html += '<select class="tbl_select wd150" name="CD_FACILITY_LEV2">'
										$.each(data.cdFacilityLev2List, function(index, item) {
											_html += '<option value="'+(item.CODE)+'"  '+(_CD_FACILITY_LEV2 == item.CODE ? 'selected' : '')+'   >'+(item.NAME)+'</option>'
										});
									_html += '</select>'
								_html += '</td>'


								_html += '<td>'
									_html += '<select class="tbl_select wd80" name="SAGC_ID">'
										$.each(data.cdSubAgencyList, function(index, item) {
											_html += '<option value="'+(item.SAGC_ID)+'"  '+(_SAGC_ID == item.SAGC_ID ? 'selected' : '')+'   >'+(item.SAGC_NAME)+'</option>'
										});
									_html += '</select>'
								_html += '</td>'
									
								_html += '<td class="date">'
								_html += '	<input type="date" class="tbl_input wd150" name="BEGIN_DATE"  value="'+ _BEGIN_DATE +'" />'
								_html += '	<input type="date" class="tbl_input wd150" name="END_DATE"  value="'+ _END_DATE +'" />'
								_html += '</td>'

								_html += '<td><a class="reply_btn wd100 stu_pop" href=javascript:void(0)>교육생 선택</a></td>'
								_html += '<td>참여교육생 <span class="stu_count">'+ _STU_COUNT +'</span>명</td>'
								
								_html += '<td><div class="delete_icon removePracticeTimeTable" data-mapper_id=""></div></td>'
							_html += '</tr>'
							
							//$('#practiceTimeTableList .filter').after(_html);

							$('#practiceTimeTableList > tbody:last-child').append(_html);

							$('#practiceTimeTableList .items:visible:last').find('select[name=CD_FACILITY_LEV1]').focus();
							
							/* $('#practiceTimeTableList tr.items:visible').each(function(i) {
								$(this).find('.no').text((i+1));
							}); */
						}
					}
			};
			apiCall(params);
		});

		
		$('#practiceTimeTableList').on('click', '.removePracticeTimeTable', function() {
			var MAPPER_ID = $(this).data('mapper_id');

			console.log("MAPPER_ID:"+$(this).data('mapper_id') + ":");
			
			if(MAPPER_ID != null && MAPPER_ID != '') {
				$(this).closest('tr.items').hide();
			} else {
				$(this).closest('tr.items').remove();
			}
			
			/* $('#practiceTimeTableList tr.items:visible').each(function(i) {
				$(this).find('.no').text((i+1));
			}); */
			
			if($('#practiceTimeTableList tr.items:visible').length <= 0) {
				$('#practiceTimeTableList .filter').after('<tr class="none"><td colspan="7">등록된 데이터가 없습니다.</td></tr>');
			}
		});


		// 임시저장
		$('.tempSave').on('click', function() {
			_CD_ADD_STATE = "4";  //임시저장
			saveLogic();
	    });

		// 제출저장
		$('.sendSave').on('click', function() {
			if(_CLASS_ID=="")  //신규등록
			{
				_CD_ADD_STATE = "1";
			}
			else   // 변경
			{
				_CD_ADD_STATE = "2";
			}	
			saveLogic();
	    });



		//STEP1 에서 다음버튼 클릭
		$(".btn_step_next02").click(function(){
			$(".step_01").hide();
			$(".step_02").show();
		});
		
		//STEP2 에서 다음버튼 클릭
		$(".btn_step_next03").click(function(){
			$(".step_03").show();
			getLogicClassList();
			$(".step_02").hide();
			//$(".step_03").show();
		});
		


		$(".btn_step_back00").click(function(){
			history.back();
			//$(".step_01").hide();
			//$(".step_02").show();
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

	/**********************************************************************
	** READY END
	***********************************************************************/

	/**********************************************************************
	** 화면 조회 
	***********************************************************************/
	var practiceDetail;
	function getPracticeDetail() {
		if(_CLASS_ID == null || _CLASS_ID == '') {
			//교육생 명부만 조회해 와야 함
		
			var params = {
					'class' : 'beginMapper',
					'method' : 'getPracticeStudentList',
					'param' : {
						'AGC_ID' : _AGC_ID
					},
					'callback' : function(data){
						if(data.success){
							loadingStop();
							var practiceStudentList = data.practiceStudentList; //담당과목 목록 조회 , 교육생 명부 조회
	
							//교육생 명부
							var _html = '';


							if(data.success){
								loadingStop();
								$('#practiceStudentList .none').remove();
								$.each(data.list, function(index, item) {
									var str_checked="";
									_html += '<tr class="tbl_list02 items" data-stu_id="'+item.STU_ID+'">'+
									'<td>'+item.NO+'</td>'+
									'<td>'+item.CLASS_NAME+'</td>'+
									'<td>'+item.STU_NAME+'</td>'+
									'<td>'+item.STU_ID_NUMBER+'</td>'+
									'<td>'+item.STU_TEL+'</td>'+
									'<td  class="check_form">'+
										'<input type="checkbox" id=list_check_'+ index+' name="chk3" value="'+item.STU_ID+'"' + str_checked +' class="tbl_check"/>'+
										'<label for=list_check_'+ index+'><span></span></label>'+
									'</td>'+
								'</tr>';
								
								});
								$('#practiceStudentList .filter').after(_html);
							}

															
						}
					}
			};
			apiCall(params);	 
			//return false;
		}
		else
		{
	
			var params = {
					'class' : 'service.BeginService',
					'method' : 'getPracticeDetail',
					'param' : {
						'CLASS_ID' : _CLASS_ID,
						'AGC_ID' : _AGC_ID,
						'PAGE_SIZE' : 1,
						'PAGE_INDEX' : 0
					},
					'callback' : function(data){
						if(data.success){
							loadingStop();
							 practiceDetail = data.practiceDetail;	//교수요원 조회  , 개강개요 조회
							var practiceStudentList = data.practiceStudentList; //담당과목 목록 조회 , 교육생 명부 조회
							var practiceTimeTableList = data.practiceTimeTableList; //자격사항 목록 조회 , 시간표 조회
							
							//개강개요 조회
							$('#CLASS_TITLE').val(practiceDetail[0].CLASS_TITLE);
							$('#STUDENT_TOTAL_COUNT').val(practiceDetail[0].STUDENT_TOTAL_COUNT);
							$('#CLASS_BEGIN_DATE').val(practiceDetail[0].CLASS_BEGIN_DATE);
							$('#CLASS_END_DATE').val(practiceDetail[0].CLASS_END_DATE);
							$('#CLASS_NOTE').val(practiceDetail[0].CLASS_NOTE);
							gAGC_NAME = practiceDetail[0].AGC_NAME;
	
							//교육생 명부
							var _html = '';
	
							//담당과목 목록 조회 , 교육생 명부 조회
							if(practiceStudentList.length > 0) {
								$('#practiceStudentList .none').remove();
								$.each(practiceStudentList, function(index, item) {
									var str_checked="";
									if (item.CLASS_ID!="") { var str_checked = "checked";}
									//'<input type="hidden" name="STU_ID" value="'+item.STU_ID+'"/>'+
									
									_html += '<tr class="tbl_list02 items" data-stu_id="'+item.STU_ID+'">'+
												'<td>'+item.NO+'</td>'+
												'<td>'+item.CLASS_NAME+'</td>'+
												'<td>'+item.STU_NAME+'</td>'+
												'<td>'+item.STU_ID_NUMBER+'</td>'+
												'<td>'+item.STU_TEL+'</td>'+
												'<td  class="check_form">'+
													'<input type="checkbox" id=list_check_'+ index+' name="chk3" value="'+item.STU_ID+'"' + str_checked +' class="tbl_check"/>'+
													'<label for=list_check_'+ index+'><span></span></label>'+
												'</td>'+
											'</tr>';
								});
								$('#practiceStudentList .filter').after(_html);
								addRow();
							}
	
													
							//자격사항 목록 , 시간표 조회
							_html = '';
	
							if(practiceTimeTableList.length > 0) {
	
								$('#practiceTimeTableList .none').remove();
								$.each(practiceTimeTableList, function(index, item) {
	
									_html += '<tr class="items" data-mapper_id="'+item.MAPPER_ID+'">'
									
										_html += '<input type="hidden" name="MAPPER_ID"  value="'+item.MAPPER_ID+'"/>'
										_html += '<input type="hidden" name="STU_IDS" value="'+ item.STU_IDS +'"/>'
										
										_html += '<td class="lecture_date"><input type="date" class="tbl_date wd150" name="LECTURE_DATE"  value="'+item.LECTURE_DATE+'" /></td>'
										_html += '<td class="date">'
										_html += '	<input type="date" class="tbl_input wd150" name="BEGIN_DATE"  value="'+item.BEGIN_DATE+'" />'
										_html += '	<input type="date" class="tbl_input wd150" name="END_DATE"  value="'+item.END_DATE+'" />'
										_html += '</td>'
										_html += '<td>'
											_html += '<select class="tbl_select wd150" name="CD_FACILITY_LEV1">'
												$.each(data.cdFacilityLev1List, function(i, cdFacilityLev1) {
													_html += '<option value="'+cdFacilityLev1.CODE+'" '+(cdFacilityLev1.CODE == item.CD_FACILITY_LEV1 ? 'selected' : '')+'>'+(cdFacilityLev1.NAME)+'</option>'
												});
											_html += '</select>'
										_html += '</td>'
										_html += '<td>'
											_html += '<select class="tbl_select wd150" name="CD_FACILITY_LEV2">'
	
												$.each(data.cdFacilityLev2List, function(i, cdFacilityLev2) {
													if(cdFacilityLev2.CD_MIDDLE == item.CD_FACILITY_LEV1) {
														_html += '<option value="'+cdFacilityLev2.CD_BOTTOM+'"  '+(cdFacilityLev2.CD_BOTTOM == item.CD_FACILITY_LEV2 ? 'selected' : '')+' >'+(cdFacilityLev2.CD_BOTTOM_KR)+'</option>'
													}
												});
																						
											_html += '</select>'
										_html += '</td>'
	
										_html += '<td>'
											_html += '<select class="tbl_select wd80" name="SAGC_ID">'
												$.each(data.cdAgencyList, function(i, cdAgencyList) {
													//if(cdAgencyList.CD_FACILITY_LEV1 == item.CD_FACILITY_LEV1 && cdAgencyList.CD_FACILITY_LEV2 == item.CD_FACILITY_LEV2 ) {
														_html += '<option value="'+cdAgencyList.SAGC_ID+'"  '+(cdAgencyList.SAGC_ID == item.SAGC_ID ? 'selected' : '')+'  >'+(cdAgencyList.SAGC_NAME)+'</option>'
													//}
												});
											_html += '</select>'
										_html += '</td>'


										_html += '<td><a class="reply_btn wd100 stu_pop" href=javascript:void(0)>교육생 선택</a></td>'
										_html += '<td>참여교육생 <span class="stu_count">'+ item.STU_COUNT +'</span> 명</td>'
											
										_html += '<td><div class="delete_icon removePracticeTimeTable" data-mapper_id="'+item.MAPPER_ID+'"></div></td>'
									_html += '</tr>'
														
								});
								$('#practiceTimeTableList .filter').after(_html);
							}
									
						}
					}
			};
			apiCall(params);
		}
	}

	function fn_null(obj , rtn)
	{
		if(obj!=null) 
		{ 
			rtn = obj ; 
		}
		return rtn;
	}


	/**********************************************************************
	** 교육생 필터
	***********************************************************************/

    function fn_fillter()
    {

    	var sch_no = $("#sch_no").val().toLowerCase();
    	var sch_class_name = $("#sch_class_name").find(":selected").text();
    	var sch_stu_name = $("#sch_stu_name").val().toLowerCase();
    	
    	var sch_stu_id_number = $("#sch_stu_id_number").val().toLowerCase();
    	var sch_stu_tel = $("#sch_stu_tel").val().toLowerCase();
    	var sch_yn = $("#sch_yn").find(":selected").text();

    	//console.log(sch_class_name);
    	$('#practiceStudentList tr.items').hide();
        $('#practiceStudentList tr.items').each(function(i) {
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
		    
			if(sch_no_flag && sch_class_name_flag && sch_stu_name_flag 
			  && sch_stu_tel_flag && sch_stu_tel_flag && sch_yn_flag) {
				$(this).show();
			}
		});

	}


	var gRowId = null;
	var gClassId = "";
	
	function SetBackgroundColor(rowId) 
	{		
	   	if ( gRowId != null && $(gRowId).css("background-color")=="rgb(235, 240, 249)")
	  	{
	   		$(gRowId).css("background-color", "rgba(0, 0, 0, 0)");
		}

   		$(rowId).css("background-color", "rgb(235, 240, 249)");
   		gClassId = $(rowId).data('class_id');
   		
	   	gRowId = rowId;
	   
	}

	/**********************************************************************
	** 실습계획표 구분/구분(세) 변경 시 : 연계실습기관 조회 콤보
	***********************************************************************/
	function fn_sub_agency()
	{
		
	} 
	
	
	/**********************************************************************
	** 선택 교육생 
	***********************************************************************/

	function addRow()
	{
		var rowData = new Array();
		var tdArr = new Array();
		var checkbox = $("input[name=chk3]:checked");
		$('#STUDENT_TOTAL_COUNT').val(checkbox.length);
				 
		// 체크된 체크박스 값을 가져온다
		checkbox.each(function(i) {
			var tr = checkbox.parent().parent().eq(i);
			var td = tr.children();
			
			// 체크된 row의 모든 값을 배열에 담는다.			
			var STU_NAME = td.eq(2).text();
			var STU_ID = checkbox.eq(i).val();
			var isAdd = true;
			
		    $('#selectList tr:not(:first)').each(function(index, item) {

				var $table = $(this);
				var td_stu_id = $table.find("td").eq(1).text();
				//같은게 있으면 추가 하지 않는다
				if (STU_ID == td_stu_id)
				{
					isAdd = false;
				}
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
			var tr = uncheckbox.parent().parent().eq(i);
			var td = tr.children();

			var STU_NAME = td.eq(1).text();
			var STU_ID = uncheckbox.eq(i).val();			
		});
		

		// 체크된 체크박스 값을 가져온다
		uncheckbox.each(function(i) {
			var tr = uncheckbox.parent().parent().eq(i);
			var td = tr.children();
			
			// 체크된 row의 모든 값을 배열에 담는다.			
			var STU_NAME = td.eq(1).text();
			var STU_ID = uncheckbox.eq(i).val();

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
		    });

		    if (isRemove)
			{				
		    	$('#selectList tr:not(:first):eq('+idx+')').remove();
			}		      
		});
				
	}


	/**********************************************************************
	** 실습계획표 --> 교육생 팝업
	***********************************************************************/

	//교육생 선택 팝업 조회
	function fn_pop_student(obj,lev)
	{
		var $obj = obj;			
		var $items = $obj.closest('tr.items');
		
		/* var CD_FACILITY_LEV1 = $items.data('cd_facility_lev1');
		var CD_FACILITY_LEV2 = $items.data('cd_facility_lev2'); */

		var CD_FACILITY_LEV1 = $items.data('cd_facility_lev1');
		var CD_FACILITY_LEV2 = $items.data('cd_facility_lev2');

		var _STU_IDS = $items.find('input[name=STU_IDS]').val();
		
		console.log("_STU_IDS:"+_STU_IDS);
		//console.log("CD_FACILITY_LEV1:"+CD_FACILITY_LEV1 + "== CD_FACILITY_LEV2:"+CD_FACILITY_LEV2);

		var params = {
				'class' : 'service.BeginService',
				'method' : 'getPracticeStudentList',
				'param' : {					
					'AGC_ID' : _AGC_ID,
					'CLASS_ID' : _CLASS_ID,
					'CLASS_TYPE' : "2" , 
					'CD_FACILITY_LEV1' : CD_FACILITY_LEV1,
					'CD_FACILITY_LEV2' : CD_FACILITY_LEV2
				},
				'callback' : function(data){
					if(data.success){
						loadingStop();
												
						$('#selectPracticeStudentList .items').remove();
						
						var _html = '';
						if(data.practiceStudentList.length > 0) {
							$.each(data.practiceStudentList, function(index, item) {							
								var str_checked="";
								if (fn_same_chk(_STU_IDS,item.STU_ID)) { var str_checked = "checked";}
								
								_html += '<tr class="items" data-stu_id="'+item.STU_ID+'">'
																	
									_html += '<td>'+(index+1)+'</td>'
									_html += '<td>'+item.STU_NAME+'</td>'
									_html += '<td>'+item.STU_ID_NUMBER+'</td>'
									_html += '<td class="check_form">'
									_html += 	'<input type="checkbox" id=pop_check_'+ index+' name=STU_ID value="'+item.STU_ID+'"' + str_checked +' class="tbl_check"/>'
									_html += '	<label for=pop_check_'+ index+'><span></span></label>'
									_html += '</td>'
								_html += '</tr>';

							});
						} else {
							_html += '<tr  class="none"><td colspan="4">등록된 데이터가 없습니다.</td></tr>';
						}

						//console.log(_html);

						$('#selectPracticeStudentList').append(_html);
					}
				}
		};
		apiCall(params);
		//practiceStudentList
		
		$('#w01').window('open');  	

	}
	//콤마 구분 같은값 존재여부
	function fn_same_chk(v1,v2)
	{
		  var rtn = false;
	      var strSplit = v1.split(',');
	      for ( var i in strSplit ) {
		      if(strSplit[i] == v2)
			  {
		    	  rtn = true;
			  }		        
	      }
	      return rtn;	
	}
	
	/**********************************************************************
	** 저장 로직
	***********************************************************************/

	function validateStep1()
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
		
		return true;
		
	}

	function validateStep2()
	{

		var CD_FACILITY_LEV1_FLAG = true;
		var CD_FACILITY_LEV2_FLAG = true;
		var SAGC_ID = true;
		
		var BEGIN_DATE_FLAG = true;
		var END_DATE_FLAG = true;

		var STU_IDS_FLAG = true;
		

		
		$('#practiceTimeTableList tr.items:visible').each(function() {
			//console.log("AGT_ID ==>"+ $(this).find('select[name=AGT_ID]').val());

			if($(this).find('input[name=CD_FACILITY_LEV1]').val() == '') {
				CD_FACILITY_LEV1_FLAG = false;
			}
			if($(this).find('input[name=CD_FACILITY_LEV2]').val() == '') {
				CD_FACILITY_LEV2_FLAG = false;
			}
			if($(this).find('input[name=SAGC_ID]').val() == '') {
				SAGC_ID_FLAG = false;
			}

			if($(this).find('input[name=BEGIN_DATE]').val() == '') {
				BEGIN_DATE_FLAG = false;
			}
			if($(this).find('input[name=END_DATE]').val() == '') {
				END_DATE_FLAG = false;
			}
			if($(this).find('input[name=STU_IDS]').val() == '') {
				STU_IDS_FLAG = false;
			}
		});

		if(!CD_FACILITY_LEV1_FLAG) {
			alert('실습계획표 구분을 선택해주세요.');
			return false;	
		}
		if(!CD_FACILITY_LEV2_FLAG) {
			alert('실습계획표 구분(세)를 선택해주세요.');
			return false;	
		}
		if(!SAGC_ID) {
			alert('연계실습기관을 선택해주세요.');
			return false;	
		}
		
		if(!BEGIN_DATE_FLAG) {
			alert('실습 시작일자를 입력해주세요.');
			return false;	
		}		
		if(!END_DATE_FLAG) {
			alert('실습 종료일자를 입력해주세요.');
			return false;	
		}
		if(!STU_IDS_FLAG) {
			alert('교육생을 선택해주세요.');
			return false;	
		}

		
		return true;
		
	}

	
	function saveLogic()
	{

		/********************************************************
		* 개강개요 유효성 검사
		********************************************************/
		if(!validateStep1())
		{
			return;
		}

		/********************************************************
		* 실습계획표 유효성 검사
		********************************************************/
		if(!validateStep2())
		{
			return;
		}

		
		
		if(!confirm('저장 하시겠습니까?')) {
			return false;
		}

		//로그인 아이디
		$('#ACC_ID').val(_ACC_ID); 
		$('#CD_ADD_STATE').val(_CD_ADD_STATE);
		
		//교육생 선택목록
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
		$('#STU_ID').val(str_stu_id);

		

		//시간표 삭제데이터 생성 및 hide 데이터 삭제
		$('#practiceTimeTableList tr.items:not(:visible)').each(function(i) {
			$('#frm').append('<input type="hidden" name="mapperIds" value="'+$(this).data('mapper_id')+'"/>');
		});
		$('#practiceTimeTableList tr.items:not(:visible)').remove(); //hide 데이터 삭제
		

		//등록상태에서 저장인지? 변경상태에서 저장인지? : Step 1 에서 Param 으로
		/* if($('#AGT_ID').val() == null || $('#AGT_ID').val() == '') {
			$('#CD_ADD_STATE').val('1');
		} else {
			if($('#CD_ADD_STATE').val() == '3') { //등록 승인 상태
				//클릭 버튼에 의해 등록 상태 변경					
			} else {
				//클릭 버튼에 의해 변경 상태 변경
				$('#CD_CHNG_STATE').val('1');
				
			}
		} */


		var formData = new FormData($('#frm')[0]);
		
		$.ajax({
            url : '/begin/practiceSave',
            dataType : "json",
            cache : false,
            processData : false,
            contentType : false,
            type : "post",
            data : formData,
            beforeSend: function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
            },
            success: function(data) {
            	if(data.success) {
            		alert('저장되었습니다.');
            		location.href='/begin/practiceList';
            	}
            },
            error:function(request,status,error){
                alert("code : " + request.status + "\n" + "error:" + error);
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
		

				<form id="frm" name="frm" method="post" >
				<input type="hidden" name="CLASS_TYPE" id=""CLASS_TYPE"" value="2"/> 
				<input type="hidden" name="ACC_ID" id="ACC_ID" value=""/>
				<input type="hidden" name="CLASS_ID" id="CLASS_ID" value="${CLASS_ID}"/>
				<input type="hidden" name="AGC_ID" id="AGC_ID" value="${AGC_ID}"/>
				<input type="hidden" name="STU_ID" id="STU_ID" value=""/>
				
				<input type="hidden" name="CD_ADD_STATE" id="CD_ADD_STATE" value=""/>
				
								
				<div class="sub_box">
					<div class="sub_menu">
						<div class="sub_title">개강보고</div>
						<div class="sub_list">
							<ul>
								<li><a href="/begin/logicList">이론/실기</a></li>
								<li class="sub_on"><a href="/begin/practiceList">실습</a></li>
								<li><a href="/begin/subPracticeList">대체실습</a></li>
							</ul>
						</div>
					</div>
					
					
					<div class="sub_con step_01">
						<!--conBox-->
						<div class="conBox">
							<div class="sub_step2">
								<ul class="page02_step wd440">
									<li class="step_list mgl0 step_on">
										<div class="step_num">1</div>
										<div class="step_txt wd60">개강개요</div>
									</li>
									<li class="step_list mgl280">
										<div class="step_num">2</div>
										<!--<div class="step_check"><img src="/assets/images/step_check.png"/></div>-->
										<div class="step_txt wd96">실습계획표 작성</div>
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
						
						<!--conBox 교육생 -->
						<div class="conBox mgt40">
							<div class="con_title">
								교육생 명부 등록
							</div>
							<div class="con_form over_y mhi417 ">
								<table class="tbl_ty5 wd755 float_l" id="practiceStudentList">
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
											<input type="checkbox" id="all_check_time" class="all_check"/>
											<label for="all_check_time" class="float_l mgl15"><span></span></label>
										</td>
									</tr>
									
									<tr class="tb_header filter">
										<td>
											<input type="text" class="tbl_input wd60" value="" id="sch_no" />
										</td>
										<td>																					
											<select class="tbl_select"  id="sch_class_name" >											
												<option></option>
												<c:forEach var="item" items="${cdEduCourse}">
													<option value="${item.CODE}">${item.NAME}</option>
												</c:forEach>
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
									<tr class="none"><td colspan="6">등록된 데이터가 없습니다.</td></tr>
									

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
								<li class="page_back mgr5 btn_step_back00"><a>취소</a></li>
								<li class="page_back mgr5 tempSave"><a>임시저장</a></li>
								<li class="page_ok btn_step_next02"><a>다음</a></li>
							</ul>
						</div>
					</div>
					<!--step_01 end-->
					
					
					<div class="sub_con step_02">
						<!--conBox-->
						<div class="conBox">
							<div class="sub_step2">
								<ul class="page02_step wd440">
									<li class="step_list mgl0 ">
										<div class="step_check"><img src="/assets/images/step_check2.png"/></div>
										<div class="step_txt wd60">개강개요</div>
									</li>
									<li class="step_list mgl280 step_on">
										<div class="step_num">2</div>
										<!--<div class="step_check"><img src="/assets/images/step_check.png"/></div>-->
										<div class="step_txt wd96">실습계획표 작성</div>
									</li>
								</ul>
							</div>
						</div>
						
						<!--conBox 시간표 -->
						<div class="conBox mgt40">
							<div class="con_title">실습계획표 작성 <a href="javascript:void(0);" class="title_btn wd115 addAgentClass">계획표 추가</a></div>

						
							<div class="con_form mgt10">
								<table class="tbl_ty3" id="practiceTimeTableList">
									<colgroup>
										<col width="80"/>
										<col width="70"/>
										<col width="115"/>
										<col width="85"/>
										<col width="130"/>
										<col width="130"/>
										<col width="100"/>
										<col width="50"/>
										<col width="50"/>							
									</colgroup>
									<tr class="filter">

										<td>순번</td>
										<td>구분</td>
										<td>구분(세)</td>
										<td>연계실습기관</td>
										<td>실습 시작 일자</td>
										<td>실습 종료 일자</td>
										<td colspan="2">교육생</td>
										<td>삭제</td>
									</tr>
									<tr class="none"><td colspan="9">등록된 데이터가 없습니다.</td></tr>
								</table>
								
								<div class="btn_box"><a href="javascript:void(0);" class="btn_center wd100 addAgentClass">계획표 추가</a></div>
							</div>
						</div>

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
						
						<!-- 
						<div class="main_btn mgt0">
							<ul class="wd295">
								<li class="page_back mgr5 btn_step_back01"><a>취소</a></li>
								<li class="page_back mgr5 tempSave"><a>임시저장</a></li>
								<li class="page_ok btn_step_next03"><a>다음</a></li>
							</ul>
						</div> -->
							
						<div class="main_btn">
							<ul class="">
								<li class="page_back mgr5 btn_step_back01"><a>취소</a></li>
								<li class="page_ok sendSave"><a>제출</a></li>
							</ul>
						</div>
						
					</div>
					<!--step_02 end-->
									
						<!--conBox end-->		
						
						
						<!-- 팝업 S
						<div id="w01" class="easyui-window" title="교육기관A - 이론/실기 개강보고 리스트" data-options="modal:true,closed:true,iconCls:'icon-save'" style="width:610px;height:328px;padding:0px;">
							<div class="pop_con">
								<table class="tbl_ty2" id="oldLogicList">
									<colgroup>
										<col width="80px"/>
										<col width="150px"/>
										<col width="318px"/>
									</colgroup>
									<tr class="filter">
										<td>순번</td>
										<td>작성일자</td>
										<td>제목</td>
									</tr>
								</table>
								
								
								<div class="btn_box mgt20 mgb30 wd205">
									<a class="pop_closed wd100 float_l mgr5">닫기</a>
									<a class="pop_choice wd100 float_l choice">선택</a>
								</div>
							</div>
						</div>
						 -->			
											
						<!--담당과목 팝업 S -->
						<div id="w01" class="easyui-window" title=""교육생 리스트" data-options="modal:true,closed:true,iconCls:'icon-save'" style="width:610px;height:328px;padding:0px;">
							<div class="pop_con">
								<table class="tbl_ty2" id="selectPracticeStudentList">
									<colgroup>
										<col width="80px"/>
										<col width="130px"/>
										<col width="208px"/>
										<col width="80px"/>
									</colgroup>
									<tr>
										<td>순번</td>
										<td>이름</td>
										<td>주민등록번호</td>
										<td>선택</td>
									</tr>
								</table>
								
								
								<div class="btn_box mgt20 mgb30 wd205">
									<a class="pop_closed wd100 float_l mgr5">닫기</a>
									<a class="pop_choice wd100 float_l choiceStudent">선택</a>
								</div>
							</div>
						</div>					
						<!--담당과목 팝업 E -->
						
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
