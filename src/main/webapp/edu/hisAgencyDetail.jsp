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
	    
		getHisAgencyDetail();
    });
	
	function getHisAgencyDetail() {
		if(CHNG_ID == null || CHNG_ID == '') {
			return false;
		}
		
		var params = {
				'class' : 'service.EduService',
				'method' : 'getHisAgencyDetail',
				'param' : {'CHNG_ID' : CHNG_ID},
				'callback' : function(data){
					if(data.success){
						loadingStop();
						
						var agencyDetail = data.agencyDetail;
						var agencyWorkerList = data.agencyWorkerList;
						
						$('#USE_YN').val(agencyDetail.USE_YN);
						$('#AGC_SERIAL').val(agencyDetail.AGC_SERIAL);
						$('#AGC_NAME').val(agencyDetail.AGC_NAME);
						$('#AGC_BOSS_NAME').val(agencyDetail.AGC_BOSS_NAME);
						$('#AGC_BOSS_TEL').val(agencyDetail.AGC_BOSS_TEL);
						$('#AGC_CORP').val(agencyDetail.AGC_CORP);
						$('#AGC_CORP_SERIAL').val(agencyDetail.AGC_CORP_SERIAL);
						$('#AGC_CORP_BOSS_NAME').val(agencyDetail.AGC_CORP_BOSS_NAME);
						$('#AGC_CORP_BOSS_TEL').val(agencyDetail.AGC_CORP_BOSS_TEL);
						$('#AGC_ZIP').val(agencyDetail.AGC_ZIP);
						$('#AGC_ADDRESS').val(agencyDetail.AGC_ADDRESS);
						$('#USER_NAME').val(agencyDetail.USER_NAME);
						$('#CD_AREA').append('<option>'+agencyDetail.CD_AREA_NAME+'</option>');
						$('#ADD_DATE').text(agencyDetail.ADD_DATE);
						$('#CHNG_DATE').text(agencyDetail.CHNG_DATE);
						$('.agencyDate').show();
						
						$('#agencyWorkerList .none').remove();
						$('#agencyWorkerList .items').remove();
						var _html = '';
						if(agencyWorkerList.length > 0) {
							$.each(agencyWorkerList, function(i, item) {
								_html += '<tr class="items" data-worker_id="'+item.WORKER_ID+'">'
									_html += '<td class="no">'+(i+1)+'</td>'
									_html += '<td><input type="text" class="tbl_input" id="WORKER_RANK" name="WORKER_RANK" value="'+item.WORKER_RANK+'"/></td>'
									_html += '<td><input type="text" class="tbl_input" id="WORKER_NAME" name="WORKER_NAME" value="'+item.WORKER_NAME+'"/></td>'
									_html += '<td><input type="text" class="tbl_input" id="WORKER_TEL" name="WORKER_TEL" value="'+item.WORKER_TEL+'"/></td>'
									_html += '<td class="t_left pdl50"><input type="text" class="tbl_input" id="AGT_NOTE" name="AGT_NOTE" value="'+item.AGT_NOTE+'"/></td>'
								_html += '</tr>'
							});
						} else {
							_html += '<tr class="none"><td colspan="5">????????? ???????????? ????????????.</td></tr>'
						}

						$('#agencyWorkerList').append(_html);
						
						$('#AGC_NOTE').val(agencyDetail.AGC_NOTE);
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
					<span class="nav">????????????</span>
					<span class="nav">????????????</span>
					<span class="nav">???????????? ??????</span>
				</div>
				<div class="sub_box">
					<div class="sub_menu">
						<div class="sub_title">????????????</div>
						<div class="sub_list">
							<ul>
								<li class="sub_on"><a href="">????????????</a></li>
								<li><a href="">????????????</a></li>
								<li><a href="">??????????????????</a></li>
								<li><a href="">???????????????</a></li>
								<li><a href="">?????????</a></li>
								<li><a href="">????????????</a></li>
							</ul>
						</div>
					</div>
					<div class="sub_con">
						<!--conBox-->
						<div class="conBox">
							<div class="con_title">??????????????????</div>
							<div class="con_form">
								<table class="tbl_ty1">
									<colgroup>
										<col width="160px"/>
										<col width="295px"/>
										<col width="160px"/>
										<col width="295px"/>
									</colgroup>
									<tr>
										<td class="t_head over_hide pdt5">????????????</td>
										<td class="pdl15 pdr15">
											<select class="tbl_select" id="USE_YN" name="USE_YN">
												<option value="Y">??????</option>
												<option value="N">?????????</option>
											</select>
										</td>
										<td></td>
										<td></td>
									</tr>
									<tr>
										<td class="t_head over_hide pdt5">???????????? ????????????</td>
										<td class="pdl15 pdr15">
											<input type="text" class="tbl_input" id="AGC_SERIAL" name="AGC_SERIAL" />
										</td>
										<td class="t_head over_hide pdt5">???????????? ??????</td>
										<td class="pdl15 pdr15">
											<input type="text" class="tbl_input" id="AGC_NAME" name="AGC_NAME" />
										</td>
									</tr>
									<tr>
										<td class="t_head over_hide pdt5">?????????</td>
										<td class="pdl15 pdr15">
											<input type="text" class="tbl_input" id="AGC_BOSS_NAME" name="AGC_BOSS_NAME" />
										</td>
										<td class="t_head over_hide pdt5">????????? ?????????</td>
										<td class="pdl15 pdr15">
											<input type="text" class="tbl_input" id="AGC_BOSS_TEL" name="AGC_BOSS_TEL" />
										</td>
									</tr>
									<tr>
										<td class="t_head over_hide pdt5">?????????</td>
										<td class="pdl15 pdr15">
											<input type="text" class="tbl_input" id="AGC_CORP" name="AGC_CORP" />
										</td>
										<td class="t_head over_hide pdt5">??????????????????</td>
										<td class="pdl15 pdr15">
											<input type="text" class="tbl_input" id="AGC_CORP_SERIAL" name="AGC_CORP_SERIAL" />
										</td>
									</tr>
									<tr>
										<td class="t_head over_hide pdt5">?????????</td>
										<td class="pdl15 pdr15">
											<input type="text" class="tbl_input" id="AGC_CORP_BOSS_NAME" name="AGC_CORP_BOSS_NAME" />
										</td>
										<td class="t_head over_hide pdt5">?????? ?????????</td>
										<td class="pdl15 pdr15">
											<input type="text" class="tbl_input" id="AGC_CORP_BOSS_TEL" name="AGC_CORP_BOSS_TEL" />
										</td>
									</tr>
									<tr>
										<td class="t_head over_hide pdt5">????????????</td>
										<td class="pdl15 pdr15">
											<input type="text" class="tbl_input" id="AGC_ZIP" name="AGC_ZIP" />
										</td>
										<td></td>
										<td></td>
									</tr>
									<tr>
										<td class="t_head over_hide pdt5">????????? ??????(?????????)</td>
										<td class="pdl15 pdr15" colspan="3">
											<input type="text" class="tbl_input" id="AGC_ADDRESS" name="AGC_ADDRESS" />
										</td>
									</tr>
									<tr>
										<td class="t_head over_hide pdt5">?????? ?????????</td>
										<td class="pdl15 pdr15">
											<input type="text" class="tbl_input" id="USER_NAME" name="USER_NAME" value="${empty AGC_ID ? sessionScope.userInfo.USER_NAME : ''}" disabled/>
										</td>
										<td class="t_head over_hide pdt5">????????????</td>
										<td class="pdl15 pdr15">
											<select class="tbl_select" id="CD_AREA" name="CD_AREA">
											</select>
										</td>
									</tr>
									<tr class="agencyDate" style="display:none;">
										<td class="t_head">????????????</td>
										<td id="ADD_DATE"></td>
										<td class="t_head">??????????????????</td>
										<td id="CHNG_DATE"></td>
									</tr>
								</table>
							</div>
						</div>
						<!--conBox end-->
						
						<!--conBox-->
						<div class="conBox">
							<div class="con_title">???????????? ????????? ??????</div>

							<div class="con_form mgt10">
								<table class="tbl_ty2" id="agencyWorkerList">
									<colgroup>
										<col width="80px"/>
										<col width="120px"/>
										<col width="120px"/>
										<col width="180px"/>
										<col width="310px"/>
									</colgroup>
									<tr class="filter">
										<td>??????</td>
										<td>??????</td>
										<td>??????</td>
										<td>????????????</td>
										<td>??????</td>
									</tr>
									<tr class="none"><td colspan="5">????????? ???????????? ????????????.</td></tr>
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
										<td class="t_head">??????</td>
										<td class="pdr10 pdl10 pdt7 pdb7">
											<textarea class="tbl_area" id="AGC_NOTE" name="AGC_NOTE"></textarea>
										</td>
									</tr>			
								</table>
							</div>
						</div>
						<!--conBox end-->
						
						<div class="main_btn">
							<ul>
								<li class="page_back mgr5"><a href="javascript:history.back();">??????</a></li>
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
