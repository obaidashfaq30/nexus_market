class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] = "Logged in successfully"
      redirect_to dashboard_path_for(user)
    else
      flash.now[:alert] = "Invalid email or password"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "Logged out"
    redirect_to login_path
  end

  private

  def dashboard_path_for(user)
    case user.role
    when "admin"
      admin_dashboard_path
    when "owner", "customer"
      admin_tenant_path(user.tenant)
    end
  end
end
