# frozen_string_literal: true

class OrderCreationService
  def initialize(shop, user, order_items)
    @shop = shop
    @user = user
    @order_items = order_items
    @order = build_order
  end

  def call
    ActiveRecord::Base.transaction do
      # Process the order items with locking
      process_order_items

      # Save the order
      @order.save!

      # Create ledger entry
      create_ledger

      # Return the successfully created order
      @order
    rescue ActiveRecord::RecordInvalid => e
      # Transaction will automatically rollback on exceptions
      Rails.logger.error("Order creation failed: #{e.message}")
      nil
    end
  end

  private

  def process_order_items
    @order_items.each do |item_params|
      # Pessimistic lock ensures no overselling
      product = Product.lock.find(item_params[:product_id])
      quantity = item_params[:quantity].to_i

      # Decrement stock (will raise if insufficient)
      product.decrement_stock!(quantity)

      # Build order item
      @order.order_items.build(product: product, quantity: quantity, price: product.price)

      # Increment total
      @order.total_cents += (product.price * quantity * 100).to_i
    end
  end

  def create_ledger
    Ledger.create!(
      order: @order,
      total_amount: (@order.total_cents * PLATFORM_FEE_PERCENTAGE).to_i
    )
  end

  def build_order
    @shop.orders.build(user: @user, total_cents: 0, status: :pending)
  end
end
