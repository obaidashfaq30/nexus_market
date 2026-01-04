require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:tenant) { Tenant.create!(name: 'Shop A') }

  it 'is valid with name, price, stock, and tenant' do
    product = tenant.products.new(name: 'Item A', price: 10.0, stock: 5)
    expect(product).to be_valid
  end

  it 'is invalid without a name' do
    product = tenant.products.new(name: nil, price: 10.0)
    expect(product).not_to be_valid
  end

  it 'is invalid without a price' do
    product = tenant.products.new(name: 'Item A', price: nil)
    expect(product).not_to be_valid
  end

  it 'defaults stock to 0' do
    product = tenant.products.create!(name: 'Item B', price: 5.0)
    expect(product.stock).to eq(0)
  end

  it 'belongs to a tenant' do
    assoc = Product.reflect_on_association(:tenant)
    expect(assoc.macro).to eq :belongs_to
  end
end
