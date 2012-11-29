class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  # TODO move to acts_as_translator
  has_many :translations, class_name: 'TranslationCenter::Translation'

  # returns the translation a user has made for a certain key in a certain language
  def translation_for(key, lang)
    self.translations.find_or_initialize_by_translation_key_id_and_lang(key.id, lang.to_s)
  end
end
