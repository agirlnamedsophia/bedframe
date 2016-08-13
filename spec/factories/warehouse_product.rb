FactoryGirl.define do
  factory :warehouse_product do
    sequence(:available_inventory)

    association :product, strategy: :build
    association :warehouse, strategy: :build
  end
end
