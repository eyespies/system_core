#
# Cookbook :: system_core
# Attributes :: repos
#
# Copyright (C) 2016 - 2017 Justin Spies
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

node.default['system_core']['repos']['ol7_base_latest']['url']     = 'http://yum.oracle.com/repo/OracleLinux/OL7/latest/$basearch/'
node.default['system_core']['repos']['ol7_uek4_latest']['url']     = 'http://yum.oracle.com/repo/OracleLinux/OL7/UEKR4/$basearch/'
node.default['system_core']['repos']['ol7_optional_latest']['url'] = 'http://yum.oracle.com/repo/OracleLinux/OL7/optional/latest/$basearch/'
node.default['system_core']['repos']['ol7_uek5_latest']['url']     = 'http://yum.oracle.com/repo/OracleLinux/OL7/UEKR5/$basearch/'
