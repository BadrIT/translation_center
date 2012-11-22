class CreateTranslationCenterTranslationKeys < ActiveRecord::Migration
  def change
    create_table :translation_center_translation_keys do |t|
      t.string :name
      t.integer :category_id
      t.integer :accepted_translation_id
      t.date :last_accessed

      t.timestamps
    end
  end
end
