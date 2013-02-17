## Introduction

Translation Center is a multi lingual web engine for Rails 3 apps. It builds a translation center community with translators and admins from your system users.

![Alt text](https://raw.github.com/BadrIT/translation_center/master/samples/view_keys.png "View category translations")

## Translation Center can be used by:

###App Users
Contribute in translating your app in different locales using easy web interface.

###Rails Developers
Avoid updating many yaml files as you will just use the easy web interface to manage translations.

###Site Admin
Manage all app translations; collect stats, accept, add, edit, remove translations...etc


## Features

  * Different roles: translators and admins
  * Add new locales easily
  * Detect new translation keys in code and store them in DB for users to translate
  * Inspect translation keys from your application view directly
  * Import and Export translations in yaml format
  * Switch translations backend between DB and yaml
  * Admin dashboard for languages status and activity
  * Users can vote up translations
  * Default translation in English for keys

## Getting started

TranslationCenter works with Rails 3.2 onwards. You can add it to your Gemfile with:

```ruby
gem 'translation_center'
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

Add new key to your views, for example:

```ruby
t('posts.index.title')
```

When you visit the page where this key is rendered, a new translation key will be stored with name 'index.title' under category 'posts'.
You then visit the TranslationCenter and translate the key (by default translations added by admins are considered accepted).

To migrate translations from TranslationCenter database to yaml files

```ruby
rake translation_center:db2yaml
```

To migrate translations from yaml files to TranslationCenter database 

```ruby
rake translation_center:yaml2db
```

If you want to export or import just one locale, provide the locale as an attribute to the rakes, for example:

```ruby
rake translation_center:yaml2db[ar]
```

Imported translations should have a translator. You can edit translator email from `translation_center.yml` The rake task `yaml2db` will create this user if it doesn't exist.

```ruby
yaml_translator_email: 'coder@tc.com'
```

The imported translations status will be accepted by default. If you want to disable this, comment the following line in `translation_center.yaml`

```ruby
yaml2db_translations_accepted: true
```

You can control the translations source by changing the value of `i18n_source` in `translation_center.yaml`

```ruby
i18n_source: 'yaml' # can be db or yaml; default is yaml
```

##Without Devise

If your application doesn't use devise for authentication then you have to
provide helper named `current_user` that returns the current user in the session and a before_filter named `authenticate_user!` that redirects a user
to login page if not already signed in.

You also need to add these methods in an initialize, for example `translation_authentication.rb` :
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

**Email attribute:** 

Translation Center assumes that the translator model (for example `User`) has an `email` attribute, this attribute is used when showing translations, activity log in dashboard and updating existing translations.

If your `User` model has no `email` attribute add one or define a method named `email` like the following:

```ruby
def email
  "translator_#{self.id}@myapp.com"
end
```






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

Now when you reload your page you will see a small icon beside your keys.

![Alt text](https://raw.github.com/BadrIT/translation_center/master/samples/inspector_shot.png "Inspected keys")

In the previous image, if you click on the icon of 'Betrachten', you will be directed to the key page, where you can add/edit translations directly.

![Alt text](https://raw.github.com/BadrIT/translation_center/master/samples/inspector_visit_key.png "Visit a key from inspector")


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

![Alt text](https://raw.github.com/BadrIT/translation_center/master/samples/categories_screen.png "Listing Categories")

Click on category to view all the keys, keys are divided into untranslated (has no translations), pending (has translations but not approved yet), translated (has accepted translations)

![Alt text](https://raw.github.com/BadrIT/translation_center/master/samples/view_keys.png "View a category")


Click on a key to view all translations for that key, then you can add or edit your translation for that key, users can also vote for translations.

![Alt text](https://raw.github.com/BadrIT/translation_center/master/samples/many_translations.png "View a translation key")

As an admin you can accept pending translations that have been added by other users, you can also edit and remove keys.

![Alt text](https://raw.github.com/BadrIT/translation_center/master/samples/accept_pending.png "Accept pending")

Admin also can view the dashboard to know the status of every language

![Alt text](https://raw.github.com/BadrIT/translation_center/master/samples/dashboard.png "Dashboard")

or monitor activity of changes to translations.

![Alt text](https://raw.github.com/BadrIT/translation_center/master/samples/activity.png "Activity")

##Demo

We have added translation_center to the [Tracks][1] app:

  * You can play with the demo here: http://translation-center.herokuapp.com/translation_center/

  * Visit the Tracks app at http://translation-center.herokuapp.com


  [1]: https://github.com/TracksApp/tracks
  

## Credits

![BadrIT](http://www.badrit.com/images/logo-main.png)

Translation Center is maintained and developed by [BadrIT](http://badrit.com/)
