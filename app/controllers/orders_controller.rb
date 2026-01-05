# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :set_shop
  skip_before_action :set_tenant

  def new
    ActsAsTenant.with_tenant(@shop) do
      @products = Product.in_stock
      @order = Order.new
    end
  end

  def create
    ActsAsTenant.with_tenant(@shop) do
      order_creation_service = ::OrderCreationService.new(@shop, current_user, params[:order_items])
      begin
        @order = order_creation_service.call

        if @order.present?
          redirect_to shop_order_path(@shop, @order), notice: 'Order placed successfully!'
        else
          # Re-render the shop product listing so users can adjust quantities
          @products = Product.in_stock
          @order = Order.new
          render 'shops/show', status: :unprocessable_entity
        end
      rescue InsufficientStockError => e
        flash.now[:alert] = e.message
        @products = Product.in_stock
        @order = Order.new
        render 'shops/show', status: :unprocessable_entity
      end
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  private

  def set_shop
    @shop = Tenant.find(params[:shop_tenant_id])
  end
end
