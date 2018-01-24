# ~ web user ~ #
node.default['system_core']['web']['service'] = 'nginx'
node.default['system_core']['web']['user']    = 'web'
node.default['system_core']['web']['group']   = 'web'

# ~ builds users ~ #
node.default['system_core']['builds']['user']   = 'builds'
node.default['system_core']['builds']['group']  = 'builds'
