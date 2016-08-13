class Product < ActiveRecord::Base
  has_many :warehouse_products, inverse_of: :product, dependent: :destroy
  has_many :warehouses, through: :warehouse_products

  has_many :shipments_products, inverse_of: :product, dependent: :destroy
  has_many :shipments, through: :shipments_products

  validates :name, :sku, :price, presence: true
end
