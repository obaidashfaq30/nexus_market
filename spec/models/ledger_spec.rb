require 'rails_helper'

RSpec.describe Ledger, type: :model do
  it 'is globally visible and not tenant-scoped' do
    t1 = create(:tenant)
    t2 = create(:tenant)

    ActsAsTenant.with_tenant(t1) do
      user = create(:user, tenant: t1)
      order = Order.create!(tenant: t1, user: user, total_cents: 1000, status: :pending)
      Ledger.create!(order: order, total_amount: 50)
    end

    ActsAsTenant.with_tenant(t2) do
      user = create(:user, tenant: t2)
      order = Order.create!(tenant: t2, user: user, total_cents: 2000, status: :pending)
      Ledger.create!(order: order, total_amount: 100)
    end

    ActsAsTenant.current_tenant = t1
    expect(Ledger.count).to eq(2)
  end
end
