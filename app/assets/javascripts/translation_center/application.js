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
//= require jquery-ui
//= require js-routes
//= require bootstrap-datepicker
//= require_tree .

function Category() {
}

Category.key = function() {
  return $('#category_key').val();
}

Category.path = function() {
  return Routes.translation_center_category_path(Category.key());
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

$(document).ready(function(){

  $('.dropdown-toggle').dropdown()

});