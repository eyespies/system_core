#
# Cookbook Name:: system_core
# Recipe:: user_ssh_config
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
if node['system_core']['ssh'].attribute?('user_config')
  # Check two specific locations for the access/secret keys and if the keys don't exist in either
  # location, then the system will default to using an IAM profile.
  if node['system_core']['aws'].attribute?('profiles') && !node['system_core']['aws']['profiles'].nil?
    if node['system_core']['aws']['profiles'].attribute?('s3_file')
      access_key = node['system_core']['aws']['profiles']['s3_file']['access_key']
      secret_key = node['system_core']['aws']['profiles']['s3_file']['secret_key']
    elsif node['system_core']['aws']['profiles'].attribute?('default')
      access_key = node['system_core']['aws']['profiles']['default']['access_key']
      secret_key = node['system_core']['aws']['profiles']['default']['secret_key']
    end
  end

  # TODO: Fix method length
  node['system_core']['ssh']['user_config'].each do |usr, opts| # rubocop:disable Metrics/BlockLength
    # TODO: What happens if the user doesn't exist?
    user_home = Dir.home(usr)

    # Make sure the users home directory exists
    directory user_home do
      owner usr
      group usr
      mode 0o0755
    end

    directory "#{user_home}/.ssh" do
      owner usr
      group usr
      mode 0o0700
    end

    # If there is a config attribute for the user, then setup a custom SSH config.
    if opts.attribute?('config')
      template "#{user_home}/.ssh/config" do
        source 'ssh_config.erb'
        owner 'root'
        group 'root'
        mode 0o0600
        # AFIAK the braces are required for Chef DSL...
        variables({ hosts: opts['config']['hosts'] }) # rubocop:disable Style/BracesAroundHashParameters
      end
    end

    next unless opts.attribute?('keys')
    next if access_key.nil? || secret_key.nil?

    opts['keys'].each do |keyname, settings|
      Chef::Log.info("Retrieving SSH private key for #{usr} as #{keyname} using #{access_key}")
      s3_file "#{user_home}/.ssh/#{keyname}" do
        bucket settings['ssh_key_bucket']
        remote_path settings['ssh_key_path']
        aws_access_key_id access_key
        aws_secret_access_key secret_key
        owner 'root'
        group 'root'
        mode 0o0600
      end

      Chef::Log.info("Retrieving SSH public key for #{usr} as #{keyname}.pub using #{access_key}")
      s3_file "#{user_home}/.ssh/#{keyname}.pub" do
        bucket settings['ssh_key_bucket']
        remote_path "#{settings['ssh_key_path']}.pub"
        aws_access_key_id access_key
        aws_secret_access_key secret_key
        owner 'root'
        group 'root'
        mode 0o0600
      end
    end
  end
end
