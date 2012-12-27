Translation admin must extend User model and implement a boolean method named can_admin_translations?


## Getting started

TranslationCenter works with Rails 3.2 onwards. You can add it to your Gemfile with:

```ruby
gem 'translation_center', :git => 'git@github.com:mahkhaled/translation_center.git'
```

Run bundle install command.

TranslationCenter depends on Devise, so make sure you installed it successfully https://github.com/plataformatec/devise#starting-with-rails

After you install TranslationCenter and add it to your Gemfile, you need to run the generator:

```ruby
rails generate translation_center:install en ar de
 ```

This will add three languages to the translation center, you need to add them in the config/translation_center.yaml

```ruby
development:
  lang:
    en: 'English'
    ar: 'Arabic'
    de: 'German'
```

if you don't supply languages for the generator it will support only English.

And run the migrations

```ruby
rake db:migrate
```

In your User model or any other model that should acts as a translator add the following line:

```ruby
acts_as_translator
```

In routes file add 

```ruby
mount TranslationCenter::Engine => "/translation_center"
```

You now need to define who is the translation center admin. Admin can accept translations, manage translation keys and do more things. To define your admin, you need to override User#can_admin_translations? method like the following....

```ruby
def can_admin_translations?
  self.email == 'admin@tc.com'
end
```

## How to use

To migrate translations from TranslationCenter database to yaml files

```ruby
rake translation_center:db2yaml
```

To migrate translations from yaml files to TranslationCenter database 

```ruby
rake translation_center:yaml2db
```

But imported translations should have translator. You can edit translator email from translation_center.yml The rake task yaml2db will create this user if not exists

```ruby
yaml_translator_email: 'coder@tc.com'
```

The imported translations status will be ACCEPTED by default. If you want to disable that, comment the following line in translation_center.yaml

```ruby
yaml2db_translations_accepted: true
```

Any I18n.translate method will display translations from database ACCEPTED translations. If you want to skip database translations and set to use yaml translations, comment the following line in translation_center.yaml

```ruby
i18n_source: 'db' # can be db or yaml; default is yaml
```

##Without Devise

If your application doesn't use devise for authentication then you have to
provide helper named `current_user` that returns the current user in the session and a before_filter named `authenticate_user!` that redirects a user
to login page if not already signed in.

You need to add these methods in an initialize, for example `translation_authentication.rb` :
```ruby
module TranslationCenter
  class ApplicationController < ActionController::Base

    # current_user is needed in views
    helper_method :current_user

    def authenticate_user!
      # redirect to login if user not signed in
    end

    def current_user
      # write code that returns the current user in session
    end

  end
end  
```

**Note:** Also notice that your user must have an email attribute.



##Add new language

If you want to add a language to the translation center, you need to run the generator:

```ruby
rails g migration translation_center:add_lang es fr
rake db:migrate
```

You will also need to add the language to config/translation_center.yml

```ruby
development:
  lang:
    en: 'English'
    ar: 'Arabic'
    de: 'German'
    es: 'Espaniol'
    fr: 'French'
```
