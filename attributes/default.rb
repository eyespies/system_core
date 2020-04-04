#
# Cookbook :: system_core
# Attributes :: default
#
# Copyright (C) 2016 - 2020 Justin Spies
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

# ~ TLD ~ #
# node.default['system_core']['domain'] = 'example.com'

# ~ system packages ~ #
# TODO: This should be determined by the platform_family and platform_version
node.default['system_core']['system']['packages'] = case node['platform_family']
                                                    when 'rhel'
                                                      # NOTE: For EL8 do not install the IPA client anymore, it
                                                      # is handled elsewhere
                                                      if node['platform_version'] =~ /^8/
                                                        if node['platform'] =~ /oracle/
                                                          # Note that htop and screen are not available from
                                                          # the Oracle EPEL repo, but using the public repo causes
                                                          # conflicts with the other Oracle repos...
                                                          %w[acpid rsyslog gnutls rsyslog-gnutls vim-enhanced
                                                             python3-pip git bash-completion tmux gcc ruby-devel
                                                             zlib-devel xfsprogs xfsprogs-devel xfsdump mutt
                                                             cloud-init sysstat]
                                                        else
                                                          # TODO: This needs tested with CentOS / RHEL 8...
                                                          %w[acpid rsyslog gnutls rsyslog-gnutls vim-enhanced
                                                             python3-pip git htop bash-completion tmux gcc ruby-devel
                                                             zlib-devel screen xfsprogs xfsprogs-devel xfsdump mutt
                                                             cloud-init sysstat]
                                                        end
                                                      else
                                                        %w[rsyslog gnutls rsyslog-gnutls perl-YAML-LibYAML acpid
                                                           python-cheetah python-configobj vim-enhanced screen
                                                           python-pip git htop bash-completion gcc ruby-devel
                                                           zlib-devel ipa-client xfsprogs xfsprogs-devel
                                                           tmux xfsdump mutt cloud-init sysstat]
                                                      end
                                                    when 'debian'
                                                      %w[rsyslog gnutls-bin libgnutls30 rsyslog-gnutls libyaml-perl acpid
                                                         python-cheetah python-configobj vim screen
                                                         python-pip git htop bash-completion gcc ruby-dev
                                                         zlib1g-dev freeipa-client xfsprogs xfslibs-dev
                                                         tmux xfsdump mutt cloud-init sysstat]
                                                    end

# ~ chef-client syslog ~ #
node.override['chef_client']['log']['syslog_facility'] = '::Syslog::LOG_DAEMON'
node.override['chef_client']['log']['syslog_progname'] = 'chef-client'
