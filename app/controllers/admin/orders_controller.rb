# frozen_string_literal: true

module Admin
  class OrdersController < ApplicationController
    before_action :require_login
    before_action :set_tenant

    def index
      @orders = Order.includes(:user).order(created_at: :desc)
    end

    def show
      @order = Order.find(params[:id])
      @platform_fee = Ledger.find_by(order: @order)&.total_amount || 0
    end

    private

    def set_tenant
      ActsAsTenant.current_tenant = Tenant.find(params[:tenant_id])
    end
  end
end
