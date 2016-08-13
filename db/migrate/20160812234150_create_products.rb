class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.integer :inventory, default: 0, null: false
      t.string :sku
      t.integer :price

      t.timestamps null: false
    end
  end
end
