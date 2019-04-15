module TranslationCenter
  class ActivityQuery
    extend ActiveModel::Naming
    include ActiveModel::Conversion

    attr_accessor :translation_key_name, :translator_identifier, :lang, :created_at_gteq, :created_at_lteq

    def persisted?
      false
    end

    def initialize args={}
      args ||= {}
      args.each do |k,v|
        instance_variable_set("@#{k}", v) unless v.blank?
      end
    end

    # retuns and ActiveRecord Relation of Audit(s) that matches this search criteria
    def activities
      query = Audited::Audit.where(auditable_id: translation_ids).all
      query = query.where("DATE(created_at) <= DATE(?)", created_at_lteq) unless created_at_lteq.blank?
      query = query.where("DATE(created_at) >= DATE(?)", created_at_gteq) unless created_at_gteq.blank?
      query.order('created_at DESC')
    end

    protected

    # return translation ids that matches this search criteria
    def translation_ids
      query = Translation.all
      query = query.where(lang: lang) unless lang.blank?
      query = query.joins(:translation_key).where("translation_center_translation_keys.name LIKE ?", "%#{translation_key_name}%") unless translation_key_name.blank?

      if translator_identifier
        translator_class = TranslationCenter::CONFIG['translator_type'].camelize.constantize
        translators_ids = translator_class.where("#{TranslationCenter::CONFIG['identifier_type']} LIKE ? ", "%#{translator_identifier}%").map(&:id)

        query = query.where(translator_id: translators_ids)
      end

      query.map(&:id)
    end
  end
end
