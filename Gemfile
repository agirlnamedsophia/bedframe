source 'https://rubygems.org'

ruby '2.2.3'

gem 'rails', '4.2.7'

# db
gem 'pg'

# assets
gem 'therubyracer'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'jbuilder', '~> 2.5'

group :development do
  gem 'stackprof'
  gem 'rack-mini-profiler', require: false

  gem 'awesome_print', '~> 1.6.1'

  gem 'better_errors'
  gem 'binding_of_caller'

  gem 'flamegraph'
  gem 'bullet'

  gem 'brakeman', '~> 3.2.1', require: false

  gem 'oink'
  gem 'rails-erd'
  gem 'delayed_job_active_record'
  gem 'rails_best_practices'

    # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :production do
  gem 'puma'
end

# tests
group :test, :development do
  gem 'faker'
  gem 'rubocop'
  gem 'rubocop-rspec'
  gem 'thin', '1.6.4'
  gem 'byebug', platform: :mri
  gem 'rspec-rails'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'stripe-ruby-mock', '2.0.0'
end

group :test do
  gem 'capybara'
  gem 'climate_control'
  gem 'launchy'
  gem 'selenium-webdriver'
  gem 'database_cleaner'
  gem 'test_after_commit', '~> 0.4.2'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
