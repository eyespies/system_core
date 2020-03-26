node.default['system_core']['chrony']['type'] = 'client'

# These are not set properly because the Chrony cookbook does not properly support Oracle Linux
case node['platform']
when 'centos', 'redhat', 'scientific' # ~FC024
  default['chrony']['systemd']['Service']['PIDFile'] = '/run/chrony/chronyd.pid'
  default['chrony']['systemd']['Service']['EnvironmentFile'] = '-/etc/sysconfig/chronyd'
  default['chrony']['systemd']['Service']['ExecStart'] = '/usr/sbin/chronyd'
  default['chrony']['systemd']['Service']['ExecStartPost'] = '/usr/libexec/chrony-helper update-daemon'
when 'oracle'
  default['chrony']['systemd']['Service']['PIDFile'] = '/run/chrony/chronyd.pid'
  default['chrony']['systemd']['Service']['EnvironmentFile'] = '-/etc/sysconfig/chronyd'
  default['chrony']['systemd']['Service']['ExecStart'] = '/usr/sbin/chronyd $OPTIONS'
  default['chrony']['systemd']['Service']['ExecStartPost'] = '/usr/libexec/chrony-helper update-daemon'
when 'debian', 'ubuntu'
  default['chrony']['systemd']['Service']['PIDFile'] = '/run/chronyd.pid'
  default['chrony']['systemd']['Service']['EnvironmentFile'] = '-/etc/default/chrony'
  default['chrony']['systemd']['Service']['ExecStart'] = '/usr/lib/systemd/scripts/chronyd-starter.sh $DAEMON_OPTS'
  default['chrony']['systemd']['Service']['ExecStartPost'] = '-/usr/lib/chrony/chrony-helper update-daemon'
end
