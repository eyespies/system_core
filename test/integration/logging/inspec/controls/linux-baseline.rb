# rubocop:disable Naming/FileName

include_controls 'system-baseline' do
  skip_control 'sshkeys' # not included in altdomain tests
end

# rubocop:enable Naming/FileName
