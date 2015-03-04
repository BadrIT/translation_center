class AddArStatusTranslationCenterTranslationKeys < ActiveRecord::Migration
  def change
    add_column :translation_center_translation_keys, :ar_status, :string, default: 'untranslated'
  end
end
