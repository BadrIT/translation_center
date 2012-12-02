module TranslationCenter
  class ApplicationController < ActionController::Base
    before_filter :translation_langs_filters
    before_filter :authenticate_user!

    def can_admin?
      current_user.respond_to?(:can_admin_translations?) && current_user.can_admin_translations?
    end

    # defaults
    def translation_langs_filters
      session[:current_filter] ||= 'untranslated'
      session[:lang_from] ||= :en
      session[:lang_to] ||= :en
    end

  end
end
