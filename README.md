## Introduction

Translation Center is an engine that can be easily integerated into your rails app, it allows users of your system to easily add translations for your site.

###Features
  * Detect new keys in code and store them in db for users to translate
  * Different roles: users and admins
  * Add new locales easily
  * Inspect keys from your application view directly
  * Translate from db(live) or yaml
  * Users can vote up translations
  * Default translation in English for keys

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

By default, all users are admins, you need to define who is the translation center admin. Admin can accept translations, manage translation keys and do more things. To define your admin, you need to override User#can_admin_translations? method like the following....

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


##Inspector

Another nice option is the inspector that allows the users to go directly to the key from your application view.
Just set `inspector` option in `translation_center.yml` to `all` if you want to inspect all keys otherwise set it to `missing` to inspect only untranslated keys, and then add this line to your `application.css`

```ruby
*= require translation_center/inspector
```

and this line to your `application.js`

```ruby
//= require translation_center/inspector
```

###Screen Shots

You will see a small icon beside each key

![Alt text](https://raw.github.com/mahkhaled/translation_center/master/samples/inspector_shot.png "Translation Center")

If you click on the icon of 'Betrachten', you will be directed to the key page, where you can add/edit translations directly.

![Alt text](https://raw.github.com/mahkhaled/translation_center/master/samples/inspector_visit_key.png "Translation Center")



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

##Screen Shots

When you visit `/translation_center` you will see the list of all categories and how many keys they have.

![Alt text](https://raw.github.com/mahkhaled/translation_center/master/samples/categories_screen.png "Translation Center")

Click on category to view all the keys, keys are divided into untranslated (has no translations), pending (has translations but not approved yet), translated (has accepted translations)

![Alt text](https://raw.github.com/mahkhaled/translation_center/master/samples/view_keys.png "Translation Center")


Click on a key to view all translations for that key, then you can add or edit your translation for that key, users can also vote for translations.

![Alt text](https://raw.github.com/mahkhaled/translation_center/master/samples/many_translations.png "Translation Center")

As an admin you can accept pending translations that have been added by other users, you can also edit and remove keys.

![Alt text](https://raw.github.com/mahkhaled/translation_center/master/samples/accept_pending.png "Translation Center")


##Demo

We have added translation_center to the [Tracks][1] app:

  * You can play with the demo here: http://translation-center.herokuapp.com/translation_center/

  * Visit the Tracks app at http://translation-center.herokuapp.com


  [1]: https://github.com/TracksApp/tracks