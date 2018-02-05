name             'system_core'
maintainer       'Justin Spies'
maintainer_email 'justin@thespies.org'
source_url       'https://github.com/eyespies/system_core'
issues_url       'https://github.com/eyespies/system_core/issues'
license          'Apache-2.0'
description      'Core operating system configuration for Enterprise Linux'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.2.0'
chef_version     '>= 12'

# This is the 3ofcoins version and is the one from which all others are forked. Tried using the 'hostnames' version
# from nathantsoi, however it does not properly support Oracle Linux. It also generates Chef warnings and although a
# PR was submitted in January 2017 to eliminate the warnings, as of August 2017 the maintainer has not merged the PR.
# So it seems the nathantsoi version is no longer maintained.
depends 'hostname', '~> 0.4.0'
depends 'iptables', '~> 4.2.0'
depends 'logrotate', '~> 2.2.0'
depends 'ntp', '~> 3.5.0'
depends 'openssh', '~> 2.4.0'
depends 'postfix', '~> 5.1.0'
depends 'ruby_rbenv', '~> 2.0.0'
depends 'rsyslog', '~> 6.0.0'
depends 's3_file', '~> 2.9.0'
depends 'selinux', '~> 2.0.0'
depends 'ssh_authorized_keys', '~> 0.4.0'
depends 'ssh_known_hosts', '~> 5.2.0'
depends 'sudo', '~> 3.5.0'
depends 'yum', '~> 5.0.0'
depends 'yum-epel', '~> 2.1.0'

supports 'centos', '>= 6.0'
supports 'redhat', '>= 6.0'
supports 'oracle', '>= 6.0'
