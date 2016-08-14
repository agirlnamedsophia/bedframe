class WarehouseProduct < ActiveRecord::Base
  # scopes
  scope :ordered, -> { order(updated_at: :desc) }

  # relationships
  belongs_to :product, inverse_of: :warehouse_products
  belongs_to :warehouse, inverse_of: :warehouse_products, touch: true

  # validations
  validates :product, :warehouse, :available_inventory, presence: true
  validates :product, uniqueness: { scope: :warehouse }
  validates :available_inventory, numericality: {
    only_integer: true, greater_than_or_equal_to: 0
  }

  def decrement_available_inventory!(qty)
    inventory = available_inventory - qty
    # inventory can never be less than 0
    inventory = inventory < 0 ? 0 : inventory
    self.available_inventory = inventory
    save
  end
end
