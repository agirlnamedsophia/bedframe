FactoryGirl.define do
  factory :shipment do
    transient do
      set_custom_products false
    end

    name Faker::Commerce.product_name
    status Shipment.statuses[:active]

    association :warehouse

    after(:build) do |shipment, evaluator|
      if set_custom_products == false
        2.times do
          shipment.products << build(
            :product
          )
        end
      end
    end

    trait :with_products do
      after(:build) do |shipment, evaluator|
        if set_custom_products == true
          debugger
          shipment.products << evaluator.products
        end
      end
    end

    trait :fulfilled do
      fulfilled_at DateTime.current
    end
  end
end
