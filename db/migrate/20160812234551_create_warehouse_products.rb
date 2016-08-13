class CreateWarehouseProducts < ActiveRecord::Migration
  def change
    create_table :warehouse_products do |t|
      t.references :product, index: true, foreign_key: true
      t.references :warehouse, index: true, foreign_key: true

      t.integer :available_inventory, default: 0, null: false

      t.timestamps null: false
    end
  end
end
