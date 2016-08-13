require 'rails_helper'

RSpec.describe WarehouseProduct, type: :model do
  describe '#decrement_available_inventory' do
    context 'when quantity purchased is passed in' do
      it 'decreases available_inventory until min 0' do
        warehouse_product = create(:warehouse_product)
        inventory_orig = warehouse_product.available_inventory
        shipment = build(:shipment, set_custom_products: true)
        shipment.shipment_products << create(:shipment_product,
          product: warehouse_product.product
        )

        quantity = shipment.shipment_products
                           .where(product_id: warehouse_product.id)
                           .pluck(:quantity).reduce(:+)
        expect(warehouse_product.reload.available_inventory).to eq inventory_orig - quantity
      end
    end
  end
end
