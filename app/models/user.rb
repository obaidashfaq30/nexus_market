# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  name            :string           not null
#  password_digest :string           not null
#  role            :integer          default("owner")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  tenant_id       :bigint           not null
#
class User < ApplicationRecord
  acts_as_tenant(:tenant)
  has_secure_password

  # --------------------------------------------------------------------------------------------------------
  # ASSOCIATIONS
  # --------------------------------------------------------------------------------------------------------
  belongs_to :tenant

  # --------------------------------------------------------------------------------------------------------
  # ENUMS
  # --------------------------------------------------------------------------------------------------------
  enum role: ::USER_ROLES

  # --------------------------------------------------------------------------------------------------------
  # VALIDATIONS
  # --------------------------------------------------------------------------------------------------------
  validates :name, presence: true
  validates :email, presence: true, uniqueness: { scope: :tenant_id }, format: { with: URI::MailTo::EMAIL_REGEXP }
end
