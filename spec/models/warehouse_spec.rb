require 'rails_helper'

RSpec.describe Warehouse, type: :model do
  describe '#update_available_inventory!' do
    context 'when there is a new shipment' do
      it 'decrements associated warehouse_product.available_inventory' do
        warehouse = create(:warehouse)
        products = warehouse.warehouse_products
        inventory_orig = products.first.available_inventory

        expect(warehouse.has_available_inventory(products.first)).to eq true
        warehouse.shipments << create(:shipment, :with_products, product: products.first)
        expect(warehouse.has_available_inventory(products.first)).to eq false
        expect(products.first.available_inventory).to < inventory_orig
      end
    end
  end

  describe '#fulfill_shipment!' do
    let(:warehouse) { create(:warehouse) }
    let(:shipment) { build(:shipment, set_custom_products: true) }

    context 'when there is an active shipment passed in' do
      it 'sets shipment to fulfilled' do
      end
    end

    context 'when there is an inactive shipment pass in' do
      it 'does not modify the shipment' do
      end
    end
  end
end
