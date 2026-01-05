# frozen_string_literal: true

module Admin
  class TenantsController < ApplicationController
    before_action :require_login
    skip_before_action :set_tenant, only: %i[index]

    def index
        # Compute global metrics outside of tenant scoping
        ActsAsTenant.without_tenant do
          @total_revenue = Order.sum(:total_cents)
          @platform_fees = Ledger.sum(:total_amount)
        end

        @tenants = Tenant.all
    end

    def show
      @tenant = Tenant.find(params[:id])
    end

    def new
      @tenant = Tenant.new
    end

    def create
      @tenant = Tenant.new(tenant_params)

      if @tenant.save
        redirect_to admin_tenants_path, notice: 'Tenant created successfully.'
      else
        render :new
      end
    end

    private

    def tenant_params
      params.require(:tenant).permit(:name)
    end
  end
end
