class CreateShipments < ActiveRecord::Migration
  def change
    create_table :shipments do |t|
      t.string :name
      t.integer :status, default: 0, null: false
      t.datetime :fulfilled_at

      t.references :warehouse, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
