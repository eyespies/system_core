# Copyright:: (C) 2016 - 2021 Justin Spies
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
control 'ruby' do
  impact 1.0
  title 'Validates the Remote Syslog package from Papertrail'
  desc 'Ensures that the remote-syslog2 package is installed for use with forwarding arbitrary log data to Papertrail'

  describe package('bzip2') do
    it { should be_installed }
  end

  describe file('/usr/local/rbenv/shims/ruby') do
    it { should exist }
    it { should be_owned_by('root') }
    it { should be_grouped_into('root') }
    its('mode') { should cmp '0755' }
  end

  describe file('/root/.gemrc') do
    it { should exist }
    it { should be_owned_by('root') }
    it { should be_grouped_into('root') }
    its('mode') { should cmp '0644' }
  end
end
