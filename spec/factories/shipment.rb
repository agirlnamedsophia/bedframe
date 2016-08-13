FactoryGirl.define do
  factory :shipment do
    transient do
      set_custom_products false
    end

    name Faker::Commerce.product_name
    status Shipment.statuses[:processing]

    after(:build) do |shipment, evaluator|
      if evaluator.set_custom_products == false
        shipment.shipment_products << create(
          :shipment_product,
          shipment: shipment
        )
        shipment.warehouse = build(:warehouse)
      end
    end
  end
end
