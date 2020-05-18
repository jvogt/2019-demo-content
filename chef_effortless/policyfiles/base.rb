name 'base'

run_list 'os-hardening::default'

default_source :supermarket

cookbook 'os-hardening', path: '../cookbooks/os-hardening'
