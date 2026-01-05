# frozen_string_literal: true

class ShopsController < ApplicationController
  def index
    @shops = Tenant.with_in_stock_products.includes(:products)
  end

  def show
    @shop = Tenant.find(params[:tenant_id])
    ActsAsTenant.with_tenant(@shop) do
      @products = Product.in_stock
    end
  end
end
