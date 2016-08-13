FactoryGirl.define do
  factory :warehouse_product do
    available_inventory 4

    association :product
    association :warehouse
  end
end
