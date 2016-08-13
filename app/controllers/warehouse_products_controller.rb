class WarehouseProductsController < ApplicationController
  include Crud

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def warehouse_product_params
    params.require(:warehouse_product).permit(
      :id,
      :product_id,
      :warehouse_id,
      :available_inventory,
    )
  end

  def klass
    WarehouseProduct
  end
  helper_method :klass
end
