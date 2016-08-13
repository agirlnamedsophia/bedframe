require 'rails_helper'

RSpec.describe Shipment, type: :model do

  describe '#set_warehouse on create' do
    let(:product_a) { create(:product, name: 'Product A') }
    let(:product_b) { create(:product, name: 'Product B') }
    let(:product_c) { create(:product, name: 'Product C') }

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
          product: product,
          available_inventory: 4
        )
      end

      # 1) create a shipment and confirm warehouse is accurate
      shipment_a = build(:shipment, name: 'Shipment A', set_custom_products: true)
      shipment_a.shipment_products << build(
        :shipment_product,
        shipment: shipment_a,
        product: product_a,
        quantity: 1
      )
      expect(shipment_a.save).to eq true
      expect(shipment_a.warehouse).to eq warehouse_a

      warehouse_a.warehouse_products.reload

      # 2) create another shipment that cannot be fulfilled
      shipment_b = build(:shipment, name: 'Shipment B', set_custom_products: true)
      [product_a, product_b, product_c].each do |product|
        shipment_b.shipment_products << build(
          :shipment_product,
          shipment: shipment_b,
          product: product,
          quantity: 2
        )
      end
      expect(shipment_b.save).to eq true

      # this should not be nil because no warehouse can satisfy this shipment
      expect(shipment_b.warehouse).to eq nil
      warehouse_b.warehouse_products.reload
      expect(shipment_b.status).to eq 'on_hold'

      warehouse_c.warehouse_products << build(
        :warehouse_product,
        product: product_b,
        available_inventory: 2
      )
      warehouse_c.warehouse_products.reload

      shipment_b.send(:set_warehouse!)
      expect(shipment_b.warehouse).to eq warehouse_c
      expect(shipment_b.status).to eq 'processing'

      warehouse_c.warehouse_products.reload

      shipment_c = build(:shipment, name: 'Shipment C', set_custom_products: true)
      [product_a, product_b].each do |product|
        shipment_c.shipment_products << build(
          :shipment_product,
          product: product,
          shipment: shipment_c,
          quantity: 1
        )
      end

      warehouse_b.warehouse_products.reload

      expect(shipment_c.save).to eq true
      expect(shipment_c.warehouse).to eq warehouse_c
    end

    it 'sets shipment to :on_hold if no warehouse can satisfy the whole order' do
    end
  end
end
