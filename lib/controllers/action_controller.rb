class ActionController::Base
  def add_category
    TranslationCenter::Category.create(name: controller_name) unless TranslationCenter::Category.find_by_name(controller_name)
  end
end