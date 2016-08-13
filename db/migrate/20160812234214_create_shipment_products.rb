class CreateShipmentProducts < ActiveRecord::Migration
  def change
    create_table :shipment_products do |t|
      t.references :product, index: true, foreign_key: true
      t.references :shipment, index: true, foreign_key: true

      t.integer :quantity, default: 0, null: false

      t.timestamps null: false
    end
  end
end
