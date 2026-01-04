# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :set_shop
  skip_before_action :set_tenant

  def new
    ActsAsTenant.with_tenant(@shop) do
      @products = Product.where('stock > 0')
      @order = Order.new
    end
  end

  def create
    ActsAsTenant.with_tenant(@shop) do
      @order = @shop.orders.build(user: current_user, total_cents: 0, status: :pending)

      # Build order items from params
      params[:order_items].each do |item_params|
        product = Product.lock.find(item_params[:product_id]) # Pessimistic lock
        quantity = item_params[:quantity].to_i

        if product.stock < quantity
          @order.errors.add(:base, "Not enough stock for #{product.name}")
          render :new, status: :unprocessable_entity and return
        end

        product.stock -= quantity
        product.save!

        @order.order_items.build(product: product, quantity: quantity, price: product.price)
        @order.total_cents += (product.price * quantity * 100).to_i
      end

      if @order.save
        # Platform fee 5%
        Ledger.create!(
          order: @order,
          total_amount: (@order.total_cents * 0.05).to_i
        )

        redirect_to shop_order_path(@shop, @order), notice: 'Order placed successfully!'
      else
        binding.pry
        render :new, status: :unprocessable_entity
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
