include_recipe 'chef-client::default'

include_recipe 'acme_base::firewall'
include_recipe 'acme_base::passwords'

include_recipe 'audit::default' unless node.policy_group == 'local'
