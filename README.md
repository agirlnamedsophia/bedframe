## Bedframe™ is a simple Warehouse Management System that routes shipments to the warehouse that can best fulfill it

The apps handles warehouses, shipments, and products.

* A shipment is a representation of a set of products that need to be shipped somewhere from a warehouse.
* A product has inventory.
* A warehouse has many shipments and warehouse products (with limited inventory) to ship
* When the warehouse meets the needs of the shipment, it fulfills the shipment and updates its warehouse product stock tally

* Ruby version
  - ruby 2.2.3

* System dependencies
  - postgres

* Configuration

* Database creation
  - rake db:setup

* Database initialization

* How to run the test suite
 - spring rspec spec

* Services (job queues, cache servers, search engines, etc.)
