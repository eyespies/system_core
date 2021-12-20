# frozen_string_literal: true

source 'https://rubygems.org'

# After an upgrade in the ChefDK, Generated the current version of each Gem with this snippet:
#
# for g in $(grep "^\s*gem '" Gemfile  | awk '{print $2}' | awk -F\' '{print $2}' | sort -u)  ; do
#   gn=$(printf "$g" | awk '{print $1}')
#   gv=$(chef exec gem list | grep "^$g (" | sed 's/.*(\(default: \)*\([0-9]*\.[0-9]*\)\..*)/\2/g')
#   gem list | grep "^$g ("
#   echo $gn=$gv

#   sed -i.bak "s/^\( *\)gem '$gn'.*$/\1gem '$gn', '~> $gv.0'/g" Gemfile
# done

# NOTE: This requires bcrypt_pbkdf and a `chef exec bundle install` may result in the error
# `make: /usr/local/bin/gmkdir: No such file or directory` ... This is fixed by running
# `brew install coreutils`.

group :test do
  gem 'bundler', '~> 2.2.0'
  gem 'minitest', '~> 5.14.0'
end

group :rake do
  gem 'rake', '~> 13.0.0'
  gem 'tomlrb', '~> 1.3.0'
end

group :lint do
  gem 'cookstyle', '~> 7.25.0'
end

group :unit do
  gem 'berkshelf', '~> 7.2.0'
  gem 'chefspec', '~> 9.3.0'
  gem 'ffi-libarchive', '~> 1.1.0'
end

group :integration do
  gem 'inspec', '~> 4.49.0'
  gem 'kitchen-inspec', '~> 2.5.0'
end

group :kitchen_common do
  gem 'test-kitchen', '~> 3.1.0'
end

group :kitchen_cloud do
  gem 'kitchen-dokken', '~> 2.16.0'
  gem 'kitchen-ec2', '~> 3.11.0'
end

group :kitchen_vagrant do
  gem 'kitchen-vagrant', '~> 1.10.0'
end

group :development do
  gem 'guard', '~> 2.18.0'
  gem 'rb-fsevent', '~> 0.11.0'
end
