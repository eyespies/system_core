source 'https://rubygems.org'

gem 'inspec', path: '../../.'

group :test do
  gem 'bundler', '~> 1.5'
  gem 'foodcritic', '~> 5.0'
  gem 'minitest', '~> 5.5'
  gem 'overcommit'
  gem 'rake', '~> 10'
  gem 'rubocop', '~> 0.34.0'
  gem 'simplecov', '~> 0.10'
  gem 'tomlrb'
end

group :unit do
  gem 'berkshelf',  '~> 4.0'
  gem 'chefspec',   '~> 4.4'
end

group :kitchen_common do
  gem 'serverspec'
  gem 'test-kitchen', '~> 1.4'
end

group :kitchen_vagrant do
  gem 'kitchen-docker'
  gem 'kitchen-dokken'
  gem 'kitchen-vagrant', '~> 0.19'
end

group :development do
  gem 'growl'
  gem 'guard', '~> 2.4'
  gem 'guard-foodcritic'
  gem 'guard-kitchen'
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'rb-fsevent'
  gem 'ruby_gntp'
end
