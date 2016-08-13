class Warehouse < ActiveRecord::Base
  attr_accessor :has_inventory

  scope :has_inventory, ->(shipment_product) {
    joins(:warehouse_products)
      .where(
        'warehouse_products.product_id = ? AND '\
        'warehouse_products.available_inventory >= ?',
        shipment_product.product_id, shipment_product.quantity
      )
  }
  scope :by_product, ->(product_ids) {
    joins(:warehouse_products).where(
      'warehouse_products.product_id IN(?)', product_ids
    )
  }

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
    # fulfill shipments
    shipment.fulfill!
  end

  private

  class << self

    def with_available_inventory(shipment_products)
      product_ids = shipment_products.map(&:product_id)

      # 1. get list of warehouses that house these products
      query = Warehouse.joins(:warehouse_products)
      clause = []
      clause_args = []

      clause << 'warehouse_products.product_id IN(?)'
      clause_args << product_ids

      shipment_products.each do |product|
        clause << 'warehouse_products.product_id = ? AND '\
                  'warehouse_products.available_inventory >= ?'
        clause_args << product.product_id
        clause_args << product.quantity
      end
      query_args = [clause.join(' OR '), *clause_args]

      query = query.where(*query_args).select do |query|
        query.warehouse_products.pluck(:id) & product_ids
      end.first
    end
  end
end
