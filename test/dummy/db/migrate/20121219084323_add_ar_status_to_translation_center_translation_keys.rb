class AddArStatusToTranslationCenterTranslationKeys < ActiveRecord::Migration
  def change
    add_column :translation_center_translation_keys, :ar_status, :string
  end
end
