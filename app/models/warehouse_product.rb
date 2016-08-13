class WarehouseProduct < ActiveRecord::Base
  # callbacks
  before_validation :set_available_inventory

  # relationships
  belongs_to :product, touch: true
  belongs_to :warehouse, touch: true

  # validations
  validates :product, :warehouse, :available_inventory, presence: true
  validates :product, uniqueness: { scope: :warehouse_id}

  private

  def set_available_inventory
    self.available_inventory = product.inventory
  end
end
