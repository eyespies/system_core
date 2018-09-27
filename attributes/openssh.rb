#
# Cookbook :: system_core
# Attributes :: openssh
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
require 'mixlib/shellout'

# ~ openssh ~ #
case node['platform_family']
when 'rhel'
  if node['platform_version'].to_i < 7
    node.override['openssh']['server']['HostKey'] = '/etc/ssh/ssh_host_dsa_key'
  elsif node['platform_version'].to_i == 7
    node.override['openssh']['server']['HostKey'] = '/etc/ssh/ssh_host_ecdsa_key'
  else
    Chef::Log.warn("Unsupported RHEL version (#{node['platform_version']}) when setting SSH HostKey settings")
  end
else
  Chef::Log.warn("Unsupported OS platform #{node['platform']} when setting SSH HostKey settings")
end

# 'sshusers' group controls access for IPA accounts; 'root' group allows users to login as root
# TODO: Make the SSH user group name an attribute
ssh_groups = 'sshusers root'
find = Mixlib::ShellOut.new("grep vagrant /etc/group | awk -F: '{print $1}'")
find.run_command

if find.stdout == 'vagrant'
  # Per OpenSSH man page:
  # "The allow/deny directives are processed in the following order: DenyUsers, AllowUsers, DenyGroups,
  # and finally AllowGroups.  All of the specified user and group tests must succeed, before user is allowed to
  # log in." so for 'vagrant' to login, we just need to ensure the vagrant group is allowed SSH access.
  ssh_groups += ' vagrant'
end
node.default['openssh']['server']['allow_groups'] = ssh_groups

accept_env = 'LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY'
accept_env = "#{accept_env} LC_MESSAGES LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT"
accept_env += ' LC_IDENTIFICATION LC_ALL LANGUAGE XMODIFIERS'

ciphers = case node['platform_family']
          when 'rhel'
            if node['platform_version'] =~ /^6/
              %w[aes128-ctr
                 aes192-ctr
                 aes256-ctr]
            elsif node['platform_version'] =~ /^7/
              %w[chacha20-poly1305@openssh.com
                 aes128-ctr
                 aes192-ctr
                 aes256-ctr
                 aes128-gcm@openssh.com
                 aes256-gcm@openssh.com]
            end
          end

macs = case node['platform_family']
       when 'rhel'
         if node['platform_version'] =~ /^6/
           %w[hmac-sha1
              umac-64@openssh.com
              hmac-ripemd160
              hmac-sha1-96
              hmac-sha2-256
              hmac-sha2-512
              hmac-ripemd160@openssh.com]
         elsif node['platform_version'] =~ /^7/
           %w[umac-64-etm@openssh.com
              umac-128-etm@openssh.com
              hmac-sha2-256-etm@openssh.com
              hmac-sha2-512-etm@openssh.com
              hmac-sha1-etm@openssh.com
              umac-64@openssh.com
              umac-128@openssh.com
              hmac-sha2-256
              hmac-sha2-512
              hmac-sha1
              hmac-sha1-etm@openssh.com]
         end
       end

node.override['openssh']['server']['banner']                            = '/etc/ssh/banner'
node.override['openssh']['server']['login_grace_time']                  = '1m'
node.override['openssh']['server']['protocol']                          = '2'
node.override['openssh']['server']['syslog_facility']                   = 'AUTHPRIV'
node.override['openssh']['server']['password_authentication']           = 'yes'
node.override['openssh']['server']['challenge_response_authentication'] = 'no'
node.override['openssh']['server']['kerberos_authentication']           = 'no'
node.override['openssh']['server']['g_s_s_a_p_i_authentication']        = 'yes'
node.override['openssh']['server']['g_s_s_a_p_i_cleanup_credentials']   = 'yes'
node.override['openssh']['server']['use_p_a_m']                         = 'yes'
node.override['openssh']['server']['accept_env']                        = accept_env
node.override['openssh']['server']['x11_forwarding']                    = 'no'

node.override['openssh']['server']['ciphers'] = ciphers.join(',') unless ciphers.nil?
node.override['openssh']['server']['mACs']    = macs.join(',') unless macs.nil?

if File.exist?('/usr/bin/sss_ssh_authorizedkeys') && File.exist?('/etc/ipa/ca.crt')
  # Override the default SSH settings - these are required in order to enable use of SSH keys stored in IPA
  node.override['openssh']['server']['authorized_keys_command'] = '/usr/bin/sss_ssh_authorizedkeys'
  case node['platform_family']
  when 'rhel'
    if node['platform_version'].to_i == 7
      node.override['openssh']['server']['authorized_keys_command_user'] = 'nobody'
    else
      msg = "RedHat family version < 7 (#{node['platform_version']}) detected, not setting AuthorizedKeysCommandUser"
      Chef::Log.info(msg)
    end
  else
    Chef::Log.warn("Unsupported OS platform #{node['platform']} when setting SSH HostKey settings")
  end
else
  Chef::Log.info('Non IPA client detected, not setting any IPA specific SSH options')
end

node.override['openssh']['client']['*']['user_known_hosts_file']      = '/dev/null'
node.override['openssh']['client']['*']['strict_host_key_checking']   = 'no'
