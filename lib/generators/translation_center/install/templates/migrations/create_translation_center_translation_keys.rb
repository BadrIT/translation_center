class CreateTranslationCenterTranslationKeys < ActiveRecord::Migration
  def change
    create_table :translation_center_translation_keys do |t|
      t.string :name
      t.integer :category_id
      t.datetime :last_accessed

      t.timestamps
    end
  end
end
