#
# Cookbook Name:: system_core
# Recipe:: chrony
#
# Copyright (C) 2020 Justin Spies
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

include_recipe "chrony::#{node['system_core']['chrony']['type']}"

# TODO: Make the new timezone an attribute
execute 'configure_timezone' do
  command "rm /etc/localtime && ln -s /usr/share/zoneinfo/#{node['system_core']['ntp']['timezone']} /etc/localtime"
  not_if "[ `readlink /etc/localtime` == \"/usr/share/zoneinfo/#{node['system_core']['ntp']['timezone']}\" ]"
end
