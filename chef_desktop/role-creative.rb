# frozen_string_literal: true

name 'role-creative'

default_source :supermarket
default_source :chef_repo, './cookbooks'

run_list 'acme_desktop_baseline::default'

default['acme']['firewall_enable'] = true

# default['acme']['apps_additional'] = [
#   'adobecs',
#   'canon-drivers'
# ]

default['audit']['profiles'] =[
  {
    'name': 'acme_baseline_macos',
    'compliance': 'admin/acme_baseline_macos',
  }
]
