class Add<%= @model_name %>Translation < ActiveRecord::Migration

  def up
    <% @model_name.constantize.column_names.each do |column_name| %>
      translation_key = TranslationKey.create(key: '<%= @model_name.downcase %>.attributes.<%= column_name %>', version: <%= @translation_version %>, resource_type: 'model', resource_name: '<%= @model_name.downcase %>')
      Translation.create(translation_key_id: translation_key.id , value: '<%= column_name.gsub("_"," ") %>', lang: 'en')
    <% end %>
  end

  def down
    <% @model_name.constantize.column_names.each do |column_name| %>
      TranslationKey.where(resource_type: 'model', resource_name: '<%= @model_name.downcase %>').destroy_all
    <% end %>
  end
end