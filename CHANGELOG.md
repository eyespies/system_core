# system_core Cookbook Change Log

## 4.2.1

- Justin Spies - (fix) do not automatically install the IDM client, doing so prevents setup of the IDM server

## 4.2.0

- Justin Spies - (feature) support OL8 and chrony

## 4.1.0

- Justin Spies - (feature) remove unused Kitchen configuration for Docker / Dokken
- Justin Spies - (feature) update with tested `.kitchen-ec2.yml`
- Justin Spies - (feature) update config to work with Rubocop 0.55
- Justin Spies - (feature) add integration tests
- Justin Spies - (fix) support EC2 instances by allowing SSH access to servers via the `ec2-user`
- Justin Spies - (doc) update copyright dates

## 4.0.0

- Justin Spies - (breaking) upgrade default Ruby version from 2.2.2 to 2.6.5
- Justin Spies - (breaking) upgrade apt to 7.2.0 from 6.0, iptables to 6.0.0 from 4.2.0
- Justin Spies - (feature) upgrade numerous dependencies to newest feature release (see metadata.rb for details)
- Justin Spies - (feature) add UEK5 repo URL
- Justin Spies - (feature) increment all OS versions; add Ubuntu 18.04 and CentOS 8 to platform list
- Justin Spies - (fix) do not test hostname in the base tests - Vagrant / VirtualBox defaults to no domain name
- Justin Spies - (fix) defect that was breaking ssh_authorized_keys unit tests

## 3.0.1

- Justin Spies - (security) eliminate insecure SSH Ciphers

## 3.0.0

- Justin Spies - Update to latest yum-epel and yum cookbooks
- Justin Spies - Remove / update platforms that are now deprecated
- Justin Spies - Fauxhai 6.7.0 is now Chef 14.x based (from the previous Chef 13.x) at least for Oracle; this broke the SSH vagrant lookup; fixed

## 2.1.5

- Justin Spies - Fix broken unit test

## 2.1.4

- Justin Spies - Use default to set sudo attributes so they can be overridden in JSON files

## 2.1.3

- Justin Spies - Use default to set the allow_groups for SSH so that downstream cookbooks can change the values even with JSON files

## 2.1.2

- Justin Spies - Use normal, not override, when setting allow_groups for SSH so that downstream cookbooks can change the values even with JSON files

## 2.1.1

- Justin Spies - Fix incorrect configuration file name for remote_syslog2

## 2.1.0

- Justin Spies - Allow specifying the timezone to use

## 2.0.0

- Justin Spies - Add support for Ubuntu 16 OS
- Justin Spies - Add papertrail_remote recipe and corresponding unit/integration tests
- Justin Spies - Add audit recipe for configuration of Auditd within guidelines from [Linux Baseline](https://github.com/dev-sec/linux-baseline) security

## 1.1.0

- Justin Spies - Add basic configuration of auditd to match dev sec standards; current configuration does not use a template and thus is fixed

## 1.0.0

- Justin Spies - Add attribute that allows disabling the use of papertrail; set to enabled by default to maintain backwards compatibility
