
// function ConfirmDelete()
// {
//   var x = confirm("Are you sure you want to delete?");
//   if (x)
//       return true
//   		// $('#real_delete_button').show();
//   else
//     return false;
// }

    // The following code is for the navigation menu. It takes the value of how the width of the div off screen and on click animates
    // the div in either direction depending on how wide the div is.
$(document).ready(function(){
    var $leftMenu = $('#nav_container');
	var leftVal = parseInt($leftMenu.css('left'));

	$('#toggleButton').click(function(){
    animateLeft = (parseInt($leftMenu.css('left')) == 0) ? leftVal : 0;
	$leftMenu.animate({
		left: animateLeft + 'px'
    });
});
	

	// $('#real_delete_button').hide();

	$('#fake_delete').click(function(){
		var x = confirm("Are you sure you want to delete?");
		if (x)
			// return true
			$('.real_delete_button').removeClass("real_delete_button");

	});



});

