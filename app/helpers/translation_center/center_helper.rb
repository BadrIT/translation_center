module TranslationCenter
  module CenterHelper

    # returns a human readable view of the changes
    def format_change(attribute, value)
      # if value is an array then changed value
      if value.is_a? Array 
        "<span class=\"label label-info\">#{attribute}</span> changed from <span class=\"label label-important\">#{value[0]}</span> to <span class=\"label label-success\">#{value[1]}</span>".html_safe
      # else value is new
      else
        "<span class=\"label label-info\">#{attribute}</span> has new value <span class=\"label label-success\">#{value}</span>".html_safe
      end
    end

    def translator_identifier_placeholder
      "#{TranslationCenter::CONFIG['translator_type']} #{TranslationCenter::CONFIG['identifier_type']}".upcase
    end
  end
end
