class RemoveAcceptedTranslationIdFromTranslationCenterTranslationKey < ActiveRecord::Migration
  def up
    remove_column :translation_center_translation_keys, :accepted_translation_id
  end

  def down
  end
end
