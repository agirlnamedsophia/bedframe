require 'rails_helper'

RSpec.describe Warehouse, type: :model do
  describe '#update_available_inventory!' do
    context 'when there is a new shipment' do
      it 'decrements associated warehouse_product.available_inventory' do
      end
    end

    context 'when there is no new shipment' do
      it 'does not update warehouse_product.available_inventory' do
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
