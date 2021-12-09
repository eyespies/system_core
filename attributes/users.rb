#
# Cookbook :: system_core
# Attributes :: users
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

# ~ web user ~ #
node.default['system_core']['web']['service'] = 'nginx'
node.default['system_core']['web']['user']    = 'web'
node.default['system_core']['web']['group']   = 'web'

# ~ builds users ~ #
node.default['system_core']['builds']['user']   = 'builds'
node.default['system_core']['builds']['group']  = 'builds'
