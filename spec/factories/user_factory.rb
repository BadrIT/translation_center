FactoryGirl.define do
	factory :user do
	    sequence(:email) { |n| "user+#{n}@example.com" }
	    password SecureRandom.hex

	    factory :translator do

	  end
	end
end