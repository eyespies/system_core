def platforms
  {
    'ubuntu' => {
      # CentOS versions don't 100% match those from Oracle Linux
      'versions' => ['16.04']
    },
    'centos' => {
      # CentOS versions don't 100% match those from Oracle Linux
      'versions' => ['6.10', '7.6.1810']
    },
    'oracle' => {
      'versions' => ['6.10', '7.6']
    }
  }
end
