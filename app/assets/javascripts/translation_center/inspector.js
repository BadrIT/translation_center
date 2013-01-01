//= require js-routes

$(document).ready(function() {
  if($('body').children('#inplace_editing').length == 0)
    $('body').append('<div id="inplace_editing"></div>');
    
  $('.inplace_key').each(function(){
    var top = $(this).offset().top - 20;
    var left = $(this).offset().left - 10;
    var id = $(this).data('id');
    $('#inplace_editing').append($('<a>').attr('target', '_blank').attr('href', Routes.translation_center_translation_key_path(id)).attr('data-id', id).attr('style', 'left:' + left + 'px;top:' + top + 'px' ).attr('class', 'icon-edit badge badge-info inplace_edit_button'));

  });

  $(".inplace_edit_button").mouseover(function() {
    var id = $(this).data('id');
    $('.inplace_key[data-id=' + id + ']').css('color', 'red');
  }).mouseout(function(){
    var id = $(this).data('id');
    $('.inplace_key[data-id=' + id + ']').css('color', '');
  });

});