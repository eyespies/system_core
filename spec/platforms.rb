def platforms
  {
    'centos' => {
      # CentOS versions don't 100% match those from Oracle Linux
      'versions' => ['6.8', '7.2.1511']
    },
    'oracle' => {
      'versions' => ['6.8', '7.2']
    }
  }
end
