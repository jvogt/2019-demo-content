name 'acme_app_1'

default_source :supermarket
default_source :chef_repo, '../../cookbooks'

run_list 'acme_base::default', 'acme_app_1::default'

cookbook 'acme_app_1', path: '.'

default['audit']['profiles'] = [
  {
    'name': 'acme_appserver',
    'compliance': 'admin/acme_appserver',
  }
]

# # Specify any role level attributes
# default['cis']['xccdf_org.cisecurity.benchmarks_rule_9.1.1_L1_Ensure_Windows_Firewall_Domain_Firewall_state_is_set_to_On_recommended'] = false
