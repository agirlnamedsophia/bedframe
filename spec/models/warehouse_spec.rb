require 'rails_helper'

RSpec.describe Warehouse, type: :model do

  # Try writing some specs around assigning shipments to warehouses based on inventory, so that a shipment that contains product X gets assigned to ship out of a warehouse that has inventory of product X rather than another warehouse that does not have any X.

  # This application is really just about a set of things that need to get shipped somewhere.
  # You can focus on the idea of inventory and the question of whether a particular warehouse has enough of something to fulfill a particular shipment.

  # In other words, I need to ship 2 queen mattresses to Steve in New York, do we have enough queens in our New Jersey warehouse to fulfill that shipment?
  describe 'inventory tally' do
    it 'keeps a running tab of product inventory scoped to warehouse' do
    end

    it 'decrements warehouse_product available_inventory if shipment is fullfilled' do
    end
  end
end
