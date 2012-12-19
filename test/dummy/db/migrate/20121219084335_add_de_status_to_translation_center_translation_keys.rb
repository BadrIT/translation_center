class AddDeStatusToTranslationCenterTranslationKeys < ActiveRecord::Migration
  def change
    add_column :translation_center_translation_keys, :de_status, :string
  end
end
