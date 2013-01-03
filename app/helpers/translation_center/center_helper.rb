module TranslationCenter
  module CenterHelper

    # returns a human readable view of the changes
    def format_change(attribute, value)
      # if value is an array then changed value
      if value.is_a? Array 
        "#{attribute} changed from '#{value[0]}' to '#{value[1]}'"
      # else value is new
      else
        "#{attribute} has new value '#{value}'"
      end
    end
  end
end
