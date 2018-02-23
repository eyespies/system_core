# rubocop:disable Naming/FileName

# While this could be done via .kitchen.yml, as of 2018-01-26 the linux-baseline controls do not use attributes
# to enable/disable IPv6 and IPv6 forwarding. Because we want those turned on and don't want the configuration reported
# as an error, it is necessary to skip those controls below as the ability to skip controls is not possible with
# Test Kitchen.
include_controls 'linux-baseline' do
  # This host requires IPv4 forwarding
  skip_control 'sysctl-01'
  # This host requires IPv6
  skip_control 'sysctl-18'
  # This host requires IPv6 forwarding
  skip_control 'sysctl-19'
end

include_controls 'system-baseline'

# rubocop:enable Naming/FileName
