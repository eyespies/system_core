source 'https://rubygems.org'

gem 'berkshelf', '~> 6.1'
gem 'chef', '~> 13.0'
gem 'inspec', '~> 1.51.0'

group :test do
  gem 'bundler', '~> 1.15.0'
  gem 'minitest', '~> 5.11.0'
  gem 'rake', '~> 12.3.0'
  gem 'simplecov', '~> 0.15.0'
end

group :rake do
  gem 'rake', '~> 12.3.0' # rubocop:disable Bundler/DuplicatedGem
  gem 'tomlrb', '~> 1.2.0'
end

group :lint do
  gem 'foodcritic', '~> 12.3.0'
  gem 'overcommit', '~> 0.43.0'
  gem 'rubocop', '~> 0.52.0'
end

group :unit do
  gem 'chefspec', '~> 7.1.0'
end

group :kitchen_common do
  gem 'test-kitchen', '~> 1.20.0'
end

group :kitchen_vagrant do
  gem 'kitchen-docker', '~> 2.6.0'
  gem 'kitchen-dokken', '~> 2.6.0'
  gem 'kitchen-vagrant', '~> 1.3.0'
end

group :development do
  gem 'growl', '~> 1.0.0'
  gem 'guard', '~> 2.14.0'
  gem 'guard-foodcritic', '~> 3.0.0'
  gem 'guard-kitchen', '~> 0.0.0'
  gem 'guard-rspec', '~> 4.7.0'
  gem 'guard-rubocop', '~> 1.3.0'
  gem 'rb-fsevent', '~> 0.10.0'
  gem 'ruby_gntp', '~> 0.3.0'
end

group :tools do
  gem 'github_changelog_generator', '~> 1.14'
end
