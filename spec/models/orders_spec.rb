# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:tenant) { Tenant.create!(name: 'Shop A') }
  let(:user) { tenant.users.create!(name: 'John', email: 'john@example.com', password: 'password') }

  it 'is valid with tenant, user, total_cents, and status' do
    order = Order.new(tenant: tenant, user: user, total_cents: 1000, status: 0)
    expect(order).to be_valid
  end

  it 'belongs to a tenant' do
    assoc = Order.reflect_on_association(:tenant)
    expect(assoc.macro).to eq :belongs_to
  end

  it 'belongs to a user' do
    assoc = Order.reflect_on_association(:user)
    expect(assoc.macro).to eq :belongs_to
  end

  it 'has many order_items' do
    assoc = Order.reflect_on_association(:order_items)
    expect(assoc.macro).to eq :has_many
  end
end
