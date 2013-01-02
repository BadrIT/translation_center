//= require js-routes

$(document).ready(function() {
  if($('body').children('#tc-inspector-links').length == 0 && $('#tc_no_inspector').length == 0 )
    $('body').append('<div id="tc-inspector-links"></div>');

  $(window).scroll(function() {
    $('.tc-inspector-key').each(function(){
      $(this).offset().top = $(this).offset().top - $(window).scrollTop()
    })
  });
    
  // for each key add a link that goes to the key page
  $('.tc-inspector-key').each(function(){
    var top = $(this).offset().top - 20;
    var left = $(this).offset().left - 10;
    var id = $(this).data('id');
    // missing translation will be in red while translated will be in green
    var badgeClass = getBadge($(this).data('type'));
    $('#tc-inspector-links').append($('<a>').attr('title', 'Click to visit key').attr('target', '_blank').attr('href', Routes.translation_center_translation_key_path(id)).attr('data-id', id).attr('style', 'left:' + left + 'px;top:' + top + 'px' ).attr('class', 'icon-edit tc-badge ' + badgeClass  + ' tc-inspector-link'));

  });

  // highlight the key when user hovers over it
  $(".tc-inspector-link").mouseover(function() {
    var id = $(this).data('id');
    var key = $('.tc-inspector-key[data-id=' + id + ']');
    var color = getColor(key.data('type'));
    key.css('color', color);
  }).mouseout(function(){
    var id = $(this).data('id');
    $('.tc-inspector-key[data-id=' + id + ']').css('color', '');
  });

  function getBadge(status) {
    if(status == 'untranslated')
      return 'tc-badge-important'
    else if(status == 'pending')
      return 'tc-badge-warning'
    else
      return 'tc-badge-success'
  }

  function getColor(status) {
    if(status == 'untranslated')
      return 'red'
    else if(status == 'pending')
      return 'orange'
    else
      return 'green'
  }


});