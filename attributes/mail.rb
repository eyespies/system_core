# ~ postfix ~ #
node.override['postfix']['mail_type'] = 'client'
node.override['postfix']['main']['alias_database'] = 'hash:/etc/aliases'
node.override['postfix']['main']['alias_maps'] = 'hash:/etc/aliases'
