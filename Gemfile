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

group :development do
  gem 'awesome_print', '~> 1.6.1'

  gem 'better_errors'
  gem 'binding_of_caller'

  gem 'rails_best_practices'

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
  gem 'thin', '1.6.4'
  gem 'byebug', platform: :mri
  gem 'rspec-rails'
  gem 'factory_girl_rails', '~> 4.0'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'test_after_commit', '~> 0.4.2'
end
