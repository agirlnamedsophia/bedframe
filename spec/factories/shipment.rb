FactoryGirl.define do
  factory :shipment do
    transient do
      set_custom_products false
    end

    name Faker::Commerce.product_name
    status Shipment.statuses[:processing]

    association :warehouse

    after(:build) do |shipment, evaluator|
      if evaluator.set_custom_products == false
        shipment.shipment_products << create(
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
