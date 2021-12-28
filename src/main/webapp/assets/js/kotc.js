/**
 * kotc 공통로직 javascript library
 */
var __loading = null;
var __url_api = '/api/call';
var __url_api_session = '/api/callCsrf';

/** 파라미터 파싱 */
function getArgs(string) {
    var args = new Object();
    var query = string.substring(1);
    var pairs = query.split("&");

    for (var i = 0; i < pairs.length; i++) {
        var pos = pairs[i].indexOf('=');
        if (pos == -1) continue;

        var argname = pairs[i].substring(0, pos);
        var value = pairs[i].substring(pos + 1);
        args[argname] = unescape(value);
    }

    return args;
}

var Args = getArgs(window.location.search);
var Hashes = getArgs(window.location.hash);

/** 로딩중 띄우기 */
function loadingStart(){
	if(__loading == null){
		__loading = $("<div style='position:absolute;width:100%;height:100%;top:0;left:0;background-color:#00000055;z-index:5'><div style='position:absolute;top:50%; left:50%;margin-top:-100px; margin-left:-100px;width:200px; height:200px; '>Loading . . . </div></div>");
		$('body').append(__loading);
	}
}

/** 로딩중 끝 */
function loadingStop(){
	if(__loading != null){
		__loading.remove();
		__loading = null;
	}
}

/** 공통 자바스크립트  api 호출 */
function apiCall(params){
	var async = true;
	var url = __url_api_session;
	var callback = null;
	var session = true;
	
	loadingStart();

	if(params.async === false){
		async = false;
	}
	
	if(params.session === false){
		url = __url_api;
		session = false;
		delete params.session;
	}
	
	if(params.callback != null){
		callback = params.callback;
		delete params.callback;
	}
	
	$.ajax({
		type: "POST",
		async:async,
		url: url,
		contentType: "application/json; charset=UTF-8",
		dataType: "json",
		data: JSON.stringify(params),
		beforeSend: function(xhr) {
			if(session){
				var token = $("meta[name='_csrf']").attr("content");
				var header = $("meta[name='_csrf_header']").attr("content");
				xhr.setRequestHeader(header, token);
			}
		},
		error: function(request,status,error) {
			alert(error);
			loadingStop();
        },
        success: function(data, textStatus, jqXHR){
        	if(data.message){
    			alert(data.message);
    			loadingStop();
    		}else if(data.success && callback){
    			callback(data);
        	}
        }
	});
}

/** 파일업로드*/
function uploadFile(params){
	var form = new FormData();
	var callback = null;
	
	loadingStart();
	
	if(params.callback != null){
		callback = params.callback;
		delete params.callback;
	}
	form.encType = 'multipart/form-data';
	form.append('TABLE_ID', params.TABLE_ID);
	form.append('REF_ID', params.REF_ID);
	form.append('FILE_TYPE', params.FILE_TYPE);
	if(params.FILE_ID){
		form.append('FILE_ID', params.FILE_ID);
	}
    form.append('file', params.file);
    $.ajax({
        type: 'POST',
        url: '/file/upload',
        processData: false,
        contentType: false,
        cache: false,
        data: form,
        dataType: 'json',
        type: 'POST',
        beforeSend: function(xhr) {
        	var token = $("meta[name='_csrf']").attr("content");
			var header = $("meta[name='_csrf_header']").attr("content");
			xhr.setRequestHeader(header, token);
		},
		error: function(request,status,error) {
			alert(error);
			loadingStop();
        },
        success: function (data) {
        	if(data.message){
    			alert(data.message);
    			loadingStop();
    		}else if(data.success && callback){
    			callback(data);
        	}
        }
    });
}

function fnFieldDisabled() {
	$('body').find('input, select, textarea').attr('disabled', true);
}

/** json 서브밋 */
function submitForm(url, params){
	var form = document.createElement("form");
	form.setAttribute("charset", "utf-8");
	form.setAttribute("method", "post");
    form.setAttribute("action", url);
    for(var key in params) {
    	var hidden = document.createElement("input");
    	hidden.setAttribute("type", "hidden");
    	hidden.setAttribute("name", key);
    	hidden.setAttribute("value", params[key]);
    	form.appendChild(hidden);
    }
    var hidden = document.createElement("input");
	hidden.setAttribute("type", "hidden");
	hidden.setAttribute("name", "_csrf");
	hidden.setAttribute("value", $("meta[name='_csrf']").attr("content"));
	form.appendChild(hidden);
    document.body.appendChild(form);
    form.submit();
}

$(document).ready(function() {
	//파일 다운로드
	$('body').on('click', '.getFileDown', function() {
		location.href='/getFileDown?ORIGINAL_FILE_NAME='+encodeURIComponent($(this).data('original_file_name'))+'&SERVER_FILE_NAME='+encodeURIComponent($(this).data('server_file_name'));
	});
	
	//파일 전체 다운로드
	$('body').on('click', '.getFilesDown', function() {
		if($(this).data('cd_table') != null && $(this).data('id_pks') != null) {
			location.href='/getFilesDown?CD_TABLE='+encodeURIComponent($(this).data('cd_table'))+'&ID_PKS='+encodeURIComponent(JSON.stringify($(this).data('id_pks')));
		}
	});
});