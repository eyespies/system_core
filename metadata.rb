name             'system_core'
maintainer       'Justin Spies'
maintainer_email 'justin@thespies.org'
source_url       'https://github.com/eyespies/system_core'
issues_url       'https://github.com/eyespies/system_core/issues'
license          'Apache-2.0'
description      'Core operating system configuration for Enterprise Linux'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '4.2.1'
chef_version     '>= 12'

depends 'apt', '~> 7.2.0'
depends 'chrony', '~> 0.3.0'
# This is the 3ofcoins version and is the one from which all others are forked. Tried using the 'hostnames' version
# from nathantsoi, however it does not properly support Oracle Linux. It also generates Chef warnings and although a
# PR was submitted in January 2017 to eliminate the warnings, as of August 2017 the maintainer has not merged the PR.
# So it seems the nathantsoi version is no longer maintained.
depends 'hostname', '~> 0.4.0'
depends 'iptables', '~> 6.0.0'
depends 'logrotate', '~> 2.2.0'
depends 'ntp', '~> 3.7.0'
depends 'openssh', '~> 2.8.0'
depends 'postfix', '~> 5.3.0'
depends 'ruby_rbenv', '~> 2.3.0'
depends 'rsyslog', '~> 7.0.0'
# TODO: Switch to aws cookbook
depends 's3_file', '~> 2.8.0'
depends 'selinux', '~> 3.0.0'
depends 'ssh_authorized_keys', '~> 0.4.0'
depends 'ssh_known_hosts', '~> 5.2.0'
depends 'sudo', '~> 5.4.0'
depends 'yum', '~> 5.1.0'
depends 'yum-epel', '~> 3.3.0'

supports 'ubuntu', '>= 16.04'
supports 'centos', '>= 6.0'
supports 'redhat', '>= 6.0'
supports 'oracle', '>= 6.0'
