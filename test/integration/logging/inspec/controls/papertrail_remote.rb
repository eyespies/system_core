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
papertrail_host = attribute('papertrail_host',
                            default: nil,
                            description: 'Hostname to be compared when testing that papertrail is properly configured')

control 'remote-syslog' do
  impact 1.0
  title 'Validates the Remote Syslog package from Papertrail'
  desc 'Ensures that the remote-syslog2 package is installed for use with forwarding arbitrary log data to Papertrail'

  package_name = case os.name
                 when 'redhat', 'centos', 'oracle'
                   'remote_syslog2'
                 when 'debian', 'ubuntu'
                   'remote-syslog2'
                 end

  describe package(package_name) do
    it { should be_installed }
  end

  describe file('/etc/log_files.yml') do
    it { should exist }
    it { should be_owned_by('root') }
    it { should be_grouped_into('root') }
    its('mode') { should cmp '0644' }
  end

  describe file('/etc/papertrail-bundle.pem') do
    it { should exist }
    it { should be_owned_by('root') }
    it { should be_grouped_into('root') }
    its('mode') { should cmp '0644' }
  end

  describe file('/etc/rsyslog.d/22-papertrail.conf') do
    it { should exist }
    it { should be_owned_by('root') }
    it { should be_grouped_into('root') }
    its('mode') { should cmp '0644' }
    its(:content) { should match(/\*\.\*\s*#{papertrail_host}$/i) }
  end

  describe service('remote_syslog') do
    it { should be_enabled }
    it { should be_running }
  end

  only_if { !papertrail_host.nil? }
end
