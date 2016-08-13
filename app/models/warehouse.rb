class Warehouse < ActiveRecord::Base
  attr_accessor :has_inventory

  # relationships
  has_many :products, through: :warehouse_products
  has_many :warehouse_products, -> { ordered }, inverse_of:
           :warehouse, dependent: :destroy
  has_many :shipments

  validates :name, :address_1, :city, :region,
            :country, :postal_code, presence: true

  def has_available_inventory(product_id)
    warehouse_products.where(
      'warehouse_products.product_id = ? AND '\
      'warehouse_products.available_inventory > ?',
      product_id, 0
    ).any?
  end

  def active_shipments
    shipments.processing
  end

  def fulfilled_shipments
    shipments.fulfilled
  end

  def fulfill_shipment!(shipment)
    # NOTE in real life this would be called either
    # through a controller action,
    # or a background job or even a separate
    # "Fulfillment" module whose only purpose is to
    # fulfill shipment
    shipment.fulfill!
  end

  def update_available_inventory!(shipment_products)
    warehouse_products.map do |wp|
      products = shipment_products.select do |product|
        product.product_id == wp.product_id
      end
      products.map { |sp| wp.decrement_available_inventory!(sp.quantity) }
    end
  end

  private

  class << self
    def with_available_inventory(shipment_products)
      # get list of warehouses that house these products
      # IRL could make sense to scope by shipment.address
      query = Warehouse.joins(:warehouse_products)
      clause = []
      clause_args = []

      shipment_products.each do |product|
        clause << '('\
                    'warehouse_products.product_id = ? AND '\
                    'warehouse_products.available_inventory >= ?'\
                  ')'
        clause_args << product.product_id
        clause_args << product.quantity
      end
      query_args = [clause.join(' OR '), *clause_args]

      query = query.where(*query_args).distinct

      warehouse = query.select do |query|
        # pluck product_ids from DB
        warehouse_product_ids = Set.new(query.warehouse_products.pluck(:product_id))
        # map in memory product_ids
        shipment_product_ids = Set.new(shipment_products.map(&:product_id))
        # find intersection and validate
        ((warehouse_product_ids & shipment_product_ids) == shipment_product_ids) && query
      end.first
      warehouse
    end
  end
end
