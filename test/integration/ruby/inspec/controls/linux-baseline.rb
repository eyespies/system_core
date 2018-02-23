# rubocop:disable Naming/FileName

include_controls 'system-baseline' do
  skip_control 'papertrail' # not included in base tests
end

# rubocop:enable Naming/FileName
