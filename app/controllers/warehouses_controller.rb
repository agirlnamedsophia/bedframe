class WarehousesController < ApplicationController
  include Crud

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def warehouse_params
    params.require(:warehouse).permit(
      :id,
      :name,
      :address_1,
      :address_2,
      :city,
      :region,
      :postal_code,
      :country
    )
  end

  def klass
    Warehouse
  end
  helper_method :klass
end
