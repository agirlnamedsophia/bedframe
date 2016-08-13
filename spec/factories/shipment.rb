FactoryGirl.define do
  factory :shipment do
    name Faker::Commerce.product_name
    status Shipment.statuses[:active]

    association :warehouse

    after(:build) do |shipment|
      2.times do
        shipment.shipment_products << build(
          :shipment_product,
          shipment: shipment
        )
      end
    end

    trait :fulfilled do
      fulfilled_at DateTime.current
    end
  end
end
