# ~ rsyslog ~ #

# ~ Remote Logging ~ #
node.default['system_core']['papertrail']['enabled'] = false

# If Papertrail is enabled, this attribute needs set with the full name, including the leading '@' (for UDP) or
# '@@' (for TCP) prefixes.
# node.default['system_core']['papertrail']['remote_host'] = '@@log1.papertrailapp.com:12345'
