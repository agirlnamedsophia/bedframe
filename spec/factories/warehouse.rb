FactoryGirl.define do
  factory :warehouse do
    transient do
      warehouse_inventory 2
    end

    name Faker::Name.title
    address_1 Faker::Address.street_address
    city Faker::Address.city
    region Faker::Address.state
    postal_code Faker::Address.postcode
    country Faker::Address.country

    after(:build) do |warehouse, evaluator|
      2.times do
        warehouse.warehouse_products << build(
          :warehouse_product,
          warehouse: warehouse,
          available_inventory: evaluator.warehouse_inventory
        )
      end
    end
  end
end
