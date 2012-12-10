= TranslationCenter

This project rocks and uses MIT-LICENSE.

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
rails generate translation_center:install
```

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

You know need to define who is the translation center admin. Admin can accept translations, manage translation keys and do more things. To define your admin, you need to override User#can_admin_translations? method like the following....

```ruby
def can_admin_translations?
  self.email == 'admin@tc.com'
end
```

To define your website supported languages, you need to edit config/translation_center.yaml

```ruby
development:
  lang:
    en: 'English'
    de: 'German'
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
development:
  yaml_translator_email: 'coder@tc.com'
```

The imported translations status will be ACCEPTED by default. If you want to disable that, comment the following line in translation_center.yaml

```ruby
development:
  yaml2db_translations_accepted: true
```

Any I18n.translate method will display translations from database ACCEPTED translations. If you want to skip database translations and set to use yaml translations, comment the following line in translation_center.yaml

```ruby
i18n_source: 'db' # can be db or yaml; default is yaml
```