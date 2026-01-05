# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { 'password' }
    role { :customer } # Default to customer

    association :tenant

    trait :owner do
      role { :owner }
    end

    trait :customer do
      role { :customer }
    end
  end
end
