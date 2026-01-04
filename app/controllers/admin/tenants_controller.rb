class Admin::TenantsController < ApplicationController
  def index
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
      redirect_to admin_tenants_path, notice: "Tenant created successfully."
    else
      render :new
    end
  end

  private

  def tenant_params
    params.require(:tenant).permit(:name)
  end
end
