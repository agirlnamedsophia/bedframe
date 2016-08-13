class Shipment < ActiveRecord::Base
  enum status: {
    processing: 0,
    fulfilled: 1,
    on_hold: 2
  }

  # callbacks
  before_validation :set_warehouse_and_update_warehouse_inventory!, on: :create

  # relationships
  belongs_to :warehouse

  has_many :shipment_products, inverse_of: :shipment, dependent: :destroy
  has_many :products, through: :shipment_products

  accepts_nested_attributes_for :shipment_products, allow_destroy: true

  # validations
  validates_associated :shipment_products

  validates :name, presence: true
  validates :warehouse, presence: true, if: proc { |shipment|
    %w(processing fulfilled).include?(shipment.status)
  }
  validate :at_least_one_product

  private

  def set_warehouse_and_update_warehouse_inventory!
    return unless shipment_products.present?
    products_to_ship = shipment_products
    warehouse = Warehouse.with_available_inventory(products_to_ship)

    if warehouse.present?
      self.warehouse = warehouse
      set_to_processing!
      warehouse.update_available_inventory!(products_to_ship)
    else
      self.status = :on_hold
    end
  end

  def set_to_processing!
    if on_hold?
      self.status = :processing
    end
  end

  def fulfill!
    return false if on_hold?
    self.status = :fulfilled
    save
  end

  def at_least_one_product
    if shipment_products.blank?
      self.errors.add(:base, 'shipment is invalid without products')
    end
  end
end
