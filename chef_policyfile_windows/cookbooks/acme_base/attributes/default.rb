override['chef_client']['task']['frequency'] = 'minute'
override['chef_client']['task']['frequency_modifier'] = 1
override['chef_client']['splay'] = 5

default['audit']['reporter'] = 'chef-server-automate'
default['audit']['fetcher'] = 'chef-server'
