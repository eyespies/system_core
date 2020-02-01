#
# Cookbook Name:: system_core
# Recipe:: papertrail
#
# Copyright (C) 2016 - 2020 Justin Spies
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
if node['system_core']['papertrail']['enabled']
  include_recipe 'system_core::rsyslog'

  # TODO: Make the package and service names attributes
  # Required for encryption
  package 'rsyslog-gnutls' do
    notifies :restart, 'service[rsyslog]', :delayed
  end

  # TODO: Make the directory, owner, group and service names attributes
  directory '/var/spool/rsyslog' do
    owner 'root'
    group 'root'
    mode '0770'
    action :create
    notifies :restart, 'service[rsyslog]', :delayed
  end

  # TODO: Make the file name an attribute
  # Send all rsyslog content to Papertrail
  cookbook_file '/etc/papertrail-bundle.pem' do
    source 'papertrail-bundle.pem'
    owner 'root'
    group 'root'
    mode '0644'
    action :create
    notifies :restart, 'service[rsyslog]', :delayed
  end

  # TODO: Make the file and service names attributes
  template '/etc/rsyslog.d/22-papertrail.conf' do
    source '22-papertrail.conf'
    owner 'root'
    group 'root'
    mode '0644'
    action :create
    notifies :restart, 'service[rsyslog]', :delayed
  end
else
  log 'papertrail-disabled' do
    level :warn
    message 'Papertrail is disabled via the node[system_core][papertrail][enabled] attribute and will not be configured'
  end
end
