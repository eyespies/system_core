# See https://github.com/chefspec/fauxhai/blob/master/PLATFORMS.md for list of platforms
def platforms
  {
    'ubuntu' => {
      'versions' => ['16.04', '18.04']
    },
    'centos' => {
      # CentOS versions don't 100% match those from Oracle Linux
      'versions' => ['6.10', '7.7.1908', '8']
    },
    'oracle' => {
      'versions' => ['6.10', '7.6']
    }
  }
end
