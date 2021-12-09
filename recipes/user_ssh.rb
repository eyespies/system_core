#
# Cookbook Name:: system_core
# Recipe:: user_ssh_config
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
if node['system_core']['ssh'].attribute?('user_config')
  # TODO: Fix method length
  node['system_core']['ssh']['user_config'].each do |usr, opts| # rubocop:disable Metrics/BlockLength
    # TODO: This is evaluated at compile time, when users often don't exist, and thus throws an error.
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

    if node['system_core']['ssh'].attribute?('authorized_keys') && !node['system_core']['ssh']['authorized_keys'].empty?
      node['system_core']['ssh']['authorized_keys'].each do |keyname, options|
        ssh_authorize_key keyname do
          key options['public_key']
          user options['user']
        end
      end
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
  end
end
