$(document).ready(function(){
	/*상단바로가기*/
	$(".upBtn").hide();
	$(window).scroll(function () {
          if ($(this).scrollTop() > 100) {
            $('.upBtn').fadeIn(300);
          } else {
            $('.upBtn').fadeOut('slow');
          }
        });
	$('.upBtn').click(function(e){
		e.preventDefault();
		$('html, body').animate({scrollTop: 0}, 200);
	});
	
	/*main popup set*/
	$(".main_pop_close, .pop_closed").click(function(){
		$(".window-mask, .window").hide();
	});
});