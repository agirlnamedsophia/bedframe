class Warehouse < ActiveRecord::Base
  attr_accessor :has_inventory

  # relationships
  has_many :products, through: :warehouse_products
  has_many :warehouse_products, -> { ordered }, inverse_of:
           :warehouse, dependent: :destroy
  has_many :shipments

  validates :name, :address_1, :city, :region,
            :country, :postal_code, presence: true

  def fulfill_shipment!(shipment)
    # NOTE this would in real life be called either
    # through a controller action,
    # or a background job or even a separate
    # "Fulfillment" module whose only purpose is to

    # fulfill shipment
    shipment.fulfill!
  end

  def update_available_inventory!(product_h)
    warehouse_products.map do |wp|
      product_h.select do |p|
        p[:id] == wp.product_id &&
        wp.decrement_available_inventory!(p[:quantity])
      end
    end
  end

  private

  class << self
    def with_available_inventory(shipment_products)
      # 1. get list of warehouses that house these products
      query = Warehouse.joins(:warehouse_products)
      clause = []
      clause_args = []

      shipment_products.each do |product|
        clause << 'warehouse_products.product_id = ? AND '\
                  'warehouse_products.available_inventory >= ?'
        clause_args << product.product_id
        clause_args << product.quantity
      end
      query_args = [clause.join(' OR '), *clause_args]

      query = query.where(*query_args).distinct

      query.select do |query|
        warehouse_product_ids = Set.new(query.warehouse_products.pluck(:product_id))
        shipment_product_ids = Set.new(shipment_products.map(&:product_id))
        (warehouse_product_ids & shipment_product_ids) == shipment_product_ids && query
      end.first
    end
  end
end
