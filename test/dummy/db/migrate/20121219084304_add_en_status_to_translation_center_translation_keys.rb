class AddEnStatusToTranslationCenterTranslationKeys < ActiveRecord::Migration
  def change
    add_column :translation_center_translation_keys, :en_status, :string
  end
end
