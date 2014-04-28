require 'spec_helper'

module TranslationCenter
  describe Translation do
  	let(:translation_key) { FactoryGirl.create(:translation_key, name: "whatever") }

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
  		en_translation = FactoryGirl.create(
  			:translation,
  			value: "Whatever",
  			translation_key: translation_key,
  			lang: "en"
  		)

  		de_translation = FactoryGirl.create(
  			:translation,
  			value: "Egal",
  			translation_key: translation_key,
  			lang: "de"
  		)

  		# Arabic translation
  		expect(translation_key.translations.in("ar")).to eq([])

  		# English translation
  		expect(translation_key.translations.in("en")).to eq([en_translation])

  		# Deutsch translation
  		expect(translation_key.translations.in("de")).to eq([de_translation])
  	end
  end
end
