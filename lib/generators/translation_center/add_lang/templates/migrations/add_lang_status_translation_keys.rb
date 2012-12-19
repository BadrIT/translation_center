class Add<%= @lang.capitalize %>StatusTranslationCenterTranslationKeys < ActiveRecord::Migration
  def change
    add_column :translation_center_translation_keys, :<%= @lang %>_status, :string, default: 'untranslated'
  end
end
