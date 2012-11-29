module TranslationCenter
  class ApplicationController < ActionController::Base
    before_filter :translation_langs_filters

    # defaults
    def translation_langs_filters
      session[:current_filter] ||= 'untranslated'
      session[:lang_from] ||= :en
      session[:lang_to] ||= :en
    end

  end
end
