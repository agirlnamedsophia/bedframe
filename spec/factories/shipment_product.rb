FactoryGirl.define do
  factory :shipment_product do
    sequence(:quantity)

    association :product
    association :shipment
  end
end
