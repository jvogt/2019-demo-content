# frozen_string_literal: true

case node['platform']
when 'windows'
  include_recipe 'desktop-config::windows'
when 'mac_os_x'
  include_recipe 'desktop-config::mac'
end
