class CreateTranslationCenterTranslations < ActiveRecord::Migration
  def change
    # if mysql
    if defined?(ActiveRecord::ConnectionAdapters::Mysql2Adapter).present? && ActiveRecord::Base.connection.instance_of?(ActiveRecord::ConnectionAdapters::Mysql2Adapter)
      
      create_table :translation_center_translations, options: 'CHARACTER SET=utf8' do |t|
        t.integer :translation_key_id
        t.text :value
        t.string :lang
        t.references :translator, polymorphic: true
        t.string :status, default: 'pending'

        t.timestamps
      end

    else

      create_table :translation_center_translations do |t|
        t.integer :translation_key_id
        t.text :value
        t.string :lang
        t.references :translator, polymorphic: true
        t.string :status, default: 'pending'

        t.timestamps
      end      

    end

    add_index :translation_center_translations, :translation_key_id
  end
end
