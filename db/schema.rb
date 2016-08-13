# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160812234551) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string   "nickname"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "region"
    t.string   "postal_code"
    t.string   "country"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.integer  "inventory",  default: 0, null: false
    t.string   "sku"
    t.integer  "price"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "shipment_products", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "shipment_id"
    t.integer  "quantity",    default: 0, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "shipment_products", ["product_id"], name: "index_shipment_products_on_product_id", using: :btree
  add_index "shipment_products", ["shipment_id"], name: "index_shipment_products_on_shipment_id", using: :btree

  create_table "shipments", force: :cascade do |t|
    t.string   "name"
    t.integer  "status",       default: 0, null: false
    t.datetime "fulfilled_at"
    t.integer  "warehouse_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "shipments", ["warehouse_id"], name: "index_shipments_on_warehouse_id", using: :btree

  create_table "warehouse_products", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "warehouse_id"
    t.integer  "available_inventory", default: 0, null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "warehouse_products", ["product_id"], name: "index_warehouse_products_on_product_id", using: :btree
  add_index "warehouse_products", ["warehouse_id"], name: "index_warehouse_products_on_warehouse_id", using: :btree

  create_table "warehouses", force: :cascade do |t|
    t.string   "name"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "region"
    t.string   "postal_code"
    t.string   "country"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_foreign_key "shipment_products", "products"
  add_foreign_key "shipment_products", "shipments"
  add_foreign_key "shipments", "warehouses"
  add_foreign_key "warehouse_products", "products"
  add_foreign_key "warehouse_products", "warehouses"
end
