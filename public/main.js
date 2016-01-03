function ConfirmDelete()
{
  var x = confirm("Are you sure you want to delete?");
  if (x)
      return true;
  else
    return false;
}

$( document ).ready(function() {
    // console.log( "ready!" );
    var $leftMenu = $('#nav_container');
	var leftVal = parseInt($leftMenu.css('left'));

	$('#toggleButton').click(function () {
    animateLeft = (parseInt($leftMenu.css('left')) == 0) ? leftVal : 0;
	$leftMenu.animate({
		left: animateLeft + 'px'
    });
});





});