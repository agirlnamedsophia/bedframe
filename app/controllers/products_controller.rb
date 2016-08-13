class ProductsController < ApplicationController
  include Crud

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def product_params
    params.require(:product).permit(
      :id,
      :name,
      :status,
      :inventory,
      :sku,
      :price
    )
  end

  def klass
    Product
  end
  helper_method :klass
end
