# frozen_string_literal: true

module Admin
  class ProductsController < ApplicationController
    before_action :require_login
    before_action :set_tenant
    before_action :set_product, only: %i[edit show destroy update]
    before_action :ensure_tenant_membership

    def index
      @products = Product.all
    end

    def show; end

    def new
      @product = Product.new
    end

    def edit; end

    def create
      @product = Product.new(product_params)

      if @product.save
        redirect_to admin_tenant_products_path(ActsAsTenant.current_tenant), notice: 'Product created successfully.'
      else
        render :new
      end
    end

    def update
      if @product.update(product_params)
        redirect_to admin_tenant_products_path(ActsAsTenant.current_tenant), notice: 'Product updated successfully.'
      else
        render :edit
      end
    end

    def destroy
      @product.destroy
      redirect_to admin_tenant_products_path(ActsAsTenant.current_tenant), notice: 'Product deleted successfully.'
    end

    private

    def set_product
      @product = Product.find(params[:id])
    end

    def set_tenant
      ActsAsTenant.current_tenant = Tenant.find(params[:tenant_id])
    end

    def product_params
      params.require(:product).permit(:name, :price, :stock, :description)
    end
  end
end
