module TranslationCenter
  class ApplicationController < ActionController::Base
    def add_category
      Category.create(name: controller_name)
    end
  end
end
