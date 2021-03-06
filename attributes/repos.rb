#
# Cookbook :: system_core
# Attributes :: repos
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

# Oracle Linux 7
node.default['system_core']['repos']['ol7_base_latest']['url']     = 'https://yum.oracle.com/repo/OracleLinux/OL7/latest/$basearch/'
node.default['system_core']['repos']['ol7_uek4_latest']['url']     = 'https://yum.oracle.com/repo/OracleLinux/OL7/UEKR4/$basearch/'
node.default['system_core']['repos']['ol7_uek5_latest']['url']     = 'https://yum.oracle.com/repo/OracleLinux/OL7/UEKR5/$basearch/'
node.default['system_core']['repos']['ol7_optional_latest']['url'] = 'https://yum.oracle.com/repo/OracleLinux/OL7/optional/latest/$basearch/'

# Oracle Linux 8
node.default['system_core']['repos']['ol8_addons_latest']['url']    = 'https://yum.oracle.com/repo/OracleLinux/OL8/addons/$basearch/'
node.default['system_core']['repos']['ol8_appstream_latest']['url'] = 'https://yum.oracle.com/repo/OracleLinux/OL8/appstream/$basearch/'
node.default['system_core']['repos']['ol8_base_latest']['url']      = 'https://yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/$basearch/'
node.default['system_core']['repos']['ol8_codeready_latest']['url'] = 'https://yum.oracle.com/repo/OracleLinux/OL8/codeready/builder/$basearch/'
node.default['system_core']['repos']['ol8_epel_latest']['url']      = 'https://yum.oracle.com/repo/OracleLinux/OL8/developer/EPEL/$basearch/'
