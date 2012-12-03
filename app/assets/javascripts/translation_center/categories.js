// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function(){

  // when filter changes
  $('.keys_filter').click(function(){
    $('#current_filter').val($(this).attr('id'));
    $.ajax({
      url: Routes.translation_center_category_path(Category.key(), {format: 'js'}),
      data: { filter: Filter.key() }
    });
    $($('.keys_filter').parent()).removeClass('active');
    $($(this).parent()).addClass('active');
  });


});
