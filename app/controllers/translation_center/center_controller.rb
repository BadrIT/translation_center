require_dependency "translation_center/application_controller"

module TranslationCenter
  class CenterController < ApplicationController

    before_filter :can_admin?, only: [ :dashboard, :search_activity, :manage ]
    before_filter :set_page_number, only: [ :dashboard, :search_activity ]

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

      # build an empty activity query
      @activity_query = ActivityQuery.new(params[:activity_query])

      #TODO perpage constant should be put somewhere else
      @translations_changes = @activity_query.activities.offset(Translation::CHANGES_PER_PAGE * (@page - 1)).limit(Translation::CHANGES_PER_PAGE)
      @total_pages = (@activity_query.activities.count / (Translation::CHANGES_PER_PAGE * 1.0)).ceil

      respond_to do |format|
        format.html
        format.js { render 'search_activity' }
      end
    end

    def search_activity
      @translations_changes = ActivityQuery.new(params[:activity_query]).activities.offset(Translation::CHANGES_PER_PAGE * (@page - 1)).limit(Translation::CHANGES_PER_PAGE)
      @total_pages =  (ActivityQuery.new(params[:activity_query]).activities.count / (Translation::CHANGES_PER_PAGE * 1.0)).ceil
      
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
