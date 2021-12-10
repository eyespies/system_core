#
# Cookbook Name:: system_core
# Recipe:: repos
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

# Used to install various outside packages
include_recipe 'apt::default' if node['platform_family'] == 'debian'

# Avoid caching something we don't need cached.
file '/etc/yum.repos.d/cobbler-config.repo' do
  action :delete
end

if node['platform'] =~ /oracle/ && node['platform_version'] =~ /^7/
  # Deleting because it conflicts with Chef setting up the other repositories and causes errors about the
  # same repo defined twice.
  file '/etc/yum.repos.d/public-yum-ol7.repo' do
    action :delete
  end

  file '/etc/yum.repos.d/oracle-linux-ol7.repo' do
    action :delete
  end

  file '/etc/yum.repos.d/uek-ol7.repo' do
    action :delete
  end

  file '/etc/yum.repos.d/virt-ol7.repo' do
    action :delete
  end

  # TODO: Allow overriding the baseurl so that local YUM servers can be used.
  # Only needed for RHEL 7 / Oracle 7 but not CentOS.
  node['system_core']['repos']['ol7'].each do |_repo, repo_opts|
    next unless repo_opts['enabled']

    yum_repository repo_opts['name'] do
      description "Oracle Linux $releasever #{repo_opts['name']} ($basearch)"
      baseurl repo_opts['url']
      gpgkey 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle'
      gpgcheck true
      make_cache true
      action :create
    end
  end
elsif node['platform'] =~ /oracle/ && node['platform_version'] =~ /^8/
  # Deleting because it conflicts with Chef setting up the other repositories and causes errors about the
  # same repo defined twice.
  file '/etc/yum.repos.d/oracle-linux-ol8.repo' do
    action :delete
  end

  # TODO: Allow overriding the baseurl so that local YUM servers can be used.
  # Only needed for RHEL 7 / Oracle 7 but not CentOS.
  node['system_core']['repos']['ol8'].each do |_repo, repo_opts|
    next unless repo_opts['enabled']

    yum_repository repo_opts['name'] do
      description "Oracle Linux $releasever #{repo_opts['name']} ($basearch)"
      baseurl repo_opts['url']
      gpgkey 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle'
      gpgcheck true
      make_cache true
      action :create
    end
  end
end

# Install common packages
node['system_core']['system']['packages'].each do |pkg|
  package pkg do
    action :install
  end
end
