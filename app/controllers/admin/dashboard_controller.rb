# frozen_string_literal: true

module Admin
  class DashboardController < ApplicationController
    skip_before_action :set_tenant

    def index
      @tenants = Tenant.all
      @total_revenue = Order.sum(:total_cents)
      @platform_fees = Ledger.sum(:total_amount)
    end
  end
end
