require 'rails_helper'

RSpec.describe Shipment, type: :model do

  describe '#set_warehouse' do
    # Try writing some specs around assigning shipments to warehouses based on inventory,
    # so that a shipment that contains product X gets assigned to ship out of a warehouse
    # that has inventory of product X rather than another warehouse that does not have any X.
    it 'routes shipment to warehouse with sufficient stock' do
      product_a = create(:product, name: 'Product A', inventory: 5)
      product_b = create(:product, name: 'Product B', inventory: 10)
      product_c = create(:product, name: 'Product C', inventory: 3)

      warehouses = create_list(:warehouse, 3)
      warehouses[1..-1].each do |w|
        w.warehouse_products << [product_a, product_b]
      end
      warehouses.first.warehouse_products << product_c

      shipment_a = build(:shipment, shipment_products: product_a)
      shipment_b = build(:shipment, shipment_products: [product_b, product_c])
      shipment_c = build(:shipment, shipment_products: [product_a, product_b])
    end
  end
end
