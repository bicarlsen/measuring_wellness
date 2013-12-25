# FILE: facotries.rb

FactoryGirl.define do
	factory :user do
		sequence(:name) { |n| "User #{n}" }
		sequence(:email) { |n| "user_#{n}@test.com" }
		password 'password'
		password_confirmation 'password'

		factory :admin do
			admin true
		end
	end # user


end # define
