// JavaScript Document
/*
$(function(){
	$(".banner ul li").height($(window).height()-120)
})
*/
function popup(t,b){
	var doc_height = $(document).height();
	var doc_width = $(document).width();
	var win_height = $(window).height();
	var win_width = $(window).width();
	
	var layer_height = $(t).height();
	var layer_width = $(t).width();
	
	var scrollTop = document.documentElement.scrollTop || window.pageYOffset || document.body.scrollTop;
	
	//tab
	$(b).bind('click',function(){
		    $(".mask").css({display:'block',height:doc_height});
			$(t).css('top',(win_height-layer_height)/2);
			$(t).css('left',(win_width-layer_width)/2);
			$(t).css('display','block');
			return false;
		}
	)
	$(document).bind('click', function(e) {
		var $clicked = $(e.target);
		if (! $clicked.hasClass("tab")){
			$(t).css('display','none');
			$(".mask").css('display','none');
		}
	});
}
$(function(){
	popup(".tab",".video_box a");//
})
