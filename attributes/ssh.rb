#
# Cookbook :: system_core
# Attributes :: ssh
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

node.default['system_core']['ssh']['banner']['source_file'] = 'banner.erb'

# Set this attribute in order to use a banner file from another cookbook.
# node.default['system_core']['ssh']['banner']['source_cookbook'] = 'some_cookbook'

# ~ ssh_known_hosts ~ #
node.override['ssh_known_hosts']['file']                    = '/etc/ssh/ssh_known_hosts'
node.override['ssh_known_hosts']['key_type']                = 'rsa,dsa'
node.override['ssh_known_hosts']['cacher']['data_bag']      = 'server_data'
node.override['ssh_known_hosts']['cacher']['data_bag_item'] = 'known_hosts'

node.default['system_core']['ssh']['user_config']['root']['config']['hosts']['*'].tap do |config|
  config['SendEnv'] = 'LANG LC_*'
  config['ForwardAgent'] = 'yes'
  config['HostkeyAlgorithms'] = '+ssh-ed25519,ssh-rsa,ssh-dss,ecdsa-sha2-nistp256'
  config['UserKnownHostsFile'] = '/dev/null'
  config['StrictHostKeyChecking'] = 'no'
end

node.default['system_core']['ssh']['user_config']['root']['config']['hosts']['github.com bitbucket.org bitbucket.com'].tap do |config|
  config['IdentityFile'] = '~/.ssh/id_rsa'
  config['UserKnownHostsFile'] = '~/.ssh/known_hosts'
  config['StrictHostKeyChecking'] = 'yes'
end
