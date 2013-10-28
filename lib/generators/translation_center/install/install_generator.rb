require 'rails/generators/active_record'

module TranslationCenter

  class InstallGenerator < ActiveRecord::Generators::Base
    source_root File.expand_path('../templates', __FILE__)
    argument :langs, type: :array, :default => ['en']

    def install_translation
      # Generate migration templates for the models needed
      migration_template 'migrations/create_translation_center_categories.rb', 'db/migrate/create_translation_center_categories.rb'
      migration_template 'migrations/create_translation_center_translation_keys.rb', 'db/migrate/create_translation_center_translation_keys.rb'
      migration_template 'migrations/create_translation_center_translations.rb', 'db/migrate/create_translation_center_translations.rb'

      # generate votes if it doesn't already exist
      unless ActiveRecord::Base.connection.table_exists? 'votes'
        # A workaround for act_as_votable migration version number generation
        acts_as_votable_migration_class = Rails::Generators.find_by_namespace('acts_as_votable:migration')
        next_migration_number = self.class.next_migration_number('db/migrate')
        acts_as_votable_migration_class.class_eval(%Q{def self.next_migration_number(path); #{next_migration_number}; end})

        acts_as_votable_migration_class.start
      end

      copy_file 'config/translation_center.yml', 'config/translation_center.yml'

      # user can replace this logo to change the logo
      copy_file 'assets/translation_center_logo.png', 'app/assets/images/translation_center_logo.png'

      unless ActiveRecord::Base.connection.table_exists? 'audits'
        # we use audited for tracking activity
        Rails::Generators.invoke('audited:install')
      end
    end

  end

end
