name 'acme_mongodb'

run_list 'chef-client::default' # , 'os-hardening::default', 'audit::default'

default_source :supermarket

##############
# speed up chef runs for demo
default['chef_client']['interval'] = '30'
default['chef_client']['splay']    = '1'

# #############
# # prebaked audit cookbook profiles
# default['audit']['reporter'] = 'chef-server-automate'
# default['audit']['profiles'] =[
#   {
#     'name': 'acme_baseline_centos7',
#     'compliance': 'admin/acme_baseline_centos7',
#   }
# ]