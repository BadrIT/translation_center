require 'spec_helper'

module TranslationCenter
  describe Translation do
  	let(:translation_key) { FactoryGirl.create(:translation_key, name: "whatever") }

    let(:en_translation) do
      FactoryGirl.create(
        :translation,
        value: "Whatever",
        translation_key: translation_key,
        lang: "en"
      )
    end

    let(:de_translation) do
      FactoryGirl.create(
        :translation,
        value: "Egal",
        translation_key: translation_key,
        lang: "de"
      )
    end

    context "scopes" do
    	it "should sort by votes" do
    		# Creating translations
    		high_voted_translation = FactoryGirl.create(
    			:translation,
    			value: "Whatever",
    			translation_key: translation_key
    		)

    		low_voted_translation = FactoryGirl.create(
    			:translation,
    			value: "What ever",
    			translation_key: translation_key
    		)

    		# Voting for "Whatever"
    		5.times { high_voted_translation.liked_by FactoryGirl.create(:user) }

    		# Voting for "What ever"
    		2.times { low_voted_translation.liked_by FactoryGirl.create(:user) }

    		expected_order = [high_voted_translation, low_voted_translation]

    		expect(translation_key.translations.sorted_by_votes).to eq(expected_order)
    		expect(translation_key.translations.sorted_by_votes).not_to eq(expected_order.reverse)
    	end

    	it "should return translations of certain lang" do
    		# Arabic translation
    		expect(translation_key.translations.in("ar")).to eq([])

    		# English translation
    		expect(translation_key.translations.in("en")).to eq([en_translation])

    		# Deutsch translation
    		expect(translation_key.translations.in("de")).to eq([de_translation])
    	end
    end

    context "translation key acceptance" do
      it "should accept a translation" do
        expect(en_translation.status).to eq(Translation::PENDING)

        en_translation.accept

        expect(en_translation.status).to eq(Translation::ACCEPTED)
      end

      it "should unaccept a translation" do
        en_translation.accept

        expect(en_translation.status).to eq(Translation::ACCEPTED)

        en_translation.unaccept

        expect(en_translation.status).to eq(Translation::PENDING)
      end

      it "should flag the translation key as pending when translation is unaccepted" do
        en_translation.accept

        expect(en_translation.translation_key
          .status(en_translation.lang)).to eq(TranslationKey::TRANSLATED)

        en_translation.unaccept

        expect(en_translation.translation_key
          .status(en_translation.lang)).to eq(TranslationKey::PENDING)
      end
    end

    context "validations" do
      it "should create one translation per lang per key" do
        translation_attributes = en_translation.attributes.except("id")
        duplicated_translation = FactoryGirl.build(:translation, translation_attributes)

        expect(duplicated_translation.valid?).to eq false

        expect(duplicated_translation.errors.messages).not_to be_empty
      end
    end

    context "suggest translation" do
      it "should raise error when Bing credentials are missing" do
        expect{ en_translation.suggest_translation.downcase }.to(
          raise_error(TranslationCenter::MissingBingCredentials)
        )
      end

      it "should suggest an English translation" do
        TranslationCenter::CONFIG["bing"] = {
          "client_id" => "fake",
          "client_secret" => "fake"
        }

        translator_object = OpenStruct.new
        BingTranslator.stub(:new).and_return(translator_object)
        translator_object.stub(:translate).and_return(en_translation.value)

        expect(en_translation.suggest_translation.downcase).to eq("whatever")
      end
    end
  end
end
