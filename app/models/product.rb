# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id          :bigint           not null, primary key
#  description :text
#  name        :string           not null
#  price       :decimal(10, 2)   not null
#  stock       :integer          default(0), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  tenant_id   :bigint           not null
#
class Product < ApplicationRecord
  acts_as_tenant(:tenant)

  # --------------------------------------------------------------------------------------------------------
  # ASSOCIATIONS
  # --------------------------------------------------------------------------------------------------------
  belongs_to :tenant

  # --------------------------------------------------------------------------------------------------------
  # VALIDATIONS
  # --------------------------------------------------------------------------------------------------------
  validates :name, :price, presence: true
  validates :stock, numericality: { greater_than_or_equal_to: 0 }

  def decrement_stock!(quantity)
    with_lock do
      raise 'Not enough stock' if stock < quantity

      update!(stock: stock - quantity)
    end
  end
end
