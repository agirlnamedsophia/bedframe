## Bedframe™ is a simple Warehouse Management System that routes shipments to the warehouse that can best fulfill it

The apps handles warehouses, shipments, and products.

* A warehouse has many shipments and warehouse products (with limited inventory) to ship,
  and it is the goal of this app to find the right warehouse for each shipment

* When the warehouse meets the needs of the shipment, it updates its warehouse_product available inventory
  (kind of like a stock tally) and can then fulfill the shipment

* Ruby version and gemset
  - ruby 2.2.3@bedframe

* System dependencies
  - postgres

* Database creation
  - `rake db:setup && rake db:reset`
  this will seed some phony data if you want to mess around in the console, 
  or you can just run the test suite

* Database initialization

* How to run the test suite
 - I develop with [ZEUS](https://github.com/burke/zeus) locally, so I just run "zeus test", but you can also
  run rspec spec

* Services
 - it would make sense to set up a cron job to fulfill! (ie: "ship") any shipments that are processing
 after a certain point, or to set up a controller action for the WMS to trigger when they're ready
