name 'acme_app'

run_list 'acme_base::default', 'acme_app::default'

default_source :supermarket
default_source :chef_repo, '../cookbooks'

default['audit']['profiles'] =[
  {
    'name': 'acme_appserver_centos7',
    'compliance': 'admin/acme_appserver_centos7',
  }
]
