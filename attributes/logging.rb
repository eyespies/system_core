#
# Cookbook :: system_core
# Attributes :: logging
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

# ~ rsyslog ~ #

# ~ Remote Logging ~ #
node.default['system_core']['papertrail']['enabled'] = false

# If Papertrail is enabled, this attribute needs set with the full name, including the leading '@' (for UDP) or
# '@@' (for TCP) prefixes.
# node.default['system_core']['papertrail']['remote_host'] = '@@log1.papertrailapp.com:12345'
node.default['system_core']['papertrail']['remote_syslog2']['source_url_prefix'] = 'https://github.com/papertrail/remote_syslog2/releases/download'
node.default['system_core']['papertrail']['remote_syslog2']['version'] = '0.20'
node.default['system_core']['papertrail']['remote_syslog2']['service_name'] = 'remote_syslog'

node.default['system_core']['papertrail']['remote_syslog2']['config']['file_name'] = '/etc/log_files.yml'
node.default['system_core']['papertrail']['remote_syslog2']['config']['template_file'] = '/etc/log_files.yml'
node.default['system_core']['papertrail']['remote_syslog2']['config']['template_cookbook'] = 'system_core'
node.default['system_core']['papertrail']['remote_syslog2']['config']['template_file'] = 'log_files.yml.erb'

node.default['system_core']['papertrail']['remote_syslog2']['protocol'] = 'tls'
node.default['system_core']['papertrail']['remote_syslog2']['hostname'] = nil
node.default['system_core']['papertrail']['remote_syslog2']['files'] = nil
node.default['system_core']['papertrail']['remote_syslog2']['exclude_patterns'] = nil
