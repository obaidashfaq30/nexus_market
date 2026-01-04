# frozen_string_literal: true

class SessionsController < ApplicationController
  def new; end

  def create
    user = find_user_by_email

    if user_authenticated?(user)
      log_in_user(user)
      redirect_to dashboard_path_for(user), notice: 'Logged in successfully'
    else
      flash.now[:alert] = 'Invalid email or password'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = 'Logged out'
    redirect_to login_path
  end

  private

  def find_user_by_email
    User.find_by(email: params[:email])
  end

  def user_authenticated?(user)
    user&.authenticate(params[:password])
  end

  def log_in_user(user)
    session[:user_id] = user.id
  end

  def dashboard_path_for(user)
    case user.role
    when 'admin'
      admin_tenants_path
    when 'owner'
      admin_tenant_path(user.tenant)
    when 'customer'
      
      binding.pry
      
      shops_path
    end
  end
end
