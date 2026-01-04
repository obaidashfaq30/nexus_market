FactoryBot.define do
  factory :tenant do
    name { "Tenant #{SecureRandom.hex(4)}" }
  end
end
