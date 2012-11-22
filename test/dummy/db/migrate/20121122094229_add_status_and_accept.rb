class AddStatusAndAccept < ActiveRecord::Migration
  def up
    add_column :translation_center_translations, :status, :string, :default => 'pending'
  end

  def down
  end
end
