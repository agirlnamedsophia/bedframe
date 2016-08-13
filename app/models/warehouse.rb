class Warehouse < ActiveRecord::Base
  # A warehouse has_many shipments (need to ship) and has_many fullfillments
  #   (has_shipped) and has_many warehouse_products
  # A warehouse needs to keep a tally on inventory
  # A warehouse is a facility that can store products and maintain a list of
  #   shipments that it will be responsible for fulfilling
  attr_accessor :has_inventory

  scope :has_inventory, -> shipment_product {
    joins(:warehouse_products).where('warehouse_products.product_id = ? '\
      'AND warehouse_products.available_inventory >= ?',
      shipment_product.id, shipment_product.quantity
    )
  }
  validates :name, :address_1, :city, :region,
            :country, :postal_code, presence: true

  # relationships
  has_many :products, through: :warehouse_products
  has_many :warehouse_products

  has_many :shipments

  private

  def fulfill_shipment!(shipment)
    shipment.mark_as_fulfilled!
  end

  class << self
    def with_available_inventory(shipment_products)
      product_ids = shipment_products.map(&:product_id)

      # 1. for each shipment product there is one warehouse product
      warehouses = joins(:warehouse_products)
                    .where(warehouse_products: { product: product_ids } )
                    .distinct

      # 2. find the warehouse that has enough of the shipment_products
      warehouses.select do |warehouse|
        warehouse_products = warehouse.warehouse_products
        return false if warehouse_products.length < shipment_products.length

        shippable_products = shipment_products.select do |shipment_product|
          product_id = shipment_product.product_id
          insufficient_inventory = proc do |wp|
                                     wp.product.id == product_id &&
                                     wp.available_inventory < shipment_product.quantity
                                   end
          warehouse_products.to_a.delete_if(&insufficient_inventory)
          warehouse_products && warehouse_products.pluck(:product_id).include?(product_id)
        end

        if shippable_products.any? && shippable_products.length == shipment_products.length
          return warehouse
        end
      end
    end
  end
end
