system_core Cookbook
=======================
Performs general system configuration that is core to all servers. Also provides some attributes that are leveraged by other cookbooks, although attempts are
made to limit such dependencies. Examples of 'core' configuration including SSH, the AWS CLI, bash customizations, logrotate, NTP, rsyslog, selinux, and mail
server configuration.

*Note* that this cookbook depends and a number of other cookbooks to perform the actual work, this is essentially just a wrapper around those cookbooks.

Requirements
------------
#### cookbooks
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

#### packages
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

Attributes
----------
#### system_core::awscli
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['system_core']['awscli']['version']</tt></td>
    <td>String</td>
    <td>The version of the AWS CLI to be downloaded from AWS and installed</td>
    <td><tt>1.4.4</tt></td>
  </tr>
  <tr>
    <td><tt>['system_core']['awscli']['packages']</tt></td>
    <td>Array</td>
    <td>Any additional packages required for, or helping when, using the AWS CLI</td>
    <td><tt>%w[jq wget curl unzip]</tt></td>
  </tr>
  <tr>
    <td><tt>['system_core']['awscli']['profiles']</tt></td>
    <td>Attributes hash</td>
    <td>This is hash of attributes with the first element being the AWS profile name. Under the profile name, the following attributes can be set:<br>
      <table>
        <tr>
          <td><tt>['output_format']</tt></td>
          <td>Default format used when content is output, see the AWS CLI documentation for allowed values.</td>
        </tr>
        <tr>
          <td><tt>['default_region']</tt></td>
          <td>The default region used for this profile by the CLI unless overridden on the command line.</td>
        </tr>
        <tr>
          <td><tt>['access_key']</tt></td>
          <td>The access key used when using the CLI; only necessary if running on a system that does not have an IAM profile (which makes it required for any non-EC2 systems.) Also requires that the <strong>secret_key</strong> is specified.</td>
        </tr>
        <tr>
          <td><tt>['secret_key']</tt></td>
          <td>The secret access key used when using the CLI; only necessary if running on a system that does not have an IAM profile (which makes it required for any non-EC2 systems.) Also requires that the <strong>access_key</strong> is specified.</td>
        </tr>
      </table>
    </td>
    <td><tt>nil</tt></td>
  </tr>
</table>

#### system_core::bash
There currently are no custom attributes.

#### system_core::default
There currently are no custom attributes.

#### system_core::hostname
There currently are no custom attributes.

#### system_core::logrotate
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['system_core']['awscli']['version']</tt></td>
    <td>String</td>
    <td>The version of the AWS CLI to be downloaded from AWS and installed</td>
    <td><tt>1.4.4</tt></td>
  </tr>
  <tr>
    <td><tt>['system_core']['awscli']['packages']</tt></td>
    <td>Array</td>
    <td>Any additional packages required for, or helping when, using the AWS CLI</td>
    <td><tt>%w[jq wget curl unzip]</tt></td>
  </tr>
</table>

#### system_core::ntp
There currently are no custom attributes.

#### system_core::papertrail
There currently are no custom attributes.

#### system_core::postfix
There currently are no custom attributes.

#### system_core::rbenv
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['system_core']['ruby']['global']</tt></td>
    <td>String</td>
    <td>The version of Ruby to be installed by rbenv</td>
    <td><tt>2.2.2</tt></td>
  </tr>
  <tr>
    <td><tt>['system_core']['ruby']['packages']</tt></td>
    <td>Array</td>
    <td>An array of strings indicating the Ruby GEMs to be installed when Ruby is installed</td>
    <td><tt>%w[bundler backup]</tt></td>
  </tr>
</table>

#### system_core::repos
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['system_core']['system']['packages']</tt></td>
    <td>Array</td>
    <td>An array of String values where each array element is the name of a package to be installed</td>
    <td><tt>%w( rsyslog gnutls rsyslog-gnutls perl-YAML-LibYAML acpid python-cheetah python-configobj vim-enhanced screen python-pip git htop
                bash-completion gcc ruby-devel zlib-devel ipa-client xfsprogs xfsprogs-devel tmux xfsdump mutt cloud-init )</tt></td>
  </tr>
</table>

#### system_core::rsyslog
There currently are no custom attributes.

#### system_core::selinux
There currently are no custom attributes.

#### system_core::ssh
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['environment']</tt></td>
    <td>String</td>
    <td>The name of the environment in which the recipe is running; typically this corresponds to the Chef environment</td>
    <td><tt>nil</tt></td>
  </tr>
</table>


#### system_core::user_ssh
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['system_core']['ssh']['user_config']</tt></td>
    <td>String</td>
    <td>The group created and which is used to run any web server applications</td>
    <td><tt>web</tt></td>
  </tr>
</table>

Usage
-----
#### system_core::default
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

License and Authors
-------------------
Authors: Justin Spies <justin@thespies.org>
