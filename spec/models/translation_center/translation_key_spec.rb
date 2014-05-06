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

        expect(translation_key.accepted_in?(language)).to be_true
        expect(translation_key.has_translations_in?(language)).to be_true
      end

      it "should be untranslated in German" do
        expect(translation_key.no_translations_in?("de")).to be_true
      end

      it "should be pending in English" do
        en_translation

        expect(translation_key.pending_in?(language)).to be_true
      end
    end
  end
end
