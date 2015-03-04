class CreateTranslationCenterCategories < ActiveRecord::Migration
  def change
    create_table :translation_center_categories do |t|
      t.string :name

      t.timestamps
    end
  end
end
