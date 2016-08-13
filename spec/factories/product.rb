FactoryGirl.define do
  factory :product do
    name Faker::Commerce.product_name
    sku SecureRandom.hex(5)
    sequence(:inventory)
    price Faker::Commerce.price
  end
end
