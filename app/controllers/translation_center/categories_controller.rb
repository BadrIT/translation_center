require_dependency "translation_center/application_controller"

module TranslationCenter
  class CategoriesController < ApplicationController
    require 'will_paginate/array'
    before_filter :can_admin?, only: [ :destroy ]

    # GET /categories
    # GET /categories.json
    def index
      @categories = Category.all
  
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @categories }
      end
    end
  
    # GET /categories/1
    # GET /categories/1.json
    def show
      @category = Category.find(params[:id])
      session[:current_filter] = params[:filter] || session[:current_filter]
      @keys = @category.send("#{session[:current_filter]}_keys", session[:lang_to]).paginate(:page => params[:page], :per_page => TranslationKey::PER_PAGE)
      @untranslated_keys_count = @category.untranslated_keys(session[:lang_to]).count
      @translated_keys_count = @category.translated_keys(session[:lang_to]).count
      @pending_keys_count = @category.pending_keys(session[:lang_to]).count
      @all_keys_count = @untranslated_keys_count + @translated_keys_count + @pending_keys_count
      respond_to do |format|
        format.html # show.html.erb
        format.js
      end
    end

    # GET /categories/1/more_keys.js
    def more_keys
      @category = Category.find(params[:category_id])
      @keys = @category.send("#{session[:current_filter]}_keys", session[:lang_to]).paginate(:page => params[:page], :per_page => TranslationKey::PER_PAGE)
      respond_to do |format|
        format.js { render 'keys' }
      end
    end

  
    # DELETE /categories/1
    # DELETE /categories/1.json
    def destroy
      @category = Category.find(params[:id])
      @category.destroy
  
      respond_to do |format|
        format.html { redirect_to categories_url }
        format.json { head :no_content }
      end
    end
  end
end
