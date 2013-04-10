module TranslationCenter
  module ApplicationHelper

    # get the current user the language translating from
    def from_lang
      session[:lang_from]
    end

    # get the current user the language translating to
    def to_lang
      session[:lang_to]
    end

    # returns the display name of the language
    def language_name(lang)
      TranslationCenter::CONFIG['lang'][lang.to_s]
    end

    # returns the current status filter for translation keys
    def current_filter
      session[:current_filter]
    end

    # returns true if the current filter is equal to the passed filter
    def current_filter_is?(filter)
      session[:current_filter] == filter
    end

    # returns true if the current user can admin translations
    def translation_admin?
      current_user.respond_to?(:can_admin_translations?) && current_user.can_admin_translations?
    end

    # returns formated date
    def format_date(date)
      date.strftime('%e %b %Y')
    end

  end
end
