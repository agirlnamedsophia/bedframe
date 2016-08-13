require 'rails_helper'

RSpec.describe Warehouse, type: :model do
  describe 'inventory tally' do
    let(:warehouse) { create(:warehouse) }
    let(:shipment) { build(:shipment, set_custom_products: true) }

    it 'keeps a running tab of product inventory scoped to warehouse_product' do
    end

    it 'decrements warehouse_product#available_inventory if shipment is fullfilled' do
    end

    it 'does nothing to warehouse_product#available_inventory of total shipment cannot be fulfilled' do
    end
  end
end
