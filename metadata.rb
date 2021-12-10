name             'system_core'
maintainer       'Justin Spies'
maintainer_email 'justin@thespies.org'
source_url       'https://github.com/eyespies/system_core'
issues_url       'https://github.com/eyespies/system_core/issues'
license          'Apache-2.0'
description      'Core operating system configuration for Enterprise Linux'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '6.0.0'
chef_version     '>= 16'

depends 'apt', '~> 7.4.0'
depends 'chrony', '~> 1.2.0'
# This is the 3ofcoins version and is the one from which all others are forked. Tried using the 'hostnames' version
# from nathantsoi, however it does not properly support Oracle Linux. It also generates Chef warnings and although a
# PR was submitted in January 2017 to eliminate the warnings, as of August 2017 the maintainer has not merged the PR.
# So it seems the nathantsoi version is no longer maintained.
depends 'hostname', '~> 0.4.0'
depends 'iptables', '~> 8.0.0'
depends 'logrotate', '~> 3.0.5'
depends 'ntp', '~> 3.12.0'
depends 'openssh', '~> 2.9.2'
depends 'postfix', '~> 6.0.4'
depends 'ruby_rbenv', '~> 4.0.1'
depends 'rsyslog', '~> 9.0.1'
depends 'selinux', '~> 6.0.1'
depends 'ssh_authorized_keys', '~> 1.0.0'
depends 'ssh_known_hosts', '~> 7.0.0'

supports 'ubuntu', '>= 16.04'
supports 'centos', '>= 7.0'
supports 'redhat', '>= 7.0'
supports 'oracle', '>= 7.0'
