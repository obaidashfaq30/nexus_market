# frozen_string_literal: true

class ShopsController < ApplicationController
  def index
    @shops = Tenant.all
  end

  def show
    @shop = Tenant.find(params[:tenant_id])
    ActsAsTenant.with_tenant(@shop) do
      @products = Product.all
    end
  end
end
