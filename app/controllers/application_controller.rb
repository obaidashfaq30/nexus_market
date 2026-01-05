# frozen_string_literal: true

class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  helper_method :current_user
  set_current_tenant_through_filter

  before_action :set_tenant

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def require_login
    redirect_to login_path, alert: 'Please login first' unless current_user
  end

  def ensure_tenant_membership
    return if current_user.nil?

    # Allow platform admins to bypass tenant restrictions
    return if current_user.admin?

    unless ActsAsTenant.current_tenant && current_user.tenant_id == ActsAsTenant.current_tenant.id
      redirect_to admin_tenants_path, alert: 'You are not authorized to access this tenant.'
    end
  end

  def set_tenant
    return unless params[:id]

    ActsAsTenant.current_tenant = Tenant.find(params[:id])
  end
end
