#
# Cookbook:: system_core
# Recipe:: ssh
#
# Copyright:: (C) 2016 - 2021 Justin Spies
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
package 'sudo'

sudo 'global_sudo' do
  defaults               node['system_core']['sudo']['sudoers_defaults']
  groups                 node['system_core']['sudo']['groups']
  nopasswd               node['system_core']['sudo']['passwordless']
end
