# frozen_string_literal: true

case node['platform']
when 'windows'
  include_recipe 'acme_desktop_baseline::windows'
when 'mac_os_x'
  include_recipe 'acme_desktop_baseline::mac-demo'
end

include_recipe 'audit::default' unless node.policy_group == 'local'
