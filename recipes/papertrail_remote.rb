#
# Cookbook Name:: system_core
# Recipe:: papertrail
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
if node['system_core']['papertrail']['enabled']
  remote_file "#{Chef::Config['file_cache_path']}/remote_syslog2.rpm" do
    source node['system_core']['papertrail']['remote_syslog2']['source_url']
    owner 'root'
    group 'root'
    mode '0644'
  end

  package "#{Chef::Config['file_cache_path']}/remote_syslog2.rpm"

  parts = node['system_core']['papertrail']['remote_host'].split(':')
  pt_protocol = node['system_core']['papertrail']['remote_syslog2']['protocol']
  pt_hostname = parts[0].gsub(/@/, '')
  pt_port = if parts.length > 1
              parts[1]
            else
              ''
            end

  hostname = if node['system_core']['papertrail']['remote_syslog2']['hostname'].nil?
               node['hostname']
             else
               node['system_core']['papertrail']['remote_syslog2']['hostname']
             end
  remote_config = { hostname: hostname,
                    files: node['system_core']['papertrail']['remote_syslog2']['files'],
                    exclude_patterns: node['system_core']['papertrail']['remote_syslog2']['exclude_patterns'] }

  template node['system_core']['papertrail']['remote_syslog2']['config']['file_name'] do
    source node['system_core']['papertrail']['remote_syslog2']['config']['template_file']
    owner 'root'
    group 'root'
    mode '0644'
    variables(config: remote_config,
              papertrail_host: pt_hostname,
              papertrail_port: pt_port,
              papertrail_protocol: pt_protocol)
  end

  service 'remote-syslog' do
    action [:start, :enable]
  end

else
  log 'papertrail-disabled' do
    level :warn
    message 'Papertrail is disabled via the node[system_core][papertrail][enabled] attribute and will not be configured'
  end
end
