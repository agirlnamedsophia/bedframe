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
      warehouse_products: { product: product_ids }
    ).distinct
  }

  # relationships
  has_many :products, through: :warehouse_products
  has_many :warehouse_products

  has_many :shipments

  validates :name, :address_1, :city, :region,
            :country, :postal_code, presence: true

  def fulfill_shipment!(shipment)
    # NOTE this would be called either through a controller action,
    # or a background job
    shipment.fulfill!
  end

  private

  class << self
    def with_available_inventory(shipment_products)
      product_ids = shipment_products.map(&:product_id)

      query = Warehouse.by_product(product_ids)
      shipment_products.each do |product|
        query = query.has_inventory(product)
      end
      query && query.first
    end
  end
end
