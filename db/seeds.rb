# frozen_string_literal: true

Rails.logger.debug 'Seeding database...'

# Clean slate
OrderItem.delete_all
Order.delete_all
Product.delete_all
Tenant.delete_all

# --------------------------
# 2 empty tenants (no products)
# --------------------------
Tenant.create!(name: 'Empty Shop One')
Tenant.create!(name: 'Empty Shop Two')
Rails.logger.debug '✔ Created 2 empty tenants'

# --------------------------
# 2 e-commerce tenants with products
# --------------------------
shop1 = Tenant.create!(name: 'Alpha Apparel')
shop2 = Tenant.create!(name: 'Gadget World')

# Add products for shop1 (clothing vertical)
ActsAsTenant.with_tenant(shop1) do
  Product.create!(name: 'Basic T-Shirt', description: '100% Cotton', price: 19.99, stock: 50, tenant: shop1)
  Product.create!(name: 'Jeans', description: 'Slim Fit', price: 49.99, stock: 30, tenant: shop1)
  Product.create!(name: 'Hoodie', description: 'Warm and comfy', price: 39.99, stock: 20, tenant: shop1)
end

# Add products for shop2 (electronics vertical)
ActsAsTenant.with_tenant(shop2) do
  Product.create!(name: 'Wireless Earbuds', description: 'Bluetooth 5.0', price: 79.99, stock: 15, tenant: shop2)
  Product.create!(name: 'Smartwatch', description: 'Heart rate monitor', price: 129.99, stock: 10, tenant: shop2)
  Product.create!(name: 'USB-C Hub', description: '5-in-1 adapter', price: 29.99, stock: 25, tenant: shop2)
end

Rails.logger.debug 'Created 2 e-commerce tenants with products'
Rails.logger.debug 'Seeding complete!'

ActsAsTenant.with_tenant(shop1) do
  User.create!(name: 'Owner Alpha', email: 'owner_alpha@test.com', password: 'password', role: :owner, tenant: shop1)
  User.create!(name: 'Customer Alpha', email: 'customer_alpha@test.com', password: 'password', role: :customer,
               tenant: shop1)
end

platform = Tenant.create!(name: 'Platform')
User.create!(name: 'Nexus Markets Admin', email: 'admin@test.com', password: 'password', role: :admin, tenant: platform)
