require_dependency "translation_center/application_controller"

module TranslationCenter
  class CenterController < ApplicationController

    before_filter :can_admin?, only: [ :dashboard, :search_activity, :manage ]

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
      params[:page] ||= 1
      @page = params[:page].to_i
      @stats = TranslationKey.langs_stats
      @langs = @stats.keys
      # to be used for meta search
      @search = Audited::Adapters::ActiveRecord::Audit.search(params[:search])
      #TODO perpage constant should be put somewhere else
      @translations_changes = Translation.recent_changes.offset(Translation::CHANGES_PER_PAGE * (@page - 1)).limit(Translation::CHANGES_PER_PAGE)
      @total_pages = (Translation.recent_changes.count / (Translation::CHANGES_PER_PAGE * 1.0)).ceil

      respond_to do |format|
        format.html
        format.js { render 'search_activity' }
      end
    end

    def search_activity
      params[:page] ||= 1
      @page = params[:page].to_i

      @translations_changes = Translation.recent_changes(params[:search]).offset(Translation::CHANGES_PER_PAGE * (@page - 1)).limit(Translation::CHANGES_PER_PAGE)
      @total_pages =  (Translation.recent_changes(params[:search]).count / (Translation::CHANGES_PER_PAGE * 1.0)).ceil
      
      respond_to do |format|
        format.js
      end
    end

    def manage
      # if locale is all then send no locale
      locale = params[:locale] == 'all' ? nil : params[:locale]
      TranslationCenter.send params[:manage_action], locale

      respond_to do |format|
        format.js
      end
    end

  end
end
