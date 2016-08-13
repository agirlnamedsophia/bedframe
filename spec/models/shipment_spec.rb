require 'rails_helper'

RSpec.describe Shipment, type: :model do

  def expect_valid_shipment(shipment, warehouse)
    expect(shipment.save).to eq true
    expect(shipment.warehouse).to eq warehouse
    if warehouse
      warehouse.warehouse_products.reload
    end
  end

  def build_warehouse_products(warehouse, products, inventory)
    products.each do |product|
      warehouse.warehouse_products << build(
        :warehouse_product,
        product: product,
        available_inventory: inventory
      )
    end
  end

  def build_shipment_products(shipment, products, quantity)
    products.each do |product|
      shipment.shipment_products << build(
        :shipment_product,
        shipment: shipment,
        product: product,
        quantity: quantity
      )
    end
  end

  describe '#set_warehouse' do
    let!(:product_a) { create(:product, name: 'Product A') }
    let!(:product_b) { create(:product, name: 'Product B') }
    let!(:product_c) { create(:product, name: 'Product C') }

    context 'when there are several shipments and warehouses' do
      it 'routes shipments to a warehouse that has sufficient stock for the shipment' do
        warehouse_a = create(:warehouse, name: 'Warehouse A')
        build_warehouse_products(warehouse_a, [product_a], 2)

        warehouse_b = create(:warehouse, name: 'Warehouse B')
        build_warehouse_products(warehouse_b, [product_b, product_c], 2)

        warehouse_c = create(:warehouse, name: 'Warehouse C')
        build_warehouse_products(warehouse_c, [product_a, product_c], 4)

        # 1) create a shipment and confirm warehouse is accurate
        shipment_a = build(:shipment, name: 'Shipment A', set_custom_products: true)
        build_shipment_products(shipment_a, [product_a], 1)
        expect_valid_shipment(shipment_a, warehouse_a)

        # 2) create another shipment but one that cannot be fulfilled
        shipment_b = build(:shipment, name: 'Shipment B', set_custom_products: true)
        build_shipment_products(shipment_b, [product_a, product_b, product_c], 2)

        # 3. second shipment is still valid, just on_hold
        expect_valid_shipment(shipment_b, nil)
        expect(shipment_b.status).to eq 'on_hold'

        # so we need to add the right product to the warehouse to satisfy constraints
        warehouse_c.warehouse_products << build(
          :warehouse_product,
          product: product_b,
          available_inventory: 2
        )
        warehouse_c.warehouse_products.reload

        shipment_b.send(:set_warehouse_and_update_warehouse_inventory!)
        expect_valid_shipment(shipment_b, warehouse_c)
        expect(shipment_b.status).to eq 'processing'

        shipment_c = build(:shipment, name: 'Shipment C', set_custom_products: true)
        build_shipment_products(shipment_c, [product_a, product_b], 1)

        expect_valid_shipment(shipment_c, warehouse_c)
      end
    end

    context 'when there is a warehouse without enough stock' do
      it 'sets shipment to :on_hold' do
        warehouse = create(:warehouse, name: 'Warehouse Without Enough Mattresses')
        build_warehouse_products(warehouse, [product_a], 1)

        mattresses = create_list(:product, 5)
        shipment = build(:shipment, name: 'Shipment For 5 Mattresses', set_custom_products: true)
        build_shipment_products(shipment, mattresses, 1)

        expect_valid_shipment(shipment, nil)
        expect(shipment.warehouse).to eq nil
        expect(shipment.status).to eq 'on_hold'
      end
    end
  end

  describe '#fulfill!' do
    context 'when on_hold' do
      it 'does not fulfill the shipment' do
        shipment = create(:shipment, :on_hold)
        expect(shipment.send(:fulfill!)).to eq false
      end
    end

    context 'when processing' do
      it 'fulfills the shipment' do
        shipment = build(:shipment)
        warehouse = shipment.warehouse
        build_shipment_products(shipment, warehouse.products, 1)
        expect_valid_shipment(shipment, warehouse)
        shipment.update_column(:status, Shipment.statuses[:processing])
        expect(shipment.send(:fulfill!)).to eq true
      end
    end
  end
end
