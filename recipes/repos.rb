#
# Cookbook Name:: system_core
# Recipe:: repos
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

# Used to install various outside packages
include_recipe 'yum' if node['platform_family'] == 'rhel'
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

  # OL 7 ; this should not run for OL 8; for other EL platforms, see the bottom of the "if node ..."
  include_recipe 'yum-epel'

  # TODO: Allow overriding the baseurl so that local YUM servers can be used.
  # Only needed for RHEL 7 / Oracle 7 but not CentOS.
  yum_repository 'ol7_base_latest' do
    description 'Oracle Linux $releasever Base Latest ($basearch)'
    baseurl node['system_core']['repos']['ol7_base_latest']['url']
    gpgkey 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle'
    gpgcheck true
    make_cache true
    action :create
  end

  yum_repository 'ol7_uek4_latest' do
    description 'Oracle Linux $releasever UEK4 Latest ($basearch)'
    baseurl node['system_core']['repos']['ol7_uek4_latest']['url']
    gpgkey 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle'
    gpgcheck true
    make_cache true
    action :create
  end

  yum_repository 'ol7_uek5_latest' do
    description 'Oracle Linux $releasever UEK5 Latest ($basearch)'
    baseurl node['system_core']['repos']['ol7_uek5_latest']['url']
    gpgkey 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle'
    gpgcheck true
    make_cache true
    action :create
  end

  # Required so that python-cheetah / python-pygments installs successfully. CentOS automatically provides
  # access to python-pygments while RHEL and Oracle put it into the 'optional' repo which is disabled by default
  # Only needed for RHEL 7 / Oracle 7 but not CentOS.
  yum_repository 'ol7_optional_latest' do
    description 'Oracle Linux $releasever Optional Latest ($basearch)'
    baseurl node['system_core']['repos']['ol7_optional_latest']['url']
    gpgkey 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle'
    gpgcheck true
    make_cache true
    action :create
  end
elsif node['platform'] =~ /oracle/ && node['platform_version'] =~ /^8/
  # Deleting because it conflicts with Chef setting up the other repositories and causes errors about the
  # same repo defined twice.
  file '/etc/yum.repos.d/oracle-linux-ol8.repo' do
    action :delete
  end

  yum_repository 'ol8_addons_latest' do
    description 'Oracle Linux $releasever Addons Latest ($basearch)'
    baseurl node['system_core']['repos']['ol8_addons_latest']['url']
    gpgkey 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle'
    gpgcheck true
    make_cache true
    action :create
  end

  yum_repository 'ol8_appstream_latest' do
    description 'Oracle Linux $releasever Appstream Latest ($basearch)'
    baseurl node['system_core']['repos']['ol8_appstream_latest']['url']
    gpgkey 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle'
    gpgcheck true
    make_cache true
    action :create
  end

  # TODO: Allow overriding the baseurl so that local YUM servers can be used.
  # Only needed for RHEL 7 / Oracle 7 but not CentOS.
  yum_repository 'ol8_base_latest' do
    description 'Oracle Linux $releasever Base Latest ($basearch)'
    baseurl node['system_core']['repos']['ol8_base_latest']['url']
    gpgkey 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle'
    gpgcheck true
    make_cache true
    action :create
  end

  yum_repository 'ol8_codeready_latest' do
    description 'Oracle Linux $releasever CodeReady Latest ($basearch)'
    baseurl node['system_core']['repos']['ol8_codeready_latest']['url']
    gpgkey 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle'
    gpgcheck true
    make_cache true
    action :create
  end

  yum_repository 'ol8_epel_latest' do
    description 'Oracle Linux $releasever Optional Latest ($basearch)'
    baseurl node['system_core']['repos']['ol8_epel_latest']['url']
    gpgkey 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle'
    gpgcheck true
    make_cache true
    action :create
  end
elsif node['platform_family'] == 'rhel'
  # Include only if not using Oracle Linux >= 7 because the public EPEL repo conflicts
  # with the other Oracle repos (e.g. the Oracle base repo includes packages that are
  # also in the public EPEL repo but with different versions.)
  include_recipe 'yum-epel'
end

# Install common packages
node['system_core']['system']['packages'].each do |pkg|
  package pkg do
    action :install
  end
end
