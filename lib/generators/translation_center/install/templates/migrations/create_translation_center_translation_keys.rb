class CreateTranslationCenterTranslationKeys < ActiveRecord::Migration
  def change
    create_table :translation_center_translation_keys do |t|
      t.string :name
      t.integer :parent_id
      t.integer :category_id
      t.datetime :last_accessed
      <% langs.each do |lang| %>
      t.string :<%= lang.downcase.gsub('-','_') %>_status, default: 'untranslated'
      <% end %>

      t.timestamps
    end

    add_index :translation_center_translation_keys, :name
  end
end
