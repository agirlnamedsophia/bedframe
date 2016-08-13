class ShipmentProduct < ActiveRecord::Base
  # relationships
  belongs_to :product, touch: true
  belongs_to :shipment, touch: true

  # validations
  validates :product, :shipment, presence: true
  validates :product, uniqueness: { scope: :shipment }

  delegate :name, to: :product, prefix: true
end
