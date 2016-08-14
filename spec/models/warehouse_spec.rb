require 'rails_helper'

RSpec.describe Warehouse, type: :model do
  describe '#update_available_inventory!' do
    context 'when there is a new shipment' do

      it 'decrements associated warehouse_product.available_inventory' do
        warehouse = create(:warehouse)
        w_product = warehouse.warehouse_products.first
        inventory_orig = w_product.available_inventory
        expect(warehouse.inventory_for_product?(w_product.product_id)).to eq true

        shipment = build(:shipment, set_custom_products: true)
        shipment.shipment_products << build(:shipment_product,
          shipment: shipment,
          product: w_product.product,
          quantity: w_product.available_inventory
        )
        shipment.save!

        expect(w_product.reload.available_inventory).to be < inventory_orig
        expect(warehouse.inventory_for_product?(w_product.product_id)).to eq false
      end
    end
  end

  describe '#fulfill_shipment!' do
    let(:warehouse) { create(:warehouse) }
    let(:shipment) { build(:shipment, set_custom_products: true) }

    context 'when there is an active shipment passed in' do

      it 'sets shipment to fulfilled' do
        shipment.shipment_products << build(:shipment_product,
          shipment: shipment,
          product: warehouse.warehouse_products.first.product
        )
        shipment.save!
        expect(warehouse.fulfill_shipment!(shipment)).to eq true
        expect(shipment.status).to eq 'fulfilled'
      end
    end

    context 'when there is an inactive shipment pass in' do

      it 'does not modify the shipment' do
        shipment.shipment_products << build(:shipment_product,
          shipment: shipment,
          product: create(:product)
        )
        shipment.save!
        expect(warehouse.fulfill_shipment!(shipment)).to eq false
        expect(shipment.status).to eq 'on_hold'
      end
    end
  end
end
