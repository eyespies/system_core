#
# Cookbook :: system_core
# Attributes :: repos
#
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

# Oracle Linux 7
node.default['system_core']['repos']['ol7']['base_latest']['name']    = 'ol7_base_latest'
node.default['system_core']['repos']['ol7']['base_latest']['enabled'] = true
node.default['system_core']['repos']['ol7']['base_latest']['url']     = 'https://yum.oracle.com/repo/OracleLinux/OL7/latest/$basearch/'

node.default['system_core']['repos']['ol7']['uek4_latest']['name']    = 'ol7_uek4_latest'
node.default['system_core']['repos']['ol7']['uek4_latest']['enabled'] = true
node.default['system_core']['repos']['ol7']['uek4_latest']['url']     = 'https://yum.oracle.com/repo/OracleLinux/OL7/UEKR4/$basearch/'

node.default['system_core']['repos']['ol7']['uek5_latest']['name']    = 'ol7_uek5_latest'
node.default['system_core']['repos']['ol7']['uek5_latest']['enabled'] = true
node.default['system_core']['repos']['ol7']['uek5_latest']['url']     = 'https://yum.oracle.com/repo/OracleLinux/OL7/UEKR5/$basearch/'

node.default['system_core']['repos']['ol7']['uek6_latest']['name']    = 'ol7_uek6_latest'
node.default['system_core']['repos']['ol7']['uek6_latest']['enabled'] = true
node.default['system_core']['repos']['ol7']['uek6_latest']['url']     = 'https://yum.oracle.com/repo/OracleLinux/OL7/UEKR5/$basearch/'

# Required so that python-cheetah / python-pygments installs successfully. CentOS automatically provides
# access to python-pygments while RHEL and Oracle put it into the 'optional' repo which is disabled by default
# Only needed for RHEL 7 / Oracle 7 but not CentOS.
node.default['system_core']['repos']['ol7']['optional_latest']['name']    = 'ol7_optional_latest'
node.default['system_core']['repos']['ol7']['optional_latest']['enabled'] = true
node.default['system_core']['repos']['ol7']['optional_latest']['url']     = 'https://yum.oracle.com/repo/OracleLinux/OL7/optional/latest/$basearch/'

node.default['system_core']['repos']['ol7']['epel_latest']['name']    = 'ol7_epel_latest'
node.default['system_core']['repos']['ol7']['epel_latest']['enabled'] = true
node.default['system_core']['repos']['ol7']['epel_latest']['url']     = 'https://yum.oracle.com/repo/OracleLinux/OL7/developer_EPEL/$basearch/'

node.default['system_core']['repos']['ol7']['addons_latest']['name'] = 'ol7_addons_latest'
node.default['system_core']['repos']['ol7']['addons_latest']['enabled'] = true
node.default['system_core']['repos']['ol7']['addons_latest']['url']  = 'https://yum.oracle.com/repo/OracleLinux/OL7/addons/$basearch/'

node.default['system_core']['repos']['ol7']['kvm_utilities_latest']['name']    = 'ol7_kvm_utilities_latest'
node.default['system_core']['repos']['ol7']['kvm_utilities_latest']['enabled'] = false
node.default['system_core']['repos']['ol7']['kvm_utilities_latest']['url']     = 'https://yum.oracle.com/repo/OracleLinux/OL7/kvm/utils/$basearch/'

node.default['system_core']['repos']['ol7']['ovirt43_latest']['name'] = 'ol7_ovirt43_latest'
node.default['system_core']['repos']['ol7']['ovirt43_latest']['enabled'] = false
node.default['system_core']['repos']['ol7']['ovirt43_latest']['url']  = 'https://yum.oracle.com/repo/OracleLinux/OL7/ovirt43/$basearch/'

node.default['system_core']['repos']['ol7']['ovirt43_extras_latest']['name'] = 'ol7_ovirt43_extras_latest'
node.default['system_core']['repos']['ol7']['ovirt43_extras_latest']['enabled'] = false
node.default['system_core']['repos']['ol7']['ovirt43_extras_latest']['url']  = 'https://yum.oracle.com/repo/OracleLinux/OL7/ovirt43/extras/$basearch/'

node.default['system_core']['repos']['ol7']['gluster6_latest']['name'] = 'ol7_gluster6_latest'
node.default['system_core']['repos']['ol7']['gluster6_latest']['enabled'] = false
node.default['system_core']['repos']['ol7']['gluster6_latest']['url']  = 'https://yum.oracle.com/repo/OracleLinux/OL7/gluster6/$basearch/'

node.default['system_core']['repos']['ol7']['gluster8_latest']['name'] = 'ol7_gluster8_latest'
node.default['system_core']['repos']['ol7']['gluster8_latest']['enabled'] = false
node.default['system_core']['repos']['ol7']['gluster8_latest']['url']  = 'https://yum.oracle.com/repo/OracleLinux/OL7/gluster8/$basearch/'

node.default['system_core']['repos']['ol7']['php_latest']['name'] = 'ol7_php_latest'
node.default['system_core']['repos']['ol7']['php_latest']['enabled'] = false
node.default['system_core']['repos']['ol7']['php_latest']['url']  = 'https://yum.oracle.com/repo/OracleLinux/OL7/developer/php74/$basearch/'

# Oracle Linux 8
node.default['system_core']['repos']['ol8']['base_latest']['name']    = 'ol8_base_latest'
node.default['system_core']['repos']['ol8']['base_latest']['enabled'] = true
node.default['system_core']['repos']['ol8']['base_latest']['url']     = 'https://yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/$basearch/'

node.default['system_core']['repos']['ol8']['addons_latest']['name']    = 'ol8_addons_latest'
node.default['system_core']['repos']['ol8']['addons_latest']['enabled'] = true
node.default['system_core']['repos']['ol8']['addons_latest']['url']     = 'https://yum.oracle.com/repo/OracleLinux/OL8/addons/$basearch/'

node.default['system_core']['repos']['ol8']['appstream_latest']['name']    = 'ol8_appstream_latest'
node.default['system_core']['repos']['ol8']['appstream_latest']['enabled'] = true
node.default['system_core']['repos']['ol8']['appstream_latest']['url']     = 'https://yum.oracle.com/repo/OracleLinux/OL8/appstream/$basearch/'

node.default['system_core']['repos']['ol8']['codeready_latest']['name']    = 'ol8_codeready_latest'
node.default['system_core']['repos']['ol8']['codeready_latest']['enabled'] = true
node.default['system_core']['repos']['ol8']['codeready_latest']['url']     = 'https://yum.oracle.com/repo/OracleLinux/OL8/codeready/builder/$basearch/'

node.default['system_core']['repos']['ol8']['epel_latest']['name']    = 'ol8_epel_latest'
node.default['system_core']['repos']['ol8']['epel_latest']['enabled'] = true
node.default['system_core']['repos']['ol8']['epel_latest']['url']     = 'https://yum.oracle.com/repo/OracleLinux/OL8/developer/EPEL/$basearch/'

node.default['system_core']['repos']['ol8']['uek6_latest']['name']    = 'ol8_uek6_latest'
node.default['system_core']['repos']['ol8']['uek6_latest']['enabled'] = true
node.default['system_core']['repos']['ol8']['uek6_latest']['url']     = 'https://yum.oracle.com/repo/OracleLinux/OL8/UEKR6/$basearch/'

node.default['system_core']['repos']['ol8']['kvm_appstream_latest']['name']    = 'ol8_kvm_appstream_latest'
node.default['system_core']['repos']['ol8']['kvm_appstream_latest']['enabled'] = false
node.default['system_core']['repos']['ol8']['kvm_appstream_latest']['url']     = 'https://yum.oracle.com/repo/OracleLinux/OL8/kvm/appstream/$basearch/'

node.default['system_core']['repos']['ol8']['automation_manager_latest']['name']    = 'ol8_automation_manager_latest'
node.default['system_core']['repos']['ol8']['automation_manager_latest']['enabled'] = false
node.default['system_core']['repos']['ol8']['automation_manager_latest']['url']     = 'https://yum.oracle.com/repo/OracleLinux/OL8/automation/$basearch/'

node.default['system_core']['repos']['ol8']['gluster_appstream_latest']['name']    = 'ol8_gluster_appstream_latest'
node.default['system_core']['repos']['ol8']['gluster_appstream_latest']['enabled'] = false
node.default['system_core']['repos']['ol8']['gluster_appstream_latest']['url']     = 'https://yum.oracle.com/repo/OracleLinux/OL8/automation/$basearch/'
