// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.all
//= require_tree .


function Category() {
}

Category.key = function() {
  return $('#category_key').val();
}

function Filter() {
}

Filter.key = function() {
  return $('#current_filter').val();
}

function capitaliseFirstLetter(string)
{
  return string.charAt(0).toUpperCase() + string.slice(1);
}

var spinner_params = {
  lines: 13, // The number of lines to draw
  length: 0, // The length of each line
  width: 4, // The line thickness
  radius: 14, // The radius of the inner circle
  corners: 1, // Corner roundness (0..1)
  rotate: 33, // The rotation offset
  direction: 1, // 1: clockwise, -1: counterclockwise
  color: '#000', // #rgb or #rrggbb
  speed: 1.1, // Rounds per second
  trail: 41, // Afterglow percentage
  shadow: false, // Whether to render a shadow
  hwaccel: false, // Whether to use hardware acceleration
  className: 'spinner', // The CSS class to assign to the spinner
  zIndex: 2e9, // The z-index (defaults to 2000000000)
  top: 'auto', // Top position relative to parent in px
  left: 'auto' // Left position relative to parent in px
};

$(document).ready(function(){

  $('.dropdown-toggle').dropdown()

  // search for key with that name and jump to it when clicked
  $('#search_keys').typeahead({
    // note that "value" is the default setting for the property option
    source: function (query, process) {
      return $.get(Routes['translation_center_search_translation_keys_path'] + '.json', { query: query }, function (data) {
        return process(data);
      });
    },
    updater: function(item) {
      document.location = Routes['translation_center_search_translation_keys_path'] + '?search_key_name=' + item
    }

  });
    

});