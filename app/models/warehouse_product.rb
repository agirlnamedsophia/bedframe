class WarehouseProduct < ActiveRecord::Base

  # scopes
  scope :ordered, -> { order(updated_at: :desc) }

  # callbacks
  before_validation :set_available_inventory

  # relationships
  belongs_to :product, inverse_of: :warehouse_products, touch: true
  belongs_to :warehouse, inverse_of: :warehouse_products

  # validations
  validates :product, :warehouse, :available_inventory, presence: true
  validates :product, uniqueness: { scope: :warehouse_id}

  private

  def set_available_inventory
    self.available_inventory = product.inventory
  end
end
