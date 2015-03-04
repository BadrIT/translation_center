FactoryGirl.define do
	factory :user do
	    sequence(:email) { |n| "user+#{n}@example.com" }
	    password SecureRandom.hex
	end
end