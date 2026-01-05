# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tenant, type: :model do
  it 'is valid with a name' do
    tenant = Tenant.new(name: 'Shop A')
    expect(tenant).to be_valid
  end

  it 'is invalid without a name' do
    tenant = Tenant.new(name: nil)
    expect(tenant).not_to be_valid
  end

  it 'has many users' do
    assoc = Tenant.reflect_on_association(:users)
    expect(assoc.macro).to eq :has_many
  end

  it 'has many products' do
    assoc = Tenant.reflect_on_association(:products)
    expect(assoc.macro).to eq :has_many
  end

  it 'has many orders' do
    assoc = Tenant.reflect_on_association(:orders)
    expect(assoc.macro).to eq :has_many
  end
end
