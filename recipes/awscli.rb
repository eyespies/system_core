#
# Cookbook Name:: system_core
# Recipe:: awscli
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

# TODO: Make the user name, home directory, and shell attributes
user 'aws' do
  comment 'User to run AWS CLI Commands'
  home '/home/aws'
  shell '/bin/bash'
end

node['system_core']['awscli']['packages'].each do |pkg|
  package pkg do
    action :install
  end
end

cookbook_file '/tmp/install-aws-cli.sh' do
  source 'install-aws-cli.sh'
  owner 'root'
  group 'root'
  mode '0770'
  action :create
end

execute 'install-aws-cli' do
  command '/tmp/install-aws-cli.sh'
  cwd '/tmp'
  not_if 'which aws'
end

directory '/root/.aws' do
  owner 'root'
  group 'root'
  mode '0750'
  action :create
end

if node['system_core']['aws'].attribute?('profiles') && !node['system_core']['aws']['profiles'].nil?
  template '/root/.aws/config' do
    source 'aws/config.erb'
    owner 'root'
    group 'root'
    mode '0640'
    variables(
      profiles: node['system_core']['aws']['profiles']
    )
  end

  template '/root/.aws/credentials' do
    source 'aws/credentials.erb'
    owner 'root'
    group 'root'
    mode '0640'
    variables(
      profiles: node['system_core']['aws']['profiles']
    )
  end
else
  Chef::Log.warn('Not creating the AWS configuration files as no AWS profiles exist')
end
