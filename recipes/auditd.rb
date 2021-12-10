#
# Cookbook Name:: system_core
# Recipe:: auditd
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
auditd_packages = case node['platform_family']
                  when 'rhel'
                    %w(audit audit-libs)
                  when 'debian'
                    %w(auditd audispd-plugins)
                  end

package 'auditd' do
  package_name auditd_packages
end

cookbook_file '/etc/audit/auditd.conf' do
  source 'auditd.conf'
  owner 'root'
  group 'root'
  mode '0640'
  notifies :restart, 'service[auditd]', :delayed
end

service 'auditd' do
  restart_command '/usr/libexec/initscripts/legacy-actions/auditd/restart' if platform_family?('rhel') && node['init_package'] == 'systemd'
  supports [:start, :stop, :restart, :reload, :status]
  action :nothing
end
