Routes = {
  translation_center_category_path: translation_center_root + 'categories/',
  translation_center_set_lang_to_path: translation_center_root + 'set_language_to/',
  translation_center_set_lang_from_path: translation_center_root + 'set_language_from/',
  translation_center_search_activity_path: translation_center_root + 'search_activity',
  translation_center_translation_key_path: function(id) { translation_center_root + 'translation_keys/' + id },
  translation_center_category_more_keys_path: function(id) { return translation_center_root + 'categories/' + id + '/more_keys' },
  translation_center_translation_accept_path: function(id) { return translation_center_root + 'translations/' + id + '/accept' },
  translation_center_translation_unaccept_path: function(id) { return translation_center_root + 'translations/' + id + '/unaccept' },
  translation_center_translation_key_translations_path: function(id) { return translation_center_root + 'translation_keys/' + id + '/translations' },
  translation_center_translation_vote_path: function(id) { return translation_center_root + 'translations/' + id + '/vote' },
  translation_center_translation_unvote_path: function(id) { return translation_center_root + 'translations/' + id + '/unvote' },
  translation_center_translation_key_update_translation_path: function(id) { return translation_center_root + 'translation_keys/' + id + '/update_translation' }
}