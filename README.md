# system_core Cookbook

Performs general system configuration that is core to all servers. Also provides some attributes that are
leveraged by other cookbooks, although attempts aremade to limit such dependencies. Examples of 'core'
configuration including SSH, the AWS CLI, bash customizations, logrotate, NTP, rsyslog, selinux, and mail
server configuration.

*Note* that this cookbook depends and a number of other cookbooks to perform the actual work, this is
essentially just a wrapper around those cookbooks.

## Requirements

### cookbooks

- awscli
- bzip2
- hostnames
- logrotate
- newrelic
- ntp
- iptables
- openssh
- postfix
- ruby_rbenv
- rsyslog
- s3_file
- selinux
- ssh_authorized_keys
- ssh_known_hosts
- sudo
- yum
- yum-epel

### packages

- `curl` - for when files are needed from FTP / HTTP / etc
- `logrotate` - used to keep the disks from filling up with big log files
- `jq` - enables processing JSON from shell scripts
- `ntp` - helping when needing to keep server time in sync with other systems
- `postfix` - for sending emails from the server to other systems
- `openssh` - enables remote console access to and from servers
- `sudo` - allows normal users to temporarily have elevated access privileges on servers
- `unzip` - for processing ZIP archives
- `wget` - an alternative to `curl`
- `yum` - package management for RHEL / CentOS / Oracle family

## Attributes

Attributes are available from the various files in the _attributes/_ path, please review the files there
for all details about attributes.

## Usage

### system_core::default

TODO: Write usage instructions for each recipe.

e.g.
Just include `system_core` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[system_core]"
  ]
}
```

## License and Authors

Authors: Justin Spies <justin@thespies.org>
