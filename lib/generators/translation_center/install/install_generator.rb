module TranslationCenter

  class InstallGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    source_root File.expand_path('../templates', __FILE__)
    argument :langs, type: :array, :default => ['en']

    def self.next_migration_number(path)
      @migration_number = Time.now.utc.strftime("%Y%m%d%H%M%S%6N").to_i.to_s
    end

    def install_translation
      # Generate migration templates for the models needed
      migration_template 'migrations/create_translation_center_categories.rb', 'db/migrate/create_translation_center_categories.rb'
      migration_template 'migrations/create_translation_center_translation_keys.rb', 'db/migrate/create_translation_center_translation_keys.rb'
      migration_template 'migrations/create_translation_center_translations.rb', 'db/migrate/create_translation_center_translations.rb'

      # generate votes if it doesn't already exist
      # unless ActiveRecord::Base.connection.data_source_exists? 'votes'
        Rails::Generators.invoke('acts_as_votable:migration')
      # end

      copy_file 'config/translation_center.yml', 'config/translation_center.yml'

      # user can replace this logo to change the logo
      copy_file 'assets/translation_center_logo.png', 'app/assets/images/translation_center_logo.png'

      sleep(1) # to avoid duplicate migrations between acts_as_votable and auditable

      # unless ActiveRecord::Base.connection.data_source_exists? 'audits'
        # we use audited for tracking activity
        Rails::Generators.invoke('audited:install')
      # end
    end

  end

end
