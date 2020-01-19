# rubocop:disable Naming/FileName

include_controls 'system-baseline' do
  skip_control 'papertrail' # not included in base tests
  skip_control 'hostname' # no hostname is set in the base tests
end

# rubocop:enable Naming/FileName
