require_dependency "translation_center/application_controller"

module TranslationCenter
  class CenterController < ApplicationController

    before_filter :can_admin?, only: [ :dashboard, :search_activity ]

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

    def dashboard
      @stats = TranslationKey.langs_stats
      @langs = @stats.keys
      # to be used for meta search
      @search = Audited::Adapters::ActiveRecord::Audit.search(params[:search])
      #TODO perpage constant should be put somewhere else
      @translations_changes = Translation.recent_changes.paginate(:page => params[:page], :per_page => 5)
      respond_to do |format|
        format.html
        format.js { render 'search_activity' }
      end
    end

    def search_activity
      @translations_changes = Translation.recent_changes(params[:search]).paginate(:page => params[:page], :per_page => 5)
      respond_to do |format|
        format.js
      end
    end

  end
end
