require 'rails_helper'

RSpec.describe Shipment, type: :model do

  describe '#set_warehouse on create' do
    let(:product_a) { create(:product, name: 'Product A') }
    let(:product_b) { create(:product, name: 'Product B') }
    let(:product_c) { create(:product, name: 'Product C') }

    # Try writing some specs around assigning shipments to warehouses based on inventory,
    # so that a shipment that contains product X gets assigned to ship out of a warehouse
    # that has inventory of product X rather than another warehouse that does not have any X.
    it 'routes shipments to warehouse with sufficient stock' do
      warehouse_a = create(:warehouse, name: 'Warehouse A')
      warehouse_a.warehouse_products << build(
        :warehouse_product,
        product: product_a,
        available_inventory: 2
      )
      warehouse_b = create(:warehouse, name: 'Warehouse B')
      [product_b, product_c].each do |product|
        warehouse_b.warehouse_products << build(
          :warehouse_product,
          product: product,
          available_inventory: 2
        )
      end
      warehouse_c = create(:warehouse, name: 'Warehouse C')
      [product_a, product_c].each do |product|
        warehouse_c.warehouse_products << build(
          :warehouse_product,
          product: product_c,
          available_inventory: 4
        )
      end

      # 1) create a shipment and confirm warehouse is accurate
      shipment_a = build(:shipment, set_custom_products: true)
      shipment_a.shipment_products << create(
        :shipment_product,
        set_custom_products: true,
        shipment: shipment_a,
        product: product_a,
        quantity: 1
      )
      expect(shipment_a.save).to eq true
      debugger
      expect(shipment_a.warehouse).to eq warehouse_a

      # 2) create another shipment that cannot be fulfilled
      shipment_b = build(:shipment, set_custom_products: true)
      [product_a, product_b, product_c].each do |product|
        shipment_b.shipment_products << create(
          :shipment_product,
          set_custom_products: true,
          shipment: shipment_b,
          product: product,
          quantity: 2
        )
      end

      expect(shipment_b.save).to eq true

      # this should not be set because the warehouse doesn't have enough stock
      expect(shipment_b.warehouse).to eq nil
      expect(shipment_b.status).to eq Shipment.statuses[:procesing]

      warehouse_c.warehouse_products << build(
        :warehouse_product,
        product: product_b,
        available_inventory: 2
      )

      debugger
      expect(shipment_b.save).to eq true
      expect(shipment_b.warehouse).to eq warehouse_c

      shipment_c = build(:shipment, set_custom_products: true)
      [product_a, product_b].each do |product|
        shipment_c.shipment_product << create(
          :shipment_product,
          set_custom_products: true,
          product: product,
          shipment: shipment_c,
          quantity: 1
        )
      end
      expect(shipment_c.save).to eq true
      expect(shipment_c.warehouse).to eq warehouse_b
    end

    it 'sets shipment to :on_hold if no warehouse can satisfy the whole order' do
    end
  end
end
