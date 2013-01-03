require_dependency "translation_center/application_controller"

module TranslationCenter
  class DashboardController < ApplicationController

    def languages
      @stats = TranslationKey.langs_stats
      @langs = @stats.keys


    end

  end
end