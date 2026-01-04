# == Schema Information
#
# Table name: orders
#
#  id          :bigint           not null, primary key
#  status      :integer
#  total_cents :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  tenant_id   :bigint           not null
#
class Order < ApplicationRecord
  acts_as_tenant(:tenant)

  # --------------------------------------------------------------------------------------------------------
  # ASSOCIATIONS
  # --------------------------------------------------------------------------------------------------------
  belongs_to :tenant
  has_many :order_items, dependent: :destroy
  has_many :order_items, dependent: :destroy

  # --------------------------------------------------------------------------------------------------------
  # ENUMS
  # --------------------------------------------------------------------------------------------------------
  enum status: ::ORDER_STATUSES

  # --------------------------------------------------------------------------------------------------------
  # VALIDATIONS
  # --------------------------------------------------------------------------------------------------------
  validates :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
