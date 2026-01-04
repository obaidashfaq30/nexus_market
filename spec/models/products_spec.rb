require 'rails_helper'

RSpec.describe Product do
  it 'does not allow access across tenants' do
    tenant1 = create(:tenant)
    tenant2 = create(:tenant)

    ActsAsTenant.with_tenant(tenant1) do
      create(:product, name: "A")
    end

    ActsAsTenant.with_tenant(tenant2) do
      expect(Product.where(name: "A")).to be_empty
    end
  end
end
