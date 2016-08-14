require 'rails_helper'

RSpec.describe WarehouseProduct, type: :model do
  describe '#decrement_available_inventory' do
    context 'when quantity purchased is passed in' do
      it 'decreases available_inventory until min 0' do
        warehouse_product = create(:warehouse_product)
        inventory_orig = warehouse_product.available_inventory
        shipment = build(:shipment, set_custom_products: true)
        shipment.shipment_products << build(
          :shipment_product,
          product: warehouse_product.product,
          quantity: 1
        )
        shipment.save!

        purchased_product = shipment.shipment_products.select do |sp|
                              sp.product_id == warehouse_product.product_id
                            end.first

        quantity = purchased_product.quantity
        diff = inventory_orig - quantity
        diff = diff > 0 ? diff : 0

        expect(warehouse_product.reload.available_inventory).to eq diff
      end
    end
  end
end
