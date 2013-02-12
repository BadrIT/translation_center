// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function(){

  current_page = 1;
  var fetching = false


  $(document).on('mousewheel DOMMouseScroll', '.translation_keys_listing', function(e)
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
        url: Routes.translation_center_category_more_keys_path(Category.key()) + '.js',
        data: { page : current_page },
        complete: (function(){ fetching = false })
      });
    }
  })

});