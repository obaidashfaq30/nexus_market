# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Checkout Flow', type: :model do
  let!(:tenant_a) { create(:tenant) }
  let!(:tenant_b) { create(:tenant) }

  let!(:owner_a) { create(:user, :owner, tenant: tenant_a) }
  let!(:customer_a) { create(:user, :customer, tenant: tenant_a) }

  let!(:owner_b) { create(:user, :owner, tenant: tenant_b) }
  let!(:customer_b) { create(:user, :customer, tenant: tenant_b) }

  let!(:product_a) { create(:product, tenant: tenant_a, stock: 1) }
  let!(:product_b) { create(:product, tenant: tenant_b) }

  before do
    ActsAsTenant.current_tenant = tenant_a
  end

  context 'Multitenancy' do
    it 'only allows a tenant to see its own products' do
      ActsAsTenant.current_tenant = tenant_a
      expect(Product.all).to include(product_a)
      expect(Product.all).not_to include(product_b)

      ActsAsTenant.current_tenant = tenant_b
      expect(Product.all).to include(product_b)
      expect(Product.all).not_to include(product_a)
    end
  end

  context 'Checkout and Ledger' do
    it 'allows a customer to checkout and logs a platform fee' do
      order_items = [{ product_id: product_a.id, quantity: 1 }]
      order = OrderCreationService.new(tenant_a, customer_a, order_items).call

      expect(order).not_to be_nil

      product_a.reload
      order.reload

      expect(product_a.stock).to eq(0)
      expect(order.order_items.first.product).to eq(product_a)

      ledger_entry = Ledger.last
      expect(ledger_entry.total_amount).to eq((order.total_cents * PLATFORM_FEE_PERCENTAGE).to_i)
    end
  end

  context 'Concurrency' do
    it 'prevents overselling when two customers try to buy the last item concurrently' do
      exceptions = []

      threads = 2.times.map do
        Thread.new do
          ActsAsTenant.current_tenant = tenant_a
          begin
            product_a.decrement_stock!(1)
          rescue => e
            exceptions << e.message
          end
        end
      end

      threads.each(&:join)
      product_a.reload

      expect(product_a.stock).to eq(0)
      expect(exceptions).to include('Not enough stock')
      expect(exceptions.size).to eq(1) # Only one customer fails
    end
  end

  context 'Authentication and Roles' do
    it 'authenticates users correctly and validates roles' do
      expect(customer_a.authenticate('password')).to eq(customer_a)
      expect(owner_a.authenticate('wrong')).to be_falsey

      expect(owner_a.owner?).to be true
      expect(customer_a.customer?).to be true
      expect(owner_a.customer?).to be false
    end
  end
end
