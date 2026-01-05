# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id          :bigint           not null, primary key
#  description :text
#  name        :string           not null
#  price       :decimal(10, 2)   not null
#  stock       :integer          default(0), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  tenant_id   :bigint           not null
#
FactoryBot.define do
  factory :product do
    name { "Product #{SecureRandom.hex(4)}" }
    price { 10.0 }
    stock { rand(1..10) }

    description { 'A description for the product.' }

    association :tenant
  end
end
