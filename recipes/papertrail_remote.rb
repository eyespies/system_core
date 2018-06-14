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
  download_prefix = node['system_core']['papertrail']['remote_syslog2']['source_url_prefix']
  download_version = node['system_core']['papertrail']['remote_syslog2']['version']
  filename = case node['platform_family']
             when 'rhel'
               "remote_syslog2-#{download_version}-1.x86_64.rpm"
             when 'debian'
               "remote-syslog2_#{download_version}_amd64.deb"
             else
               Chef::Log.warn('This OS is not yet supported by the system_core::papertrail_remote cookbook')
               return
             end
  download_url = "#{download_prefix}/v#{download_version}/#{filename}"

  remote_file "#{Chef::Config['file_cache_path']}/#{filename}" do
    source download_url
    owner 'root'
    group 'root'
    mode '0644'
  end

  case node['platform_family']
  when 'rhel'
    package "#{Chef::Config['file_cache_path']}/#{filename}"
  when 'debian'
    dpkg_package 'remote_syslog2' do
      source "#{Chef::Config['file_cache_path']}/#{filename}"
    end
  end

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

  service_name = node['system_core']['papertrail']['remote_syslog2']['service_name']
  service service_name do
    action [:start, :enable]
  end

else
  log 'papertrail-disabled' do
    level :warn
    message 'Papertrail is disabled via the node[system_core][papertrail][enabled] attribute and will not be configured'
  end
end
