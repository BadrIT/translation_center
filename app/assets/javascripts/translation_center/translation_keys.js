// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


$(document).ready(function(){

  current_page = 1;
  var fetching = false

  $('.translation_keys_listing').live('mousewheel DOMMouseScroll', function(e)
  {
    if(e.originalEvent.wheelDelta < 0 &&
       $(this).scrollTop() + 
       $(this).innerHeight()
       >= $(this)[0].scrollHeight - 100 &&
       !fetching)
    {
      fetching = true;
      current_page++
      $.ajax({
        type: 'GET',
        url: Category.path() + '/more_keys',
        data: { page : current_page },
        complete: (function(){ fetching = false })
      });
    }
  })

});