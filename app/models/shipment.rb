class Shipment < ActiveRecord::Base
  enum status: {
    processing: 0,
    fulfilled: 1,
    on_hold: 2
  }

  # callbacks
  before_validation :set_warehouse, on: :create

  # relationships
  belongs_to :warehouse

  has_many :shipment_products, inverse_of: :shipment, dependent: :destroy
  has_many :products, through: :shipment_products

  accepts_nested_attributes_for :shipment_products, allow_destroy: true

  # validations
  validates_associated :shipment_products

  validates :name, :warehouse, presence: true
  validates :warehouse, presence: true, if: proc { |shipment|
    %w(processing fulfilled).include?(shipment.status)
  }
  validate :at_least_one_product

  private

  def set_warehouse
    warehouse = Warehouse.with_available_inventory(shipment_products)
    if warehouse.present?
      self.warehouse = warehouse
    else
      self.status = :on_hold
    end
  end

  def fulfill!
    shipment_products.map do |sp|
      sp.product.update_available_inventory!(sp.quantity)
    end
    self.status = :fulfilled
    save
  end

  def at_least_one_product
    if shipment_products.blank?
      self.errors.add(:base, 'shipment is invalid without products')
    end
  end
end
