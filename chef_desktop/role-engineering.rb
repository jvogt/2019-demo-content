# frozen_string_literal: true

name 'role-engineering'

default_source :supermarket
default_source :chef_repo, './cookbooks'

run_list 'acme_desktop_baseline::default'

default['acme']['firewall_enable'] = false

# default['acme']['apps_additional'] = [
#   'atom',
#   'vscode',
#   'firefox'
# ]

default['audit']['profiles'] =[
  {
    'name': 'acme_engineering_macos',
    'compliance': 'admin/acme_engineering_macos',
  }
]
