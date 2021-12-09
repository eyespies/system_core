#
# Cookbook Name:: system_core
# Recipe:: rbenv
#
# Copyright (C) 2016 - 2021 Justin Spies
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Required when installing rbenv.
package 'bzip2'

# Install rbenv itself; installation of a Ruby version does not do this automatically.
rbenv_system_install 'system'

# Install Ruby and core Gems
rbenv_ruby node['system_core']['ruby']['global']

# TODO: Use an attribute that is a hash of users to create multiple .gemrc files
cookbook_file '/root/.gemrc' do
  source 'gemrc'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

node['system_core']['ruby']['gems'].each do |gem|
  rbenv_gem gem do
    rbenv_version node['system_core']['ruby']['global']
  end
end
