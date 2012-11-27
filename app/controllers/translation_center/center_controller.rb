require_dependency "translation_center/application_controller"

module TranslationCenter
  class CenterController < ApplicationController

    def set_language_from
      session[:lang_from] = params[:lang].gsub(':', '').to_sym
      I18n.locale = session[:lang_from]
      render nothing: true
    end

    def set_language_to
      session[:lang_to] = params[:lang].gsub(':', '').to_sym
      render nothing: true
    end

  end
end
