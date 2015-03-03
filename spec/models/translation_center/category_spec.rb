require 'spec_helper'
  module TranslationCenter
    describe Category do
    let(:category) { FactoryGirl.create(:category) }
    let(:translation) { FactoryGirl.create(:translation) }

      it "should return array of keys" do 
		expect(category.all_keys(nil).class.name).to eq 'ActiveRecord::Associations::CollectionProxy'
      end

      it "should return name" do 
		expect(category.view_name.class.name).to eq 'String'
      end

      it "should return keys that are pended in the language" do 
		pending_keys = category.pending_keys(translation.lang).collect(&:"#{translation.lang}_status").uniq
             expect(pending_keys.length).to be < 2
		expect(["pending" , nil]).to include pending_keys.first
      end

      it "should return keys that have no translations in the language" do 
		untranslated = category.untranslated_keys(translation.lang).collect(&:"#{translation.lang}_status").uniq
		expect(untranslated.length).to be < 2
		expect(["untranslated" , nil]).to include untranslated.first
      end

      it "should return keys that have translations in the language" do 
		translated_keys = category.accepted_keys(translation.lang).collect(&:"#{translation.lang}_status").uniq
		expect(translated_keys.length).to be < 2
		expect(["translated" , nil]).to include translated_keys.first
      end

      it "should return percentage of compeletion" do 
            expect(category.complete_percentage_in(translation.lang).class.name).to  eq "Fixnum"
            FactoryGirl.create(:translation_key, name: "category.new")
            expect(Category.find(category).complete_percentage_in(translation.lang).class.name).to  eq "Fixnum"
      end
    end
  end