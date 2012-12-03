require_dependency "translation_center/application_controller"

module TranslationCenter
  class TranslationKeysController < ApplicationController
    before_filter :authenticate_user!
    before_filter :get_translation_key
    before_filter :can_admin?, only: [ :destroy, :update ]

    # POST /translation_keys/1/update_translation.js
    def update_translation
      @translation = current_user.translation_for @translation_key, session[:lang_to]
      respond_to do |format|
        if !@translation.accepted? && !params[:value].strip.blank?
          @translation.update_attributes(value: params[:value].strip, status: 'pending')
          format.json {render json: @translation.value}
        else
          render nothing: true
        end
      end
    end

    # GET /translation_keys/1
    def translations
      if params[:sort_by] == 'votes'
        @translations = @translation_key.translations.in(session[:lang_to]).sorted_by_votes
      else
        @translations = @translation_key.translations.in(session[:lang_to]).order('created_at DESC')
      end
      respond_to do |format|
        format.js
      end
    end
    
    # GET /translation_keys
    # GET /translation_keys.json
    def index
      @translation_keys = TranslationKey.all
  
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @translation_keys }
      end
    end
  
    # GET /translation_keys/1
    # GET /translation_keys/1.json
    def show
      @translation_key = TranslationKey.find(params[:id])
  
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @translation_key }
      end
    end
  
    # GET /translation_keys/new
    # GET /translation_keys/new.json
    def new
      @translation_key = TranslationKey.new
  
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @translation_key }
      end
    end
  
    # GET /translation_keys/1/edit
    def edit
      @translation_key = TranslationKey.find(params[:id])
      @category = @translation_key.category
    end
  
    # POST /translation_keys
    # POST /translation_keys.json
    def create
      @translation_key = TranslationKey.new(params[:translation_key])
      @translation_key.last_accessed = Time.now
      category = Category.find(params[:translation_key][:category_id])
      respond_to do |format|
        if @translation_key.save
          format.html { redirect_to @translation_key.category, notice: 'Translation key was successfully created.' }
          format.json { render json: @translation_key, status: :created, location: @translation_key }
        else
          format.html { redirect_to category, notice: 'Translation key must have a name.' }
          format.json { render json: @translation_key.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # PUT /translation_keys/1
    # PUT /translation_keys/1.json
    def update
      params[:value].strip!
      respond_to do |format|
        if !params[:value].blank? && @translation_key.update_attribute(:name, params[:value])
          format.json { render json: @translation_key.name }
        else
          format.json { render json: @translation_key.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # DELETE /translation_keys/1
    # DELETE /translation_keys/1.json
    def destroy
      @translation_key = TranslationKey.find(params[:id])
      @translation_key_id = @translation_key.id
      @translation_key.destroy
  
      respond_to do |format|
        format.js
      end
    end

    def get_translation_key
      id = params[:translation_key_id] || params[:id]
      @translation_key = TranslationKey.find(id)
    end
  end
end
