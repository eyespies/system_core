# system_core Cookbook Change Log

## 2.1.2
- Use normal, not override, when setting allow_groups for SSH so that downstream cookbooks can change the values even with JSON files

## 2.1.1
- Fix incorrect configuration file name for remote_syslog2

## 2.1.0
- Allow specifying the timezone to use

## 2.0.0
- Add support for Ubuntu 16 OS
- Add papertrail_remote recipe and corresponding unit/integration tests
- Add audit recipe for configuration of Auditd within guidelines from [Linux Baseline](https://github.com/dev-sec/linux-baseline) security

## 1.1.0
- Add basic configuration of auditd to match dev sec standards; current configuration does not use a template and thus is fixed

## 1.0.0
- Add attribute that allows disabling the use of papertrail; set to enabled by default to maintain backwards compatibility
