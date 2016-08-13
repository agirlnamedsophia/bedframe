require 'factory_girl'
FactoryGirl.definition_file_paths = [
  File.join(Rails.root.to_s, 'spec', 'factories')
]

unless Rails.env.production?
  print "Creating Warehouses with Products "
  3.times do
    Product.create!(
      name: Faker::Commerce.product_name,
      sku: SecureRandom.hex(5),
      inventory: 10,
      price: Faker::Commerce.price,

    )
  end
  all_products = Product.all
  [
    {
      name: Faker::Name.title,
      address_1: Faker::Address.street_address,
      city: Faker::Address.city,
      region: 'NY',
      postal_code: Faker::Address.postcode,
      country: 'US',
    },
    {
      name: Faker::Name.title,
      address_1: Faker::Address.street_address,
      city: Faker::Address.city,
      region: 'NJ',
      postal_code: Faker::Address.postcode,
      country: 'United States'
    },
    {
      name: Faker::Name.title,
      address_1: Faker::Address.street_address,
      city: Faker::Address.city,
      region: 'VT',
      postal_code: Faker::Address.postcode,
      country: 'United States'
    }
  ].each_with_index do |method, idx|
    warehouse = Warehouse.create!(
      name: method[:name],
      address_1: method[:address_1],
      city: method[:city],
      region: method[:region],
      postal_code: method[:postal_code],
      country: method[:country]
    )
    all_products.each do |product|
      warehouse.warehouse_products << WarehouseProduct.new(
        product: product,
        available_inventory: product.inventory
      )
     end
  end

  # print "\n"

  print "Creating 3 shipments "
  3.times do |idx|
    shipment = Shipment.new(
      name: Faker::Company.name
    )
    if idx == 0
      all_products.take(5).each do |product|
        shipment.shipment_products << ShipmentProduct.new(
          product: product,
          quantity: 2
        )
      end
    else
      shipment.shipment_products << ShipmentProduct.new(
        product: all_products[idx],
        quantity: idx += 1
      )
    end
    shipment.save!
  end
end
