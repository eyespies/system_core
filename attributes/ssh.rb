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
