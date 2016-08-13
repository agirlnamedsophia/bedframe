class Product < ActiveRecord::Base
  has_many :warehouse_products, inverse_of: :product, dependent: :destroy
  has_many :warehouses, through: :warehouse_products

  has_many :shipments_products, inverse_of: :product, dependent: :destroy
  has_many :shipments, through: :shipments_products

  validates :name, :sku, :price, presence: true
  validates :inventory,
    numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  private

  def update_available_inventory!(qty)
    updated_inventory = inventory -= qty
    if updated_inventory <= 0
      updated_inventory = 0
    end
    self.inventory = updated_inventory
    save!
  end
end
