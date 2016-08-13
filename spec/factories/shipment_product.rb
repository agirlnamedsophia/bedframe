FactoryGirl.define do
  factory :shipment_product do
    quantity 1

    association :product, strategy: :build
    association :shipment, strategy: :build
  end
end
