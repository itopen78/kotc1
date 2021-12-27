<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>테스트페이지</title>
	<sec:csrfMetaTags />
	<script src='/assets/js/jquery-3.4.1.min.js'></script>
	<script src='/assets/js/kotc.js'></script>
	<script src="/assets/js/jquery.twbsPagination.js"></script>
	<script type="text/javascript">
	$(document).ready(function() {
		getSubAgencyDeatil();
		
		$('.subAgencySaveBtn').on('click', function() {
			if($('#SUB_AGC_ROLE_CODE').val() == '') {
				alert('시설구분을 선택하세요.');
				$('#SUB_AGC_ROLE_CODE').focus();
				return false;
			}
			
			if($('#SUB_AGC_NAME').val() == '') {
				alert('시설명을 입력하세요.');
				$('#SUB_AGC_NAME').focus();
				return false;
			}
			
			if($('#SUB_AGC_ZIP').val() == '') {
				alert('우편번호를 입력하세요.');
				$('#SUB_AGC_ZIP').focus();
				return false;
			}
			
			if($('#INSTALL_DATE').val() == '') {
				alert('설치신고일을 선택하세요.');
				$('#INSTALL_DATE').focus();
				return false;
			}
			
			if($('#SUB_AGC_ADDRESS').val() == '') {
				alert('소재지 주소(도로명)를 입력하세요.');
				$('#SUB_AGC_ADDRESS').focus();
				return false;
			}
			
			if($('#SUB_AGC_BOSS_NAME').val() == '') {
				alert('기관장(대표)를 입력하세요.');
				$('#SUB_AGC_BOSS_NAME').focus();
				return false;
			}
			
			if($('#SUB_AGC_BOSS_TEL').val() == '') {
				alert('전화번호를 입력하세요.');
				$('#SUB_AGC_BOSS_TEL').focus();
				return false;
			}
			
			if($('#TERM_SDATE').val() == '') {
				alert('실습계약시작일을 선택하세요.');
				$('#TERM_SDATE').focus();
				return false;
			}
			
			if($('#TERM_EDATE').val() == '') {
				alert('실습계약종료일을 선택하세요.');
				$('#TERM_EDATE').focus();
				return false;
			}
			
			if($('#ENTER_LIMIT_CNT').val() == '') {
				alert('입소자 정원을 입력하세요.');
				$('#ENTER_LIMIT_CNT').focus();
				return false;
			}
			
			if($('#JUGDE_GRADE').val() == '') {
				alert('평가등급을 입력하세요.');
				$('#JUGDE_GRADE').focus();
				return false;
			}
			
			if($('#ENTER_CURRENT_CNT').val() == '') {
				alert('입소자 현원을 입력하세요.');
				$('#ENTER_CURRENT_CNT').focus();
				return false;
			}
			
			if($('#JUGDE_YEAR').val() == '') {
				alert('판등급판정년도를 입력하세요.');
				$('#JUGDE_YEAR').focus();
				return false;
			}
			
			if($('#TRAINING_TOTAL_CNT').val() == '') {
				alert('실습 총 인원을 입력하세요.');
				$('#TRAINING_TOTAL_CNT').focus();
				return false;
			}
			
			if($('#TRAINING_DAILY_CNT').val() == '') {
				alert('1일 실습 인원을 입력하세요.');
				$('#TRAINING_DAILY_CNT').focus();
				return false;
			}
			
			if($('#TRAINING_DAILY_PAY').val() == '') {
				alert('1일 실습비(1인당)을 입력하세요.');
				$('#TRAINING_DAILY_PAY').focus();
				return false;
			}
			
			if(!confirm("저장하시겠습니까?")) {
				return false;
			}
			
			var params = {
					'class' : 'service.EduService',
					'method' : 'saveSubAgency',
					'param' : {
						'SUB_AGC_ID' : $('#SUB_AGC_ID').val(),
						'SUB_AGC_ROLE_CODE' : $('#SUB_AGC_ROLE_CODE').val(),
						'SUB_AGC_NAME' : $('#SUB_AGC_NAME').val(),
						'SUB_AGC_ZIP' : $('#SUB_AGC_ZIP').val(),
						'INSTALL_DATE' : $('#INSTALL_DATE').val(),
						'SUB_AGC_ADDRESS' : $('#SUB_AGC_ADDRESS').val(),
						'SUB_AGC_BOSS_NAME' : $('#SUB_AGC_BOSS_NAME').val(),
						'SUB_AGC_BOSS_TEL' : $('#SUB_AGC_BOSS_TEL').val(),
						'TERM_SDATE' : $('#TERM_SDATE').val(),
						'TERM_EDATE' : $('#TERM_EDATE').val(),
						'ENTER_LIMIT_CNT' : $('#ENTER_LIMIT_CNT').val(),
						'JUGDE_GRADE' : $('#JUGDE_GRADE').val(),
						'ENTER_CURRENT_CNT' : $('#ENTER_CURRENT_CNT').val(),
						'JUGDE_YEAR' : $('#JUGDE_YEAR').val(),
						'TRAINING_TOTAL_CNT' : $('#TRAINING_TOTAL_CNT').val(),
						'TRAINING_DAILY_CNT' : $('#TRAINING_DAILY_CNT').val(),
						'TRAINING_DAILY_PAY' : $('#TRAINING_DAILY_PAY').val(),
						'REMARK' : $('#REMARK').val(),
						'SUB_AGC_STATUS_CODE' : '01' //신청
					},
					'callback' : function(data){
						if(data.success){
							loadingStop();
							alert('저장 되었습니다.');
							location.href='/edu/subAgencyList';
						} else {
							loadingStop();
							alert('장애가 발생되었습니다.');
							return false;
						}
					}
			};
			apiCall(params);
		});
	});
		
	function getSubAgencyDeatil() {
		if($('#SUB_AGC_ID').val() == null || $('#SUB_AGC_ID').val() == '') {
			return false;
		}
		
		var params = {
				'class' : 'eduMapper',
				'method' : 'getSubAgencyDetail',
				'param' : {'SUB_AGC_ID' : $('#SUB_AGC_ID').val()},
				'callback' : function(data){
					if(data.success){
						loadingStop();
						var view = data.view;
						$('#SUB_AGC_ROLE_CODE').val(view.SUB_AGC_ROLE_CODE);
						$('#SUB_AGC_NAME').val(view.SUB_AGC_NAME);
						$('#SUB_AGC_BOSS_NAME').val(view.SUB_AGC_BOSS_NAME);
						$('#SUB_AGC_BOSS_TEL').val(view.SUB_AGC_BOSS_TEL);
						$('#SUB_AGC_ADDRESS').val(view.SUB_AGC_ADDRESS);
						$('#SUB_AGC_ZIP').val(view.SUB_AGC_ZIP);
						$('#INSTALL_DATE').val(view.INSTALL_DATE);
						$('#ENTER_LIMIT_CNT').val(view.ENTER_LIMIT_CNT);
						$('#ENTER_CURRENT_CNT').val(view.ENTER_CURRENT_CNT);
						$('#TRAINING_TOTAL_CNT').val(view.TRAINING_TOTAL_CNT);
						$('#TRAINING_DAILY_CNT').val(view.TRAINING_DAILY_CNT);
						$('#TRAINING_DAILY_PAY').val(view.TRAINING_DAILY_PAY);
						$('#JUGDE_GRADE').val(view.JUGDE_GRADE);
						$('#JUGDE_YEAR').val(view.JUGDE_YEAR);
						$('#TERM_SDATE').val(view.TERM_SDATE);
						$('#TERM_EDATE').val(view.TERM_EDATE);
						$('.CREATE_DATE').text(view.CREATE_DATE);
						$('.LAST_APPROVE_DATE').text(view.LAST_APPROVE_DATE);
						$('.LAST_SUB_AGC_STATUS_CODE_NAME').text(view.LAST_SUB_AGC_STATUS_CODE_NAME);
						$('#REMARK').val(view.REMARK);
					}
				}
		};
		apiCall(params);
	}
	
	</script>
</head>
<body>
	<table class="tbl_type4" cellspacing="0">
        <colgroup>
        <col width="80">
        <col width="150">
        <col width="80">
        <col>
        </colgroup>
        <tbody>
        	<tr>
        		<th>시설 구분</th>
        		<td>
        			<select name="SUB_AGC_ROLE_CODE" id="SUB_AGC_ROLE_CODE">
        				<c:forEach var="item" items="${subAgcRoleCodeList}">
	        				<option value="${item.CODE}">${item.CODE_NAME}</option>
        				</c:forEach>
        			</select>
        		</td>
        		<th>시설명</th>
        		<td>
        			<input type="hidden" name="SUB_AGC_ID" id="SUB_AGC_ID" value="${SUB_AGC_ID}"/>
        			<input type="text" class="form-control" name="SUB_AGC_NAME" id="SUB_AGC_NAME" value="">
        		</td>
        	</tr>
        	<tr>
        		<th>우편번호</th>
        		<td><input type="text" class="form-control" name="SUB_AGC_ZIP" id="SUB_AGC_ZIP" value=""></td>
        		<th>설치신고일</th>
        		<td><input type="text" class="form-control" name="INSTALL_DATE" id="INSTALL_DATE" value=""></td>
        	</tr>
        	<tr>
        		<th>소재지 주소(도로명)</th>
        		<td><input type="text" class="form-control" name="SUB_AGC_ADDRESS" id="SUB_AGC_ADDRESS" value=""></td>
        		<th>최초등록일자</th>
        		<td class="CREATE_DATE"></td>
        	</tr>
        	<tr>
        		<th>기관장(대표)</th>
        		<td><input type="text" class="form-control" name="SUB_AGC_BOSS_NAME" id="SUB_AGC_BOSS_NAME" value=""></td>
        		<th>최종변경신청일자</th>
        		<td class=""></td>
        	</tr>
        	<tr>
        		<th>전화번호</th>
        		<td><input type="text" class="form-control" name="SUB_AGC_BOSS_TEL" id="SUB_AGC_BOSS_TEL" value=""></td>
        		<th>최종처리일자</th>
        		<td class="LAST_APPROVE_DATE"></td>
        	</tr>
        	<tr>
        		<th>실습계약기간</th>
        		<td><input type="text" class="form-control" name="TERM_SDATE" id="TERM_SDATE" value=""> ~ <input type="text" class="form-control" name="TERM_EDATE" id="TERM_EDATE" value=""></td>
        		<th>현재상태</th>
        		<td class="LAST_SUB_AGC_STATUS_CODE_NAME"></td>
        	</tr>
        	
        	<!-- 시설용량 및 평가정보 -->
        	
        	<tr>
        		<th>입소자 정원</th>
        		<td><input type="text" class="form-control" name="ENTER_LIMIT_CNT" id="ENTER_LIMIT_CNT" value=""></td>
        		<th>평가등급</th>
        		<td><input type="text" class="form-control" name="JUGDE_GRADE" id="JUGDE_GRADE" value=""></td>
        	</tr>
        	<tr>
        		<th>입소자 현원</th>
        		<td><input type="text" class="form-control" name="ENTER_CURRENT_CNT" id="ENTER_CURRENT_CNT" value=""></td>
        		<th>등급판정년도</th>
        		<td><input type="text" class="form-control" name="JUGDE_YEAR" id="JUGDE_YEAR" value=""></td>
        	</tr>
        	<tr>
        		<th>실습 총 인원</th>
        		<td colspan="3"><input type="text" class="form-control" name="TRAINING_TOTAL_CNT" id="TRAINING_TOTAL_CNT" value=""></td>
        	</tr>
        	<tr>
        		<th>1일 실습 인원</th>
        		<td colspan="3"><input type="text" class="form-control" name="TRAINING_DAILY_CNT" id="TRAINING_DAILY_CNT" value=""></td>
        	</tr>
        	<tr>
        		<th>1일 실습비(1인당)</th>
        		<td colspan="3"><input type="text" class="form-control" name="TRAINING_DAILY_PAY" id="TRAINING_DAILY_PAY" value=""></td>
        	</tr>
        	
        	<!-- 계약서 -->
        	
        	<tr>
        		<th>파일 업로드</th>
        		<td colspan="3"><input type="file" class="form-control" name="" id=""></td>
        	</tr>
        	<tr>
        		<th>비고</th>
        		<td colspan="3"><input type="text" class="form-control" name="REMARK" id="REMARK" value=""></td>
        	</tr>
        </tbody>
    </table>
    
    <a href="javascript:void(0);" class="subAgencySaveBtn">저장</a>
    
</body>
</html>