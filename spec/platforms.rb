# See https://github.com/chefspec/fauxhai/blob/master/PLATFORMS.md for list of platforms
def platforms
  {
    'ubuntu' => {
      'versions' => {
        '18.04' => { 'fixture_path' => nil },
        '20.04' => { 'fixture_path' => nil },
      },
    },
    'oracle' => {
      'versions' => {
        '7.6' => { 'fixture_path' => nil },
        '8.2' => { 'fixture_path' => 'test/fixtures/oracle-8.2.json' },
      },
    },
  }
end
