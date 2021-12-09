#
# Cookbook :: system_core
# Attributes :: aws
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

# ~ awscli ~ #
node.default['system_core']['awscli']['version'] = '1.4.4'
node.default['system_core']['awscli']['packages'] = case node['platform_family']
                                                    when 'rhel'
                                                      %w[jq wget curl unzip]
                                                    when 'debian'
                                                      # Require Markdown on Ubuntu, otherwise we get
                                                      # cheetah 2.4.4 requires Markdown>=2.0.1, which is not installed.
                                                      %w[jq wget curl unzip python-pip python-markdown python3-pip python3-markdown]
                                                    end

# Defines the attribute with no value so that we can use a shorter 'node['system_core']['aws'].attribute?('profiles')' test
node.default['system_core']['aws']['profiles'] = nil
