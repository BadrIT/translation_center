require 'spec_helper'
require 'generator_spec'
require 'generators/translation_center/add_lang/add_lang_generator'

module TranslationCenter
  describe AddLangGenerator do
    destination File.expand_path("../../tmp", __FILE__)
    arguments %w(fr)

    context "add language" do
      it "should add a French language" do
        prepare_destination

        run_generator

        migration_path = "db/migrate/add_fr_status_translation_center_translation_keys.rb"
        assert_migration migration_path

        # Cleaning up generated migration file
        FileUtils.rm_rf(Dir[File.expand_path("../../tmp", __FILE__)])
        assert_no_migration migration_path
      end
    end
  end
end
