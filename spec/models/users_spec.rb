require 'rails_helper'

RSpec.describe User, type: :model do
  let(:tenant) { Tenant.create!(name: 'Shop A') }

  it 'is valid with a name, email, and password' do
    user = tenant.users.new(name: 'John', email: 'john@example.com', password: 'password')
    expect(user).to be_valid
  end

  it 'is invalid without a name' do
    user = tenant.users.new(name: nil, email: 'john@example.com', password: 'password')
    expect(user).not_to be_valid
  end

  it 'belongs to a tenant' do
    assoc = User.reflect_on_association(:tenant)
    expect(assoc.macro).to eq :belongs_to
  end
end
