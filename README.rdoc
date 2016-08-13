== README

## Bedframe is simple a Warehouse Management System that routes shipments to the warehouse that can best fulfill it

The apps handles warehouses, shipments, and products.

* A shipment is a representation of a set of products that need to be shipped somewhere from a warehouse.
* A product has inventory.
* A warehouse has many shipments and warehouse products (with limited inventory) to ship
* When the warehouse meets the needs of the shipment, it fulfills the shipment and updates its warehouse product stock tally

In other words, I need to ship 2 queen mattresses to Steve in New York, do we have enough queens in our New Jersey warehouse to fulfill that shipment?

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
