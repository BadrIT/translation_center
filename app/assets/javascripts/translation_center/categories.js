// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function Category() {
}

Category.key = function() {
  return $('#category_key').val();
}

Category.path = function() {
  return '/categories/' + Category.key();
}

$(document).ready(function(){

  $('.keys_filter').click(function(){
    $.ajax({
      url: root_url + Category.path() + '/' + $(this).attr('id')  +'.js'
    });
    $($('.keys_filter').parent()).removeClass('active');
    $($(this).parent()).addClass('active');
  });


});
