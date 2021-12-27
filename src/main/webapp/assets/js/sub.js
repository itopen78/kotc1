$(document).ready(function(){
	/*menu hover*/
	$(".gnav_con").mouseenter(function(){
		$(".menu_form").slideDown();
	});
	$(".gnav").mouseleave(function(){
		$(".menu_form").slideUp(100);
	});
	
	/*check box*/
	$("#all_check").click(function(){
		 if($("#all_check").prop("checked")){
            $("input[name=chk]").prop("checked",true);
			$(".tbl_list").children("td").css({"background":"#ebf0f9"});
        }else{
            $("input[name=chk]").prop("checked",false);
			$(".tbl_list").children("td").css({"background":"#fff"});
        }
	});
	
	$("#all_check02").click(function(){
		 if($("#all_check02").prop("checked")){
            $("input[name=chk2]").prop("checked",true);
			$(".tbl_list02").children("td").css({"background":"#ebf0f9"});
        }else{
            $("input[name=chk2]").prop("checked",false);
			$(".tbl_list02").children("td").css({"background":"#fff"});
        }
	});
	
	$("#all_check03").click(function(){
		 if($("#all_check03").prop("checked")){
            $("input[name=chk3]").prop("checked",true);
			$(".tbl_list03").children("td").css({"background":"#ebf0f9"});
        }else{
            $("input[name=chk3]").prop("checked",false);
			$(".tbl_list03").children("td").css({"background":"#fff"});
        }
	});
	
	$(document).on('click',".tbl_check",function(){
        if($(this).is(":checked") ==true){
			$(this).parent().parent(".tbl_list").children("td").css({"background":"#ebf0f9"});
        }else{
            $(this).parent().parent(".tbl_list").children("td").css({"background":"#fff"});
        }
    });
	
	$(document).on('click',".tbl_check",function(){
        if($(this).is(":checked") ==true){
			$(this).parent().parent(".tbl_list02").children("td").css({"background":"#ebf0f9"});
        }else{
            $(this).parent().parent(".tbl_list02").children("td").css({"background":"#fff"});
        }
    });
	
	$(document).on('click',".tbl_check",function(){
        if($(this).is(":checked") ==true){
			$(this).parent().parent(".tbl_list03").children("td").css({"background":"#ebf0f9"});
        }else{
            $(this).parent().parent(".tbl_list03").children("td").css({"background":"#fff"});
        }
    });
	
	$(document).on('click',".tbl_check",function(){
        if($(this).is(":checked") ==true){
			$(this).parent().parent(".tbl_list_row2").children("td").css({"background":"#ebf0f9"});
			$(this).parent().parent(".tbl_list_row2").next(".tbl_list_row2").children("td").css({"background":"#ebf0f9"});
        }else{
            $(this).parent().parent(".tbl_list_row2").children("td").css({"background":"#fff"});
			$(this).parent().parent(".tbl_list_row2").next(".tbl_list_row2").children("td").css({"background":"#fff"});
        }
    });
	
	$(".step_next02").click(function(){
		$(".step_01").hide();
		$(".step_02").show();
	});
	$(".step_next03").click(function(){
		$(".step_02").hide();
		$(".step_03").show();
	});
	

});