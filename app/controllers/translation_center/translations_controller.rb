require_dependency "translation_center/application_controller"

module TranslationCenter
  class TranslationsController < ApplicationController
    before_action :can_admin?, only: [ :destroy, :accept, :unaccept ]
    before_action :set_page_number, only: [:search]

    # POST /translations/1/vote
    def vote
      @translation = Translation.find(params[:translation_id])
      current_user.likes(@translation)
      respond_to do |format|
        format.js
      end
    end

    # POST /translations/1/unvote
    def unvote
      @translation = Translation.find(params[:translation_id])
      current_user.unlike @translation
      respond_to do |format|
        format.js
      end
    end

    # POST /translations/1/accept
    def accept
      @translation = Translation.find(params[:translation_id])
      @translation_already_accepted = @translation.key.accepted_in? session[:lang_to]
      @translation.accept
      respond_to do |format|
        format.js
      end
    end

    # POST /translations/1/accept
    def unaccept
      @translation = Translation.find(params[:translation_id])
      @translation.unaccept
      respond_to do |format|
        format.js
      end
    end
  
    # DELETE /translations/1
    # DELETE /translations/1.json
    def destroy
      @translation = Translation.find(params[:id])
      @translation_id = @translation.id
      @translation_key_before_status = @translation.key.status session[:lang_to]
      @translation_key_id = @translation.key.id
      @translation.destroy
      @translation_key_after_status = @translation.key.status session[:lang_to]

      respond_to do |format|
        format.js
      end
    end

    def search
      @result = Translation.where('value LIKE ?', "%#{params[:translation_value]}%")
      @translations = @result.offset(Translation::NUMBER_PER_PAGE * (@page - 1)).limit(Translation::NUMBER_PER_PAGE)
      @total_pages =  (@result.count / (Translation::NUMBER_PER_PAGE * 1.0)).ceil

      respond_to do |format|
        format.html
        format.js
      end
    end

  end
end
