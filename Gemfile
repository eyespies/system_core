source 'https://rubygems.org'

gem 'berkshelf', '~> 7.0'
gem 'chef', '~> 14.0'
gem 'inspec', '~> 3.9'

group :test do
  gem 'bundler', '>= 1.17.0'
  gem 'minitest', '~> 5.11.0'
  gem 'rake', '~> 12.3.0'
  gem 'simplecov', '~> 0.15.0'
end

group :rake do
  gem 'rake', '~> 12.3.0' # rubocop:disable Bundler/DuplicatedGem
  gem 'tomlrb', '~> 1.2.0'
end

group :lint do
  gem 'foodcritic', '~> 15.1.0'
  gem 'overcommit', '~> 0.43.0'
  gem 'rubocop', '~> 0.55.0'
end

group :unit do
  gem 'chefspec', '~> 7.3.0'
end

group :kitchen_common do
  gem 'test-kitchen', '~> 1.24.0'
end

group :kitchen_vagrant do
  gem 'kitchen-docker', '~> 2.6.0'
  gem 'kitchen-dokken', '~> 2.6.0'
  gem 'kitchen-ec2', '~> 2.5.0'
  gem 'kitchen-vagrant', '~> 1.5.0'
end

group :development do
  gem 'growl', '~> 1.0.0'
  gem 'guard', '~> 2.15.0'
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
