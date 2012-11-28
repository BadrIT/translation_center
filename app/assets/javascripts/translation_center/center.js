// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function(){

  $('.language_to').click(function(){
    var language_to = $.trim($(this).text());
    $.ajax({
      type: 'POST',
      url: root_url + '/set_language_to',
      data: { lang : language_to },
      success: function(){
        location.reload();
      }
    });
  });

  $('.language_from').click(function(){
    var language_from = $(this).text();
    $.ajax({
      type: 'POST',
      url: root_url + '/set_language_from',
      data: { lang : language_from },
      success: function(){
        location.reload();
      }
    });

  });

});
