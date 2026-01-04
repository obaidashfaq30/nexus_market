class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  set_current_tenant_through_filter

  before_action :set_tenant

  private

  def set_tenant
    return unless params[:id]

    ActsAsTenant.current_tenant = Tenant.find(params[:id])
  end
end
