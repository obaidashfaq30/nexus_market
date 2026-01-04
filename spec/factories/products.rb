FactoryBot.define do
  factory :product do
    name { "Product #{SecureRandom.hex(4)}" }
    price { 10.0 }
    stock { 100 }
    description { "A description for the product." }

    # Ensure that tenant is associated with the product
    tenant { create(:tenant) }
  end
end
