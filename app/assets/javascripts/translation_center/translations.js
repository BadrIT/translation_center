// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function() {

  editableTranslations();
  
  $('.translations_tab').live('click', function(){
    $.ajax({
      type: 'GET',
      url: root_url + '/translation_keys/' + $(this).attr('key-id') + '/translations.js'
    });
  });
  

});

function editableTranslations(){

  $.each($('.user_translation'), function(){
    var key_id = $(this).attr('key-id');

    $(this).editable(root_url + '/translation_keys/' + key_id + '/update_translation.json', {
      method: 'POST',
      onblur : 'submit',
      // TODO use I18n.t for translations
      placeholder : 'click to add or edit your translation',
      tooltip     : 'click to add or edit your translation'

      
    });

  });

}