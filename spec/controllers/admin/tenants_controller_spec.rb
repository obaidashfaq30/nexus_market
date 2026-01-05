require 'rails_helper'

RSpec.describe Admin::TenantsController, type: :controller do
  let!(:tenant_a) { create(:tenant) }
  let!(:tenant_b) { create(:tenant) }
  let!(:admin_user) { create(:user, :admin) }

  before do
    # authenticate
    session[:user_id] = admin_user.id
  end

  describe 'GET #index' do
    it 'returns global totals across tenants' do
      # Create orders and ledgers under different tenants
      ActsAsTenant.with_tenant(tenant_a) do
        user = create(:user, tenant: tenant_a)
        order = Order.create!(tenant: tenant_a, user: user, total_cents: 1000, status: :pending)
        Ledger.create!(order: order, total_amount: 50)
      end

      ActsAsTenant.with_tenant(tenant_b) do
        user = create(:user, tenant: tenant_b)
        order = Order.create!(tenant: tenant_b, user: user, total_cents: 2000, status: :pending)
        Ledger.create!(order: order, total_amount: 100)
      end

      get :index

      expect(controller.instance_variable_get(:@total_revenue)).to eq(3000)
      expect(controller.instance_variable_get(:@platform_fees)).to eq(150)
      expect(controller.instance_variable_get(:@tenants)).to include(tenant_a, tenant_b)
    end
  end
end
