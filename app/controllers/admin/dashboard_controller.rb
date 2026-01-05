# frozen_string_literal: true

module Admin
  class DashboardController < ApplicationController
    skip_before_action :set_tenant
    before_action :require_login

    def index
      @tenants = Tenant.all
      ActsAsTenant.without_tenant do
        @total_revenue = Order.sum(:total_cents)
        @platform_fees = Ledger.sum(:total_amount)
      end
    end
  end
end
