require_dependency "translation_center/application_controller"

module TranslationCenter
  class CenterController < ApplicationController

    # set language user translating from
    def set_language_from
      session[:lang_from] = params[:lang].to_sym
      I18n.locale = session[:lang_from]
      render nothing: true
    end

    # set language user translating to
    def set_language_to
      session[:lang_to] = params[:lang].to_sym
      respond_to do |format|
        format.html { redirect_to root_url } 
        format.js { render nothing: true }
      end
    end

  end
end
