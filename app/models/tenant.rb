# frozen_string_literal: true

# == Schema Information
#
# Table name: tenants
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Tenant < ApplicationRecord
  # --------------------------------------------------------------------------------------------------------
  # ASSOCIATIONS
  # --------------------------------------------------------------------------------------------------------
  has_many :users, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :orders, dependent: :destroy

  # --------------------------------------------------------------------------------------------------------
  # SCOPES
  # --------------------------------------------------------------------------------------------------------
  scope :with_in_stock_products, -> {
    joins(:products)
      .merge(Product.in_stock)
      .distinct
  }

  # --------------------------------------------------------------------------------------------------------
  # VALIDATIONS
  # --------------------------------------------------------------------------------------------------------
  validates :name, presence: true, uniqueness: true
end
