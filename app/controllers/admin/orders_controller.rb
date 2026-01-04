# frozen_string_literal: true

module Admin
  class OrdersController < ApplicationController
    before_action :set_tenant

    def index
      @orders = Order.all
    end

    def show
      @order = Order.find(params[:id])
    end

    private

    def set_tenant
      ActsAsTenant.current_tenant = Tenant.find(params[:tenant_id])
    end
  end
end
