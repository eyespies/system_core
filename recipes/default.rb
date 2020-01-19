#
# Cookbook Name:: system_core
# Recipe:: default
#
# Copyright (C) 2016 - 2017 Justin Spies
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

# If the node name already has the domain component included, then use the node name itself; otherwise
# use the domain.

# NOTE: This appends the domain name if the specified domain name is not part of the hostname, even if the hostname
# already includes a domain name. e.g. if node['system_core']['domain'] is 'example.com' and the node_name is
# 'host.mydomain.org', set_fqdn will be set to 'host.mydomain.org.example.com'
# If the node_name contains a period do not append the node['system_core']['domain'] value.
node.normal['set_fqdn'] = if Chef::Config[:node_name] =~ /#{node['system_core']['domain']}$/i ||
                             Chef::Config[:node_name] =~ /.*\..*/
                            Chef::Config[:node_name]
                          else
                            "*.#{node['system_core']['domain']}"
                          end

# The default is 127.0.1.1, which is used under Debian, not RHEL based systems.
node.normal['hostname_cookbook']['hostsfile_ip'] = '127.0.0.1' if node['platform_family'] == 'rhel'

# Without this line, the 'hostname' cookbook sets:
#  -127.0.0.1 full-oracle-73.linux.example.com full-oracle-73
#  +127.0.0.1 full-oracle-73.linux.example.com full-oracle-73 localhost
#
# but then a moment letter sets:
#  -127.0.0.1 full-oracle-73.linux.example.com full-oracle-73 localhost
#  +127.0.0.1 full-oracle-73.linux.example.com full-oracle-73
#
# If using a real IP for the hostfile_ip attribute, then this should not be used.
node.normal['hostname_cookbook']['hostsfile_aliases'] = ['localhost']
include_recipe 'hostname'
