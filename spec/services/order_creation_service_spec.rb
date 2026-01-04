# frozen_string_literal: true

RSpec.describe OrderCreationService, type: :service do
  let!(:shop) { create(:tenant) }
  let!(:user) { create(:user, tenant: shop) }
  let!(:product) { create(:product, tenant: shop, stock: 10, price: 100) }

  let(:order_items) do
    [{ product_id: product.id, quantity: 2 }]
  end

  subject { described_class.new(shop, user, order_items) }

  describe '#call' do
    it 'creates an order and decrements product stock' do
      expect { subject.call }.to change { shop.orders.count }.by(1)
      expect(product.reload.stock).to eq(8) # Stock should be reduced by 2
    end

    it 'creates a ledger entry' do
      subject.call
      expect(Ledger.count).to eq(1)
    end

    it 'returns the created order' do
      order = subject.call
      expect(order).to be_persisted
      expect(order.status).to eq('pending')
    end
  end
end
