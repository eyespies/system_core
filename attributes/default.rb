# ~ TLD ~ #
# node.default['system_core']['domain'] = 'example.com'

# ~ system packages ~ #
# TODO: This should be determined by the platform_family and platform_version
node.default['system_core']['system']['packages'] = %w[rsyslog gnutls rsyslog-gnutls perl-YAML-LibYAML acpid
                                                       python-cheetah python-configobj vim-enhanced screen
                                                       python-pip git htop bash-completion gcc ruby-devel
                                                       zlib-devel ipa-client xfsprogs xfsprogs-devel
                                                       tmux xfsdump mutt cloud-init sysstat]

# ~ chef-client syslog ~ #
node.override['chef_client']['log']['syslog_facility'] = '::Syslog::LOG_DAEMON'
node.override['chef_client']['log']['syslog_progname'] = 'chef-client'
