require 'spec_helper'

module TranslationCenter
  describe TranslationKey do
    let(:translation_key) { FactoryGirl.create(:translation_key, name: "whatever") }

    let(:en_translation) do
      FactoryGirl.create(
        :translation,
        value: "Whatever",
        translation_key: translation_key,
        lang: "en"
      )
    end

    let(:language) { "en" }

    it "it should create new translation" do
      expect(translation_key.create_default_translation).to be_truthy
    end

    it "it should return all languages stats" do
      expect(TranslationKey.langs_stats.class.name).to eq "Hash"
    end

    it "it should return nested translations for language" do
      FactoryGirl.create(:translation_key, name: "whatever.whatever")
      children = translation_key.children_translations(en_translation)
      expect(children.class.name).to eq "Hash"
    end 

    it "it should check if there area any nested translations for key" do
      expect(translation_key.has_children?).to be_falsey
      FactoryGirl.create(:translation_key, name: "whatever.whatever")
      expect(translation_key.has_children?).to be_truthy
    end

    it "it should nested translations for language" do
      translation_key.update_attributes(name: "whatever.whatever")
      en_translation.accept
      expect(translation_key.add_to_hash({}, en_translation.lang).class.name).to eq "Hash"
    end 

    context "counters" do
      it "it should coutnt all records for translation keys table" do
        expect(TranslationKey.keys_count.class.name).to eq "Fixnum"
      end
      
      it "it should count translated keys for language" do
        expect(TranslationKey.translated_count(language)).to eq TranslationKey.where(:"#{language}_status" => TranslationKey::TRANSLATED).count
      end

      it "it should count pending keys for language" do
        expect(TranslationKey.pending_count(language)).to eq TranslationKey.where(:"#{language}_status" => TranslationKey::PENDING).count
      end

      it "it should count untranslated keys for language" do
        expect(TranslationKey.untranslated_count(language)).to eq TranslationKey.where(:"#{language}_status" => TranslationKey::UNTRANSLATED).count
      end
    end

    context "percentages calculating" do
      it "it should calculate percentages for translated keys for language" do
        expect(TranslationKey.translated_percentage(language).class.name).to eq "Float"
      end

      it "it should calculate percentages for pending keys for language" do
        expect(TranslationKey.pending_percentage(language).class.name).to eq "Float"
      end

      it "it should calculate percentages for untranslated keys for language" do
        expect(TranslationKey.untranslated_percentage(language).class.name).to eq "Float"
      end
    end

    context "update status" do
      it "should update translation key status to translated" do
        expect(TranslationKey.untranslated(language)).to eq([translation_key])

        en_translation.accept

        expect(TranslationKey.untranslated(language)).to be_empty
        expect(TranslationKey.translated(language)).to eq([translation_key])
      end

      it "should update translation key status to pending" do
        expect(TranslationKey.untranslated(language)).to eq([translation_key])

        en_translation

        expect(TranslationKey.untranslated(language)).to be_empty
        expect(TranslationKey.pending(language)).to eq([translation_key])
      end

      it "should update translation key status to untranslated" do
        translation_key.update_attribute(:"#{language}_status",  TranslationKey::UNTRANSLATED)
        expect(translation_key.status(language)).to eq TranslationKey::UNTRANSLATED
      end
    end

    context "status scopes" do
      it "should return the untranslated English translations" do
        expect(TranslationKey.untranslated(language)).to eq([translation_key])

        expect(TranslationKey.translated(language)).to eq([])
        expect(TranslationKey.pending(language)).to eq([])
      end

      it "should return the pending English translations" do
        en_translation
        expect(TranslationKey.pending(language)).to eq([translation_key])

        expect(TranslationKey.untranslated(language)).to eq([])
        expect(TranslationKey.translated(language)).to eq([])
      end

      it "should return the translated English translations" do
        en_translation.accept
        expect(TranslationKey.translated(language)).to eq([translation_key])

        expect(TranslationKey.untranslated(language)).to eq([])
        expect(TranslationKey.pending(language)).to eq([])
      end
    end

    context "predicates" do
      it "should be accepted and have translation in English" do
        en_translation.accept

        expect(translation_key.accepted_in?(language)).to be_truthy
        expect(translation_key.has_translations_in?(language)).to be_truthy
      end

      it "should be untranslated in German" do
        expect(translation_key.no_translations_in?("de")).to be_truthy
      end

      it "should be pending in English" do
        en_translation

        expect(translation_key.pending_in?(language)).to be_truthy
      end
    end
  end
end
