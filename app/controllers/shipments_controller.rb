class ShipmentsController < ApplicationController
  include Crud

  private

  def shipment_params
    params.require(:shipment).permit(
      :id,
      :name,
      :warehouse_id,
      shipment_products_attributes: [
        :id,
        :product_id,
        :quantity
      ]
    )
  end

  def klass
    Shipment
  end
  helper_method :klass
end
