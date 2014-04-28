class FixTranslationUserRelation < ActiveRecord::Migration
  def up
    rename_column :translation_center_translations, :user_id, :translator_id
    add_column :translation_center_translations, :translator_type, :string
    TranslationCenter::Translation.update_all(translator_type: 'User')
  end

  def down
    rename_column :translation_center_translations, :translator_id, :user_id
    remove_column :translation_center_translations, :translator_type
  end
end
