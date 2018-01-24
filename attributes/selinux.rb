# ~ selinux ~ #
# Seems that 'state' was replaced with 'status' on 23-FEB-2017.
node.override['selinux']['status']    = 'permissive'
node.override['selinux']['booleans']  = {}
