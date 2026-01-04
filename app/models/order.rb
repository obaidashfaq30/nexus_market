# frozen_string_literal: true

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
#  user_id     :bigint           not null
#
class Order < ApplicationRecord
  acts_as_tenant(:tenant)

  # --------------------------------------------------------------------------------------------------------
  # ASSOCIATIONS
  # --------------------------------------------------------------------------------------------------------
  belongs_to :tenant
  has_many :order_items, dependent: :destroy
  belongs_to :user

  # --------------------------------------------------------------------------------------------------------
  # SCOPES
  # --------------------------------------------------------------------------------------------------------
  scope :pending, -> { where(status: :pending) }
  scope :completed, -> { where(status: :completed) }
  scope :recent, -> { where('created_at > ?', 30.days.ago) }

  # --------------------------------------------------------------------------------------------------------
  # ENUMS
  # --------------------------------------------------------------------------------------------------------
  enum :status, ORDER_STATUSES

  # --------------------------------------------------------------------------------------------------------
  # VALIDATIONS
  # --------------------------------------------------------------------------------------------------------
  validates :total_cents, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
