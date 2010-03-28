$(function() {

	/* animate project links and description */
	$("h4 > a").mouseover(function() {
	  $(this).next("strong").animate({ marginLeft: "30px", paddingLeft: "15px" }, 500, "easeOutBack");
  }).mouseout(function() {
	  $(this).next("strong").animate({ marginLeft: "15px", paddingLeft: "30px" }, 500, "easeOutBack");
	});

});