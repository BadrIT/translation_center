require_dependency "translation_center/application_controller"

module TranslationCenter
  class TranslationKeysController < ApplicationController
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
    end
  
    # POST /translation_keys
    # POST /translation_keys.json
    def create
      @translation_key = TranslationKey.new(params[:translation_key])
  
      respond_to do |format|
        if @translation_key.save
          format.html { redirect_to @translation_key, notice: 'Translation key was successfully created.' }
          format.json { render json: @translation_key, status: :created, location: @translation_key }
        else
          format.html { render action: "new" }
          format.json { render json: @translation_key.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # PUT /translation_keys/1
    # PUT /translation_keys/1.json
    def update
      @translation_key = TranslationKey.find(params[:id])
  
      respond_to do |format|
        if @translation_key.update_attributes(params[:translation_key])
          format.html { redirect_to @translation_key, notice: 'Translation key was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @translation_key.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # DELETE /translation_keys/1
    # DELETE /translation_keys/1.json
    def destroy
      @translation_key = TranslationKey.find(params[:id])
      @translation_key.destroy
  
      respond_to do |format|
        format.html { redirect_to translation_keys_url }
        format.json { head :no_content }
      end
    end
  end
end
