class Warehouse < ActiveRecord::Base
  attr_accessor :has_inventory

  # scopes
  scope :ordered, -> { order(updated_at: :asc) }

  # relationships
  has_many :products, through: :warehouse_products
  has_many :warehouse_products, -> { ordered }, inverse_of:
           :warehouse, dependent: :destroy
  has_many :shipments

  validates :name, :address_1, :city, :region,
            :country, :postal_code, presence: true

  def inventory_for_product?(product_id)
    product = warehouse_products.where(product_id: product_id).first
    return product.available_inventory > 0 if product.present?
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
    wp_ids = warehouse_products.pluck(:product_id)
    sp_ids = shipment_products.map(&:product_id)
    product_id_to_update = (wp_ids & sp_ids)
    if product_id_to_update.any?
      product_id_to_update = product_id_to_update.first
    else
      return false
    end
    quantity = shipment_products.select do |sp|
      sp.product_id == product_id_to_update
    end.first.quantity

    warehouse_product = warehouse_products
                        .where(
                          product_id: product_id_to_update
                        ).first
    warehouse_product.decrement_available_inventory!(quantity)
  end

  class << self
    def with_available_inventory(shipment_products)
      # get list of warehouses that house these products
      # IRL could make sense to scope by shipment.address
      query = Warehouse.ordered.joins(:warehouse_products)
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
        wp_ids = query.warehouse_products.pluck(:product_id)
        warehouse_product_ids = Set.new(wp_ids)
        # map in memory product_ids
        shipment_product_ids = Set.new(shipment_products.map(&:product_id))
        # find intersection and validate
        (
          (warehouse_product_ids & shipment_product_ids) == shipment_product_ids
        ) && query
      end.first
      warehouse
    end
  end
end
