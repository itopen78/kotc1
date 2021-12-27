$(document).ready(function(){
	/*tab contents*/
	$(".tab-contents ul li").click(function(){
		$(".tab-contents ul li").removeClass('on');
		$(".tab-contents .conBox").removeClass('on');
		$(this).addClass('on');
		$("#"+$(this).data('id')).addClass('on');
	});
});