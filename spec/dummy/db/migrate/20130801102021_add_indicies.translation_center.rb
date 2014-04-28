class AddIndicies < ActiveRecord::Migration

  def change
    add_index :translation_center_translation_keys, :name
    add_index :translation_center_translations, :translation_key_id
  end

end
