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

  def set_tenant
    return unless params[:id]

    ActsAsTenant.current_tenant = Tenant.find(params[:id])
  end
end
