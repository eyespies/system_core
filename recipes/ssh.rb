#
# Cookbook Name:: system_core
# Recipe:: ssh
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
include_recipe 'openssh'
include_recipe 'sudo'

template '/etc/ssh/banner' do
  source node['system_core']['ssh']['banner']['source_file']
  cookbook node['system_core']['ssh']['banner']['source_cookbook'] if node['system_core']['ssh']['banner'].attribute?('source_cookbook')
  owner 'root'
  group 'root'
  mode '0664'
  variables(
    # TODO: Replace this with the Chef environment value
    environment: node.attribute['environment']
  )
end
