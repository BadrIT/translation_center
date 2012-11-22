module TranslationCenter

  class TranslateGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    source_root File.expand_path('../templates', __FILE__)
    argument :model_name, type: :string, required: false, desc: :model_name

    def self.next_migration_number(path)
      @migration_number = Time.now.utc.strftime("%Y%m%d%H%M%S%6N").to_i.to_s
    end

    def translate
      @translation_version = get_next_translation_version
      if(model_name.blank?)
        all_models.each do |model_name|
          @model_name = model_name
          migration_template 'migrations/add_model_translation.rb', "db/migrate/add_#{model_name.downcase}_translation.rb" unless @model_name == 'TranslationKey'
        end
      elsif(model_name != 'TranslationKey')
        create_model_translation
      end
    end

    private
      def create_model_translation
        @model_name = model_name
        migration_template 'migrations/add_model_translation.rb', "db/migrate/add_#{@model_name.downcase}_translation.rb"
      end

      def get_next_translation_version
        TranslationKey.all.empty? ? 0 : TranslationKey.order('version DESC').first.version + 1
      end

      def all_models
        Dir["app/models/*.rb"].collect do |file_path|
          basename = File.basename(file_path, File.extname(file_path))
          basename.camelize
        end
      end

      class Class
        def extend?(klass)
          not superclass.nil? and ( superclass == klass or superclass.extend? klass )
        end
      end

      def models 
        Module.constants.select do |constant_name|
          constant = constant_name.to_s
          if not constant.nil? and constant.is_a? Class and constant.extend? ActiveRecord::Base
          constant
          end
        end
      end


  end

end